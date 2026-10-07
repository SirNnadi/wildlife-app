import { describe, it, expect } from 'vitest';
import { animals, habitats } from './animals';

describe('animals data', () => {
  it('exports 12 animal profiles', () => {
    expect(animals).toHaveLength(12);
  });

  it('every animal has required fields', () => {
    animals.forEach(a => {
      expect(a).toMatchObject({
        id: expect.any(String),
        name: expect.any(String),
        scientific: expect.any(String),
        status: expect.any(String),
        facts: expect.any(Array),
      });
    });
  });

  it('exports 4 habitats', () => {
    expect(habitats).toHaveLength(4);
  });
});
