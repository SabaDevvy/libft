/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   bubble_sort.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <gsabatin@student.42roma.it>      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/04/07 02:52:15 by gsabatin          #+#    #+#             */
/*   Updated: 2025/04/07 15:48:52 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void	bubble_sort(int *array, size_t size)
{
	int	i;
	int	j;
	int	swapped;

	if (!array || size < 2)
		return ;
	i = 0;
	while (i < size - 1)
	{
		swapped = 0;
		j = 0;
		while (j < size - i - 1)
		{
			if (array[j] > array[j + 1])
			{
				ft_swap_ints(&array[j], &array[j + 1]);
				swapped = 1;
			}
			j++;
		}
		if (!swapped)
			break ;
		i++;
	}
}
