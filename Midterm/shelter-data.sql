SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `shelterdb`
--

--
-- Dumping data for table `shelters`
--

INSERT INTO `shelters` (`shelter_id`, `name`, `address`, `zipcode`, `city`, `state`) VALUES
(1, 'Big Paws Rescue', '121 Big Paw Dr.', '98104', 'Seattle', 'WA'),
(2, 'Canines and Crustaceans', '1200 Doberman-Pincher Rd', '97009', 'Boring', 'OR'),
(3, 'Beaglegeuse', '32 Winona Road-er', '90007', 'Los Angeles', 'CA'),
(4, 'Zoolander\'s Shelter for Pets that Can\'t Read Good', '2001 Hansel St.', '90006', 'Los Angeles', 'CA'),
(5, 'Resilient Rescues', '404 Whereabouts Rd', '90037', 'Los Angeles', 'CA'),
(6, 'RATS WITH HATS', '33 Cutie-Patootie Lane', '98144', 'Seattle', 'WA'),
(7, 'Just Uber-Likeable Lizards', '777 Himalayan St', '98145', 'Seattle', 'WA'),
(8, 'Jagex Animal Shelter', '1337 Runes Cape', '97209', 'Portland', 'OR'),
(9, 'Rocking and Rolling Stones', 'The Turtle Pond', '91107', 'Pasadena', 'CA');

--
-- Dumping data for table `animals`
--
INSERT INTO `animals` (`animal_id`, `name`, `gender`, `animal_type`, `breed`, `age_est`, `notes`, `shelter_id`, `join_date`, `adoption_price`) VALUES
(1, 'Codd', 'Male', 'Dog', 'Great Dane', 8, 'Good with older individuals, no kids', 1, '2019-01-06', '50.00'),
(2, 'Boromir', 'Male', 'Dog', 'Bullmastiff', 4, NULL, 1, '2019-01-06', '310.00'),
(3, 'Gizmo', 'Male', 'Cat', 'Maine Coone', 12, NULL, 5, '2019-01-12', '30.00'),
(4, 'Gizmo', 'Male', 'Dog', 'Boxer', 8, 'Low vision but good with guidance', 1, '2019-03-10', '280.00'),
(5, 'Ajax', 'Male', 'Rodent', 'Rabbit', 2, NULL, 4, '2019-04-04', '120.00'),
(6, 'Link', 'Male', 'Reptile', 'Bearded Dragon', 5, 'Responds to hand waves!', 7, '2019-04-04', '210.00'),
(7, 'Argon', 'Male', 'Rodent', 'Rat', 2, NULL, 8, '2019-04-07', '220.00'),
(8, 'Aristotle', NULL, 'Amphibian', 'Axolotl', 2, NULL, 2, '2019-04-11', '130.00'),
(9, 'Finn', 'Male', 'Cat', 'Domestic Shorthair', 9, NULL, 8, '2019-05-09', '340.00'),
(10, 'Q', 'Male', 'Bird', 'Cockatoo', 10, 'This one is a talker!', 5, '2019-06-11', '60.00'),
(11, 'Mulder', 'Male', 'Dog', 'Mix', 8, 'Bonded pair with Scully', 5, '2019-07-04', '110.00'),
(12, 'Scully', 'Female', 'Dog', 'Mix', 6, 'Bonded pair with Mulder', 5, '2019-08-01', '300.00'),
(13, 'Ani', 'Female', 'Cat', 'Norweigan Forest Cat', 5, 'Good with dogs', 5, '2019-08-11', '350.00'),
(14, 'Byte', 'Male', 'Fish', 'Piranha', 1, 'Bonded pair with Bit', 2, '2019-09-12', '260.00'),
(15, 'Pascal', 'Female', 'Dog', 'Golden Retriever', 2, NULL, 2, '2019-10-07', '120.00'),
(16, 'Bowser', 'Male', 'Dog', 'Mastiff Mix', 6, 'Not good with cats or dogs, but very calm', 1, '2019-12-12', '240.00'),
(17, 'Koopa', 'Male', 'Reptile', 'Turtle', 8, 'Bonded pair with Kappa', 9, '2020-01-06', '80.00'),
(18, 'Kappa', 'Female', 'Reptile', 'Turtle', 5, 'Bonded pair with Koopa', 9, '2020-01-06', '60.00'),
(19, 'Geodude', NULL, 'Rock', NULL, 300, 'Bonded pair with Graveler and Golem', 9, '2020-02-02', '1.00'),
(20, 'Graveler', NULL, 'Rock', NULL, 316, 'Bonded pair with Geodude and Golem', 9, '2020-02-02', '200.00'),
(21, 'Golem', NULL, 'Rock', NULL, 342, 'Bonded pair with Geodude and Graveler', 9, '2020-02-02', '400.00'),
(22, 'Flash', NULL, 'Rock', NULL, 100, NULL, 9, '2020-02-04', '100.00'),
(23, 'Sonic', 'Male', 'Rodent', 'Hedgehog', 1, 'Needs good watching, an escape artist', 4, '2020-05-01', '360.00'),
(24, 'Java', 'Male', 'Dog', 'Boxador', 8, 'May have other mix', 5, '2020-06-09', '400.00'),
(25, 'Algo', 'Male', 'Dog', 'Great Dane', 5, 'Very smart, good with dogs and cats, no kids', 1, '2020-06-10', '270.00'),
(26, 'Bernoulli', 'Male', 'Dog', 'Greyhound', 5, NULL, 2, '2020-07-05', '480.00'),
(27, 'Neo', 'Male', 'Rodent', 'Rat', 2, NULL, 6, '2020-09-02', '310.00'),
(28, 'Bit', 'Female', 'Fish', 'Piranha', 1, 'Bonded pair with Byte', 2, '2020-09-10', '490.00'),
(29, 'Groot', NULL, 'Plant', 'Bonsai', 1, NULL, 9, '2020-10-05', '10.00'),
(30, 'Ghost', 'Female', 'Dog', 'German Shephard', 5, NULL, 2, '2020-10-05', '70.00'),
(31, 'Astro', 'Male', 'Dog', 'Pit Mix', 2, NULL, 2, '2020-10-12', '450.00'),
(32, 'Monty', 'Male', 'Reptile', 'Boa Constrictor', 5, NULL, 4, '2020-11-03', '260.00'),
(33, 'Haskell', 'Female', 'Dog', 'Boxer', 2, NULL, 3, '2020-12-12', '380.00'),
(34, 'Tyrion', 'Male', 'Rodent', 'Rat', 3, 'Bonded pair with Joshua the Great Dane', 6, '2021-01-01', '370.00'),
(35, 'Joshua', 'Male', 'Dog', 'Great Dane', 3, 'Very good on three-legs, good with cats and dogs, bonded pair with Tyrion the rat', 1, '2021-01-01', '90.00');

