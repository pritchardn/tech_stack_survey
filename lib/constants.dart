import 'package:flutter/material.dart';

const Color BRAND_PURPLE = Color.fromRGBO(168, 31, 87, 1);
const Color BRAND_PINK = Color.fromRGBO(205, 140, 167, 1);
const Color BRAND_ORANGE = Color.fromRGBO(182, 80, 24, 1);

const List<Color> backgroundPalette = [
  BRAND_PURPLE,
  BRAND_PINK
];

const double ICON_SIZE = 64;
const double DOT_SIZE = 12;
const double LINE_WIDTH = 4;
const double LEFT_INSET = 0.05;
const double TOP_INSET = 0.05;

const int TEXT_FADE_DURATION = 600;
const int DOT_MOVE_DURATION = 1600;
const int TEXT_TRAVEL_DISTANCE = 64;

const List<String> QUESTIONS = [
  "What do you listen to music with?",
  "Where do you watch TV / Movies?",
  "Where do you play games?",
  "What social media do you use most?",
  "How do you message most people?",
  "What do you use to write documents?",
  "Which email client do you use?",
  "How do you take notes?",
  "How do you keep track of tasks?",
  "What type of device do you like the most?"
];

const List<List<String>> ANSWERS = [
  [
    "Spotify",
    "Apple Music",
    "Tidal",
    "Amazon Music",
    "Other",
    "I don't listen to music"
  ],
  [
    "Netflix",
    "Disney+",
    "Amazon Prime",
    "AppleTV Plus",
    "Hayu",
    "Other",
    "I don't watch anything"
  ],
  [
    "Steam",
    "GoG",
    "Origin",
    "Xbox",
    "Platstation",
    "Nintendo",
    "Mobile",
    "Other",
    "I don't play games"
  ],
  [
    "Facebook",
    "Instagram",
    "Twitter",
    "Snapchat",
    "Tiktok",
    "Reddit",
    "Other",
    "I don't use social media"
  ],
  [
    "Discord",
    "Facebook Messenger",
    "WhatApp",
    "WeChat",
    "Telegram",
    "Signal",
    "Other"
  ],
  [
    "Microsoft Word",
    "Apple Pages",
    "Google Docs",
    "Libre Office Writer",
    "WPS Office Writer",
    "LaTeX",
    "Other",
    "I don't write documents"
  ],
  [
    "Outlook",
    "Gmail",
    "Apple Mail",
    "ProtonMail",
    "Thunderbird",
    "Other",
    "I don't use Email (somehow)"
  ],
  [
    "Pen and Paper",
    "Evernote",
    "Word Processor",
    "Microsoft OneNote",
    "Google Keep",
    "Obsidian",
    "Emacs",
    "Other",
    "I never make notes"
  ],
  [
    "Pen and Paper",
    "Microsoft Todo",
    "Todoist",
    "Any.do",
    "Things",
    "Omnifocus",
    "Google Tasks",
    "Other",
    "I don't track todos"
  ],
  [
    "PC",
    "Laptop",
    "iPhone",
    "Smartphone (other)",
    "Tablet",
    "Other",
    "I hate all technology"
  ]
];
