function translate(string) {
	let	firstVowel
	,	firstVowelIndex
	,	regexp1 = /[q](?=[u])/
	,	chunkBeforeVowel //The chunk of the word before the first vowel (exclusive)
	,	chunkAfterVowel //The chunk of the word after the first vowerl (inclusive)
	,	translated = [];

	words = string.split(' ');
	words.forEach(word => {
		let newWord = '',
		endOfWordIndex = word.length;
		
		word = word.toLowerCase();
		firstVowel = word.match(/[aeiou]/);
		firstVowelIndex = word.indexOf(firstVowel);

		if (firstVowelIndex == 0){
			newWord = word + 'ay';
		}
		else {
			if (firstVowel == 'u' && regexp1.test(word)){
				chunkBeforeVowel = word.slice(0, firstVowelIndex + 1);
				chunkAfterVowel = word.slice(firstVowelIndex +1, endOfWordIndex);
			}
			else {
				chunkBeforeVowel = word.slice(0, firstVowelIndex);
				chunkAfterVowel = word.slice(firstVowelIndex, endOfWordIndex);
			}
				newWord = chunkAfterVowel + chunkBeforeVowel + 'ay';
		}
		
		translated.push(newWord);
	});
	return translated.join(' ');	
}

module.exports = {
	translate
}