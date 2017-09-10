extern crate lalrpop_util;

pub mod grammar;
pub mod racp;

use grammar::lalrpop::parse_Program;
use grammar::lalrpop::parse_Tokens;
use grammar::lalrpop::racp_lexer::RacpLexer;
use grammar::lalrpop::token_lexer::TokenLexer;
use std::fs::File;
use std::io::Read;
use std::iter::Iterator;

fn main() {
    println!("Hello, world!");
	let mut f1 = File::open("res/true-char.racp").unwrap();
	let racp_lexer = RacpLexer::new(f1.bytes().enumerate());
	let tokens = parse_Tokens(racp_lexer);
	match tokens {
		Ok(x) => {
			println!("Tokens: {:?}", x);
			let token_lexer = TokenLexer::new(x.into_iter());
			let r = parse_Program(token_lexer);
			
			match r {
				Ok(x) => println!("{:?}", x),
				Err(x) => println!("Parsing error: {:?}", x),
			}
		},
		Err(x) => println!("Lexing error: {:?}", x),
	}
	
	
	
	
}