--
-- Dumping data for table `applicants`
--

INSERT INTO `applicants` (`applicant_id`, `name`, `phone`, `address`, `zipcode`, `curr_pet_count`, `household_size`, `notes`) VALUES
(1, 'John Samson', '503-969-8104', '96 West Highland Ave.', '98104', 1, 2, 'Looking for special needs dog'),
(2, 'Lukas Kelsey', '360-111-3210', '70 Caterbury St.', '91105', 0, 3, 'Has 4 kids ages 2-10'),
(3, 'Vedrana Pas', '503-969-4018', '8414 Passaro Dr.', '97009', 5, 4, NULL),
(4, 'Suresh Kopek', '626-111-0123', '2503 Buckhannan Ave.', '91125', 4, 4, NULL),
(5, 'Emelrich Grahn', '909-111-3210', '95 Middleville Road', '91801', 3, 6, NULL),
(6, 'Adalia Scully', '626-321-1111', '310 Skinner St.', '91105', 3, 1, NULL),
(7, 'Iacob Durnin', '661-312-1801', '312 Fugi Dr.', '91801', 0, 4, NULL),
(8, 'Derek Solo', '425-104-9810', '101 Dalmation St.', '98104', 1, 1, NULL),
(9, 'Tena Robertson', '509-989-8103', '98th Lind Ave.', '98103', 1, 2, NULL),
(10, 'Carlos Perro', '201-101-1101', '101 El Pez Dorado Lane', '91101', 5, 3, NULL),
(11, 'Clara Chien', '814-307-9006', '307 Bellevue St.', '90006', 3, 1, 'Looking for dog-friendly cat'),
(12, 'Hans der Hund', '860-120-7075', 'NW Lapin Lane', '97075', 4, 1, 'Looking for cat-friendly dog'),
(13, 'Dimka Sabaka', '626-121-9876', '154 Kato Circle', '91106', 0, 6, NULL),
(14, 'Sasha Kot', '661-149-0037', '2nd Inu Dr.', '90037', 4, 5, NULL),
(15, 'Jin Yu', '503-999-8136', '99 West Highland Ave.', '98136', 4, 4, NULL),
(16, 'Klaus Gullfiskur', '626-222-0123', '100 West Highland Ave.', '91105', 0, 2, NULL);

--
-- Dumping data for table `applications`
--

