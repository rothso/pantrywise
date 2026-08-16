package pantry

import "fmt"

type Money int64

func NewMoney(dollars int, cents int) Money {
	return Money(dollars*100 + cents)
}

func (m Money) Add(other Money) Money { return m + other }
func (m Money) Sub(other Money) Money { return m - other }
func (m Money) IsZero() bool          { return m == 0 }
func (m Money) String() string {
	return fmt.Sprintf("$%d.%02d", m/100, max(int(m%100), -int(m%100)))
}
