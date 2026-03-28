import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { authAPI } from '../services/api';
import { useAuth } from '../context/AuthContext';
import { toast } from '../utils/toast';
import '../styles/login.css';

const Login = () => {
  const navigate = useNavigate();
  const { updateUser } = useAuth();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [captchaAnswer, setCaptchaAnswer] = useState('');
  const [captchaToken, setCaptchaToken] = useState('');
  const [captchaQuestion, setCaptchaQuestion] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [challengeLoading, setChallengeLoading] = useState(true);

  const loadChallenge = useCallback(async () => {
    setChallengeLoading(true);
    try {
      const res = await authAPI.getLoginChallenge();
      const d = res?.data ?? res;
      setCaptchaToken(d?.captcha_token || '');
      setCaptchaQuestion(d?.question || '');
      setCaptchaAnswer('');
    } catch (e) {
      setCaptchaQuestion('');
      setCaptchaToken('');
      toast.error(e.message || 'Could not load security challenge. Check API connection.');
    } finally {
      setChallengeLoading(false);
    }
  }, []);

  useEffect(() => {
    loadChallenge();
  }, [loadChallenge]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    if (!captchaToken || !captchaQuestion) {
      setError('Security challenge not ready. Refresh the page.');
      setLoading(false);
      await loadChallenge();
      return;
    }

    try {
      const data = await authAPI.login(username, password, captchaToken, captchaAnswer);
      if (data.user) updateUser(data.user);
      navigate('/admin/dashboard');
    } catch (err) {
      const message =
        err.errors?.captcha_answer?.[0]
        || err.errors?.username?.[0]
        || err.message
        || 'Invalid username or password.';
      setError(message);
      setPassword('');
      setCaptchaAnswer('');
      await loadChallenge();
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-page">
      <div className="login-container">
        <div className="left-side">
          <div className="logo-box">
            <img src="/images/air.png" alt="AirKing Logo" className="logo" />
          </div>
          <h1>AirKing Air Conditioning</h1>
          <p className="description">
            WEB-BASED ADAPTIVE BARCODE AUDITING AND INVENTORY MANAGEMENT SYSTEM FOR AIRKING AIR CONDITIONING
          </p>
        </div>

        <div className="right-side">
          <div className="login-form">
            <h2>Welcome Back !</h2>
            <p>Please login to your account</p>

            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label>Username</label>
                <input
                  type="text"
                  placeholder="Enter your username"
                  value={username}
                  onChange={(e) => {
                    setUsername(e.target.value);
                    setError('');
                  }}
                  autoComplete="username"
                  maxLength={100}
                  required
                />
              </div>

              <div className="form-group">
                <label>Password</label>
                <input
                  type="password"
                  placeholder="Enter your password"
                  value={password}
                  onChange={(e) => {
                    setPassword(e.target.value);
                    setError('');
                  }}
                  autoComplete="current-password"
                  maxLength={255}
                  required
                />
              </div>

              <div className="form-group">
                <label>Security check</label>
                {challengeLoading ? (
                  <p className="login-challenge-loading">Loading challenge…</p>
                ) : captchaQuestion ? (
                  <>
                    <p className="login-captcha-question">{captchaQuestion}</p>
                    <input
                      type="text"
                      inputMode="numeric"
                      placeholder="Your answer"
                      value={captchaAnswer}
                      onChange={(e) => {
                        setCaptchaAnswer(e.target.value.replace(/[^\d-]/g, ''));
                        setError('');
                      }}
                      maxLength={10}
                      required
                    />
                    <button type="button" className="login-refresh-captcha" onClick={loadChallenge}>
                      New question
                    </button>
                  </>
                ) : (
                  <p className="login-challenge-error">Challenge unavailable. Check API / backend.</p>
                )}
              </div>

              <div className="form-options">
                <div className="remember">
                  <input type="checkbox" id="remember" />
                  <label htmlFor="remember">Remember me</label>
                </div>
                <button
                  type="button"
                  className="forgot"
                  onClick={() => navigate('/admin/forgot-password')}
                >
                  Forgot Password?
                </button>
              </div>

              <button type="submit" className="login-btn" disabled={loading || challengeLoading || !captchaToken}>
                {loading ? 'Logging in...' : 'Login'}
              </button>

              {error && <p className="error">{error}</p>}
            </form>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Login;
