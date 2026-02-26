import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import '../styles/dashboard_air.css';

const Header = ({ searchPlaceholder = "Search...", onSearch }) => {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = React.useState('');
  const [user, setUser] = useState(null);

  // Simulate getting user from authentication/session
  useEffect(() => {
    // Get user data from localStorage or auth context
    const storedUser = localStorage.getItem('user');
    if (storedUser) {
      try {
        const parsedUser = JSON.parse(storedUser);
        setUser(parsedUser);
      } catch (error) {
        console.error('Error parsing user data:', error);
        // Fallback user data
        setUser({ 
          email: 'admin@airking.com',
          first_name: 'Admin',
          last_name: 'User'
        });
      }
    } else {
      // Fallback user data for demo
      setUser({ 
        email: 'admin@airking.com',
        first_name: 'Admin',
        last_name: 'User'
      });
    }
  }, []);

  const handleSearch = () => {
    if (onSearch) {
      onSearch(searchTerm);
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter') {
      handleSearch();
    }
  };

  const handleLogout = () => {
    localStorage.removeItem('user');
    localStorage.removeItem('token');
    navigate('/admin/login');
  };

  return (
    <header className="top-header">
      <div className="search-box">
        <input
          type="text"
          id="searchInput"
          placeholder={searchPlaceholder}
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          onKeyPress={handleKeyPress}
        />
        <button id="searchBtn" onClick={handleSearch}>Search</button>
      </div>
      <div className="header-right">
        <span className="role-badge">System Admin</span>
        <button className="icon-btn" onClick={() => alert('You have 3 new notifications')}>
          Bell
        </button>
        <button className="icon-btn" onClick={() => alert('Opening settings...')}>
          Settings
        </button>
        <div className="user-profile">
          <img src="/images/air.png" alt="User" />
          <span>
            {user ? (user.first_name || user.email?.split('@')[0]) : 'Admin'}
          </span>
        </div>
        <button
          type="button"
          className="logout-btn"
          onClick={handleLogout}
        >
          Logout
        </button>
      </div>
    </header>
  );
};

export default Header;