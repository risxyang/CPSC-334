#!/usr/bin/env python3

# Old Code written for a Genetic Algorithm assignment

import matplotlib.pyplot as plt
import numpy as np
import random

def crossover(p1_genes, p2_genes, probability_crossover): #takes in genes of two parents, outputs child gene produced w/ multi point crossover
    #TODO START
    ch1_genes = ""
    ch2_genes = ""
    curr = 1 #oscillate between 1 or 2, depending on which parent's genes you're currently taking from
    i = 0
    while i < 30: #length of all ant genes
        switch_chance = random.uniform(0,1)
        if(curr == 1):
            ch1_genes += p1_genes[i:i+3]
            ch2_genes += p2_genes[i:i+3]
            if(switch_chance < probability_crossover):
                curr = 2
        else:
            ch1_genes += p2_genes[i:i+3]
            ch2_genes += p1_genes[i:i+3]
            if(switch_chance < probability_crossover):
                curr = 1
        i += 3

    return ch1_genes, ch2_genes
    #TODO END


def mutate(ch_genes, probability_mutation):
    #TODO START
    new_ch_genes = ""

    i = 0
    while i < 30:
        rand_mutation = random.uniform(0,1)
        rand_digit = random.randint(0,9)
    
        if rand_mutation < probability_mutation:
            #generate rand index
            rand_index = random.randint(0,9)
            c1 = str((int(ch_genes[rand_index * 3]) + rand_digit) % 4 + 1)
            c2 = str((int(ch_genes[rand_index * 3 + 1]) + rand_digit) % 9)
            c3 = str((int(ch_genes[rand_index * 3 + 2]) + rand_digit) % 9)
            new_ch_genes += (c1 + c2 + c3)
        else:
            new_ch_genes += ch_genes[i:i+3]
        
        i += 3
    #TODO END
    return new_ch_genes

def select(old_gen, fitness):
    #TODO START
    pop_num = len(fitness)
    rand_range = 0
    for i in range(1, pop_num + 1):
        rand_range += i

    rand_index_1 = random.randint(1, rand_range)
    rand_index_2 = random.randint(1, rand_range)
    c_index_1 = 0
    c_index_2 = 0
    
    for i in range(1, pop_num + 1):
        if (rand_index_1 < i):
            c_index_1 = pop_num - i
            break
        else:
            rand_index_1 -= i

    for i in range(1, pop_num + 1):
        if (rand_index_2 < i):
            c_index_2 = pop_num - i
            break
        else:
            rand_index_2 -= i

    return(population[fitness[c_index_1][1]], population[fitness[c_index_2][1]])
    
    #TODO END

#genetic algorithm
    #X generate random population of n chromosomes
    ##evaluate fitness of each chromosome
        #selection -- select two parent chromosomes based on their fitness
        #crossover -- with a crossover probability, cross over parents to form children. if no crossover, offspring is exact copy of parents
        #mutation -- w/ mutation probability, mutate new offspring at each position in chromosome
        #accepting -- place new offspring in a new population
    #replace -- use new generated population for a further run of algorithm
    #test -- if end condition is satisfied, stop and return best solution in current population
    #loop to step 2 if needed


def genetic_algorithm(population, food_map, max_generation, probability_crossover, probability_mutation):
    #RETURNS the maximum fitness in the last generatino, the individual gene with the maximum fitness in the last generation, the trial of the individual with the maximum fitness in the last generation, the overall statistics of all the generations (aka a list of [max fitness, min fitness, average fitness] of each generation, population in last generation)
    #TODO START
    
    food_map, map_size = get_map(food_map) #just working w/ the defined paramters, food_map is at first just the name of the map
    curr_generation = 1
    overall_stats = [] #list of [max fitness, min fitness, avg fitness] 
    last_gen_max_fitness = 0
    last_gen_max_fitness_gene = ""
    last_gen_max_fitness_trial = []

    last_gen_population = genetic_algorithm_helper(population, food_map, map_size, max_generation, probability_crossover, probability_mutation, curr_generation, overall_stats, last_gen_max_fitness, last_gen_max_fitness_gene, last_gen_max_fitness_trial)

    for line in overall_stats:
        print(line)

    return(last_gen_max_fitness, last_gen_max_fitness_gene, overall_stats, last_gen_population)
     
    #TODO END
    
