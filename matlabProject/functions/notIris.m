function [netSpecies, trSpecies, accuracySpecies, timeSpecies, epochsSpecies, netSubSpecies, trSubSpecies, accuracySubSpecies, timeSubSpecies, epochsSubSpecies] = notIris(isToTrain, funcTreino, cam1Treino, cam2Treino, trainRatio, valRatio, testRatio, trainTool, isToTrainWithProps, isToDivideFcn, camadasEscondidas, isToPlot, redeCarregada)
%disp(camadasEscondidas);
disp('The neural network to recognize the species will start!')
disp('Please wait! The neural network is being created and configured...')
% CRIAR E CONFIGURAR A REDE NEURONAL
% Camadas Escondidas
netSpecies = feedforwardnet(camadasEscondidas);
netSubSpecies = feedforwardnet(camadasEscondidas);
% INDICAR: N? camadas escondidas e nos por camada escondida //1 no
% enunciado
disp('The training functions are being configured...')
%net.layers{3}.transferFcn = 'purelin'; %(camada 2, pure linear)
% INDICAR: Funcao de treino: fishe{'trainlm', 'trainbfg', traingd'}
if funcTreino == 1.0
    netSpecies.trainFcn = 'trainlm';
    netSubSpecies.trainFcn = 'trainlm';
elseif funcTreino == 2.0
    netSpecies.trainFcn = 'traingd';
    netSubSpecies.trainFcn = 'traingd';
else
    netSpecies.trainFcn = 'trainbfg';
    netSubSpecies.trainFcn = 'traingd';
end
% INDICAR: Funcoes de ativacao das camadas escondidas e de saida: {'purelin', 'logsig', 'tansig'}
% FUNCAO DE ATIVACAO DA CAMADA DE SAIDA
%aqui coloca-se o nº da camada onde se quer mexer
% CAMADA 1
if cam1Treino == 1.0
	netSpecies.layers{1}.transferFcn = 'hardlim'; %(camada 1, step)
    netSubSpecies.layers{1}.transferFcn = 'hardlim'; %(camada 1, step)
elseif cam1Treino == 2.0
	netSpecies.layers{1}.transferFcn = 'purelin'; %(camada 1, linear)
    netSubSpecies.layers{1}.transferFcn = 'purelin'; %(camada 1, linear)
elseif cam1Treino == 3.0
	netSpecies.layers{1}.transferFcn = 'logsig'; %(camada 1, sigmoid)
    netSubSpecies.layers{1}.transferFcn = 'logsig'; %(camada 1, sigmoid)
elseif cam1Treino == 4.0
	netSpecies.layers{1}.transferFcn = 'tansig'; %(camada 1, tanH)
    netSubSpecies.layers{1}.transferFcn = 'tansig'; %(camada 1, tanH)
elseif cam1Treino == 5.0
	netSpecies.layers{1}.transferFcn = 'hardlims'; %(camada 1, sinal)
    netSubSpecies.layers{1}.transferFcn = 'hardlims'; %(camada 1, sinal)
end
% CAMADA 2
if cam2Treino == 1.0
    netSpecies.layers{2}.transferFcn = 'hardlim'; %(camada 2, step)
    netSubSpecies.layers{2}.transferFcn = 'hardlim'; %(camada 2, step)
elseif cam2Treino == 2.0
    netSpecies.layers{2}.transferFcn = 'purelin'; %(camada 2, linear)
    netSubSpecies.layers{2}.transferFcn = 'purelin'; %(camada 2, linear)
elseif cam2Treino == 3.0
    netSpecies.layers{2}.transferFcn = 'logsig'; %(camada 2, sigmoid)
    netSubSpecies.layers{2}.transferFcn = 'logsig'; %(camada 2, sigmoid)
elseif cam2Treino == 4.0
    netSpecies.layers{2}.transferFcn = 'tansig'; %(camada 2, tanH)
    netSubSpecies.layers{2}.transferFcn = 'tansig'; %(camada 2, tanH)
elseif cam2Treino == 5.0
    netSpecies.layers{2}.transferFcn = 'hardlims'; %(camada 2, sinal)
    netSubSpecies.layers{2}.transferFcn = 'hardlims'; %(camada 2, sinal)
end
disp('The percentages of the training function, validation and test are being configured...')
% INDICAR: Divisao dos exemplos pelos conjuntos de treino, validacao e teste
%A função de divisão por defeito (dividerand) cria os 3 conjuntos de
%treino, validação e teste, respetivamente, com 70%, 15% e 15% dos exemplos. Estes valores
%podem ser alterados através das variáveis pertencentes ao objeto net.divideParam .
if isToDivideFcn == 1.0
    % Species
	netSpecies.divideFcn = 'dividerand';
	netSpecies.divideParam.trainRatio = trainRatio;
	netSpecies.divideParam.valRatio = valRatio;
	netSpecies.divideParam.testRatio = testRatio;
    % Subspecies
    netSubSpecies.divideFcn = 'dividerand';
	netSubSpecies.divideParam.trainRatio = trainRatio;
	netSubSpecies.divideParam.valRatio = valRatio;
	netSubSpecies.divideParam.testRatio = testRatio;
end
disp('The images are vectorized and the indicators of the species are being uploaded to the neural network...')
if isToTrainWithProps == 1.0
    % Species
    load('imagesProperties.mat')
	imagesvectorized = imagesProperties;
	clear imagesProperties;
    % Subspecies
  	load('imagesPropertiesSub.mat')
	imagesvectorizedSub = imagesPropertiesSub;
	clear imagesPropertiesSub;
else
    % Species
    load('imagesvectorized.mat')
    % Subspecies
    load('imagesvectorizedSub.mat')
end
% Species
load('labelsSpecies.mat')
imagesvectorized=imagesvectorized';
% Subspecies
load('labelsSubSpecies.mat')
imagesvectorizedSub=imagesvectorizedSub';
% Show training window
if trainTool == 0.0
    netSpecies.trainParam.showWindow = 0;
    netSubSpecies.trainParam.showWindow = 0;
end
% COMPLETAR A RESTANTE CONFIGURACAO
disp('The configuration of the neural network finished.')
% TREINAR
if isToTrain
    disp('Please wait while the neural network is training...')
    if redeCarregada == 1 && isToTrainWithProps == 0.0
        % Species
        load('neuralNetworkSpecies.mat')
        netSpecies = redeEspecie;
        clear redeEspecie;
        % Subspecies
        load('neuralNetworkSubSpecies.mat')
        netSubSpecies = redeSubEspecie;
        clear redeSubEspecie;
        % Display message
        disp('The neural networks for Species and Subspecies with images in binary have been uploaded successfuly!')
    else
        if redeCarregada == 1 && isToTrainWithProps == 1.0
            % Species
            load('neuralNetworkSpeciesProps.mat')
            netSpecies = redeEspecie;
            clear redeEspecie;
            % Subspecies
            load('neuralNetworkSubSpeciesProps.mat')
            netSubSpecies = redeSubEspecie;
            clear redeSubEspecie;
            % Display message
            disp('The neural network with characteristics has been uploaded successfuly!')
        end
    end
    % Species
    [netSpecies,trSpecies] = train(netSpecies, imagesvectorized, labels);
    % Subspecies
    [netSubSpecies,trSubSpecies] = train(netSubSpecies, imagesvectorizedSub, labelsSubEspecies);
else
    disp('Please wait! The neural network is being uploaded...')
    if isToTrainWithProps == 1.0
        % Species
        load('neuralNetworkSpeciesProps.mat')
        netSpecies = redeEspecie;
        clear redeEspecie;
        load('trSpeciesProps.mat')
        trSpecies = trEspecie;
        clear trEspecie;
        % Subspecies
        load('neuralNetworkSubSpeciesProps.mat')
        netSubSpecies = redeSubEspecie;
        clear redeSubEspecie;
        load('trSubSpeciesProps.mat')
        trSubSpecies = trSubEspecie;
        clear trSubEspecie;
    else
        % Species
        load('neuralNetworkSpecies.mat')
        netSpecies = redeEspecie;
        clear redeEspecie;
        load('trSpecies.mat')
        trSpecies = trEspecie;
        clear trEspecie;
        % Subspecies
        load('neuralNetworkSubSpecies.mat')
        netSubSpecies = redeSubEspecie;
        clear redeSubEspecie;
        load('trSubSpecies.mat')
        trSubSpecies = trSubEspecie;
        clear trSubEspecie;
    end
end
%view(net);
disp('Please wait! A simulation for the training of the neural network for the Species is being done!')
% SIMULAR Species
outSpecies = sim(netSpecies, imagesvectorized);
disp('Please wait! The plots are being prepared for the species...')
%VISUALIZAR DESEMPENHO
if isToPlot == 1.0
    %plotconfusion(labels, out) % Matriz de confusao
    plotperf(trSpecies)         % Grafico com o desempenho da rede nos 3 conjuntos
end
disp('The plots are done for the species!')
% SIMULAR Subspecies
outSubSpecies = sim(netSubSpecies, imagesvectorizedSub);
disp('Please wait! The plots are being prepared for the subspecies...')
%VISUALIZAR DESEMPENHO
if isToPlot == 1.0
    %plotconfusion(labelsSubEspecies, out) % Matriz de confusao
    plotperf(trSubSpecies)         % Grafico com o desempenho da rede nos 3 conjuntos
end
disp('The plots are done for the subspecies!')
disp('Please wait! The classifications for the species are being calculated...')
%Calcula e mostra a percentagem de classificacoes corretas no total dos exemplos
r=0;
for i=1:size(outSpecies,2)               % Para cada classificacao
    [a b] = max(outSpecies(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
    [c d] = max(labels(:,i));  %d guarda a linha onde encontrou valor mais alto da saida desejada
    if b == d                       % se estao na mesma linha, a classificacao foi correta (incrementa 1)
        r = r+1;
    end
end
accuracySpecies = r/size(outSpecies,2)*100;
%fprintf('Precisao total %f\n', accuracySpecies)
disp('The classifications for the species have been done!')
disp('Please wait! The classifications for the subspecies are being calculated...')
%Calcula e mostra a percentagem de classificacoes corretas no total dos exemplos
r=0;
for i=1:size(outSubSpecies,2)               % Para cada classificacao
    [a b] = max(outSubSpecies(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
    [c d] = max(labelsSubEspecies(:,i));  %d guarda a linha onde encontrou valor mais alto da saida desejada
    if b == d                       % se estao na mesma linha, a classificacao foi correta (incrementa 1)
        r = r+1;
    end
end
accuracySubSpecies = r/size(outSubSpecies,2)*100;
%fprintf('Precisao total %f\n', accuracySubSpecies)
disp('The classifications for the subspecies have been done!')
% Simulation for the test set
if isToTrain
    % Species
    disp('Please wait! A simulation is being done in the test set for the species...')
    % SIMULAR A REDE APENAS NO CONJUNTO DE TESTE
    TInput = imagesvectorized(:, trSpecies.testInd);
    TTargets = labels(:, trSpecies.testInd);
    outSpecies = sim(netSpecies, TInput);
    disp('Please wait! The classifications are being calculated for the test set for the species...')
    % Calcula e mostra a percentagem de classificacoes corretas no conjunto de teste
    r=0;
    for i=1:size(trSpecies.testInd,2)               % Para cada classificacao
        [a b] = max(outSpecies(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
        [c d] = max(TTargets(:,i));  %d guarda a linha onde encontrou valor mais alto da saida desejada
        if b == d                       % se estao na mesma linha, a classificacao foi correta (incrementa 1)
            r = r+1;
        end
    end
    accuracySpecies = r/size(trSpecies.testInd,2)*100;
    timeSpecies = trSpecies.time(:,size(trSpecies.time,2))/60;
    timeSpecies = round(timeSpecies,2);
    epochsSpecies = trSpecies.num_epochs;
    % Subspecies
    disp('Please wait! A simulation is being done in the test set for the subspecies...')
    % SIMULAR A REDE APENAS NO CONJUNTO DE TESTE
    TInput = imagesvectorizedSub(:, trSubSpecies.testInd);
    TTargets = labelsSubEspecies(:, trSubSpecies.testInd);
    outSubSpecies = sim(netSubSpecies, TInput);
    disp('Please wait! The classifications are being calculated for the test set for the subspecies...')
    %Calcula e mostra a percentagem de classificacoes corretas no conjunto de teste
    r=0;
    for i=1:size(trSubSpecies.testInd,2)               % Para cada classificacao
        [a b] = max(outSubSpecies(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
        [c d] = max(TTargets(:,i));  %d guarda a linha onde encontrou valor mais alto da saida desejada
        if b == d                       % se estao na mesma linha, a classificacao foi correta (incrementa 1)
            r = r+1;
        end
    end
    accuracySubSpecies = r/size(trSubSpecies.testInd,2)*100;
    timeSubSpecies = trSubSpecies.time(:,size(trSubSpecies.time,2))/60;
    timeSubSpecies = round(timeSubSpecies,2);
    epochsSubSpecies = trSubSpecies.num_epochs;
else
    % Species
    timeSpecies = -1;
    epochsSpecies = -1;
    % Subspecies
    timeSubSpecies = -1;
    epochsSubSpecies = -1;
end
% Species
xxSpecies = netSpecies.IW{1,:};                    % w's de todos os inputs para a camada 1
yy1Species = netSpecies.LW(2,1);                  % w's entre a camada 1 e a camada 2
xx1Species = netSpecies.b{1};                      % w0's (bias) da camada 1
b1Species = netSpecies.b{2};                      % bias output
% SubSpecies
xxSubSpecies = netSubSpecies.IW{1,:};                    % w's de todos os inputs para a camada 1
yy1SubSpecies = netSubSpecies.LW(2,1);                  % w's entre a camada 1 e a camada 2
xx1SubSpecies = netSubSpecies.b{1};                      % w0's (bias) da camada 1
b1SubSpecies = netSubSpecies.b{2};                      % bias output

% SE E PARA MELHORAR A REDE ENTAO GUARDA LOGO
if redeCarregada == 1 && isToTrain
    % Specie
    redeEspecie = netSpecies;
    trEspecie = trSpecies;
    if isToTrainWithProps == 1.0
        save('neuralNetworkSpeciesProps.mat','redeEspecie')
        save('trSpeciesProps.mat','trEspecie')
        disp('The species neural network has been saved successfuly!')
    else
        save('neuralNetworkSpecies.mat','redeEspecie')
        save('trSpecies.mat','trEspecie')
        disp('The species neural network has been saved successfuly!')
    end
    % SubSpecie
    redeSubEspecie = netSubSpecies;
    trSubEspecie = trSubSpecies;
    if isToTrainWithProps == 1.0
        save('neuralNetworkSubSpeciesProps.mat','redeSubEspecie')
        save('trSubSpeciesProps.mat','trSubEspecie')
        disp('The subspecies neural network has been saved successfuly!')
    else
        save('neuralNetworkSubSpecies.mat','redeSubEspecie')
        save('trSubSpecies.mat','trSubEspecie')
        disp('The subspecies neural network has been saved successfuly!')
    end
end
%disp(camadasEscondidas);
end
