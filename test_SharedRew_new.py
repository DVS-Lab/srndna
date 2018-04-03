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
decision_dur=2
#instruct_dur=8
outcome_dur=1

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

#checkpoint
print "got to check 1"

#define stimulus
fixation = visual.TextStim(win, text="+", height=2)
ready_screen = visual.TextStim(win, text="Ready...", height=1.5)

#decision screen
pictureStim =  visual.ImageStim(win, pos=(0,8.0))
cardStim = visual.Rect(win=win, name='polygon', width=(8.0,8.0)[0], height=(10.0,10.0)[1], ori=0, pos=(0, 0),lineWidth=5, lineColor=[1,1,1], lineColorSpace='rgb',fillColor=[0,0,0], fillColorSpace='rgb',opacity=1, depth=0.0, interpolate=True)
question = visual.TextStim(win=win, name='text',text='?',font='Arial',pos=(0, 0), height=1, wrapWidth=None, ori=0, color='white', colorSpace='rgb', opacity=1,depth=-1.0);

#outcome screen
outcome_cardStim = visual.Rect(win=win, name='polygon', width=(8.0,8.0)[0], height=(10.0,10.0)[1], ori=0, pos=(0, 0),lineWidth=5, lineColor=[1,1,1], lineColorSpace='rgb',fillColor=[0,0,0], fillColorSpace='rgb',opacity=1, depth=0.0, interpolate=True)
outcome_text = visual.TextStim(win=win, name='text',text='',font='Arial',pos=(0, 0), height=2, wrapWidth=None, ori=0, color='white', colorSpace='rgb', opacity=1,depth=-1.0);
outcome_money = visual.TextStim(win=win, name='text',text='',font='Wingdings 3',pos=(0, 2.0), height=2, wrapWidth=None, ori=0, colorSpace='rgb', opacity=1,depth=-1.0);

#instructions
instruct_screen = visual.TextStim(win, text='Welcome to the experiment.\n\nIn this task you will be guessing the numerical value of a card.\n\nPress Button 1 to guess low and press Button 2 to guess high.\n\nCorrect responses will result in a monetary gain of $4, and incorrect responses will result in a monetary loss of $2.00.\n\nRemember, you will be sharing monetary outcomes on each trial with the partner displayed at the top of the screen.', pos = (0,1), wrapWidth=20, height = 1.2)

#instructions
exit_screen = visual.TextStim(win, text='Thanks for playing! Please wait for instructions from the experimenter.', pos = (0,1), wrapWidth=20, height = 1.2)

#logging
log_file = 'logs/{}_run_{}.csv'

globalClock = core.Clock()
logging.setDefaultClock(globalClock)

timer = core.Clock()

#trial handler
trial_data = [r for r in csv.DictReader(open('SharedReward_design_test_new.csv','rU'))]
trials = data.TrialHandler(trial_data[:8], 1, method="sequential") #change to [] for full run

stim_map = {
  '3': 'friend',
  '2': 'stranger',
  '1': 'computer',
  }

outcome_map = {
  '3': 'reward',
  '2': 'neutral',
  '1': 'punish',
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
#checkpoint
print "got to check 2"

runs=[]
for run in range(1):
    run_data = []
    for t in range(8):
        sample = random.sample(range(len(trial_data)),1)[0]
        run_data.append(trial_data.pop(sample))
    runs.append(run_data)

# main task loop
# Instructions
instruct_screen.draw()
win.flip()
event.waitKeys()


def do_run(trial_data, run_num):
    resp=[]
    for trial in trials:
        condition_label = stim_map[trial['Partner']]
        image = "Images/%s.png" % condition_label
        pictureStim.setImage(image)
        print 'image'
        
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
        decision_onset = globalClock.getTime()

        resp_val=None
        resp_onset=None
        ifresp = 0
        
        while timer.getTime() < decision_dur:
            cardStim.draw()
            question.draw()
            pictureStim.draw()
            win.flip()

        #if ifresp:
        #    core.wait(.5)
        #    break
           
        resp = event.getKeys(keyList = responseKeys)
           
        if len(resp)>0:
            resp_val = int(resp[0])
            resp_onset = globalClock.getTime()
            if resp_val == 1:
                ifresp=1
                #print ifresp
            if resp_val == 2:
                ifresp=1
                #print ifresp
        else:
            resp_val = 0

        trials.addData('resp', resp_val)
        trials.addData('rt', resp_onset)
        trials.addData('decision', decision_onset)
        
#ISI
        if resp_val > 0 and timer.getTime() < decision_dur:
            logging.log(level=logging.DATA, msg='ISI') #send ISI log event
            isi_for_trial = float(trial['ISI'])
            while timer.getTime() < decision_dur:
               fixation.draw()
               win.flip()

#outcome phase
        timer.reset()
        #win.flip()
        outcome_onset = globalClock.getTime()
        
        while timer.getTime() < outcome_dur:
            outcome_cardStim.draw()
            pictureStim.draw()
            #win.flip()
    
            if trial['Feedback'] == '3' and resp_val == 1:
                outcome_txt = random.randint(1,4)
                outcome_moneyTxt= 'h'
                outcome_color='green'
            elif trial['Feedback'] == '3' and resp_val == 2:
                outcome_txt = random.randint(6,9)
                outcome_moneyTxt= 'h'
                outcome_color='green'
            elif trial['Feedback'] == '2' and resp_val == 1:
                outcome_txt = '5'
                outcome_moneyTxt= 'n'
                outcome_color='white'
            elif trial['Feedback'] == '2' and resp_val == 2:
                outcome_txt = '5'
                outcome_moneyTxt= 'n'
                outcome_color='white'
            elif trial['Feedback'] == '1' and resp_val == 1:
                outcome_txt = random.randint(6,9)
                outcome_moneyTxt= 'i'
                outcome_color='red'
            elif trial['Feedback'] == '1' and resp_val == 2:
                outcome_txt = random.randint(1,4)
                outcome_moneyTxt= 'i'
                outcome_color='red'
            elif resp_val == 0: 
                outcome_txt='#'
                outcome_moneyTxt = ''
                outcome_color='white'
            
            print outcome_txt
            outcome_text.setText(outcome_txt)
            outcome_money.setText(outcome_moneyTxt)
            outcome_money.setColor(outcome_color)
            outcome_text.draw()
            outcome_money.draw()
            win.flip()
            core.wait(2)
            trials.addData('outcome_txt', outcome_txt)
            trials.addData('outcome', outcome_onset)
            
            event.clearEvents()
        print "got to check 3"

    trials.saveAsText(fileName=log_file.format(subj_id, run_num)) #, dataOut='all_raw', encoding='utf-8')
do_run(trial_data,1)

# Exit
exit_screen.draw()
win.flip()
event.waitKeys()