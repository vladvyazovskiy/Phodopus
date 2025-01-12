% Define input parameters
animals_wanted = input('How many animals do you want: '); % Integer, user-entered value
winter = input('Will you use winter hamsters? (y/n): ', 's'); % 'y' or 'n'
mix_of_gender = input('Will you use a mix of genders? (y/n): ', 's'); % 'y' or 'n'
gender_ratio = 0.5; % Assume equal numbers of males and females in experiment
age_at_experiment = input('What age in weeks will animals be at onset of experiment? (must be >=20 if winter hamsters are to be used): '); % Integer
duration_of_recording = input('How many weeks will your recording last? '); % Integer
application_type = input('Is this a Wellcome Trust application? (y/n): ', 's'); % 'y' or 'n'
verbose_output = input('Do you want verbose output? (y/n): ', 's'); % 'y' or 'n'

% Defined constants
age_at_breeding = 25;
max_housing_density = 4;
duration_of_habituation = 1; % Weeks
duration_of_postsurgery_recovery = 2; % Weeks
surgery_attrition = 0.8;
breeding_attrition = 0.8;
average_litter_size = 5.6;
WT_rate = 12.76; % Cost of WT rate per cage per week
FEC_rate = 14.35; % Cost of FEC rate per cage per week

% Biological variables
weaning_period = 3; % Weeks
gestation_period = 3; % Weeks
expected_males_per_litter = average_litter_size * gender_ratio;
expected_females_per_litter = average_litter_size * gender_ratio;

% Determine cage cost
if application_type == 'y'
    cage_cost = WT_rate;
else
    cage_cost = FEC_rate;
end

% Winter attrition
if winter == 'y'
    winter_attrition = 0.8;
else
    winter_attrition = 1;
end

% Gender ratio calculations
if mix_of_gender == 'n'
    males_needed = ceil(animals_wanted / (surgery_attrition * winter_attrition));
    females_needed = 0;
else
    males_needed = ceil(gender_ratio * animals_wanted / (surgery_attrition * winter_attrition));
    females_needed = ceil((1 - gender_ratio) * animals_wanted / (surgery_attrition * winter_attrition));
end

% Calculate number of breeder pairs
No_of_pairs = ceil(max(males_needed / expected_males_per_litter * breeding_attrition, ...
                      females_needed / expected_females_per_litter * breeding_attrition));

if No_of_pairs < 3 && animals_wanted > 2
    No_of_pairs = 3; % Ensure at least three different litters contribute
end

if No_of_pairs >= 6
    repeat_litter = 2;
else
    repeat_litter = 1; % Use repeat litters for large cohorts
end

actual_pairs_used = ceil(No_of_pairs / repeat_litter);

% Calculate costs
cost_of_breeders = actual_pairs_used * 2 * age_at_breeding * cage_cost;

if verbose_output == 'y'
    fprintf('Cost of generating and maintaining breeders: £%.2f\n', cost_of_breeders);
end

cost_of_breeding = (No_of_pairs / repeat_litter) * gestation_period * cage_cost;

if verbose_output == 'y'
    fprintf('Cost of breeding: £%.2f\n', cost_of_breeding);
end

% Cost of maintaining animals
litters_needed = No_of_pairs;
male_cages = ceil(males_needed / max_housing_density);
female_cages = ceil(females_needed / max_housing_density);

if winter == 'n'
    cost_of_animals = (weaning_period * litters_needed) * cage_cost + ...
                      (age_at_experiment - weaning_period) * (male_cages + female_cages) * cage_cost;
else
    cost_of_animals = (weaning_period * litters_needed) * cage_cost + ...
                      (age_at_experiment - weaning_period) * (males_needed + females_needed) * cage_cost;
end

if verbose_output == 'y'
    fprintf('Cost of animals up to experiment: £%.2f\n', cost_of_animals);
end

% Cost of experiment
cost_of_experiment = animals_wanted * ...
                     (duration_of_habituation + duration_of_postsurgery_recovery + duration_of_recording) * cage_cost;

if verbose_output == 'y'
    fprintf('Cost of experiment: £%.2f\n', cost_of_experiment);
end

% Total cost
cost_total = cost_of_breeders + cost_of_breeding + cost_of_animals + cost_of_experiment;
fprintf('The cost of %d hamsters aged %d weeks is £%.2f\n', animals_wanted, age_at_experiment, cost_total);

% Cage weeks calculation
total_cageweeks_breeding = floor(cost_of_breeders / cage_cost + cost_of_breeding / cage_cost);
total_cageweeks_selectingforexperiment = floor(cost_of_animals / cage_cost);
total_cageweeks_experiment = floor(cost_of_experiment / cage_cost);
total_cages=total_cageweeks_breeding+total_cageweeks_selectingforexperiment+total_cageweeks_experiment;

fprintf('Total cage weeks for breeding: %d\n', total_cageweeks_breeding);
fprintf('Cage weeks to maintain hamsters: %d\n', total_cageweeks_selectingforexperiment);
fprintf('Cage weeks for experiment: %d\n', total_cageweeks_experiment);
fprintf('Total cage weeks: %d\n', total_cages);
fprintf('Divide total cage weeks by grant length (weeks) for average cages/week.\n');


