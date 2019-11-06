
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

    atomic {
        alice_verified_partner = 0
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
                goto err
        fi
        if
            :: incoming_msg.cnt1 == nonce ->
                skip
            :: else ->
                printf("Invalid Nonce for A\n")
                goto err
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
    goto end
err:
    printf("err in Alice")
end:
}

active proctype Bob() {
    mtype:msg_cnt nonce = nonce_bob
    mtype:msg_key key = key_bob
    
    encrypted_msg outgoing_msg, incoming_msg
    mtype:agent receiver

    bob_verified_partner = 0
    
    atomic {
        network ? syn(bob, incoming_msg)
        if
            :: incoming_msg.key == key ->
                skip
            :: else ->
                printf("Invalid Key for B: %e\n", incoming_msg.key)
                goto err
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
                goto err
        fi
        if
            :: incoming_msg.cnt1 == nonce ->
                skip
            :: else ->
                printf("Invalid Nonce for B\n")
                goto err
        fi

        bob_verified_partner = alice
    }
    goto end
err:
    printf("err in Bob")
end:
}

active proctype Intruder() {
    mtype:msg_cnt nonce = nonce_intruder
    mtype:msg_key key = key_intruder

    mtype:msg_t stored_msg_t, outgoing_msg_t
    mtype:agent stored_msg_receiver, outgoing_msg_receiver, outgoing_msg_sender
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
                                fi
                            :: stored_msg_t == synack ->
                                         nonce_john_stored = stored_cnt2
                            :: stored_msg_t == ack ->
                                        nonce_john_stored = stored_cnt1
                        fi
                    :: else ->
                        goto end_iteration
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
        :: // send new messages
        atomic {
            if
                :: outgoing_msg_receiver = alice ->
                    outgoing_msg.key = key_alice
                :: outgoing_msg_receiver = bob ->
                    outgoing_msg.key = key_bob
            fi
            if
            :: outgoing_msg_t = syn ->
                if
                    :: outgoing_msg.cnt1 = intruder
                    :: outgoing_msg.cnt1 = alice
                    :: outgoing_msg.cnt1 = bob
                fi
                if
                    :: outgoing_msg.cnt2 = nonce_intruder
                    :: outgoing_msg.cnt2 = nonce_alice_stored
                    :: outgoing_msg.cnt2 = nonce_bob_stored
                    :: outgoing_msg.cnt2 = nonce_john_stored
                fi
            :: outgoing_msg_t = synack ->
                if
                    :: outgoing_msg.cnt2 = nonce_intruder
                    :: outgoing_msg.cnt2 = nonce_alice_stored
                    :: outgoing_msg.cnt2 = nonce_bob_stored
                    :: outgoing_msg.cnt2 = nonce_john_stored
                fi
                if
                    :: outgoing_msg.cnt1 = nonce_intruder
                    :: outgoing_msg.cnt1 = nonce_alice_stored
                    :: outgoing_msg.cnt1 = nonce_bob_stored
                    :: outgoing_msg.cnt1 = nonce_john_stored
                fi
            :: outgoing_msg_t = ack ->
                outgoing_msg.cnt2 = null
                if
                    :: outgoing_msg.cnt2 = nonce_intruder
                    :: outgoing_msg.cnt2 = nonce_alice_stored
                    :: outgoing_msg.cnt2 = nonce_bob_stored
                    :: outgoing_msg.cnt2 = nonce_john_stored
                fi
            fi
            network ! outgoing_msg_t, outgoing_msg_receiver, outgoing_msg
        }
    od
}

ltl encrypted_connection {
    [](
        (alice_verified_partner != 0 && bob_verified_partner != 0) -> (
            alice_verified_partner == bob -> bob_verified_partner == alice
            &&
            bob_verified_partner == alice -> alice_verified_partner == bob
        )
    )
}

ltl alice_confidentiality {
    [](
        alice_verified_partner == bob -> nonce_alice_stored != nonce_alice && nonce_john_stored != nonce_alice
    )
}

ltl bob_confidentiality {
    [](
        bob_verified_partner == alice -> nonce_bob_stored != nonce_bob && nonce_john_stored != nonce_bob
    )
}


ltl termination {
    <> (alice_verified_partner != 0 && bob_verified_partner == 0)
}
