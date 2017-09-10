
use super::racp_lexer::RacpLexer;
use std::io::Read;
use std::iter::Enumerate;
use std::io::Bytes;
use std::collections::HashMap;
use racp::Racp::*;
use racp::Racp;

pub type Spanned<Tok, Loc, Error> = Result<(Loc, Tok, Loc), Error>;

#[derive(Debug)]
pub enum TokenLexerError {
	InvalidCharError(u8),
}

pub struct TokenLexer<T:Iterator<Item=(usize, Token, usize)>> {
	input: T,
}

impl<T:Iterator<Item=(usize, Token, usize)>> TokenLexer<T>{
	pub fn new(input: T) -> Self {
		TokenLexer {input}
	}
}

#[derive(Debug)]
pub enum Token {
	If,
	Else,
}

impl<T:Iterator<Item=(usize, Token, usize)>> Iterator for TokenLexer<T> {
	type Item = Spanned<Token, usize, TokenLexerError>;
	
	fn next(&mut self) -> Option<Self::Item> {
		match self.input.next() {
			Some(x) => Some(Ok(x)),
			None => None,
		}
	}
}