def genetic_algorithm_helper(population, food_map, map_size, max_generation, probability_crossover, probability_mutation, curr_generation, overall_stats, last_gen_max_fitness, last_gen_max_fitness_gene, last_gen_max_fitness_trial):

    if curr_generation > max_generation:
        return population
    elif curr_generation <= max_generation:
        fitness_log = [] #each item in array has formatting: [fitness, index of ant with this fitness]

        #run trials for every ant in this population
        #keep track of avg fitness, trial of most fit ant
        total_fitness = 0
        gen_largest_fitness = 0
        for i, ant_genes in enumerate(population):
            trial, fitness = ant_simulator(food_map, map_size, ant_genes) 
            fitness_log.append([fitness, i])
            total_fitness += fitness
            if(fitness > gen_largest_fitness):
                gen_largest_fitness = fitness
                display_trials(trial, "last_gen_max_fitness_trial.txt")

        
        children = []

        fitness_sorted = sorted(fitness_log, key = lambda x: -x[0])

        #keep 40% most fit children
        num_elites = int((len(population) * 0.4))
        num_rest = len(population) - num_elites

        for i in range(num_elites):
            children.append(population[fitness_sorted[i][1]])

        last_gen_max_fitness = fitness_sorted[0][0]
        last_gen_max_fitness_gene = population[fitness_sorted[0][1]]
        overall_stats.append([fitness_sorted[0][0], fitness_sorted[len(population) - 1][0], total_fitness / len(population)])


        #for the rest of the children: select, possibly crossover and/or mutate
        for i in range(int(num_rest / 2)): #use 40% elite to populate last 60%
            p1, p2 = select(population, fitness_sorted[:num_elites]) 
            ch1, ch2 = crossover(p1, p2, probability_crossover)
            ch1 = mutate(ch1, probability_mutation)
            ch2 = mutate(ch2, probability_mutation)
            children.append(ch1)
            children.append(ch2)

        # print(children)

        #get stats
        generation_max_fitness = fitness_sorted[0][1]
        generation_max_fitness_gene = population[fitness_sorted[0][1]]

        #run again
        return genetic_algorithm_helper(children, food_map, map_size, max_generation, probability_crossover, probability_mutation, curr_generation + 1, overall_stats, last_gen_max_fitness, last_gen_max_fitness_gene, last_gen_max_fitness_trial)    

#generate random population of n chromosomes 
def initialize_population(num_population):
    #TODO START
    population = []
    for i in range(num_population):
        genes = ""
        for i in range(10):
            genes += str(random.randint(1,4)) + str(random.randint(0, 9)) + str(random.randint(0, 9))
        population.append(genes)
    #TODO END
    return population
    
