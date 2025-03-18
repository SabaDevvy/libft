/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   arithmetic_transform.h                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <gsabatin@student.42roma.it>      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/18 18:28:27 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/18 18:49:47 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef ARITHMETIC_TRANSFORM_H
# define ARITHMETIC_TRANSFORM_H

# include "arithmetic_basic.h"

/*
 * @brief Constrains a value between a minimum and maximum.
 * @param value int to constrain
 * @param min lower bound
 * @param max upper bound
 * @return clamped value
 */
static inline int	ft_clamp(int value, int min, int max)
{
	return (ft_min(ft_max(value, min), max));
}

/*
 * @brief Swaps two integers using XOR operations.
 * @param a ptr to first integer
 * @param b ptr to second integer
 */
static inline void	ft_swap_ints(int *a, int *b)
{
	*a = *a ^ *b;
	*b = *a ^ *b;
	*a = *a ^ *b;
}

#endif /* ARITHMETIC_TRANSFORM_H */
