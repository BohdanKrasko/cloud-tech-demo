import React, {useState, useEffect} from 'react'
import { Redirect } from "react-router-dom"
import { v4 } from 'uuid'
import {
  Grid,
  Alert,
  Typography,
  CircularProgress,
  Button
} from '@mui/material'
import { addAnketa } from '../../api/client'
import { verify } from  'jsonwebtoken'
import Tree from '../../Components/anketa/Tree'
import { useHistory } from "react-router-dom"

const AddAnketa = (props) => {
  const history = useHistory()
  const data = (props.location && props.location.state) || {}
  const [isAuthorized, setIsAuthorized] = useState(false)
  const [anketa] = useState([
    {
      id: "name_of_ankety",
      name: "anketa",
      id_feild: "name_of_ankety",
      label: "Назва анкети",
      value: "",
      category: "",
      parentid: 0
    }
  ])
  const [section, setSection] = useState([])
  const [question, setQuestion] = useState([])
  const [answer, setAnswer] = useState([])
  const [useCount] = useState(0)
  const [isLoading, setLoading] = useState(true)
  const [error, setError] = useState()

  useEffect(() => {
    try {
      verify(data.token, 'TOKEN_KEY')
      setIsAuthorized(true)
      setLoading(false)
    } catch (err) {
      setError('Вибачте але ваш токен не валідний щоб авторизуватись')
    }
  }, [useCount])

  const genereteJson = () => {
    let requets = {
      name_of_anketa: anketa[0].value,
      category: anketa[0].category,
      sections: []
    }
    section.forEach(s_v => {
      let section = {
        name_of_section: s_v.value,
        questions: []
      }
      question.forEach(q_v => {
        let questions = {
          question: q_v.value,
          answers: []
        }
        answer.forEach(a_v => {
          let answer = {
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
    addAnketa(dataJSON, data.token).then(() => {
      history.push({ 
        pathname: '/ankety',
        state: data
      })
    })
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
    let newQuestion = question.filter(question => question.parentid !== id)
    let deleteQuestion = question.filter(question => question.parentid === id)

    deleteQuestion.forEach((v, k) => {
      let newAnswer = answer.filter(answer => answer.parentid !== v.id)
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
    let newAnswer = answer.filter(answer => answer.parentid !== id)
    
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
  } 
  else {
    return (
      <div>
        <Typography component="h1" variant="h5" style={{
          display: 'block', 
          textAlign: 'center',
          marginTop: 50
        }}
        >
          Додати анкету
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

export default AddAnketa