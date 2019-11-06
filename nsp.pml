
mtype:msg_t = { syn, synack, ack }
mtype:agent = { john, alice, bob, intruder }
mtype:msg_cnt = { null, alice_agent, bob_agent, intruder_agent, nonce_alice, nonce_bob, nonce_intruder }
mtype:msg_key = { key_alice, key_bob, key_intruder }
typedef encrypted_msg { mtype:msg_cnt cnt1, cnt2; mtype:msg_key key }

chan network = [0] of {
    mtype:msg_t,
    mtype:agent,  // receiver
    encrypted_msg
}
mtype:agent alice_verified_partner
mtype:agent bob_verified_partner
mtype:msg_cnt nonce_alice_stored, nonce_bob_stored, nonce_john_stored

active proctype Alice() {
    mtype:msg_cnt nonce = nonce_alice
    mtype:msg_key key = key_alice
    
    encrypted_msg outgoing_msg, incoming_msg
    mtype:agent receiver

start:
    atomic {
        alice_verified_partner = john
        if
            :: receiver = bob
            :: receiver = intruder
        fi
    }

    atomic {
        outgoing_msg.cnt1 = alice_agent
        outgoing_msg.cnt2 = nonce
        if
            :: receiver == bob ->
                outgoing_msg.key = key_bob
            :: receiver == intruder ->
                outgoing_msg.key = key_intruder
        fi
        network ! syn(receiver, outgoing_msg)
    }
    atomic {
        network ? synack(alice, incoming_msg)
        if
            :: incoming_msg.key == key ->
                skip
            :: else ->
                printf("Invalid Key for A\n")
                assert(false)
                goto start
        fi
        if
            :: incoming_msg.cnt1 == nonce ->
                skip
            :: else ->
                printf("Invalid Nonce for A\n")
                assert(false)
                goto start
        fi

        alice_verified_partner = receiver
    }
    atomic {
        outgoing_msg.cnt1 = incoming_msg.cnt2
        outgoing_msg.cnt2 = null
        if
            :: receiver == bob ->
                outgoing_msg.key = key_bob
            :: receiver == intruder ->
                outgoing_msg.key = key_intruder
        fi
        network ! ack(receiver, outgoing_msg)
    }
}

active proctype Bob() {
    mtype:msg_cnt nonce = nonce_bob
    mtype:msg_key key = key_bob
    
    encrypted_msg outgoing_msg, incoming_msg
    mtype:agent receiver

start:
    bob_verified_partner = john
    
    atomic {
        network ? syn(bob, incoming_msg)
        if
            :: incoming_msg.key == key ->
                skip
            :: else ->
                printf("Invalid Key for B: %e\n", incoming_msg.key)
                // assert(false)
                goto start
        fi
    }
    atomic {
        if
            :: incoming_msg.cnt1 == alice_agent ->
                receiver = alice
                outgoing_msg.key = key_alice
            :: incoming_msg.cnt1 == intruder_agent ->
                receiver = intruder
                outgoing_msg.key = key_intruder
        fi
        outgoing_msg.cnt1 = incoming_msg.cnt2
        outgoing_msg.cnt2 = nonce
        network ! synack(receiver, outgoing_msg)
    }
    atomic {
        network ? ack(bob, incoming_msg)
        if
            :: incoming_msg.key == key ->
                skip
            :: else ->
                printf("Invalid Key for B\n")
                // assert(false)
                goto start
        fi
        if
            :: incoming_msg.cnt1 == nonce ->
                skip
            :: else ->
                printf("Invalid Nonce for B\n")
                // assert(false)
                goto start
        fi

        bob_verified_partner = alice
    }
}

