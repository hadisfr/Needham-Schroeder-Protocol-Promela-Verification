
mtype:msg_t = { syn, synack, ack }
mtype:agent = { alice, bob }
mtype:msg_cnt = { null, alice_agent, bib_agent, nonce_alice, nonce_bob }
mtype:msg_key = { key_alice, key_bob }
typedef encrypted_msg { mtype:msg_cnt cnt1, cnt2; mtype:msg_key key }

chan network = [0] of {
    mtype:msg_t,
    mtype:agent,  // receiver
    encrypted_msg
}

active proctype Alice() {
    mtype:msg_cnt nonce = nonce_alice
    mtype:msg_key key = key_alice
    
    encrypted_msg outgoing_msg, incoming_msg
    mtype:agent receiver

    start: do
        ::
            atomic {
                outgoing_msg.cnt1 = alice_agent
                outgoing_msg.cnt2 = nonce
                if
                    :: receiver = bob ->
                        outgoing_msg.key = key_bob
                fi
                network ! syn(receiver, outgoing_msg)
            }
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
            atomic {
                outgoing_msg.cnt1 = incoming_msg.cnt2
                outgoing_msg.cnt2 = null
                if
                    :: receiver == bob ->
                        outgoing_msg.key = key_bob
                fi
                network ! ack(receiver, outgoing_msg)
            }
    od
    assert(false)
}

active proctype Bob() {
    mtype:msg_cnt nonce = nonce_bob
    mtype:msg_key key = key_bob
    
    encrypted_msg outgoing_msg, incoming_msg
    mtype:agent receiver

    start: do
        ::
            network ? syn(bob, incoming_msg)
            if
                :: incoming_msg.key == key ->
                    skip
                :: else ->
                    printf("Invalid Key for B: %e\n", incoming_msg.key)
                    assert(false)
                    goto start
            fi
            atomic {
                if
                    :: incoming_msg.cnt1 == alice_agent ->
                        receiver = alice
                        outgoing_msg.key = key_alice
                fi
                outgoing_msg.cnt1 = incoming_msg.cnt2
                outgoing_msg.cnt2 = nonce
                network ! synack(receiver, outgoing_msg)
            }
            network ? ack(bob, incoming_msg)
            if
                :: incoming_msg.key == key ->
                    skip
                :: else ->
                    printf("Invalid Key for B\n")
                    assert(false)
                    goto start
            fi
            if
                :: incoming_msg.cnt1 == nonce ->
                    skip
                :: else ->
                    printf("Invalid Nonce for B\n")
                    assert(false)
                    goto start
            fi
    od
    assert(false)
}

/*
init {
    printf("%e\n", null)
    printf("%e\n", alice_agent)
    printf("%e\n", bib_agent)
    printf("%e\n", nonce_alice)
    printf("%e\n", nonce_bob)
}
*/