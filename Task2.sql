CREATE TABLE instrument_rental (
 id INT NOT NULL,
 price VARCHAR(10) NOT NULL,
 dilevery_price VARCHAR(10) NOT NULL
);

ALTER TABLE instrument_rental ADD CONSTRAINT PK_instrument_rental PRIMARY KEY (id);


CREATE TABLE instrument_storage (
 id INT NOT NULL,
 instrument_amount VARCHAR(10) NOT NULL,
 instrumrnt_rental_id INT NOT NULL
);

ALTER TABLE instrument_storage ADD CONSTRAINT PK_instrument_storage PRIMARY KEY (id);


CREATE TABLE person (
 id INT NOT NULL,
 person_number VARCHAR(10) NOT NULL,
 name VARCHAR(500) NOT NULL,
 age VARCHAR(3) NOT NULL,
 street VARCHAR(500) NOT NULL,
 street_number VARCHAR(500) NOT NULL,
 zip_code VARCHAR(5) NOT NULL,
 city VARCHAR(500) NOT NULL
);

ALTER TABLE person ADD CONSTRAINT PK_person PRIMARY KEY (id);


CREATE TABLE phone (
 phone_no VARCHAR(11) NOT NULL,
 person_id INT NOT NULL
);

ALTER TABLE phone ADD CONSTRAINT PK_phone PRIMARY KEY (phone_no,person_id);


CREATE TABLE school (
 id INT NOT NULL,
 school_id VARCHAR(500) NOT NULL,
 street_number VARCHAR(500) NOT NULL,
 zip_code VARCHAR(5) NOT NULL,
 city VARCHAR(500) NOT NULL,
 street VARCHAR(500) NOT NULL
);

ALTER TABLE school ADD CONSTRAINT PK_school PRIMARY KEY (id);


CREATE TABLE sibling (
 id INT NOT NULL
);

ALTER TABLE sibling ADD CONSTRAINT PK_sibling PRIMARY KEY (id);


CREATE TABLE student (
 id INT NOT NULL,
 studentID VARCHAR(500) NOT NULL,
 person_id INT NOT NULL,
 instrument_currently_rented VARCHAR(1),
 sibling_id INT,
 instrument_rental_id INT
);

ALTER TABLE student ADD CONSTRAINT PK_student PRIMARY KEY (id);


CREATE TABLE submission_letter (
 school_id INT NOT NULL,
 person_id INT NOT NULL,
 person_number VARCHAR(10) NOT NULL,
 name VARCHAR(500),
 age VARCHAR(3),
 instrument_skill_level VARCHAR(10) NOT NULL
);

ALTER TABLE submission_letter ADD CONSTRAINT PK_submission_letter PRIMARY KEY (school_id,person_id);


CREATE TABLE acceptence_letter (
 school_id INT NOT NULL,
 person_id INT NOT NULL,
 admitance_confirmation VARCHAR(10) NOT NULL
);

ALTER TABLE acceptence_letter ADD CONSTRAINT PK_acceptence_letter PRIMARY KEY (school_id,person_id);


CREATE TABLE classroom (
 school_id INT NOT NULL,
 room_number VARCHAR(500) NOT NULL
);

ALTER TABLE classroom ADD CONSTRAINT PK_classroom PRIMARY KEY (school_id);


CREATE TABLE discount (
 sibling_id INT NOT NULL,
 amount  VARCHAR(10) NOT NULL
);

ALTER TABLE discount ADD CONSTRAINT PK_discount PRIMARY KEY (sibling_id);


CREATE TABLE email (
 email_adress VARCHAR(500) NOT NULL,
 person_id INT NOT NULL
);

ALTER TABLE email ADD CONSTRAINT PK_email PRIMARY KEY (email_adress,person_id);


CREATE TABLE instructor (
 id INT NOT NULL,
 employmentID VARCHAR(500) NOT NULL,
 person_id INT NOT NULL
);

ALTER TABLE instructor ADD CONSTRAINT PK_instructor PRIMARY KEY (id);


CREATE TABLE instrument (
 id INT NOT NULL,
 brand VARCHAR(500),
 type VARCHAR(500) NOT NULL,
 rented_by VARCHAR(500),
 student_id INT,
 instrument_storage_id INT
);

ALTER TABLE instrument ADD CONSTRAINT PK_instrument PRIMARY KEY (id);


CREATE TABLE instrument_type (
 instrument_id INT NOT NULL,
 instructor_id INT NOT NULL
);

ALTER TABLE instrument_type ADD CONSTRAINT PK_instrument_type PRIMARY KEY (instrument_id);


CREATE TABLE music_lesson (
 id INT NOT NULL,
 time TIMESTAMP(10) NOT NULL,
 date VARCHAR(8) NOT NULL,
 place VARCHAR(500) NOT NULL,
 instructor_id INT NOT NULL,
 school_id INT NOT NULL
);

ALTER TABLE music_lesson ADD CONSTRAINT PK_music_lesson PRIMARY KEY (id);


CREATE TABLE parent (
 id CHAR(10) NOT NULL,
 person_id INT NOT NULL
);

ALTER TABLE parent ADD CONSTRAINT PK_parent PRIMARY KEY (id);


CREATE TABLE salery (
 instructor_id INT NOT NULL,
 school_id INT NOT NULL,
 amount VARCHAR(10) NOT NULL
);

ALTER TABLE salery ADD CONSTRAINT PK_salery PRIMARY KEY (instructor_id,school_id);


CREATE TABLE student_music_lesson (
 student_id INT NOT NULL,
 music_lesson_id INT NOT NULL
);

ALTER TABLE student_music_lesson ADD CONSTRAINT PK_student_music_lesson PRIMARY KEY (student_id,music_lesson_id);


CREATE TABLE student_parent (
 student_id INT NOT NULL,
 parent_id CHAR(10) NOT NULL
);

ALTER TABLE student_parent ADD CONSTRAINT PK_student_parent PRIMARY KEY (student_id,parent_id);


CREATE TABLE ensamble (
 music_lesson_id INT NOT NULL,
 maximum_number_of_students VARCHAR(500),
 minimum_number_of_students VARCHAR(500) NOT NULL
);

ALTER TABLE ensamble ADD CONSTRAINT PK_ensamble PRIMARY KEY (music_lesson_id);


CREATE TABLE genre (
 music_lesson_id INT NOT NULL,
 price VARCHAR(10) NOT NULL,
 type VARCHAR(500) NOT NULL
);

ALTER TABLE genre ADD CONSTRAINT PK_genre PRIMARY KEY (music_lesson_id);


CREATE TABLE group_lesson (
 music_lesson_id INT NOT NULL,
 instrument_taught VARCHAR(500) NOT NULL
);

ALTER TABLE group_lesson ADD CONSTRAINT PK_group_lesson PRIMARY KEY (music_lesson_id);


CREATE TABLE individual_lesson (
 music_lesson_id INT NOT NULL,
 instrument_taught VARCHAR(500) NOT NULL
);

ALTER TABLE individual_lesson ADD CONSTRAINT PK_individual_lesson PRIMARY KEY (music_lesson_id);


CREATE TABLE difficulty_level (
 music_lesson_id INT NOT NULL,
 price VARCHAR(10) NOT NULL,
 difficulty VARCHAR(500) NOT NULL
);

ALTER TABLE difficulty_level ADD CONSTRAINT PK_difficulty_level PRIMARY KEY (music_lesson_id);


ALTER TABLE instrument_storage ADD CONSTRAINT FK_instrument_storage_0 FOREIGN KEY (instrumrnt_rental_id) REFERENCES instrument_rental (id);


ALTER TABLE phone ADD CONSTRAINT FK_phone_0 FOREIGN KEY (person_id) REFERENCES person (id);


ALTER TABLE student ADD CONSTRAINT FK_student_0 FOREIGN KEY (person_id) REFERENCES person (id);
ALTER TABLE student ADD CONSTRAINT FK_student_1 FOREIGN KEY (sibling_id) REFERENCES sibling (id);
ALTER TABLE student ADD CONSTRAINT FK_student_2 FOREIGN KEY (instrument_rental_id) REFERENCES instrument_rental (id);


