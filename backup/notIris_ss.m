function [net, tr, accuracy, time, epochs] = notIris_ss(isToTrain, funcTreino, cam1Treino, cam2Treino, trainRatio, valRatio, testRatio, trainTool, isToTrainWithProps, isToDivideFcn, camadasEscondidas, isToPlot, redeCarregada)
disp('The neural network to recognize the sub species will start!')
disp('Please wait! The neural network is being created and configured...')
% CRIAR E CONFIGURAR A REDE NEURONAL
% Camadas Escondidas
net = feedforwardnet(camadasEscondidas);
disp('The training functions are being configured...')
% INDICAR: Funcao de treino: fishe{'trainlm', 'trainbfg', traingd'}
if funcTreino == 1.0
    net.trainFcn = 'trainlm';
elseif funcTreino == 2.0
    net.trainFcn = 'traingd';
else
    net.trainFcn = 'trainbfg';
end
% INDICAR: Funcoes de ativacao das camadas escondidas e de saida: {'purelin', 'logsig', 'tansig'}
% FUNCAO DE ATIVACAO DA CAMADA DE SAIDA
if cam2Treino == 6.0
    % CAMADA 1
    if cam1Treino == 1.0
        net.layers{1}.transferFcn = 'hardlim'; %(camada 1, step)
    elseif cam1Treino == 2.0
        net.layers{1}.transferFcn = 'purelin'; %(camada 1, linear)
    elseif cam1Treino == 3.0
        net.layers{1}.transferFcn = 'logsig'; %(camada 1, sigmoid)
    elseif cam1Treino == 4.0
        net.layers{1}.transferFcn = 'tansig'; %(camada 1, tanH)
    elseif cam1Treino == 5.0
        net.layers{1}.transferFcn = 'hardlims'; %(camada 1, sinal)
    end
else
    % CAMADA 1
    if cam1Treino == 1.0
        net.layers{1}.transferFcn = 'hardlim'; %(camada 1, step)
    elseif cam1Treino == 2.0
        net.layers{1}.transferFcn = 'purelin'; %(camada 1, linear)
    elseif cam1Treino == 3.0
        net.layers{1}.transferFcn = 'logsig'; %(camada 1, sigmoid)
    elseif cam1Treino == 4.0
        net.layers{1}.transferFcn = 'tansig'; %(camada 1, tanH)
    elseif cam1Treino == 5.0
        net.layers{1}.transferFcn = 'hardlims'; %(camada 1, sinal)
    end
    
    % CAMADA 2
    if cam2Treino == 1.0
        net.layers{2}.transferFcn = 'hardlim'; %(camada 2, step)
    elseif cam2Treino == 2.0
        net.layers{2}.transferFcn = 'purelin'; %(camada 2, linear)
    elseif cam2Treino == 3.0
        net.layers{2}.transferFcn = 'logsig'; %(camada 2, sigmoid)
    elseif cam2Treino == 4.0
        net.layers{2}.transferFcn = 'tansig'; %(camada 2, tanH)
    elseif cam2Treino == 5.0
        net.layers{2}.transferFcn = 'hardlims'; %(camada 2, sinal)
    end
end

disp('The percentages of the training function, validation and test are being configured...')
% INDICAR: Divisao dos exemplos pelos conjuntos de treino, validacao e teste
%A fun��o de divis�o por defeito (dividerand) cria os 3 conjuntos de
%treino, valida��o e teste, respetivamente, com 70%, 15% e 15% dos exemplos. Estes valores
%podem ser alterados atrav�s das vari�veis pertencentes ao objeto net.divideParam .

if isToDivideFcn == 1.0
    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = trainRatio;
    net.divideParam.valRatio = valRatio;
    net.divideParam.testRatio = testRatio;
end
disp('The images are vectorized and the indicators of the species are being uploaded to the neural network...')
if isToTrainWithProps == 1.0
    load('imagesPropertiesSub.mat')
    disp('Okay')
    imagesvectorizedSub = imagesPropertiesSub;
    clear imagesPropertiesSub;
else
    load('imagesvectorizedSub.mat')
end
load('labelsSubSpecies.mat')
imagesvectorizedSub=imagesvectorizedSub';
if trainTool == 0.0
    net.trainParam.showWindow = 0;
end
% COMPLETAR A RESTANTE CONFIGURACAO

disp('The configuration of the neural network finished.')
% TREINAR
if isToTrain
    disp('Please wait while the neural network is training...')
    if redeCarregada == 1 && isToTrainWithProps == 0.0
        disp('The neural network with binary has been uploaded successfuly!')
        load('neuralNetworkSubSpecies.mat')
        net = redeSubEspecie;
        clear redeSubEspecie;
    else
        if redeCarregada == 1 && isToTrainWithProps == 1.0
            disp('The neural network with characteristics has been uploaded successfuly!')
            load('neuralNetworkSubSpeciesProps.mat')
            net = redeSubEspecie;
            clear redeSubEspecie;
        end
    end
    [net,tr] = train(net, imagesvectorizedSub, labelsSubEspecies);
else
    disp('Please wait! The neural network is being uploaded...')
    if isToTrainWithProps == 1.0
        load('neuralNetworkSubSpeciesProps.mat')
        net = redeSubEspecie;
        clear redeSubEspecie;
        load('trSubSpeciesProps.mat')
        tr = trSubEspecie;
        clear trSubEspecie;
    else
        load('neuralNetworkSubSpecies.mat')
        net = redeSubEspecie;
        clear redeSubEspecie;
        load('trSubSpecies.mat')
        tr = trSubEspecie;
        clear trSubEspecie;
    end
end
disp('Please wait! A simulation for the training of the neural network is being done!')
% SIMULAR
out = sim(net, imagesvectorizedSub);

disp('Please wait! The plots are being prepared...')
%VISUALIZAR DESEMPENHO
if isToPlot == 1.0
    %plotconfusion(labelsSubEspecies, out) % Matriz de confusao
    plotperf(tr)         % Grafico com o desempenho da rede nos 3 conjuntos
end
disp('Please wait! The classifications are being calculated...')
%Calcula e mostra a percentagem de classificacoes corretas no total dos exemplos
r=0;
for i=1:size(out,2)               % Para cada classificacao
    [a b] = max(out(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
    [c d] = max(labelsSubEspecies(:,i));  %d guarda a linha onde encontrou valor mais alto da saida desejada
    if b == d                       % se estao na mesma linha, a classificacao foi correta (incrementa 1)
        r = r+1;
    end
end
accuracy = r/size(out,2)*100;
%fprintf('Precisao total %f\n', accuracy)

disp('Please wait! A simulation is being done in the test set...')
if isToTrain
    % SIMULAR A REDE APENAS NO CONJUNTO DE TESTE
    TInput = imagesvectorizedSub(:, tr.testInd);
    TTargets = labelsSubEspecies(:, tr.testInd);
    
    out = sim(net, TInput);
    
    disp('Please wait! The classifications are being calculated for the test set...')
    %Calcula e mostra a percentagem de classificacoes corretas no conjunto de teste
    r=0;
    for i=1:size(tr.testInd,2)               % Para cada classificacao
        [a b] = max(out(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
        [c d] = max(TTargets(:,i));  %d guarda a linha onde encontrou valor mais alto da saida desejada
        if b == d                       % se estao na mesma linha, a classificacao foi correta (incrementa 1)
            r = r+1;
        end
    end
    accuracy = r/size(tr.testInd,2)*100;
    time = tr.time(:,size(tr.time,2))/60;
    time = round(time,2);
    epochs = tr.num_epochs;
else
    time = -1;
    epochs = -1;
end
%fprintf('Precisao teste %f\n', accuracy)



xx = net.IW{1,:};                    % w's de todos os inputs para a camada 1
yy1 = net.LW(2,1);                  % w's entre a camada 1 e a camada 2
xx1 = net.b{1};                      % w0's (bias) da camada 1
b1 = net.b{2};                      % bias output

%fprintf('ws entre inputs e camada 1 \n');
%disp(xx);
%fprintf('ws entre camada 1 e camada 2\n');
%disp(yy1);
%fprintf('w0 s (bias) da camada 1\n');
%disp(xx1);
%fprintf('ws entre camada 2 e camada de saida \n');
%disp(b1);

% SE E PARA MELHORAR A REDE ENTAO GUARDA LOGO
if redeCarregada == 1 && isToTrain
    redeSubEspecie = net;
    trSubEspecie = tr;
    if isToTrainWithProps == 1.0
        save('neuralNetworkSubSpeciesProps.mat','redeSubEspecie')
        save('trSubSpeciesProps.mat','trSubEspecie')
        disp('The neural network has been saved successfuly!')
    else
        save('neuralNetworkSubSpecies.mat','redeSubEspecie')
        save('trSubSpecies.mat','trSubEspecie')
        disp('The neural network has been saved successfuly!')
    end
end
end

