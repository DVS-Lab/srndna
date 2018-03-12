###SRNDNA
###shared reward, block design

from psychopy import visual, core, event, gui, data, sound, logging
import csv
import datetime
import random
import numpy

#parameters
useFullScreen = True
DEBUG = False

frame_rate=1
decision_dur=1.5
#instruct_dur=8
#outcome_dur=2

responseKeys=('1','2')

#get subjID
subjDlg=gui.Dlg(title="Shared Reward Task")
subjDlg.addField('Enter Subject ID: ')
subjDlg.show()

if gui.OK:
    subj_id=subjDlg.data[0]
else:
    sys.exit()

run_data = {
    'Participant ID': subj_id,
    'Date': str(datetime.datetime.now()),
    'Description': 'SRNDNA Pilot - SharedReward Task'
    }

#window setup
win = visual.Window([800,600], monitor="testMonitor", units="deg", fullscr=useFullScreen, allowGUI=False)

#define stimulus
fixation = visual.TextStim(win, text="+", height=2)
ready_screen = visual.TextStim(win, text="Ready...", height=1.5)

#decision screen
pictureStim =  visual.ImageStim(win, pos=(0,5.5))
cardStim = visual.Rect(win=win, name='polygon', width=(0.5, 1.0)[0], height=(0.5, 1.0)[1], ori=0, pos=(0, 0),lineWidth=5, lineColor=[1,1,1], lineColorSpace='rgb',fillColor=[0,0,0], fillColorSpace='rgb',opacity=1, depth=0.0, interpolate=True)
question = visual.TextStim(win=win, name='text',text='?',font='Arial',pos=(0, 0), height=0.1, wrapWidth=None, ori=0, color='white', colorSpace='rgb', opacity=1,depth=-1.0);

#outcome screen
outcome_cardStim = visual.Rect(win=win, name='polygon', width=(0.5, 1.0)[0], height=(0.5, 1.0)[1], ori=0, pos=(0, 0),lineWidth=5, lineColor=[1,1,1], lineColorSpace='rgb',fillColor=[0,0,0], fillColorSpace='rgb',opacity=1, depth=0.0, interpolate=True)
outcome_text = visual.TextStim(win=win, name='text',text='',font='Arial',pos=(0, 0), height=0.1, wrapWidth=None, ori=0, color='white', colorSpace='rgb', opacity=1,depth=-1.0);
outcome_money = visual.TextStim(win=win, name='text',text='',font='Wingdings 3',pos=(0, 2.0), height=0.1, wrapWidth=None, ori=0, colorSpace='rgb', opacity=1,depth=-1.0);

#instructions
instruct_screen = visual.TextStim(win, text='Welcome to the experiment. In this task you will be guessing the numerical value of a card.  Press Button 1 to guess low and press Button 2 to guess high.  Correct responses will result in a monetary gain of $4, and incorrect responses will result in a monetary loss of $2.00. ', pos = (0,1), wrapWidth=20, height = 1.2)

#logging
log_file = 'logs/{}_run_{}.csv'

globalClock = core.Clock()
logging.setDefaultClock(globalClock)

timer = core.Clock()

#trial handler
trial_data = [r for r in csv.DictReader(open('SharedReward_design_test.csv','rU'))]
trials = data.TrialHandler(trial_data[:8], 1, method="sequential") #change to [] for full run

stim_map = {
  '3': 'friend',
  '2': 'stranger',
  '1': 'computer',
  }
  
'''
#parsing out file data
blocks=[]
runs=[]
for run in range(2):
    run_data=[]
    for block in range(12):
        block_data = []
        for t in range(8):
            sample = random.sample(range(len(trial_data)),1)[0]
            run_data.append(trial_data.pop(sample))
            runs.append(run_data)
            blocks.append(block_data)
         
'''
# main task loop
def do_run(trial_data, run_num):
    resp=[]
    for trial in trials:
        condition_label = stim_map['Partner']
        image = "Images/%s.png" % condition_label
        pictureStim.setImage(image)
        
        #ITI
        logging.log(level=logging.DATA, msg='ITI') #send fixation log event
        timer.reset()
        iti_for_trial = float(trial['ITI'])
        while timer.getTime() < iti_for_trial:
            fixation.draw()
            win.flip()
            
        #decision phase   
        timer.reset()
        event.clearEvents()
            
        resp_val=None
        resp_onset=None
        ifresp = 0
        
        while timer.getTime() < decision_dur:
            cardStim.draw()
            question.draw()
            pictureStim.draw()
            win.flip()

        if ifresp:
            core.wait(.5)
            break
           
        resp = event.getKeys(keyList = responseKeys)
           
        if len(resp)>0:
            resp_val = int(resp[0])
            resp_onset = globalClock.getTime()
            if resp_val == 1:
                ifresp=1
            if resp_val == 2:
                ifresp=1

        trials.addData('resp', resp_val)
        trials.addData('rt', resp_onset)
        
    #outcome phase
    while ('Feedback' == 3):
        if responseKeys == '1':
            outcome_text.setText = np.random.randint(1,4)
        elif responseKeys == '2':
            outcome_text.setText = np.random.randint(6,9)
        else:
            outcome_text.setText = "No Response"
        if responseKeys == '1':
            outcome_money.setText = 'h'
            outcome_money.setColor('green')
        elif responseKeys == '2':
            outcome_money.setText = 'h'
            outcome_money.setColor('green')
        else:
            outcome_money.setText = '#'
     
    while ('Feedback' == 2):
        if responseKeys == '1':
            outcome_text.setText = '5'
        elif responseKeys == '2':
            outcome_text.setText = '5'
        else:
            outcome_text.setText = "No Response"
        if responseKeys == '1':
            outcome_money.setText = '---'
            outcome_money.setColor('white')
        elif responseKeys == '2':
            outcome_money.setText = '---'
            outcome_money.setColor('white')
        else:
            outcome_money.setText = '#'
     
    while ('Feedback' == 1):
        if responseKeys == '1':
            outcome_text.setText = np.random.randint(6,9)
        elif responseKeys == '2':
            outcome_text.setText = np.random.randint(1,4)
        else: 
            outcome_text.setText = "No Response"
        if responseKeys == '1':
            outcome_money.setText = 'i'
            outcome_money.setColor('red')
        elif responseKeys == '2':
            outcome_money.setText = 'i'
            outcome_money.setColor('red')
        else:
            outcome_money.setText = '#'
    
    trials.saveAsText(fileName=log_file.format(subj_id, run_num)) #, dataOut='all_raw', encoding='utf-8')