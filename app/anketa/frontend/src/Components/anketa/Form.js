import React, {useState} from 'react'
import TextField from '@mui/material/TextField'
import Box from '@mui/material/Box'
import { v4 } from 'uuid'
import {
  Alert,
  Radio,
  Button,
  Typography,
  FormControl,
  FormLabel,
  RadioGroup,
  Snackbar,
  FormControlLabel
} from '@mui/material'
import { 
  Grid,
  Card,
  Container 
} from "@material-ui/core"
import { addAnswer } from '../../api/client'

export default function Form({
  data,
  history,
  anketa
}) {
  const [value, setValue] = useState([])
  const [openNotifyS, setOpenNotifyS] = useState(false)

  const handleCloseS = () => {
    setOpenNotifyS(false)
  }

  const handleOpenS = () => {
    setOpenNotifyS(true)
  }

  const addValue = (children_id, answer_id, question_id) => {
    const newValue = {
      children_id: children_id,
      list_of_answers_id: answer_id,
      question_id: question_id
    }
    let dataToAdd = [...value]
    
    let newArray = dataToAdd.filter(ans => ans.question_id !== question_id )

    newArray.push(newValue)
    setValue(newArray)
  }

  const handleSubmit = (event) => {
    event.preventDefault()
    data.is_success = true
      handleOpenS()
      addAnswer(value ,data.token)
      setTimeout(function () {
        history.push({ 
          pathname: '/ankety',
          state: data
        })
      }, 2800)
  }

  return (
    <div>
      <Snackbar
        anchorOrigin={{
          vertical: 'top',
          horizontal: 'right'}}
        open={openNotifyS}
        onClose={handleCloseS}
        autoHideDuration={6000}
        key={v4()}
      > 
        <Alert onClose={handleCloseS} severity="success" sx={{ width: '100%' }}>
          Ви успішно пройшли анкетування
        </Alert>
      </Snackbar>
      <Box component="form" onSubmit={handleSubmit} id="anketa" noValidate>
        <Container> 
          <Grid container spacing={3}>
            {
              anketa.sections.map(section => {
                  let questionCount = 0
                  return (
                    <Grid item key={anketa.anketa_id} md={12} lg={12} xs={12}>
                      <Card>
                      <TextField
                        id="filled-read-only-input"
                        defaultValue={section.name_of_section}
                        InputProps={{
                            readOnly: true,
                        }}
                        variant="filled"
                        disabled
                        fullWidth={true}
                      />
                      {
                        section.questions.map(question => {
                          questionCount++
                          return (
                            <Grid container spacing={3}>
                              <Grid item key={anketa.anketa_id} md={12} lg={12} xs={12}>
                                <Card>
                                  <FormControl component="fieldset">
                                    <FormLabel component="legend">
                                      <Typography variant="h6" gutterBottom component="div" color='inherit' style={{marginLeft: '10px'}}>
                                        {questionCount}. {question.question}
                                      </Typography>
                                    </FormLabel>
                                    <RadioGroup
                                      aria-label="gender"
                                      name="radio-buttons-group"
                                    >
                                    {
                                      question.answers.map(answer => {
                                        return (
                                          <FormControlLabel 
                                            value={answer.name_of_answer} 
                                            control={<Radio />} 
                                            label={answer.name_of_answer} 
                                            style={{marginLeft: '20px'}}
                                            onChange={() => {
                                              addValue(data.child.id, answer.list_of_answers_id, question.question_id)
                                            }}
                                          />
                                        )
                                      })
                                    }
                                    </RadioGroup>
                                  </FormControl>
                                </Card>
                              </Grid>
                            </Grid>
                          )
                        })
                      }
                    </Card>
                  </Grid>
                )
              })
            }
            <Grid container >
              <Grid item md={7} lg={7}></Grid>
              <Grid item md={3} lg={3}>
                <Button 
                  style={{backgroundColor: 'grey'}}
                  variant="contained"
                  onClick={() => {
                    history.push({ 
                      pathname: '/ankety',
                      state: data
                    })
                  }}
                >Повернутись назад</Button>
              </Grid>
              <Grid item md={2} lg={2}>
                <Button 
                  variant="contained"
                  type="submit"
                > Відправити</Button>
              </Grid>
            </Grid>
          </Grid>
        </Container>
      </Box>
    </div>
  )
}