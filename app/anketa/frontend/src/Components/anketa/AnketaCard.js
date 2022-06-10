import React from "react"
import Card from '@material-ui/core/Card'
import CardHeader from '@material-ui/core/CardHeader'
import CardMedia from '@mui/material/CardMedia'
import { IconButton } from '@material-ui/core'
import anketaLogo from '../../img/anketa.png'
import { CardActionArea } from '@mui/material'
import { DeleteOutlined } from '@material-ui/icons'
import EditIcon from '@mui/icons-material/Edit'
import Box from '@mui/material/Box'
import { useHistory } from "react-router-dom"
import { useConfirm } from 'material-ui-confirm'


export default function AnketaCard({
  anketa, 
  parents, 
  handleDelete, 
  handleOpenChildren, 
  check
}) {
  const history = useHistory()
  const confirm = useConfirm()
  const data = {
    first_name: parents.first_name,
    last_name: parents.last_name,
    phone: parents.phone,
    token: parents.token,
    role: parents.role,
    parents_id: parents.parents_id,
    anketa_id: anketa.anketa_id,
    name_of_anketa: anketa.name_of_anketa
  }

  return (
    <div>
      <Card >
        <CardHeader
          action = {
            <Box>
              { parents.role === 'admin' ? 
                <div>
                  <IconButton onClick={() => {
                  history.push({ 
                      pathname: `/anketa/edit/${anketa.anketa_id}`,
                      state: data
                      })
                  }}>
                  <EditIcon />
                  </IconButton>
                  <IconButton onClick={async () => {
                    await check(anketa.anketa_id)
                      .then(res => {
                        if (res) {
                          confirm({ 
                            title: 'Ви впевнені?', 
                            cancellationText: 'Скасувати',
                            confirmationText: 'Підтвердити',
                            description: 'На дану анкету користувачі дали відповіді. У разі видаленя всі їхні відповіді будуть видалені.' })
                            .then(() => {
                              handleDelete(anketa.anketa_id)
                            })
                            .catch(err => {})
                        } else {
                          handleDelete(anketa.anketa_id)
                        }
                      })
                  }}>
                    <DeleteOutlined />
                  </IconButton>
                </div> : <Box/>
              }
            </Box>
          }
          title={anketa.name_of_anketa}
          subheader={anketa.category}
        />
        <CardActionArea onClick={() => {
            handleOpenChildren(data)
          }} className='card-action-area'>
          <CardMedia
            component="img"
            style={{
                width: "auto",
                maxHeight: "250px",
                margin: "auto"
            }}
            image={anketaLogo}
            alt="Anketa logo"
          />
        </CardActionArea>
      </Card>
    </div>
  )
}