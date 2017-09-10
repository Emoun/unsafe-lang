use std::str::CharIndices;
use racp;

use std::io::Read;
use std::iter::Enumerate;
use std::io::Bytes;
use racp::Racp;

pub type Spanned<Tok, Loc, Error> = Result<(Loc, Tok, Loc), Error>;

#[derive(Debug)]
pub enum RacpLexerError {
	InvalidCharError(u8),
}

pub struct RacpLexer<T:Read> {
	input: Enumerate<Bytes<T>>,
}

impl<T:Read> RacpLexer<T>{
	pub fn new(input: Enumerate<Bytes<T>>) -> Self {
		RacpLexer {input}
	}
}



macro_rules! racp_to_token {
	{
		$id0:ident :
		$($id1:ident),*
	} => {
		match $id0 {
			$(
				Some((i, Ok(x)))
					if x == (Racp::$id1 as u8)
				=>
					return
						Some(
							Ok(
								(	i,
									Racp::$id1,
									i+1,
								)
							)
						),
			)*
			_ => (),
		}
	};

}

impl<T:Read> Iterator for RacpLexer<T> {
	type Item = Spanned<Racp, usize, RacpLexerError>;
	
	fn next(&mut self) -> Option<Self::Item> {
		let next = self.input.next();
		racp_to_token!(
			next:
			False,
			True,
			Space,
			Tab,
			NewLine,
			Slash,
			Backslash,
			RPilcrow,
			Pilcrow,
			LDQuote,
			RDQuote,
			LLath,
			RLath,
			LJamb,
			RJamb,
			LParen,
			RParen,
			LBracket,
			RBracket,
			LBrace,
			RBrace,
			LABracket,
			RABracket,
			Lt,
			Gt,
			Equal,
			Not,
			Aampersand,
			VBar,
			Caret,
			Dollar,
			Hex0,
			Hex1,
			Hex2,
			Hex3,
			Hex4,
			Hex5,
			Hex6,
			Hex7,
			Hex8,
			Hex9,
			Hex10,
			Hex11,
			Hex12,
			Hex13,
			Hex14,
			Hex15,
			Dec0,
			Dec1,
			Dec2,
			Dec3,
			Dec4,
			Dec5,
			Dec6,
			Dec7,
			Dec8,
			Dec9,
			Colon,
			Semicolon,
			Period,
			Comma,
			Exclamation,
			Question,
			At,
			CapA,
			CapB,
			CapC,
			CapD,
			CapE,
			CapF,
			CapG,
			CapH,
			CapI,
			CapJ,
			CapK,
			CapL,
			CapM,
			CapN,
			CapO,
			CapP,
			CapQ,
			CapR,
			CapS,
			CapT,
			CapU,
			CapV,
			CapW,
			CapX,
			CapY,
			CapZ,
			Plus,
			Dash,
			Asterisk,
			Division,
			Percent,
			Section,
			LowA,
			LowB,
			LowC,
			LowD,
			LowE,
			LowF,
			LowG,
			LowH,
			LowI,
			LowJ,
			LowK,
			LowL,
			LowM,
			LowN,
			LowO,
			LowP,
			LowQ,
			LowR,
			LowS,
			LowT,
			LowU,
			LowV,
			LowW,
			LowX,
			LowY,
			LowZ,
			Quote,
			Apostrophe,
			Underscore,
			Tilde,
			Hash
		);
		
		match next {
			Some((i, Ok(x))) => return Some(Err(RacpLexerError::InvalidCharError(x as u8))),
			None => return None, // End of file
			_ => unimplemented!("Dono what to do"),
		}
		None
	}
}