def ant_simulator(food_map, map_size, ant_genes):
    """
    parameters:
        food_map: a list of list of strings, representing the map of the environment with food
            "1": there is a food at the position
            "0": there is no food at the position
            (0, 0) position: the top left corner of the map
            (x, y) position: x is the row, and y is the column
        map_size: a list of int, the dimension of the map. It is in the format of [row, column]
        ant_genes: a string with length 30. It encodes the ant's genes, for more information, please refer to the handout.
    
    return:
        trial: a list of list of strings, representing the trials
            1: there is food at that position, and the spot was not visited by the ant
            0: there is no food at that position, and the spot was not visited by the ant
            empty: the spot has been visited by the ant
	fitness: fitness of ant
    
    It takes in the food_map and its dimension of the map and the ant's gene information, and return the trial in the map
    """
    
    step_time = 200
    
    trial = []
    for i in food_map:
        line = []
        for j in i:
            line.append(j)
        trial.append(line)

    position_x, position_y = 0, 0
    orientation = [(1, 0), (0, -1), (-1, 0), (0, 1)] # face down, left, up, right
    fitness = 0
    state = 0
    orientation_state = 3
    gene_list = [ant_genes[i : i + 3] for i in range(0, len(ant_genes), 3)]
    
    for i in range(step_time):
        if trial[position_x][position_y] == "1":
            fitness += 1
        trial[position_x][position_y] = " "
        
        sensor_x = (position_x + orientation[orientation_state][0]) % map_size[0]
        sensor_y = (position_y + orientation[orientation_state][1]) % map_size[1]
        sensor_result = trial[sensor_x][sensor_y]
        
        if sensor_result == "1":
            state = int(gene_list[state][2])
        else:
            state = int(gene_list[state][1])
        
        action = gene_list[state][0]
        
        if action == "1": # move forward
            position_x = (position_x + orientation[orientation_state][0]) % map_size[0]
            position_y = (position_y + orientation[orientation_state][1]) % map_size[1]
        elif action == "2": # turn right
            orientation_state = (orientation_state + 1) % 4
        elif action == "3": # turn left
            orientation_state = (orientation_state - 1) % 4
        elif action == "4": # do nothing
            pass
        else:
            raise Exception("invalid action number!")
    
    return trial, fitness
        

def get_map(file_name):
    """
    parameters:
        file_name: a string, the name of the file which stored the map. The first line of the map is the dimension (row, column), the rest is the map
            1: there is a food at the position
            0: there is no food at the position
    
    return:
        food_map: a list of list of strings, representing the map of the environment with food
            "1": there is a food at the position
            "0": there is no food at the position
            (0, 0) position: the top left corner of the map
            (x, y) position: x is the row, and y is the column
        map_size: a list of int, the dimension of the map. It is in the format of [row, column]
    
    It takes in the file_name of the map, and return the food_map and the dimension map_size
    """
    food_map = []
    map_file = open(file_name, "r")
    first_line = True
    map_size = []
    
    for line in map_file:
        line = line.strip()
        if first_line:
            first_line = False
            map_size = line.split()
            continue
        if line:
            food_map.append(line.split())
    
    map_file.close()
    return food_map, [int(i) for i in map_size]

def display_trials(trials, target_file):
    """
    parameters:
        trials: a list of list of strings, representing the trials
            1: there is food at that position, and the spot was not visited by the ant
            0: there is no food at that position, and the spot was not visited by the ant
            empty: the spot has been visited by the ant
        taret_file: a string, the name the target_file to be saved
    
    It takes in the trials, and target_file, and saved the trials in the target_file. You can open the target_file to take a look at the ant's trial.
    """
    trial_file = open(target_file, "w")
    for line in trials:
        trial_file.write(" ".join(line))
        trial_file.write("\n")
    trial_file.close()