INSERT INTO `applications` (`app_id`, `applicant_id`, `animal_id`, `status`, `application_date`) VALUES
(100, 1, 1, 'Rejected', '2020-01-01 20:06:31'),
(101, 5, 5, 'Reviewed', '2020-01-13 21:56:04'),
(105, 4, 2, 'Accepted', '2020-02-01 12:45:16'),
(112, 2, 5, 'Rejected', '2020-02-27 09:32:22'),
(113, 14, 7, 'Rejected', '2020-02-27 14:22:21'),
(144, 11, 5, 'Accepted', '2020-02-27 18:04:25'),
(145, 2, 21, 'Submitted', '2020-03-01 21:51:49'),
(146, 14, 19, 'Submitted', '2020-03-01 22:28:32'),
(150, 9, 13, 'Rejected', '2020-03-02 08:00:01'),
(151, 6, 15, 'Accepted', '2020-03-02 23:20:20'),
(152, 12, 23, 'Reviewed', '2020-03-03 04:07:12'),
(156, 14, 7, 'Reviewed', '2020-03-09 12:04:26'),
(157, 11, 19, 'Submitted', '2020-03-10 04:21:09'),
(158, 8, 26, 'Submitted', '2020-03-10 12:25:27'),
(160, 6, 14, 'Submitted', '2020-03-11 06:59:59'),
(161, 9, 19, 'Submitted', '2020-03-12 15:32:57'),
(162, 9, 20, 'Submitted', '2020-03-12 15:32:57'),
(163, 9, 21, 'Submitted', '2020-03-12 15:32:57'),
(164, 3, 33, 'Submitted', '2020-03-14 01:00:18'),
(165, 7, 2, 'Submitted', '2020-03-15 16:10:00'),
(166, 15, 3, 'Submitted', '2020-03-15 17:01:00'),
(167, 16, 10, 'Submitted', '2020-03-19 04:00:00'),
(168, 13, 3, 'Submitted', '2020-03-19 05:22:02');

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`emp_id`, `name`, `gender`, `is_volunteer`, `phone`, `email`, `role`, `join_date`, `shelter_id`) VALUES
(1, 'Thane Okabe', 'Male', 1, '503-333-4321', 'thanka@me.com', 'Animal Caretaker', '2019-03-06', 4),
(2, 'Alan Wong', 'Male', 1, '503-305-0306', 'alan@yahoo.com', 'Application Reviewer', '2019-03-06', 8),
(3, 'Sasha Kot', 'Non-Binary', 1, '661-149-0037', 'sasha@kot.me', 'Animal Caretaker', '2019-09-01', 6),
(4, 'Douglas Elliott', 'Male', 1, '661-149-2121', 'elliotd@douglas.me', 'Animal Caretaker', '2019-09-08', 7),
(5, 'Percy Perry', 'Male', 1, '626-121-1106', 'perry@percy.me', 'Application Reviewer', '2019-11-06', 5),
(6, 'Sylvia Brown', 'Female', 0, '805-019-1107', 'brown@yahoo.com', 'Manager', '2019-11-07', 8),
(7, 'Sam Johnson', 'Female', 1, '360-121-2021', 'sjohnson@johnson.com', 'Animal Caretaker', '2020-01-01', 1),
(8, 'Eija Bellandi', 'Female', 1, '971-111-1111', 'eija@bellandi.net', 'Transport', '2020-01-02', 2),
(9, 'Emelrich Grahn', 'Male', 0, '909-111-3210', 'emerlrich@grahn.net', 'Custodian', '2020-03-02', 3),
(10, 'Edwina Duncanson', 'Female', 0, '971-222-9876', 'edwina@yahoo.com', 'Manager', '2020-04-08', 1),
(11, 'Jessie Maldonado', 'Non-Binary', 1, '260-111-2222', 'maldo@gmail.com', 'Animal Caretaker', '2020-05-08', 8),
(12, 'Nicolas Hampton', 'Male', 1, '503-111-1111', 'nic@hampton.net', 'Application Reviewer', '2020-06-07', 9),
(13, 'Darrin Hill', 'Male', 1, '805-061-2020', 'darrinhill@yahoo.com', 'Animal Caretaker', '2020-06-10', 5),
(14, 'Lorena Reeves', 'Female', 0, '661-131-4321', 'reeves@hotmail.com', 'Manager', '2020-06-11', 6),
(15, 'Jan Morales', 'Female', 1, '206-360-5036', 'jan@gmail.com', 'Application Reviewer', '2020-08-04', 5),
(16, 'John Samson', 'Male', 0, '503-969-8104', 'jsamson@gmail.com', 'Application Reviewer', '2020-08-09', 1),
(17, 'Allan Haynes', 'Male', 1, '360-206-1104', 'allan@haynes.net', 'Application Reviewer', '2020-11-04', 1),
(18, 'Alex Thompson', 'Non-Binary', 1, '720-123-4567', 'athompson@', 'Rehabilitor', '2020-11-09', 2),
(19, 'Dimka Sabaka', 'Male', 1, '626-121-9876', 'dimka@gmail.com', 'Application Reviewer', '2020-12-04', 5),
(20, 'Casey Pope', 'Female', 0, '971-999-1111', 'casey@aol.com', 'Manager', '2020-12-08', 7);

