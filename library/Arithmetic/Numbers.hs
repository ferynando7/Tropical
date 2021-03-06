{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}
{-# LANGUAGE UndecidableInstances #-}

module Arithmetic.Numbers 
(
  -- * Types
  Tropical(..)
) where

import Data.Function
import Numeric.Algebra hiding (negate, fromInteger)
import Numeric.Algebra.Class as AC




--The set includes all the real numbers and the infinity
data Tropical a = Tropical {value :: a} | Inf 
  deriving (Eq)


instance (Show a) => Show (Tropical a) where
  show Inf = "Inf"
  show (Tropical a) = show a



(.+.) :: (Ord a) => Tropical a -> Tropical a -> Tropical a
Inf .+. t = t
t .+. Inf = t
t1 .+. t2 = Tropical $ (min `on` value) t1 t2 

(.*.) :: (Num a) => Tropical a -> Tropical a -> Tropical a
t .*. Inf = Inf
Inf .*. t = Inf
t1 .*. t2 = Tropical $ ((Prelude.+) `on` value) t1 t2 


instance (Num a) => Unital (Tropical a) where
  one = Tropical 0


instance (Num a, Ord a, Rig a) => LeftModule Natural (Tropical a) where
  a .* t1 = Tropical (fromNatural a) AC.* t1

instance (Num a, Ord a, Rig a) => RightModule Natural (Tropical a) where
  (*.) = flip (.*)
  

instance (Num a, Ord a, Rig a) => Monoidal (Tropical a) where
  zero = Inf

instance (Num a) => Multiplicative (Tropical a) where 
  (*) = (.*.)

instance (Num a) => Commutative (Tropical a)

instance (Rig a, Num a, Ord a) => Rig (Tropical a) where
  fromNatural a = Tropical $ fromNatural a

instance (Ord a) => Additive (Tropical a) where
  (+) = (.+.)
instance (Ord a) => Abelian (Tropical a)
instance (Ord a, Num a) => Semiring (Tropical a) 

instance (Ord a, Num a) => Num (Tropical a) where
  (+) = (.+.)
  (*) = (.*.)
  fromInteger a = Tropical $ Prelude.fromInteger a
  negate = fmap negate

-- | Not neccesary to implement since it is already defined  
instance (Num a, Ord a, Rig a) => DecidableZero (Tropical a) 
instance Functor Tropical where
  fmap f (Tropical a) = Tropical (f a)


instance Integral (Tropical Integer) where
  toInteger (Tropical a) = a
  toInteger Inf = 0

instance Enum (Tropical Integer) where
  toEnum a = Tropical (toInteger a)
  fromEnum (Tropical a) = fromInteger a
  fromEnum Inf = 0

instance Real (Tropical Integer) where
  toRational (Tropical a) = toRational a
  toRational Inf = 0

instance Ord (Tropical Integer) where
  compare Inf a = LT
  compare a Inf = GT
  compare (Tropical a) (Tropical b) = compare a b