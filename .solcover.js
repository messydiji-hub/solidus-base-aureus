module.exports = {
  istanbulReporter: ['html', 'lcov', 'text-summary'],
  providerOptions: {
    mnemonic: process.env.MNEMONIC,
  },
  skipFiles: ['mocks', 'interfaces'],
  measureStatementCoverage: true,
  measureFunctionCoverage: true,
  measureModifierCoverage: true,
};
