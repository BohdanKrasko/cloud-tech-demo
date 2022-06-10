import React, {useState, useEffect} from 'react'
import { Redirect } from "react-router-dom"
import { v4 } from 'uuid'
import {
  Grid,
  Alert,
  Button,
  Typography,
  CircularProgress
} from '@mui/material'
import { verify } from  'jsonwebtoken'
import { useHistory } from "react-router-dom"
import Tree from '../../Components/anketa/Tree'
import { getAnaketa, editAnketa } from '../../api/client'


const EditAnketa = (props) => {
  const history = useHistory()
  const data = (props.location && props.location.state) || {}
  const [isAuthorized, setIsAuthorized] = useState(false)
  const [anketa, setAnketa] = useState([])
  const [section, setSection] = useState([])
  const [question, setQuestion] = useState([])
  const [answer, setAnswer] = useState([])
  const [useCount] = useState(0)
  const [isLoading, setLoading] = useState(true)
  const [error, setError] = useState()
  const [deleteIteam] = useState({
    children_answer: [],
    list_of_answers: [],
    question: [],
    section: []
  })


  useEffect(() => {
    try {
      verify(data.token, 'TOKEN_KEY')
      setIsAuthorized(true)
      getAnaketa(data)
        .then(res => res.json())
        .then(data => {
          putValuesIntoForm(data)
          setLoading(false)
        })
    } catch (err) {
      setError('Вибачте але ваш токен не валідний щоб авторизуватись')
    }
  }, [useCount])

  const genereteJson = () => {
    let requets = {
      anketa_id: data.anketa_id,
      name_of_anketa: anketa[0].value,
      category: anketa[0].category,
      sections: [],
      delete: deleteIteam
    }
    section.forEach(s_v => {
      let section = {
        section_id: s_v.section_id,
        name_of_section: s_v.value,
        questions: []
      }
      question.forEach(q_v => {
        let questions = {
          question_id: q_v.question_id,
          question: q_v.value,
          answers: []
        }
        answer.forEach(a_v => {
          let answer = {
            list_of_answers_id: a_v.list_of_answers_id,
            name_of_answer: a_v.value
          }
          if (q_v.id === a_v.parentid) {
            questions.answers.push(answer)
          }
        })
        if (s_v.id === q_v.parentid) {
          section.questions.push(questions)
        }
      })
      requets.sections.push(section)
    })
    return requets
  }

  const handleSubmit = (event) => {
    event.preventDefault()
    const dataJSON = genereteJson()
    editAnketa(dataJSON, data.token).then(() => {
      history.push({ 
        pathname: '/ankety',
        state: data
      })
    })
  }

  const putValuesIntoForm = (json) => {
    const newAnketa = {
      id: data.anketa_id.toString(),
      name: "anketa",
      id_feild: "name_of_ankety",
      label: "Назва анкети",
      value: json.name_of_anketa,
      category: json.category,
      parentid: 0,
      anketa_id: data.anketa_id
    }
    let index = 1
    for (const sectionKey in json.sections) {
      let sectionElement = json.sections[sectionKey]
      
      let newSection = {
        id: "name_of_section_" + index + "_" + v4(),
        name: "name_of_section_" + index + "_" + v4(),
        id_feild: "name_of_section_" + index + "_" + v4(),
        label: "Блок " + index,
        value: sectionElement.name_of_section,
        parentid: data.anketa_id.toString(),
        section_id: sectionElement.section_id
      }

      let index2 = 1
      for (const questionKey in sectionElement.questions) {
        let questionElement = sectionElement.questions[questionKey]
        let newQuestion = {
          id: "question_" + index2 + "_" + v4(),
          name: "question_" + index2 + "_" + v4(),
          id_feild: "question_" + index2 + "_" + v4(),
          label: "Запитання " + index2,
          value: questionElement.question,
          parentid: newSection.id,
          question_id: questionElement.question_id,
          section_id: questionElement.section_id
        }
        if (newQuestion.section_id === newSection.section_id) {
          question.push(newQuestion)
        }
        let index3 = 1
        for (const answerKey in questionElement.answers) {
          let answerElement = questionElement.answers[answerKey]
          let newAnswer = {
            id: "answer_" + index3 + "_" + v4(),
            name: "answer_" + index3 + "_" + v4(),
            id_feild: "answer_" + index3 + "_" + v4(),
            label: "Варіант відповіді " + index3,
            value: answerElement.name_of_answer,
            parentid: newQuestion.id,
            list_of_answers_id: answerElement.list_of_answers_id,
            question_id: answerElement.question_id
          }
          if (newQuestion.id === newAnswer.parentid) {
            answer.push(newAnswer)
          }
          index3++
        }
        index2++
      }
      index++
      section.push(newSection)
    }
    addAnketaState(newAnketa)
  } 

  const addAnketaState = (newData) => {
    let dataToAdd = [...anketa]
    dataToAdd.push(newData)
    setAnketa(dataToAdd)
  }
  
  
  const addSection = (parentId, index) => {
    let newData = {
      id: "name_of_section_" + index + "_" + v4(),
      name: "name_of_section_" + index + "_" + v4(),
      id_feild: "name_of_section_" + index + "_" + v4(),
      label: "Блок " + index,
      parentid: parentId
    }
    let dataToAdd = [...section]
    dataToAdd.push(newData)
    setSection(dataToAdd)
  }

  const deleteSection = (id) => {
    let newSection = section.filter(section => section.id !== id )
    let deleteSection = section.filter(section => section.id === id )

    if (deleteSection[0].section_id) {
      deleteIteam.section.push(deleteSection[0].section_id)
    }

    let newQuestion = question.filter(question => question.parentid !== id)
    let deleteQuestion = question.filter(question => question.parentid === id)
    deleteQuestion.forEach(v => {
      if (v.question_id) {
          deleteIteam.question.push(v.question_id)
      }
    })
      

    deleteQuestion.forEach((v, k) => {
      let newAnswer = answer.filter(answer => answer.parentid !== v.id)
      let deleteAnswer = answer.filter(answer => answer.parentid === v.id)
      deleteAnswer.forEach(v => {
        if (v.list_of_answers_id) {
          deleteIteam.list_of_answers.push(v.list_of_answers_id)
          deleteIteam.children_answer.push(v.list_of_answers_id)
        }
      })
      setAnswer(newAnswer)
    })

    setQuestion(newQuestion)
    setSection(newSection)
  }

  const addQuestion = (parentId, index) => {
    let newData = {
      id: "question_" + index + "_" + v4(),
      name: "question_" + index + "_" + v4(),
      id_feild: "question_" + index + "_" + v4(),
      label: "Запитання " + index,
      parentid: parentId
    }
    let dataToAdd = [...question]
    dataToAdd.push(newData)
    setQuestion(dataToAdd)
  }

  const deleteQuestion = (id) => {
    let newQuestion = question.filter(question => question.id !== id)
    let delteQuestion = question.filter(question => question.id === id)
    
    if (delteQuestion[0].question_id) {
      deleteIteam.question.push(delteQuestion[0].question_id)
    }

    let newAnswer = answer.filter(answer => answer.parentid !== id)
    let deleteAnswer = answer.filter(answer => answer.parentid === id)
    deleteAnswer.forEach(v => {
      if (v.list_of_answers_id) {
        deleteIteam.list_of_answers.push(v.list_of_answers_id)
      }
    })
    
    setAnswer(newAnswer)
    setQuestion(newQuestion)
  }

  const addAnswer = (parentId, index) => {
    let newData = {
      id: "answer_" + index + "_" + v4(),
      name: "answer_" + index + "_" + v4(),
      id_feild: "answer_" + index + "_" + v4(),
      label: "Варіант відповіді  " + index,
      parentid: parentId
    }
    let dataToAdd = [...answer]
    dataToAdd.push(newData)
    setAnswer(dataToAdd)
  }

  const deleteAnswer = (id) => {
    let newAnswer = answer.filter(answer => answer.id !== id)
    let deleteAnswer = answer.filter(answer => answer.id === id)
    
    if (deleteAnswer[0].list_of_answers_id) {
      deleteIteam.list_of_answers.push(deleteAnswer[0].list_of_answers_id)
    }
    setAnswer(newAnswer)
  }

  if (error) {
    return (
      <Alert severity="error">
        {error}
        <Button 
          variant='contained' 
          color='warning'
          style={{marginLeft: '50px'}}
          onClick={() => {
            history.push({ 
              pathname: '/ankety',
              state: data
              })
          }}
        >Головна сторінка</Button>
      </Alert>
    )
  }
  if (isLoading) {
    return (
      <Grid
        container
        justifyContent="center"
        alignItems="center"
        direction="column"
        style={{ minHeight: "100vh" }}
      >
        <CircularProgress />
      </Grid>
    )
  }
  if (!isAuthorized) {
    return <Redirect to="/signin"></Redirect>
  } else {
    return (
      <div>
        <Typography component="h1" variant="h5" style={{
        display: 'block', 
        textAlign: 'center',
        marginTop: 50
        }}
        >
          Редагувати анкету {data.name_of_anketa}
        </Typography>
        
        <Tree
          data={data}
          history={history}
          handleSubmit={handleSubmit}
          anketa={anketa}
          section={section}
          question={question}
          answer={answer}
          addSection={addSection}
          deleteSection={deleteSection}
          addQuestion={addQuestion}
          deleteQuestion={deleteQuestion}
          addAnswer={addAnswer}
          deleteAnswer={deleteAnswer}
        />
      </div>
    )
  }
}

export default EditAnketa