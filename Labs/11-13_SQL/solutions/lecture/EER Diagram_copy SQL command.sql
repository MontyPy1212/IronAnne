CREATE TABLE IF NOT EXISTS `lab_db`.`student _course` (
  `idstudent _course` INT NOT NULL,
  `score` INT NULL,
  `student_idstudent` INT NULL,
  `course_idcourse` INT NOT NULL,
  `student_idstudent1` INT NOT NULL,
  PRIMARY KEY (`idstudent _course`, `course_idcourse`, `student_idstudent1`),
  INDEX `fk_student _course_course_idx` (`course_idcourse` ASC) VISIBLE,
  INDEX `fk_student _course_student1_idx` (`student_idstudent1` ASC) VISIBLE,
  CONSTRAINT `fk_student _course_course`
    FOREIGN KEY (`course_idcourse`)
    REFERENCES `lab_db`.`course` (`idcourse`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_student _course_student1`
    FOREIGN KEY (`student_idstudent1`)
    REFERENCES `lab_db`.`student` (`idstudent`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB