function frequencyDiscrimExperiment(exptdesign)

    % frequencyDiscrimination
    % Patrick Malone pmalone333@gmail.com, Courtney Sprouse
    % cs1471@georgetown.edu, Levan Bokeria levan.bokeria@georgetown.edu
    
    % Open a screen and display instructions
    screens=Screen('Screens');
    screenNumber=0;
    
    % Open window with default settings:
    [w windowRect] =Screen('OpenWindow', screenNumber,[128 128 128]);
    white = WhiteIndex(w); % pixel value for white
    gray = GrayIndex(w); % pixel value for gray
    black = BlackIndex(w); % pixel value for black
    HideCursor;
    %load images
    fixationImage = imread(exptdesign.fixationImage);
    fixationTexture=Screen('MakeTexture', w, double(fixationImage));
    
    responseTime = exptdesign.responseTime;
    interStimulusInterval = exptdesign.interStimulusInterval;
    
    %load training stimuli
    if exptdesign.response == '0'
        load('frequencyDiscrimStimuli_0.mat');
    else
        load('frequencyDiscrimStimuli_1.mat');
    end
    
    for iBlock=1:exptdesign.numBlocks
         if mod(iBlock,2)
            drawAndCenterText(w, ['Please review instructions\n\n'...
                'Please click a mouse button to advance'],1)
            
            drawAndCenterText(w,['\nOn each trial, you will feel 2 vibrations, one after the other. \n'...
                'Indicate whether the vibrations are the same or different\n\n'...
                'LEFT mouse button = "SAME"\n\n'... 
                'RIGHT = "DIFFERENT".\n\n'...
                'Please click the mouse to continue\n'],1)
            %after 300-800 ms, present the vibrotactile stimulus
            %on odd blocks, lower frequency @top is on left of screen
        else
            drawAndCenterText(w, ['Please review instructions \n Click the mouse to continue\n'...
                'Please click a mouse button to advance'],1)
            
            drawAndCenterText(w,['\nOn each trial, you will feel 2 vibrations, one after the other. \n'...
                'Indicate whether the vibrations are the same or different\n\n'...
                'RIGHT mouse button = "SAME"\n\n'... 
                'LEFT = "DIFFERENT".\n\n'...
                'Please click the mouse to continue\n'],1)
        end
        
        drawAndCenterText(w,['Block #' num2str(iBlock) ' of ' num2str(exptdesign.numBlocks) '\n\n\n\n'...
            'Click the mouse to continue'],1);
        %WaitSecs(1);
        
        %randomize the stimuli for this level
        order=randperm(size(stimuli,2));
        stimuli=stimuli(:, order);
        %lower and upper limit of fixation before stimulus is presented
        ll=.3;
        ul=.8;
        
        for iTrial=1:exptdesign.numTrialsPerSession
           Screen('DrawTexture', w, fixationTexture);
               [FixationVBLTimestamp, FixationOnsetTime, FixationFlipTimestamp, FixationMissed] = Screen('Flip',w);
               
           %initial wait before stim presentation    
           wait1 = ll + (ul-ll).*rand(1);
           WaitSecs(wait1);
           
           %stimulus 1 presentation with time parameters
           stimulusOneOnset = GetSecs;
           [stimOneLoadStart, stimOneLoadEnd,stimOneStartStart, stimOneStartEnd] = constructStimuli(stimuli(1:2,iTrial)); % present stim 1
           stimulusOneEnd = GetSecs;
       
           %interstimulus interval
           WaitSecs(interStimulusInterval);
           
           %stimulus 2 presentation with time parameters
           stimulusTwoOnset = GetSecs;
           [stimTwoLoadStart, stimTwoLoadEnd,stimTwoStartStart, stimTwoStartEnd] = constructStimuli(stimuli(3:4,iTrial)); % present stim 2
           stimulusTwoEnd = GetSecs;
           
           drawAndCenterText(w,'Were the vibrations the same or different? \n', 0);
           
           %collect Response
           responseStartTime=GetSecs;
           sResp=getResponseMouse(responseTime);
           responseFinishedTime=GetSecs;
           
           if isequal(stimuli(1:2, iTrial),stimuli(3:4,iTrial))
               if mod(iBlock,2) % are stimuli the same?
                   correctResponse=1;
               else 
                   correctResponse=2;
               end
           elseif ~isequal(stimuli(1:2, iTrial),stimuli(3:4,iTrial)) 
               if mod(iBlock,2) % are stimuli the same?
                   correctResponse=2;
               else 
                   correctResponse=1;
               end
           end

           %score the answer -- is sResp(iTrial)==correctResponse?
           if sResp==correctResponse
               accuracy=1;
           else
               accuracy=0;
           end
           
           %record parameters for the trial
           trialOutput(iBlock).FixationVBLTimestamp(iTrial)   = FixationVBLTimestamp;
           trialOutput(iBlock).FixationOnsetTime(iTrial)      = FixationOnsetTime;
           trialOutput(iBlock).FixationFlipTimestamp(iTrial)  = FixationFlipTimestamp;
           trialOutput(iBlock).FixationMissed(iTrial)         = FixationMissed;
           trialOutput(iBlock).order                          = order;
           trialOutput(iBlock).stimuli                        = stimuli;
           trialOutput(iBlock).responseStartTime(iTrial)      = responseStartTime;
           trialOutput(iBlock).responseFinishedTime(iTrial)   = responseFinishedTime;
           trialOutput(iBlock).RT(iTrial)                     = responseFinishedTime-responseStartTime;
           trialOutput(iBlock).sResp(iTrial)                  = sResp;
           trialOutput(iBlock).correctResponse(iTrial)        = correctResponse;
           trialOutput(iBlock).accuracy(iTrial)               = accuracy;
           trialOutput(iBlock).wait1(iTrial)                  = wait1;
           trialOutput(iBlock).stimulusOneOnset(iTrial)       = stimulusOneOnset;
           trialOutput(iBlock).stimulusOneEnd(iTrial)         = stimulusOneEnd;
           trialOutput(iBlock).stimOneDuration(iTrial)        = stimulusOneEnd - stimulusOneOnset;
           trialOutput(iBlock).stimulusTwoOnset(iTrial)       = stimulusTwoOnset;
           trialOutput(iBlock).stimulusTwoEnd(iTrial)         = stimulusTwoEnd;
           trialOutput(iBlock).stimTwoDuration(iTrial)        = stimulusTwoEnd - stimulusTwoOnset;
           trialOutput(iBlock).stimOneLoadStart(iTrial)       = stimOneLoadStart;
           trialOutput(iBlock).stimOneLoadEnd(iTrial)         = stimOneLoadEnd;
           trialOutput(iBlock).stimOneLoadDuration(iTrial)    = stimOneLoadEnd - stimOneLoadStart;
           trialOutput(iBlock).stimOneStartStart(iTrial)      = stimOneStartStart; 
           trialOutput(iBlock).stimOneStartEnd(iTrial)        = stimOneStartEnd;
           trialOutput(iBlock).stimOneStartDuration(iTrial)   = stimOneStartEnd - stimOneStartStart;
           trialOutput(iBlock).stimTwoLoadStart(iTrial)       = stimTwoLoadStart;
           trialOutput(iBlock).stimTwoLoadEnd(iTrial)         = stimTwoLoadEnd;
           trialOutput(iBlock).stimTwoLoadDuration(iTrial)    = stimTwoLoadEnd - stimTwoLoadStart;
           trialOutput(iBlock).stimTwoStartStart(iTrial)      = stimTwoStartStart; 
           trialOutput(iBlock).stimTwoStartEnd(iTrial)        = stimTwoStartEnd;
           trialOutput(iBlock).stimTwoStartDuration(iTrial)   = stimTwoStartEnd - stimTwoStartStart;
           
           %tell subject how they did on last block
           if iTrial == exptdesign.numTrialsPerSession && iBlock < exptdesign.numBlocks
               %calculate accuracy
               accuracyForLevel=mean(trialOutput(iBlock).accuracy);
               drawAndCenterText(w, ['Your accuracy was ' num2str(round(accuracyForLevel.*100)) '%\n\n\n'...
                    'Click mouse to continue' ],1)
               %WaitSecs(2);
               KbWait(1);
           elseif iTrial == exptdesign.numTrialsPerSession && iBlock == exptdesign.numBlocks
               %calculate accuracy
               accuracyForLevel=mean(trialOutput(iBlock).accuracy);
               drawAndCenterText(w, ['Your accuracy was ' num2str(round(accuracyForLevel.*100)) '%\n\n\n'...
                   'You have completed this training session.  Great job!' ],1)
               %WaitSecs(2);
               KbWait(1);
               Screen('CloseAll')
           end
           
           clear correctResponse correctionTexture;
        end  

        %save the session data in the data directory
        save(['./data/' exptdesign.number '/' datestr(now, 'yyyymmdd_HHMM') '-' exptdesign.subjectName '_block' num2str(iBlock) '.mat'], 'trialOutput', 'exptdesign');
        %save the history data (stimuli, last level passed)
        
        
    end
    
    ShowCursor;
    