active proctype Intruder() {
    mtype:msg_cnt nonce = nonce_intruder
    mtype:msg_key key = key_intruder

    mtype:msg_t stored_msg_t, outgoing_msg_t
    mtype:agent stored_msg_receiver, outgoing_msg_receiver
    encrypted_msg stored_msg, outgoing_msg
    mtype:msg_cnt stored_cnt1, stored_cnt2
    mtype:msg_key stored_key

end_iteration:
    do
        ::  // store message
            atomic {
                network ? stored_msg_t, stored_msg_receiver, stored_msg
                if
                    :: stored_msg.key == key ->
                        stored_cnt1 = stored_msg.cnt1
                        stored_cnt2 = stored_msg.cnt2
                        if
                            :: stored_msg_t == syn ->
                                if
                                    :: stored_cnt1 == alice_agent ->
                                        nonce_alice_stored = stored_cnt2
                                    :: stored_cnt1 == bob_agent ->
                                        nonce_bob_stored = stored_cnt2
                                    :: else ->
                                        skip
                                fi
                            :: stored_msg_t == synack ->
                                         nonce_john_stored = stored_cnt2
                            :: stored_msg_t == ack ->
                                        nonce_john_stored = stored_cnt1
                            :: else ->
                                skip
                        fi
                    :: else ->
                        skip
                fi
            }
        ::  // resend message
            atomic {
                stored_msg_t != 0 && stored_msg_receiver != 0 && stored_msg_receiver != intruder && stored_msg.key != 0 ->
                    network ! stored_msg_t, stored_msg_receiver, stored_msg
            }
        ::  // send patched message
            atomic {
                stored_msg_t != 0 && stored_msg_receiver != 0 && stored_msg.key == key_intruder ->
                    outgoing_msg.cnt1 = stored_msg.cnt1
                    outgoing_msg.cnt2 = stored_msg.cnt2
                    if
                        :: stored_msg_t == synack ->
                            outgoing_msg_receiver = alice
                            outgoing_msg.key = key_alice
                        :: stored_msg_t != synack ->
                            outgoing_msg_receiver = bob
                            outgoing_msg.key = key_bob
                    fi
                    network ! stored_msg_t, outgoing_msg_receiver, outgoing_msg
            }
        :: // send messages with true identity
            atomic {
                if
                    :: outgoing_msg_receiver = alice
                    :: outgoing_msg_receiver = bob
                fi
                if
                :: true ->
                    outgoing_msg_t = syn
                    outgoing_msg.cnt1 = intruder
                    outgoing_msg.cnt2 = nonce
                :: stored_msg_t == syn && stored_msg.key == key_intruder ->
                    outgoing_msg_t = synack
                    if
                        :: stored_msg.cnt1 == alice_agent ->
                            outgoing_msg_receiver = alice
                            outgoing_msg.key = key_alice
                        :: stored_msg.cnt1 == bob_agent ->
                            outgoing_msg_receiver = bob
                            outgoing_msg.key = key_bob
                    fi
                    outgoing_msg.cnt1 = stored_msg.cnt2
                    outgoing_msg.cnt2 = nonce
                :: stored_msg_t == synack && stored_msg.key == key_intruder ->
                    outgoing_msg_t = ack
                    outgoing_msg.cnt1 = stored_msg.cnt2
                    outgoing_msg.cnt2 = null
                    if
                        :: outgoing_msg_receiver == bob ->
                            outgoing_msg.key = key_bob
                        :: outgoing_msg_receiver == intruder ->
                            outgoing_msg.key = key_intruder
                    fi
                :: else ->
                    skip
                network ! outgoing_msg_t, outgoing_msg_receiver, outgoing_msg
                fi
            }
    od
}

ltl encrypted_connection {
    [](
        (alice_verified_partner != john && bob_verified_partner != john && alice_verified_partner != 0 && bob_verified_partner != 0) -> (
            alice_verified_partner == bob -> bob_verified_partner == alice
            &&
            bob_verified_partner == alice -> alice_verified_partner == bob
        )
    )
}

ltl alice_confidentiality {
    [](
        alice_verified_partner == bob -> nonce_alice_stored != nonce_alice
    )
}

ltl bob_confidentiality {
    [](
        bob_verified_partner == alice -> nonce_bob_stored != nonce_bob
    )
}


ltl termination {
    <> (
        alice_verified_partner != 0 && alice_verified_partner != john &&
        bob_verified_partner == 0 && bob_verified_partner == john
    )
}


/*
init {
    printf("%e\n", null)
    printf("%e\n", alice_agent)
    printf("%e\n", bob_agent)
    printf("%e\n", nonce_alice)
    printf("%e\n", nonce_bob)
}
*/
