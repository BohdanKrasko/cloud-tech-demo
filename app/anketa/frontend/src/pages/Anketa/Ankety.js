import React, {useState, useEffect} from 'react'
import { Redirect } from "react-router-dom"
import SwipedTable from '../../Components/table/SwipedTable'
import { deleteAnketa, getAnaketa } from '../../api/client'
import RightMenuStats from '../../Components/menu/RightMenuStats'
import { ConfirmProvider } from 'material-ui-confirm'
import AnketaCard from '../../Components/anketa/AnketaCard'
import AddAncketa from '../../Components/anketa/AddAnketa'
import {
  CssBaseline,
  CircularProgress
} from '@mui/material'
import { 
  Grid,
  Container 
} from "@material-ui/core"
import { 
  getAnakety, 
  getChildren, 
  deleteChildren, 
  addChildren, 
  editChildren,
  hasAnswersExist 
} from '../../api/client'
  
const columns = [
  {title: "id", field: "id", hidden: true},
  {title: "Прізвище", field: "surname"},
  {title: "Ім'я", field: "name"},
  {title: "Дата народження", field: "birthday", type: "date", format: "YYYY-dd-mm"},
  {title: "Вага", field: "weight", type: "numeric"},
  {title: "Зріст", field: "height", type: "numeric"}
]

