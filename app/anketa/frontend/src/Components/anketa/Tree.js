import React from 'react'
import TextField from '@mui/material/TextField'
import Box from '@mui/material/Box'
import { v4 } from 'uuid'
import {
  Grid,
  Button,
  Tooltip
} from '@mui/material'
import AddBoxIcon from '@mui/icons-material/AddBox'
import AddCircleOutlineIcon from '@mui/icons-material/AddCircleOutline'
import AddIcon from '@mui/icons-material/Add'
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline'

export default function Tree({
  data,
  history,
  handleSubmit,
  anketa,
  section,
  question,
  answer,
  addSection,
  deleteSection,
  addQuestion,
  deleteQuestion,
  addAnswer,
  deleteAnswer
}) {

  let indexSection = 1
  return (
    <Box
      sx={{
        width: '90%',
        margin: 'auto',
        display: 'block',
        flexDirection: 'column',
        alignItems: 'center'
      }}
    >
      <Box component="form" onSubmit={handleSubmit} id="anketa" noValidate sx={{ mt: 2 }}>
        <Grid container direction="row" alignItems="center">
          <Grid item xs={1} md={1}>
            <Tooltip title="Додати блок"> 
              <Button style={{color: 'grey'}} onClick={() => {
                  addSection(anketa[0].id, indexSection)
                }}>
                <AddBoxIcon fontSize="large"/>
              </Button>
            </Tooltip>
          </Grid>
          <Grid item xs={5} md={5} form="anketa">
            <TextField
              key={v4()}
              margin="normal"
              required
              fullWidth
              id={anketa[0].id}
              label={anketa[0].label}
              name={anketa[0].name}
              autoComplete="off"
              defaultValue={anketa[0].value}
              onChange={(e) => {
                  anketa[0].value = e.target.value
              }}
            /> 
          </Grid>
          <Grid item xs={1} md={1}></Grid>
          <Grid item xs={4} md={4} form="anketa">
            <TextField
              key={v4()}
              margin="normal"
              required
              fullWidth
              id="category"
              label="Категорія анкети"
              name="category"
              autoComplete="off"
              defaultValue={anketa[0].category}
              onChange={(e) => {
                  anketa[0].category = e.target.value
              }}
            /> 
          </Grid>
      </Grid>
      {anketa.map(anketa => {
        return (
          section.map(section => {
            if (anketa.id === section.parentid) {
              indexSection++
              let indexQuestion = 1
              return (
                <Grid container direction="row" alignItems="center" key={v4()}>
                  <Grid item xs={2} md={2} style={{textAlign: 'right'}}>
                    <Tooltip title="Додати питанння"> 
                      <Button style={{color: 'grey'}} onClick={() => {
                        addQuestion(section.id, indexQuestion)
                      }}>
                        <AddCircleOutlineIcon fontSize="large"/>
                      </Button>
                    </Tooltip>
                  </Grid>
                  <Grid item xs={8} md={9}>
                    <TextField
                      key = {section.id}
                      margin="normal"
                      required
                      fullWidth
                      id={section.id}
                      label={section.label}
                      name={section.name}
                      autoComplete="off"
                      defaultValue={section.value}
                      onChange={(e) => {
                        section.value = e.target.value
                      }}
                    /> 
                  </Grid>
                  <Grid item xs={1} md={1} style={{textAlign: 'right'}}>
                    <Tooltip title="Видалити блок"> 
                      <Button style={{color: 'grey'}} onClick={() => {
                          deleteSection(section.id)
                        }}>
                        <DeleteOutlineIcon fontSize="large"/>
                      </Button>
                    </Tooltip>
                  </Grid>
                      {question.map(question => {
                        if (section.id === question.parentid) {
                          indexQuestion++
                          let indexAnswer = 1

                          return (
                            <Grid container direction="row" alignItems="center" key={v4()}>
                                <Grid item xs={3} md={3} style={{textAlign: 'right'}}>
                                  <Tooltip title="Додати відповідь"> 
                                    <Button style={{color: 'grey'}} onClick={() => {
                                      addAnswer(question.id, indexAnswer)
                                    }}>
                                      <AddIcon fontSize="large"/>
                                    </Button>
                                  </Tooltip>
                                </Grid>
                                <Grid item xs={7} md={8}>
                                  <TextField
                                    key = {question.id}
                                    margin="normal"
                                    required
                                    fullWidth
                                    id={question.id}
                                    label={question.label}
                                    name={question.name}
                                    autoComplete="off"
                                    defaultValue={question.value}
                                    onChange={(e) => {
                                      question.value = e.target.value
                                    }}
                                  /> 
                                </Grid>
                                <Grid item xs={1} md={1} style={{textAlign: 'right'}}>
                                    <Tooltip title="Видалити питання"> 
                                      <Button style={{color: 'grey'}} onClick={() => {
                                            deleteQuestion(question.id)
                                          }}>
                                          <DeleteOutlineIcon fontSize="large"/>
                                      </Button>
                                    </Tooltip>
                                </Grid>
                                {answer.map(answer => {
                                  if (question.id === answer.parentid) {
                                    indexAnswer++
                                    return (
                                      <Grid container direction="row" alignItems="center" key={v4()}>
                                        <Grid item xs={4} md={4}>
                                        </Grid>
                                        <Grid item xs={6} md={7}>
                                          <TextField
                                            key = {answer.id}
                                            margin="normal"
                                            required
                                            fullWidth
                                            id={answer.id}
                                            label={answer.label}
                                            name={answer.name}
                                            autoComplete="off"
                                            defaultValue={answer.value}
                                            onChange={(e) => {
                                              answer.value = e.target.value
                                            }}
                                          /> 
                                        </Grid>
                                        <Grid item xs={1} md={1} style={{textAlign: 'right'}}>
                                          <Tooltip title="Видалити відповідь"> 
                                            <Button style={{color: 'grey'}} onClick={() => {
                                                deleteAnswer(answer.id)
                                              }}>
                                              <DeleteOutlineIcon fontSize="large"/>
                                            </Button>
                                          </Tooltip>
                                        </Grid>
                                      </Grid>
                                    )
                                  }
                                })}
                            </Grid>
                          )
                        }
                    })}
                </Grid>
              )
            }
          })
        )
      })}
      <Grid container direction="row" alignItems="center" key={v4()} style={{marginBottom: '70px'}}> 
          <Grid item xs={5.5} md={5.5}> 
              <Button
                  fullWidth
                  variant="contained"
                  sx={{ mt: 3, mb: 2 }}
                  style={{backgroundColor: 'grey'}}
                  onClick={() => {
                    history.push({ 
                      pathname: '/ankety',
                      state: data
                    })
                  }}
                  size="large"
              >
                Повернутись назад
              </Button>
          </Grid>
          <Grid item xs={0.5} md={0.5}> </Grid>
          <Grid item xs={5.5} md={5.5}> 
              <Button
                type="submit"
                fullWidth
                variant="contained"
                sx={{ mt: 3, mb: 2 }}
                size="large"
              >
                Зберегти
              </Button>
          </Grid>
        </Grid>
      </Box>
    </Box>
  )
}