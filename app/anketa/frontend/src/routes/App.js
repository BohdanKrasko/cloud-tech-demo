import {
  BrowserRouter as Router,
  Route 
} from 'react-router-dom'
import Start from '../pages/Start/Start'
import SignIn from '../pages/SingIn/SignIn'
import SignUp from '../pages/SingUp/SignUp'
import Ankety from '../pages/Anketa/Ankety'
import Anketa from '../pages/Anketa/Anketa'
import AddAnketa from '../pages/Anketa/AddAnketa'
import EditAnketa from '../pages/Anketa/EditAnketa'
import Statistics from '../pages/Statistics/Statistics'
import Children from '../pages/Children/Children'
import Profile from '../pages/Profile/Profile'
import Admin from '../pages/Admin/Admin'

function App() {
  return (
    <Router>
      <Route exact path="/" component={Start}></Route>
      <Route exact path="/signin" component={SignIn}></Route>
      <Route exact path="/signup" component={SignUp}></Route>
      <Route exact path="/ankety" component={Ankety}></Route>
      <Route exact path="/anketa" component={Anketa}></Route>
      <Route exact path="/anketa/add" component={AddAnketa}></Route>
      <Route exact path="/anketa/edit/:anketa_id" component={EditAnketa}></Route>
      <Route exact path="/statistics" component={Statistics}></Route>
      <Route exact path="/children" component={Children}></Route>
      <Route exact path="/profile" component={Profile}></Route>
      <Route exact path="/dashboard/admin" component={Admin}></Route>
    </Router>
  )
}

export default App
