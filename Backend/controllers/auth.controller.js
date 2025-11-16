const User = require('../models/User.model');
const Doctor = require('../models/Doctor.model');
const Patient = require('../models/Patient.model');
const Pharmacy = require('../models/Pharmacy.model');
const { generateToken } = require('../middleware/auth.middleware');

// @desc    Register a new user
// @route   POST /api/auth/register
// @access  Public
exports.register = async (req, res) => {
  try {
    const { name, email, password, phone, role, ...roleSpecificData } = req.body;

    // Check if user already exists
    const userExists = await User.findOne({ email });
    if (userExists) {
      return res.status(400).json({
        success: false,
        message: 'User already exists with this email'
      });
    }

    // Create user
    const user = await User.create({
      name,
      email,
      password,
      phone,
      role
    });

    // Create role-specific profile
    let roleProfile;
    
    if (role === 'doctor') {
      roleProfile = await Doctor.create({
        userId: user._id,
        ...roleSpecificData
      });
    } else if (role === 'patient') {
      roleProfile = await Patient.create({
        userId: user._id,
        ...roleSpecificData
      });
    } else if (role === 'pharmacist') {
      roleProfile = await Pharmacy.create({
        userId: user._id,
        ...roleSpecificData
      });
    }

    // Generate token
    const token = generateToken(user._id);

    res.status(201).json({
      success: true,
      message: 'User registered successfully',
      data: {
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          phone: user.phone,
          role: user.role,
          isVerified: user.isVerified
        },
        roleProfileId: roleProfile?._id,
        token
      }
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({
      success: false,
      message: 'Error registering user',
      error: error.message
    });
  }
};

// @desc    Login user
// @route   POST /api/auth/login
// @access  Public
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validate input
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Please provide email and password'
      });
    }

    // Check for user (include password for comparison)
    const user = await User.findOne({ email }).select('+password');
    
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }

    // Check password
    const isPasswordMatch = await user.comparePassword(password);
    
    if (!isPasswordMatch) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }

    // Get role-specific profile
    let roleProfile;
    if (user.role === 'doctor') {
      roleProfile = await Doctor.findOne({ userId: user._id });
    } else if (user.role === 'patient') {
      roleProfile = await Patient.findOne({ userId: user._id });
    } else if (user.role === 'pharmacist') {
      roleProfile = await Pharmacy.findOne({ userId: user._id });
    }

    // Generate token
    const token = generateToken(user._id);

    res.status(200).json({
      success: true,
      message: 'Login successful',
      data: {
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          phone: user.phone,
          role: user.role,
          isVerified: user.isVerified,
          profileImage: user.profileImage
        },
        roleProfileId: roleProfile?._id,
        token
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: 'Error logging in',
      error: error.message
    });
  }
};

// @desc    Get current logged in user
// @route   GET /api/auth/me
// @access  Private
exports.getMe = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);

    // Get role-specific profile
    let roleProfile;
    if (user.role === 'doctor') {
      roleProfile = await Doctor.findOne({ userId: user._id });
    } else if (user.role === 'patient') {
      roleProfile = await Patient.findOne({ userId: user._id });
    } else if (user.role === 'pharmacist') {
      roleProfile = await Pharmacy.findOne({ userId: user._id });
    }

    res.status(200).json({
      success: true,
      data: {
        user,
        roleProfile
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching user data',
      error: error.message
    });
  }
};
