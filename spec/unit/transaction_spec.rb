RSpec.describe Transflow::Transaction do
  let(:steps) { { three: step3, two: step2, one: step1 } }

  describe '#call' do
    context 'with steps accepting a single arg' do
      let(:step1) { -> i { i + 1 } }
      let(:step2) { -> i { i + 2 } }
      let(:step3) { -> i { i + 3 } }

      it 'composes steps and calls them' do
        transaction = Transflow::Transaction.new(steps)

        expect(transaction[1]).to be(7)
      end
    end

    context 'with steps accepting an array' do
      let(:step1) { -> arr { arr.map(&:succ) } }
      let(:step2) { -> arr { arr.map(&:succ) } }
      let(:step3) { -> arr { arr.map(&:succ) } }

      it 'composes steps and calls them' do
        transaction = Transflow::Transaction.new(steps)

        expect(transaction[[1, 2, 3]]).to eql([4, 5, 6])
      end
    end

    context 'with steps accepting a hash' do
      let(:step1) { -> i { { i: i } } }
      let(:step2) { -> h { h[:i].succ } }
      let(:step3) { -> i { i.succ } }

      it 'composes steps and calls them' do
        transaction = Transflow::Transaction.new(steps)

        expect(transaction[1]).to eql(3)
      end
    end

    context 'with steps accepting a kw args' do
      let(:step1) { -> i { { i: i, j: i + 1 } } }
      let(:step2) { -> i:, j: { i + j } }
      let(:step3) { -> i { i + 3 } }

      it 'composes steps and calls them' do
        transaction = Transflow::Transaction.new(steps)

        expect(transaction[1]).to be(6)
      end
    end
  end
end
