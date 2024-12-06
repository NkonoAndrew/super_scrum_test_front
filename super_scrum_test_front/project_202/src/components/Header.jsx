import React, { useEffect, useState } from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import styled from 'styled-components';
import Signup from './Signup';
import Login from './Login';

const Header = ({ setSearchTerm }) => {
  const [showSignup, setShowSignup] = useState(false);
  const [showLogin, setShowLogin] = useState(false);
  const [user, setUser] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const token = localStorage.getItem('access_token');
    const userInfo = localStorage.getItem('user');
    
    if (token && userInfo) {
      setUser(JSON.parse(userInfo));
    }
  }, []);

  const handleSearch = (e) => {
    e.preventDefault();
    const searchValue = e.target.elements.search.value;
    if (searchValue.trim()) {
      setSearchTerm(searchValue);
    }
  };

  const handleSignupClick = () => {
    setShowSignup(true);
    setShowLogin(false);
  };

  const handleLoginClick = () => {
    setShowLogin(true);
    setShowSignup(false);
  };

  const handleCloseModal = () => {
    setShowSignup(false);
    setShowLogin(false);
  };

  const handleLogout = () => {
    localStorage.removeItem('access_token');
    localStorage.removeItem('user');
    setUser(null);
    navigate('/');
  };

  const handleBusinessClick = () => {
    const token = localStorage.getItem('access_token');
    if (!token) {
      setShowLogin(true);
      return;
    }
    if (user?.user_type !== 'owner') {
      alert('Only business owners can access this section');
      return;
    }
    navigate('/business');
  };

  return (
    <header className="bg-gray-600 text-white p-4">
      <NavContainer>
        <NavLink to="/" className="font-bold mb-1">Restaurant Finder</NavLink>
        <SearchForm onSubmit={handleSearch}>
          <SearchInput
            type="text"
            name="search"
            placeholder="Search restaurants..."
            autoComplete="off"
          />
          <SearchButton type="submit">Search</SearchButton>
        </SearchForm>
        
        <NavList>
        {(!user || (user.user_type !== 'admin' && user.user_type !== 'user')) && (
          <NavItem>
            <StyledButton onClick={handleBusinessClick}>
              Business Owner?
            </StyledButton>
          </NavItem>
        )}


        {user && user.user_type === 'admin' && (
          <NavItem>
            <StyledAdminLink to="/admin">
              Admin Panel
              
            </StyledAdminLink>
          </NavItem>
        )}

          
          {user ? (
            <>
              <NavItem>
                <span className="mr-2">Welcome, {user.username}</span>
              </NavItem>
              <NavItem>
                <StyledButton onClick={handleLogout}>Logout</StyledButton>
              </NavItem>
            </>
          ) : (
            <>
              <NavItem>
                <StyledButton onClick={handleLoginClick}>Login</StyledButton>
              </NavItem>
              <NavItem>
                <StyledButton onClick={handleSignupClick}>Signup</StyledButton>
              </NavItem>
            </>
          )}
        </NavList>
      </NavContainer>

      {showSignup && (
        <ModalOverlay>
          <ModalContent>
            <CloseButton onClick={handleCloseModal}>&times;</CloseButton>
            <Signup 
              setShowLogin={setShowLogin} 
              setShowSignup={setShowSignup} 
            />
          </ModalContent>
        </ModalOverlay>
      )}

      {showLogin && (
        <ModalOverlay>
          <ModalContent>
            <CloseButton onClick={handleCloseModal}>&times;</CloseButton>
            <Login 
              setShowLogin={setShowLogin}
              setUser={setUser} 
            />
          </ModalContent>
        </ModalOverlay>
      )}
    </header>
  );
};

// styled components
const ModalOverlay = styled.div`
  position: fixed;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: rgba(0, 0, 0, 0.75);
  z-index: 1000;
`;

const ModalContent = styled.div`
  background: white;
  border-radius: 0.5rem;
  padding: 1.5rem;
  width: 100%;
  max-width: 28rem;
  margin: 0 auto;
  position: relative;
`;

const CloseButton = styled.button`
  position: absolute;
  top: 0.5rem;
  right: 0.5rem;
  color: #666;
  font-size: 1.5rem;
  background: none;
  border: none;
  cursor: pointer;
  
  &:hover {
    color: #333;
  }
`;

const NavContainer = styled.nav`
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 2rem;
`;

const NavList = styled.ul`
  display: flex;
  list-style: none;
  margin: 0;
  padding: 0;
  align-items: center;  
  gap: 1rem;  
`;

const NavItem = styled.li`
  display: flex;  
  align-items: center;  
  height: 100%;  
  margin: 0;  
  padding: 0;  
`;

const StyledNavLink = styled(NavLink)`
  color: inherit;
  text-decoration: none;
  font-weight: bold;

  &:hover {
    text-decoration: underline;
  }
`;

const StyledAdminLink = styled(StyledNavLink)`
  background-color: #f59e0b;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  display: flex;  
  align-items: center;  
  height: 100%;  
  
  &:hover {
    background-color: #d97706;
    text-decoration: none;
  }
`;

const SearchForm = styled.form`
  display: flex;
  align-items: center;
`;

const SearchInput = styled.input`
  margin-right: 0.5rem;
  padding: 0.5rem 1rem;
  width: 300px;
  border-radius: 20px;
  border: 1px solid #ddd;
  background-color: white;
  color: #333;
  font-size: 16px;
  outline: none;

  &::placeholder {
    color: #888;
    opacity: 1;
  }

  &:focus {
    border-color: #4caf50;
    box-shadow: 0 0 5px rgba(76, 175, 80, 0.5);
  }
`;

const SearchButton = styled.button`
  padding: 0.5rem 1rem;
  background-color: #4caf50;
  color: white;
  border: none;
  border-radius: 20px;
  cursor: pointer;
  font-size: 16px;
  transition: background-color 0.2s ease;

  &:hover {
    background-color: #45a049;
  }
`;

const StyledButton = styled.button`
  background-color: red;
  color: white;
  font-size: 15px;
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 20px;
  cursor: pointer;
  transition: background-color 0.2s ease;

  &:hover {
    background-color: #045a3d;
  }
`;

export default Header;