end
    
function drawAndCenterText(window,message,wait)
    if nargin < 3
        wait = 1;
    end
    
    % Now horizontally and vertically centered:
    [nx, ny, bbox] = DrawFormattedText(window, message, 'center', 'center', 0);
    black = BlackIndex(window); % pixel value for black               
    Screen('Flip',window);
    %KbWait(1) waits for a MOUSE click to continue
    if wait, KbWait(1); end
    WaitSecs(0.2); %this is necessary on the windows XP machine to wait for mouse response -- DOES delay timing!
end

function numericalanswer = getResponseMouse(waitTime)

  %Wait for a response
  numericalanswer = -1;
  mousePressed = 0;
  startWaiting=clock;
  while etime(clock,startWaiting) < waitTime && mousePressed == 0
      %check to see if a button is pressed
       [x,y,buttons] = GetMouse();
       if (~buttons(1) && ~buttons(3))
           continue;
       else
           if buttons(1)
               numericalanswer = 1;
           elseif buttons(3)
               numericalanswer = 2;
           else
               numericalanswer = 0;
           end
          if numericalanswer ~= -1
              %stop checking for a button press
              mousePressed = 1;
          end
       end

  end
end

function [stimLoadStart, stimLoadEnd,stimStartStart, stimStartEnd] = constructStimuli(stimulus)
    f = stimulus(1);
    p = stimulus(2);

    stim = {...
        {'fixed',f,1,300},...
        {'fixchan',p},...
        };

    [t,s]=buildTSM_nomap(stim);
    
    stimLoadStart = GetSecs;
    stimGenPTB('load',s,t);
    stimLoadEnd = GetSecs;
    rtn=-1;
    
    stimStartStart = GetSecs;
    while rtn==-1
        rtn=stimGenPTB('start');
    end
    stimStartEnd = GetSecs;
end
