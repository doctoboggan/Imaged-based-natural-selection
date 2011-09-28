function [finalChild lastFitness] = evolve(mommy,daddy,fertility,generations,percentMutated,mutationRate,goal)
%This function simulates the sexual reproduction of mommy and daddy, which
%should both be 2 dimensional arrays.

%-fertility is how many babies in each generation
%-generations is the number of generations to cycle through
%-percentMutated is a number between 0 and 1 representing percentage of
    %offspring that receive a mutation
%-mutationRate is a number between 0 and 1 representing percentage of child
    %that is mutated
%-goal is the final goal of evolution (2 dimensional array).


%Initialize variables
[m,n]=size(mommy);
children=zeros(m,n,fertility);
fitness=zeros(fertility,1);
fitnessGraph=zeros(1,generations);

%Two loops, one for generations, and one for children in that generation.
for mm=1:generations
    for nn=1:fertility 
        sperm=randint(m,n); %Randomly select 50% of the father
        egg=not(sperm); %Select the other 50% from the mother
        
        %Here is the sexual reproduction. Must be 18 or older to read past
        %this line. We first combine the mommy and daddy pieces we selected
        %earlier. To create the mutations we create a zeros matrix the
        %same size as the child and randomly add 1s up to the percentage
        %defined by mutationRate. We then multiply this by either 0 or 1
        %depending on percentMutated, to decide of this child gets mutated
        %or not. Then this whole matrix is subtracted from the child and
        %the absolute value is taken to keep numbers positive.
        children(:,:,nn)=abs((sperm.*daddy+egg.*mommy)-(randsrc(1,1,[1 0;percentMutated 1-percentMutated]).*(randsrc(m,n,[1 0;mutationRate 1-mutationRate]))));
        
        %The fitness variable is how much this child differs from the goal
        %matrix.
        fitness(nn)=sum(sum(abs(children(:,:,nn)-goal)));
    end
    
    %Here we select the best two childred to mate for the next generation.
    %Very incestual.
    [y,i]=sort(fitness);
    bestChild=children(:,:,i(1));
    secondChild=children(:,:,i(2));
    
    %Store the fitness of the best child for your graphing pleasure.
    fitnessGraph(mm)=y(1);
    
    %Awww, there all grown up, and starting their own families now.
    daddy=bestChild;
    mommy=secondChild;
end

%Plot the goal
figure(1);
image(goal*255);

%Plot the best child
figure(2);
image(bestChild*255);

%Plot the fitness of the best child from each generation.
figure(3);
plot([1:generations],fitnessGraph);

%Set output variables.
lastFitness=sort(fitness);
finalChild=bestChild;