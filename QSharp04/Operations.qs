namespace QSharp04
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;

    operation HelloQ (i1 : Int, i2 : Int) : Unit {
        Message("Hello quantum world!");
        let bigZero = 0L;
        let bigHex = 0x123456789abcdef123456789abcdefL;
        let bigOne = bigZero + 1L;
        Message($"{bigZero} {bigHex} ");
    }

    operation TooManyQubits () : Unit {
        let num = 500000;
        Message($"Start {num}");
        using(qs = Qubit[num])
        {
            ApplyToEachCA(X, qs);
            ResetAll(qs);
        }
        Message("End");
    }

    operation TeleportClassicalMessage (message : Bool) : Bool {
        
        mutable measurement = false;
        
        using (register = Qubit[2]) {
            
            // Ask for some qubits that we can use to teleport.
            let msg = register[0];
            let there = register[1];
            
            // Encode the message we want to send.
            if (message) {
                X(msg);
            }
            
            // Use the operation we defined above.
            Teleport(msg, there);
            
            // Check what message was sent.
            if (M(there) == One) {
                set measurement = true;
            }
            
            // Reset all of the qubits that we used before releasing
            // them.
            ResetAll(register);
        }
        
        return measurement;
    }

    operation Teleport (source : Qubit, target : Qubit) : Unit {
        body (...) {
            using (ancillaRegister = Qubit[1]) {
                let ancilla = ancillaRegister[0];

                H(ancilla);
                CNOT(ancilla, target);

                CNOT(source, ancilla);
                H(source);

                AssertProb([PauliZ], [source], Zero, 0.5, "Outcomes must be equally likely", 1e-5);
                AssertProb([PauliZ], [ancilla], Zero, 0.5, "Outcomes must be equally likely", 1e-5);

                if (M(source) == One)  { Z(target); X(source); }
                if (M(ancilla) == One) { X(target); X(ancilla); }
            }
        }
    }
}
