import { useState } from 'react';
import { useNavigate } from 'react-router-dom';

const Login = ({ setShowLogin, setUser }) => {
  const navigate = useNavigate();
  const [userData, setUserData] = useState({
    email: '',
    password: '',
  });
  const [error, setError] = useState('');

  const handleChange = (e) => {
    const { name, value } = e.target;
    setUserData((prevData) => ({
      ...prevData,
      [name]: value,
    }));
    setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      // Convert the data to URLSearchParams
      const formData = new URLSearchParams();
      formData.append('username', userData.email); // FastAPI expects 'username'
      formData.append('password', userData.password);

      const response = await fetch("http://54.67.35.1/auth/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: formData,
      });

      const data = await response.json();
      
      if (response.ok) {
        
        // Store token and user info
        localStorage.setItem('access_token', data.login_access_token);
        localStorage.setItem('user', JSON.stringify(data.user_info));
        console.log(localStorage.getItem('access_token'));
        console.log(localStorage.getItem('user'));
        
        // Update app state
        setUser(data.user_info);
        setShowLogin(false);
        
        // Navigate based on user type
        if (data.user_info.user_type === 'owner') {
          navigate('/business');
        } else {
          navigate('/');
        }
      } else {
        setError(data.detail || 'Invalid credentials');
      }
    } catch (error) {
      setError('Login failed. Please try again.');
      console.error('Login error:', error);
    }
  };

  return (
    <div className="w-full max-w-md">
      <form 
        className='border border-black text-black p-4 rounded-md flex flex-col items-center gap-5' 
        onSubmit={handleSubmit}
      >
        <h1 className='text-xl font-bold'>LOG IN</h1>
        
        {error && (
          <div className="mb-4 p-2 bg-red-100 border border-red-400 text-red-700 rounded">
            {error}
          </div>
        )}

        <div className="mb-4">
          <input
            className='bg-gray-200 appearance-none border-2 border-gray-200 rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-green-500'
            placeholder='Email'
            type="email"
            name="email"
            value={userData.email}
            onChange={handleChange}
            required
          />
        </div>

        <div className="mb-6">
          <input
            className='bg-gray-200 appearance-none border-2 border-gray-200 rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-green-500'
            placeholder='Password'
            type="password"
            name="password"
            value={userData.password}
            onChange={handleChange}
            required
          />
        </div>

        <div className="flex items-center justify-center">
          <button
            type="submit"
            className='shadow bg-green-500 focus:shadow-outline focus:outline-none text-white font-bold py-2 px-4 rounded'
          >
            Log In
          </button>
        </div>
      </form>
    </div>
  );
};

export default Login;