import fetch from 'unfetch'

// const url = "https://dubr-irc.herokuapp.com" // use in prod env
// const url = "http://backend.stage.cloud-tech-demo.pp.ua" // use in prod env
const url = process.env.REACT_APP_HOST // use in prod env
// const url = "http://localhost:3000" // use it in local env

const checkStatus = (response) => {
  if(response.ok) {
    return response
  } else {
    let error = new Error(response.statusText)
    error.response = response
    response.json().then(e => {
      error.error = e
    })
    return Promise.reject(response.statusText)
  }
}

export const login = (user) => 
  fetch(url + '/api/v1/login', {
    headers: {
      'Content-Type': 'application/json'
    },
    method: 'POST',
    body: JSON.stringify(user)
  }).then(checkStatus)

export const register = (user) => 
  fetch(url + '/api/v1/register', {
    headers: {
      'Content-Type': 'application/json'
    },
    method: 'POST',
    body: JSON.stringify({
      first_name: user.firstName,
      last_name : user.lastName,
      username  : user.username,
      password  : user.password,
      phone     : user.phone
    })
  }).then(checkStatus)

export const getAnakety = (token) => 
  fetch(url + '/api/v1/get/ankety', {
    headers: {
      'Authorization': 'Bearer ' + token
    },
    method: 'GET'
  }).then(checkStatus)

export const getChildren = (parents_id, token) => 
  fetch(url + `/api/v1/get/children/${parents_id}`, {
    headers: {
      'Authorization': 'Bearer ' + token
    },
    method: 'GET'
  }).then(checkStatus)

export const deleteChildren = (children_id, token) => 
  fetch(url + `/api/v1/delete/children/${children_id}`, {
    headers: {
      'Authorization': 'Bearer ' + token
    },
    method: 'DELETE'
  }).then(checkStatus)

export const addChildren = (data, token, parents_id) => 
  fetch(url + '/api/v1/create/children', {
    headers: {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json'
    },
    method: 'POST',
    body: JSON.stringify({
      parents_id: parents_id,
      surname : data.surname,
      name  : data.name,
      birthday  : data.birthday.toLocaleDateString('en-CA'),
      weight     : data.weight,
      height     : data.height
    })
  }).then(checkStatus)

export const editChildren = (data, token) => 
  fetch(url + '/api/v1/edit/children', {
    headers: {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json'
    },
    method: 'PUT',
    body: JSON.stringify({
      children_id: data.id,
      surname : data.surname,
      name  : data.name,
      birthday  : data.birthday.toLocaleDateString('en-CA'),
      weight     : data.weight,
      height     : data.height
    })
  }).then(checkStatus)

export const addAnketa = (data, token) => 
  fetch(url + '/api/v1/create/anketa', {
    headers: {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json'
    },
    method: 'POST',
    body: JSON.stringify(data)
  }).then(checkStatus)

export const editAnketa = (data, token) => 
  fetch(url + '/api/v1/edit/anketa', {
    headers: {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json'
    },
    method: 'PUT',
    body: JSON.stringify(data)
  }).then(checkStatus)

export const getAnaketa = (data) => 
  fetch(url + `/api/v1/get/anketa/${data.anketa_id}`, {
    headers: {
      'Authorization': 'Bearer ' + data.token
    },
    method: 'GET'
  }).then(checkStatus)  

export const deleteAnketa = (data) => {
  fetch(url + `/api/v1/delete/anketa/${data.anketa_id}`, {
    headers: {
      'Authorization': 'Bearer ' + data.token,
      'Content-Type': 'application/json'
    },
    method: 'DELETE',
    body: JSON.stringify(data)
  }).then(checkStatus)
}

export const addAnswer = (data, token) => {
  fetch(url + '/api/v1/create/child_answer', {
    headers: {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json'
    },
    method: 'POST',
    body: JSON.stringify({answers: data})
  }).then(checkStatus)
}

export const getStatistic = (data) => 
  fetch(url + `/api/v1/get/anketa/${data.anketa_id}/children/${data.children_id}`, {
    headers: {
      'Authorization': 'Bearer ' + data.token
    },
    method: 'GET'
  }).then(checkStatus)

export const getAllChildrenByAnketa = (anketa_id, token) => 
  fetch(url + `/api/v1/get/all/children/anketa/${anketa_id}`, {
    headers: {
      'Authorization': 'Bearer ' + token
    },
    method: 'GET'
  }).then(checkStatus)

export const getAllChildrenByAnketaAndParent = (anketa_id, parents_id, token) => 
  fetch(url + `/api/v1/get/all/children/anketa/${anketa_id}/parent/${parents_id}`, {
    headers: {
      'Authorization': 'Bearer ' + token
    },
    method: 'GET'
  }).then(checkStatus)

export const hasAnswersExist = (data) => 
  fetch(url + '/api/v1/exist/answers', {
    headers: {
      'Authorization': 'Bearer ' + data.token,
      'Content-Type': 'application/json'
    },
    method: 'POST',
    body: JSON.stringify({check: data.check})
  }
).then(checkStatus)

export const getUserByUsername = (data) => 
  fetch(url + `/api/v1/get/user/${data.username}`, {
    headers: {
      'Authorization': 'Bearer ' + data.token,
    },
    method: 'GET'
  }
).then(checkStatus)

export const isExistsUser = (data) => 
  fetch(url + `/api/v1/exist/user/${data.parents_id}/username/${data.username}`, {
    headers: {
      'Authorization': 'Bearer ' + data.token,
    },
    method: 'GET'
  }
).then(checkStatus)

export const editUser = (data) => 
  fetch(url + '/api/v1/edit/user', {
    headers: {
      'Authorization': 'Bearer ' + data.token,
      'Content-Type': 'application/json'
    },
    method: 'PUT',
    body: JSON.stringify({check: data.user})
  }
).then(checkStatus)

export const editPassword = (data) => 
  fetch(url + '/api/v1/edit/password', {
    headers: {
      'Authorization': 'Bearer ' + data.token,
      'Content-Type': 'application/json'
    },
    method: 'PUT',
    body: JSON.stringify({
      parents_id: data.parents_id,
      password: data.password
    })
  }
).then(checkStatus)

export const getAdmins = (data) => 
  fetch(url + '/api/v1/get/all/admins', {
    headers: {
      'Authorization': 'Bearer ' + data.token,
    },
    method: 'GET'
  }
).then(checkStatus)

export const addAdmin = (data) => 
  fetch(url + '/api/v1/create/admin', {
    headers: {
      'Authorization': 'Bearer ' + data.token,
      'Content-Type': 'application/json'
    },
    method: 'POST',
    body: JSON.stringify(data.admin)
  }
).then(checkStatus)

export const editAdmin = (data) => 
  fetch(url + '/api/v1/edit/admin', {
    headers: {
      'Authorization': 'Bearer ' + data.token,
      'Content-Type': 'application/json'
    },
    method: 'PUT',
    body: JSON.stringify(data.admin)
  }
).then(checkStatus)

export const deleteAdmin = (data) => 
  fetch(url + `/api/v1/delete/admin/${data.admin_id}`, {
    headers: {
      'Authorization': 'Bearer ' + data.token,
    },
    method: 'DELETE'
  }
)