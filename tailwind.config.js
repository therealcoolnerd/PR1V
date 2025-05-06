module.exports = {
  content: ["./pages/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        neonBlue: '#00E6FF',
        neonGreen: '#00FF66',
        canvas: '#000000'
      },
      fontFamily: { dotgothic: ['"DotGothic16"', 'monospace'] }
    }
  },
  plugins: []
};