ALTER TABLE submission_letter ADD CONSTRAINT FK_submission_letter_0 FOREIGN KEY (school_id) REFERENCES school (id);
ALTER TABLE submission_letter ADD CONSTRAINT FK_submission_letter_1 FOREIGN KEY (person_id) REFERENCES person (id);


ALTER TABLE acceptence_letter ADD CONSTRAINT FK_acceptence_letter_0 FOREIGN KEY (school_id) REFERENCES school (id);
ALTER TABLE acceptence_letter ADD CONSTRAINT FK_acceptence_letter_1 FOREIGN KEY (person_id) REFERENCES person (id);


ALTER TABLE classroom ADD CONSTRAINT FK_classroom_0 FOREIGN KEY (school_id) REFERENCES school (id);


ALTER TABLE discount ADD CONSTRAINT FK_discount_0 FOREIGN KEY (sibling_id) REFERENCES sibling (id);


ALTER TABLE email ADD CONSTRAINT FK_email_0 FOREIGN KEY (person_id) REFERENCES person (id);


ALTER TABLE instructor ADD CONSTRAINT FK_instructor_0 FOREIGN KEY (person_id) REFERENCES person (id);


ALTER TABLE instrument ADD CONSTRAINT FK_instrument_0 FOREIGN KEY (student_id) REFERENCES student (id);
ALTER TABLE instrument ADD CONSTRAINT FK_instrument_1 FOREIGN KEY (instrument_storage_id) REFERENCES instrument_storage (id);


ALTER TABLE instrument_type ADD CONSTRAINT FK_instrument_type_0 FOREIGN KEY (instrument_id) REFERENCES instrument (id);
ALTER TABLE instrument_type ADD CONSTRAINT FK_instrument_type_1 FOREIGN KEY (instructor_id) REFERENCES instructor (id);


ALTER TABLE music_lesson ADD CONSTRAINT FK_music_lesson_0 FOREIGN KEY (instructor_id) REFERENCES instructor (id);
ALTER TABLE music_lesson ADD CONSTRAINT FK_music_lesson_1 FOREIGN KEY (school_id) REFERENCES classroom (school_id);


ALTER TABLE parent ADD CONSTRAINT FK_parent_0 FOREIGN KEY (person_id) REFERENCES person (id);


ALTER TABLE salery ADD CONSTRAINT FK_salery_0 FOREIGN KEY (instructor_id) REFERENCES instructor (id);
ALTER TABLE salery ADD CONSTRAINT FK_salery_1 FOREIGN KEY (school_id) REFERENCES school (id);


ALTER TABLE student_music_lesson ADD CONSTRAINT FK_student_music_lesson_0 FOREIGN KEY (student_id) REFERENCES student (id);
ALTER TABLE student_music_lesson ADD CONSTRAINT FK_student_music_lesson_1 FOREIGN KEY (music_lesson_id) REFERENCES music_lesson (id);


ALTER TABLE student_parent ADD CONSTRAINT FK_student_parent_0 FOREIGN KEY (student_id) REFERENCES student (id);
ALTER TABLE student_parent ADD CONSTRAINT FK_student_parent_1 FOREIGN KEY (parent_id) REFERENCES parent (id);


ALTER TABLE ensamble ADD CONSTRAINT FK_ensamble_0 FOREIGN KEY (music_lesson_id) REFERENCES music_lesson (id);


ALTER TABLE genre ADD CONSTRAINT FK_genre_0 FOREIGN KEY (music_lesson_id) REFERENCES ensamble (music_lesson_id);


ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_0 FOREIGN KEY (music_lesson_id) REFERENCES music_lesson (id);


ALTER TABLE individual_lesson ADD CONSTRAINT FK_individual_lesson_0 FOREIGN KEY (music_lesson_id) REFERENCES music_lesson (id);


ALTER TABLE difficulty_level ADD CONSTRAINT FK_difficulty_level_0 FOREIGN KEY (music_lesson_id) REFERENCES individual_lesson (music_lesson_id);
ALTER TABLE difficulty_level ADD CONSTRAINT FK_difficulty_level_1 FOREIGN KEY (music_lesson_id) REFERENCES group_lesson (music_lesson_id);


