f1=2.^([0:.1:2]+log2(25));

frequency = [f1(2) f1(20)];

channels = [1 3 5 9; 5 9 11 13];
pair1 = [repmat(1,1,4), repmat(3,1,4), repmat(5,1,4), repmat(9,1,4), repmat(11,1,4), repmat(13,1,4),...
         repmat(1,1,4), repmat(3,1,4), repmat(5,1,4), repmat(9,1,4), repmat(11,1,4), repmat(13,1,4);
         repmat(frequency(1),1,24), repmat(frequency(2),1,24)];
         
pair2 = [repmat(channels(1,:),1,3), repmat(channels(2,:),1,3),...
         repmat(channels(1,:),1,3), repmat(channels(2,:),1,3);
         repmat(frequency(1),1,24), repmat(frequency(2),1,24)];   
    
%combine frequency combinations with position pairs 
stimuli = [pair1; pair2];
stimuli = [repmat(stimuli,1,3)]; 

% populate trial structure with 2 instances of the same stimulus
save ('positionLocalizationStimuli_0.mat','stimuli')