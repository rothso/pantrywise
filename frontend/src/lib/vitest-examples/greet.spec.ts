import { describe, it, expect } from 'vitest';
import { greet } from './greet';

describe('greet', () => {
  it('returns a greeting', () => {
    // Arrange
    const name = 'World';

    // Act
    const result = greet(name);

    // Assert
    expect(result).toBe('Hello, World!');
  });
});