export default function Ankety(props) {
  let data = (props.location && props.location.state) || {}
  const { window } = props
  const [open, setOpen] = useState(false)
  const [isLoading, setLoading] = useState(true)
  const { parents_id, token } = data
  const [useCount] = useState(0)
  const [anketa, setAnketa] = useState([])
  const [openChildrend, setOpenChildrend] = useState(false)
  const [isAuthorized, setIsAuthorized] = useState(false)
  const [children, setChildren] = useState([])
  const [iserror, setIserror] = useState(false)
  const [errorMessages, setErrorMessages] = useState([])
  const [selectedAnketa, setSelectedAnketa] = useState([])

  const handleDrawerOpen = () => {
    setOpen(true)
  }

  const handleDrawerClose = () => {
    setOpen(false)
  }


  const validate = (data) => {
    let errorList = []
    if(data.surname === undefined || data.surname === ''){
      errorList.push("Будь ласка ведіть ім'я")
    }
    if(data.name === undefined || data.name === ''){
      errorList.push("Будь ласка ведіть прізвище")
    }
    if(data.birthday === undefined || data.birthday === ''){
      errorList.push("Будь ласка ведіть дату народження")
    }
    if(data.weight === undefined || data.weight === ''){
      errorList.push("Будь ласка ведіть вагу")
    }
    if(data.height === undefined || data.height === ''){
      errorList.push("Будь ласка ведіть зріст")
    }
    return errorList
  }

  const handleRowUpdate = async (newData, oldData) => {
    //validation
    if (typeof(newData.birthday) === 'string' ) {
      newData.birthday = new Date(newData.birthday) 
    }

    let errorList = validate(newData)
  
    if (errorList.length > 0) {
      setErrorMessages(errorList)
      setIserror(true)
      throw Error
    } else { //no error
      editChildren(newData, token)
      .then(() => {
        let updatedChildrend = [...children]
        const index = updatedChildrend.findIndex(obj => obj.id === oldData.id)
        updatedChildrend[index] = newData
        setChildren(updatedChildrend)
        setIserror(false)
        setErrorMessages([])
      })
      .catch(err => {
        setErrorMessages(["Update failed! Server error"])
        setIserror(true)
      })
    } 
  }

  const handleRowAdd = async (newData) => {
    //validation
    let errorList = validate(newData)
    if (errorList.length > 0) {
      setErrorMessages(errorList)
      setIserror(true)
      throw Error
    } else { //no error
      addChildren(newData, token, parents_id)
      .then(res => res.json())
      .then(res => {
        newData.id = res[0].insertId
        let dataToAdd = [...children]
        dataToAdd.push(newData)
        setChildren(dataToAdd)
        setErrorMessages([])
        setIserror(false)
      })
      .catch(() => {
        setErrorMessages(["Помилка на сервері буль ласка зачекайте"])
        setIserror(true)
      })
    }
  }

  const handleRowDelete = async (oldData) => {
    deleteChildren(oldData.id, token)
      .then(res => {
        let newChildren = children.filter(children => children.id !== oldData.id )
        setChildren(newChildren)
        setErrorMessages([])
        setIserror()
      })
      .catch(err => {
        setErrorMessages(["Помилка на сервері буль ласка зачекайте"])
        setIserror(true)
      })
    }

  const toggleDrawer = (newOpen) => () => {
      setOpenChildrend(newOpen)
    }
    
  const container = window !== undefined ? () => window().document.body : undefined

  const handleDelete = async (anketa_id) => {
      // send request to Delete from DB
      let deleteData = {
        anketa_id: anketa_id,
        token: token,
        delete: {
          children_answer: [],
          list_of_answers: [],
          question: [],
          section: [],
          anketa: []
        }
      }
      getAnaketa(deleteData)
        .then(res => res.json())
        .then(res => {
          for (const k_s in res.sections) {
            const section = res.sections[k_s]
            deleteData.delete.section.push(section.section_id)
            for (const k_q in section.questions) {
              const question = section.questions[k_q]
              deleteData.delete.question.push(question.question_id)
              for (const k_a in question.answers) {
                const answer = question.answers[k_a]
                deleteData.delete.list_of_answers.push(answer.list_of_answers_id)
                deleteData.delete.children_answer.push(answer.list_of_answers_id)
              }
            }
          }
          deleteData.delete.anketa.push(anketa_id)
          deleteAnketa(deleteData)
        })
      const newAnakety = anketa.filter(anketa => anketa.anketa_id !== anketa_id )
      setAnketa(newAnakety)
      
  }

  const check = async (anketa_id) => {
    let checkData = {
      anketa_id: anketa_id,
      token: token,
      check: []
    }
    await getAnaketa(checkData)
      .then(res => res.json())
      .then(res => {
        for (const k_s in res.sections) {
          const section = res.sections[k_s]
          for (const k_q in section.questions) {
            const question = section.questions[k_q]
            for (const k_a in question.answers) {
              const answer = question.answers[k_a]
              checkData.check.push(answer.list_of_answers_id)
            }
          }
        }
      })

      return hasAnswersExist(checkData)
        .then(res => res.json())
        .then(res => {
          return res.has_answers
        })
  }

  const handleOpenChildren = async (anketa_data) => {
    setSelectedAnketa(anketa_data)
      getChildren(parents_id, token)
          .then(data => data.json())
          .then((data) => {
            let preperadData = []

            data.forEach((key, val) => {
              var parts = key.birthday.split('/')
              var dateString = parts[2] + '-' + parts[1] + '-' + parts[0] 
              key.birthday = new Date(dateString) 
              preperadData.push(key)
            })
            setChildren(preperadData)
      })
      setOpenChildrend(true)
    }
    
    useEffect(() => {
      const fetchOffsetAnketa = (token) => {
        getAnakety(token)
          .then(res => res.json())
          .then(anketa => {
              setAnketa(anketa)
              setIsAuthorized(true)   
              setLoading(false) 
          }).catch(err => {
              setIsAuthorized(false)
              setLoading(false) 
              return err
          })
      }
      fetchOffsetAnketa(token) 
    }, [useCount])

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
          <div sx={{ display: 'flex' }}>
          <CssBaseline />
          <RightMenuStats
            open={open}
            handleDrawerOpen={handleDrawerOpen}
            handleDrawerClose={handleDrawerClose}
            parents={data}
            isShowButton={false}
          />
          <Container>
            <Grid container spacing={3}>
                { data.role === 'admin' ? <Grid item key={anketa.anketa_id} xs={12} md={6} lg={4}>
                    <AddAncketa parents={data}/>
                </Grid> : <Grid/>}
                {anketa.map(anketa => (
                  <ConfirmProvider> 
                    <Grid item key={anketa.anketa_id} xs={12} md={6} lg={4}>
                        <AnketaCard 
                          anketa={anketa} 
                          parents={data} 
                          handleDelete={handleDelete} 
                          handleOpenChildren={handleOpenChildren}
                          check={check}
                        />
                    </Grid>
                  </ConfirmProvider>
                ))}
            </Grid>
          </Container>
         <SwipedTable
            container={container}
            openChildrend={openChildrend}
            toggleDrawer={toggleDrawer}
            selectedAnketa={selectedAnketa}
            columns={columns} 
            parents={data}
            children={children} 
            handleRowDelete={handleRowDelete} 
            handleRowAdd={handleRowAdd}
            handleRowUpdate={handleRowUpdate}
            iserror={iserror} 
            errorMessages={errorMessages}
          />
        </div>
      )
  }
}
