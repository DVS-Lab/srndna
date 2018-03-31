from neurodesign import geneticalgorithm,generate,msequence,report

EXP = geneticalgorithm.experiment(
    TR=1,
    duration=360,
    P = [0.1667,0.1667,0.1667,0.1667,0.1667,0.1667],
    C = [[1,0,0,0,0,0],[0,1,0,0,0,0],[0,0,1,0,0,0],[0,0,0,1,0,0],[0,0,0,0,1,0],[0,0,0,0,0,1],
                [1,-1,0,0,0,0],[1,0,-1,0,0,0],[1,0,0,-1,0,0],[1,0,0,0,-1,0],[1,0,0,0,0,-1],
                               [0,1,-1,0,0,0],[0,1,0,-1,0,0],[0,1,0,0,-1,0],[0,1,0,0,0,-1],
                                              [0,0,1,-1,0,0],[0,0,1,0,-1,0],[0,0,1,0,0,-1],
                                                             [0,0,0,1,-1,0],[0,0,0,1,0,-1],
                                                                            [0,0,0,0,1,-1],
    ],
    n_stimuli = 6,
    rho = 0.3,
    resolution=0.1,
    stim_duration=1,
    t_pre = 0,
    t_post = 2,
    ITImodel = "exponential",
    ITImin = 2,
    ITImean = 3,
    ITImax=6
    )

POP = geneticalgorithm.population(
    experiment=EXP,
    weights=[0,0.5,0.25,0.25],
    preruncycles = 20,
    cycles = 20,
    seed=1,
    outdes=5,
    folder='/Users/DVS/GitProjects/srndna/nd-out2'
    )

#########################
# run natural selection #
#########################

POP.naturalselection()
POP.download()
POP.evaluate()

################
# step by step #
################

POP.add_new_designs()
POP.to_next_generation(seed=1)
POP.to_next_generation(seed=1001)

#################
# export report #
#################

report.make_report(POP,"/Users/DVS/GitProjects/srndna/nd-out/test2.pdf")
