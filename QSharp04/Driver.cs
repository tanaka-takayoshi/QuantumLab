using System;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace QSharp04
{
    class Driver
    {
        static void Main(string[] args)
        {
            // using (var qsim = new QuantumSimulator())
            // {
            //     //HelloQ.Run(qsim, int.MaxValue, int.MaxValue).Wait();
            //     TooManyQubits.Run(qsim).Wait();
            // }

            var tsim = new ToffoliSimulator(qubitCount: 500000);
            TooManyQubits.Run(tsim).Wait();

            var estimator = new ResourcesEstimator();
            TeleportClassicalMessage.Run(estimator, false).Wait();

            var data = estimator.Data;
            Console.WriteLine(estimator.ToTSV());
        }
    }
}