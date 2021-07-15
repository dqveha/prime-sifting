require('rspec')
require('prime_sifting')
require('pry')

describe('prime_sifting') do
  it("remove primes from 2 to 10") do
    expect(prime(10)).to(eq([2,3,5,7]))
  end

  it("remove primes from 2 to 19") do
    expect(prime(20)).to(eq([2,3,5,7,11,13,17,19]))
  end
end