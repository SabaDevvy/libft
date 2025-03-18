/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   arithmetic_check.h                                 :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <gsabatin@student.42roma.it>      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/18 18:28:53 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/18 18:28:56 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef ARITHMETIC_CHECK_H
# define ARITHMETIC_CHECK_H

/*
 * @param x input value
 * @return -1 if negative, 0 if zero, 1 if positive
 */
static inline int	ft_sign(int x)
{
	return ((x > 0) - (x < 0));
}

/*
 * @brief Checks if an integer is within a range (inclusive).
 * @param value int to check
 * @param min minimum bound
 * @param max maximum bound
 * @return 1 if within range, 0 otherwise
 */
static inline int	ft_is_in_range(int value, int min, int max)
{
	return ((value >= min) && (value <= max));
}

/*
 * @brief Checks if an unsigned integer is a power of two.
 * @param x value to check
 * @return 1 if x is a power of two, 0 otherwise
 */
static inline int	ft_is_power_of_two(unsigned int x)
{
	return (x && !(x & (x - 1)));
}

#endif /* ARITHMETIC_CHECK_H */
