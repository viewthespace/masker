require 'spec_helper'

describe Masker::Configurations::Postgres do
  let(:pg_mock) { instance_double(PG::Connection) }
  let(:config_path) { 'spec/test.yml' }
  let(:logger) { double(:logger) }
  let(:subject) { described_class.new(pg_mock, config_path, logger) }

  describe '#missing_tables' do
    before do
      expect(logger).to receive(:warn).with(/Table: users exists in configuration but not in database/)
      expect(pg_mock).to receive(:exec).with(/tablename = 'users'/).and_yield([{'exists' => 'f'}])
    end

    it 'returns an array of missing tables' do
      expect(subject.missing_tables).to match_array(['users'])
    end
  end

  describe '#missing_columns' do
    before do
      expect(logger).to receive(:warn).with(/Column: users:ssn exists in configuration but not in database/)
      expect(pg_mock).to receive(:exec).with(/column_name='email'/).and_yield([{'exists' => 't'}])
      expect(pg_mock).to receive(:exec).with(/column_name='name'/).and_yield([{'exists' => 't'}])
      expect(pg_mock).to receive(:exec).with(/column_name='ssn'/).and_yield([{'exists' => 'f'}])
    end

    it 'returns a hash of tables and missing columns' do
      expect(subject.missing_columns).to eq({ 'users' => ['ssn'] })
    end
  end

  describe '#ids_to_mask' do
    context 'with no safe_ids passed into opts' do
      before do
        expect(pg_mock).to receive(:exec).with(/SELECT id FROM users/).and_yield(double(:result, values: [['1'], ['2']]))
      end

      it 'returns a hash of tables and ids to mask' do
        expect(subject.ids_to_mask).to eq({ 'users' => ['1', '2'] })
      end
    end

    context 'with safe_ids passed into opts' do
      let(:opts) do
        {
          safe_ids: {
            users: [1]
          }
        }
      end
      let(:subject) { described_class.new(pg_mock, config_path, logger, opts) }

      before do
        expect(pg_mock).to receive(:exec).with(/SELECT id FROM users/).and_yield(double(:result, values: [['1'], ['2']]))
      end

      it 'returns a hash of tables and ids without the safe_ids' do
        expect(subject.ids_to_mask).to eq({ 'users' => ['2'] })
      end
    end
  end

  describe '#remove_missing_tables' do
    before do
      allow_any_instance_of(described_class).to receive(:missing_tables).and_return(['users'])
    end

    it 'removes the missing table from the configuration' do
      expect(subject.tables.keys).to match_array(['users'])
      subject.remove_missing_tables
      expect(subject.tables.keys).to match_array([])
    end
  end

  describe '#remove_missing_columns' do
    before do
      allow_any_instance_of(described_class).to receive(:missing_columns).and_return({ 'users' => ['ssn'] })
    end

    it 'removes the missing column from the configuration' do
      expect(subject.tables['users'].keys).to include('ssn')
      subject.remove_missing_columns
      expect(subject.tables['users'].keys).to_not include('ssn')
    end
  end

  describe '#tables_to_truncate' do
    it 'returns tables to truncate' do
      expect(subject.tables_to_truncate).to eq(['sensitive_table'])
    end
  end
end
