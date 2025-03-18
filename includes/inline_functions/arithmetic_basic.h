/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   arithmetic_basic.h                                 :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <gsabatin@student.42roma.it>      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/18 18:20:57 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/18 18:48:51 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef ARITHMETIC_BASIC_H
# define ARITHMETIC_BASIC_H

/*
 * @param x input value
 * @return absolute value of x
 */
static inline int	ft_abs(int x)
{
	return ((x * (x >= 0)) + (-(x) * (x < 0)));
}

/*
 * @param a first integer
 * @param b second integer
 * @return maximum value between a and b
 */
static inline int	ft_max(int a, int b)
{
	return ((a * (a >= b)) + (b * (b > a)));
}

/*
 * @param a first integer
 * @param b second integer
 * @return minimum value between a and b
 */
static inline int	ft_min(int a, int b)
{
	return ((a * (a <= b)) + (b * (b < a)));
}

#endif /* ARITHMETIC_BASIC_H */
