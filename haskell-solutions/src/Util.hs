{-# OPTIONS_GHC -Wno-orphans #-}
module Util
    ( module BasePrelude
    , Type
    , both
    , word1
    , fromBase2
    , chunksOf
    , dropEnd
    , breakOn
    , rightToMaybe
    , pNum
    , pInput
    ) where

import BasePrelude
import Data.Kind (Type)
import Text.ParserCombinators.ReadP

both :: Bifunctor p => (c -> d) -> p c c -> p d d
both f = bimap f f

word1 :: String -> (String, String)
word1 = second (drop 1) . break isSpace

fromBase2 :: String -> Int
fromBase2 = foldl' (\acc x -> 2 * acc + x) 0 . map digitToInt

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = as : chunksOf n bs
 where (as, bs) = splitAt n xs

dropEnd :: Int -> [a] -> [a]
dropEnd n = reverse . drop n . reverse

breakOn :: Eq a => [a] -> [a] -> ([a], [a])
breakOn needle haystack | needle `isPrefixOf` haystack = ([], haystack)
breakOn _      []       = ([], [])
breakOn needle (x:xs)   = first (x:) $ breakOn needle xs

rightToMaybe :: Either a b -> Maybe b
rightToMaybe = either (const Nothing) Just

pInput :: ReadP p -> String -> p
pInput p = fst . head . readP_to_S p

pNum :: Read a => ReadP a
pNum = read <$> munch1 isDigit

-- | We want to use @"string"@ as a parser with @OverloadedStrings@
-- instead of having to write @string "string"@—make it so.
instance a ~ String => IsString (ReadP a) where
  fromString :: String -> ReadP a
  fromString = string