if __name__ == "__main__":
    #TODO START

    # Example of how to use get_map, ant_simulator and display trials function
    food_map = "muir.txt"
    population = initialize_population(50)
    max_generation = 120
    probability_crossover = 0.4
    probability_mutation = 0.1

    last_gen_max_fitness, last_gen_max_fitness_gene, overall_stats, last_gen_population = genetic_algorithm(population, food_map, max_generation, probability_crossover, probability_mutation)
    
    #setup highest fitness per generation plot
    highest_fitness_stats = []
    for item in overall_stats:
        highest_fitness_stats.append(item[0])
    plt.plot(highest_fitness_stats)
    plt.xlabel('Generation Number')
    plt.ylabel('Highest Fitness in Generation')
    plt.title('Highest Fitness per Generation')
    plt.savefig('highest_fitness_stats.png')
    plt.clf()


    #take last_gen_population and run fitness on santa fe trail
    food_map, map_size = get_map("santafe.txt")
    sf_fitnesses = []
    for ant_genes in last_gen_population:
            trial, fitness = ant_simulator(food_map, map_size, ant_genes) 
            sf_fitnesses.append(fitness)
    
    #take last_gen_population and run fitness on muir (last gen were never tested on yet)
    food_map, map_size = get_map("muir.txt")
    muir_fitnesses = []
    for ant_genes in last_gen_population:
            trial, fitness = ant_simulator(food_map, map_size, ant_genes) 
            muir_fitnesses.append(fitness)
    #setup comparison graph, double bar graph
    labels = ["[0, 10)", "[10, 20)", "[20, 30)", "[30, 40)", "[40, 50)", "[50, 100]"]
    graph_groups_sf = [0, 0, 0, 0, 0, 0]
    graph_groups_muir = [0, 0, 0, 0, 0, 0]
    for fitness_val in sf_fitnesses:
        if fitness_val < 10:
            graph_groups_sf[0] += 1
        elif fitness_val < 20:
            graph_groups_sf[1] += 1
        elif fitness_val < 30:
            graph_groups_sf[2] += 1
        elif fitness_val < 40:
            graph_groups_sf[3] += 1
        elif fitness_val < 50:
            graph_groups_sf[4] += 1
        else:
            graph_groups_sf[5] += 1

    for fitness_val in muir_fitnesses:
        if fitness_val < 10:
            graph_groups_muir[0] += 1
        elif fitness_val < 20:
            graph_groups_muir[1] += 1
        elif fitness_val < 30:
            graph_groups_muir[2] += 1
        elif fitness_val < 40:
            graph_groups_muir[3] += 1
        elif fitness_val < 50:
            graph_groups_muir[4] += 1
        else:
            graph_groups_muir[5] += 1
    
    # set width of bars
    barWidth = 0.25
    
    
    # Set position of bar on X axis
    r1 = np.arange(len(graph_groups_sf))
    r2 = [x + barWidth for x in r1]
    
    # Make the plot
    plt.bar(r1, graph_groups_sf, color='blue', width=barWidth, edgecolor='white', label='sf trail')
    plt.bar(r2, graph_groups_muir, color='red', width=barWidth, edgecolor='white', label='muir trail')
    
    # Add xticks on the middle of the group bars
    plt.xlabel('Fitness Values')
    plt.ylabel('Number of Ants in Last Generation with Fitness Value in this Range')
    plt.title('Grouped Fitness Values for Last Generation of Ants on SF Trail vs Muir Trail')
    plt.xticks([r + barWidth for r in range(len(graph_groups_sf))], ["[0, 10)", "[10, 20)", "[20, 30)", "[30, 40)", "[40, 50)", "[50, 100]"])
    
    # Create legend & Show graphic
    plt.legend()
    #plt.show()
    plt.savefig('fitness_vals_sf_vs_muir.png')

    plt.clf()
    #plot INDIVIDUALS

    # Set position of bar on X axis
    r1 = np.arange(len(sf_fitnesses))
    r2 = [x + barWidth for x in r1]
    
    # Make the plot
    plt.bar(r1, sf_fitnesses, color='blue', width=barWidth, edgecolor='white', label='fitnes on sf trail')
    plt.bar(r2, muir_fitnesses, color='red', width=barWidth, edgecolor='white', label='fitness on muir trail')
    
    # Add xticks on the middle of the group bars
    plt.xlabel('Individual Number')
    plt.ylabel('Fitness Value')
    plt.title('Fitness Values of Individuals in Last Generation, on SF Trail vs Muir Trail')

    indiv_nos = []
    for i in range(1, len(sf_fitnesses) + 1):
        indiv_nos.append(i)

    plt.xticks([r + barWidth for r in range(len(sf_fitnesses))], indiv_nos)
    plt.legend()
    plt.savefig('indiv_fitnesses_last_gen_trail_compare.png')
