function [specieClassified, subSpecieClassified] = customizedImageGetSpecieAndSubSpecie(isToTrainWithProps, image, imageProps)
% CARREGA A REDE
disp('Please wait while the neural network is being uploaded...')
% REDE CARREGADA
% DECIDE INPUTS
if isToTrainWithProps == 2.0
    % Specie
    load('neuralNetworkSpeciesProps.mat')
    netSpecies = redeEspecie;
    clear redeEspecie;
    load('trSpeciesProps.mat')
    trSpecies = trEspecie;
    clear trEspecie;
    % Subspecie
    load('neuralNetworkSubSpeciesProps.mat')
    netSubSpecies = redeSubEspecie;
    clear redeSubEspecie;
    load('trSubSpeciesProps.mat')
    trSubSpecies = trSubEspecie;
    clear trSubEspecie;
    % Image
    image = imageProps; %size(image)
    clear imageProps;
    image=image';
else
    % Specie
    load('neuralNetworkSpecies.mat')
    netSpecies = redeEspecie;
    clear redeEspecie;
    load('trSpecies.mat')
    trSpecies = trEspecie;
    clear trEspecie;
    % Subspecie
    load('neuralNetworkSubSpecies.mat')
    netSubSpecies = redeSubEspecie;
    clear redeSubEspecie;
    load('trSubSpecies.mat')
    trSubSpecies = trSubEspecie;
    clear trSubEspecie;
    % Image
    clear imageProps;
end
disp('Please wait while the simulation of the training of the neural network is ongoing...')
% SIMULAR
outSpecies = sim(netSpecies, image);
outSubSpecies = sim(netSubSpecies, image);
%VISUALIZAR DESEMPENHO

disp('Please wait while the classification is being calculated...')
%Calcula e mostra a percentagem de classificacoes corretas no total dos exemplos
for i=1:size(outSpecies,2)               % Para cada classificacao
    [a b] = max(outSpecies(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
end
specieClassified=b;
for i=1:size(outSubSpecies,2)               % Para cada classificacao
    [a b] = max(outSubSpecies(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
end
subSpecieClassified=b;
end
