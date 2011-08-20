require File.join(File.dirname(__FILE__), '..', 'lib', 'osx', 'say')

describe 'say' do
  describe 'sanitize' do
    it 'should remove double quotes' do
      OSX::Say.sanitize('""').should eql('')
    end

    it 'should remove backticks' do
      OSX::Say.sanitize('`').should eql('')
    end
    
    it 'should allow letters' do
      OSX::Say.sanitize('abcdefghijklmnopqrstuvwxy').should eql('abcdefghijklmnopqrstuvwxy')
      OSX::Say.sanitize('ABCDEFGHIJKLMNOPQRSTUVWXY').should eql('ABCDEFGHIJKLMNOPQRSTUVWXY')
    end

    it 'should allow numbers' do
      OSX::Say.sanitize('012345678').should eql('012345678')
    end

    it 'should allow spaces' do
      OSX::Say.sanitize(' ').should eql(' ')
    end
    
    it 'should allow periods' do
      OSX::Say.sanitize('...').should eql('...')
    end
    
    it 'should allow exclamation points' do
      OSX::Say.sanitize('!!!').should eql('!!!')
    end
    
    it 'should allow commas' do
      OSX::Say.sanitize(',').should eql(',')
    end
    
    it 'should allow hyphens' do
      OSX::Say.sanitize('-').should eql('-')
    end
    
    it 'should allow apostrophes' do
      OSX::Say.sanitize("'").should eql("'")
    end
  end
end