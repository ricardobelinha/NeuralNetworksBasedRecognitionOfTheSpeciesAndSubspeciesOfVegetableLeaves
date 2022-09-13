function b = customizedImageGetSubSpecie(isToTrainWithProps, image, imageProps)
% CARREGA A REDE
disp('Please wait while the neural network is being uploaded...')
% REDE CARREGADA
% DECIDE INPUTS
if isToTrainWithProps == 2.0
    load('neuralNetworkSubSpeciesProps.mat')
    net = redeSubEspecie;
    clear redeSubEspecie;
    load('trSubSpeciesProps.mat')
    tr = trSubEspecie;
    clear trSubEspecie;
    image = imageProps;%size(image)
    clear imageProps;
    image=image';
else
    load('neuralNetworkSubSpecies.mat')
    net = redeSubEspecie;
    clear redeSubEspecie;
    load('trSubSpecies.mat')
    tr = trSubEspecie;
    clear trSubEspecie;
    clear imageProps;
end
disp('Please wait while the simulation of the training of the neural network is ongoing...')
% SIMULAR
out = sim(net, image);
disp('Please wait while the classification is being calculated...')
for i=1:size(out,2)               % Para cada classificacao
    [a b] = max(out(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
end
end

