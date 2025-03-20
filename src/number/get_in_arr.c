/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_in_arr.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/27 18:54:38 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/20 02:04:22 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../includes/libft.h"
#include <stdlib.h>

int	median_number(int *arr, size_t len)
{
	int	*sorted;
	int	result;

	if (!arr || len < 1)
		return (INT_MIN);
	sorted = ft_arrdup(arr, len);
	if (!sorted)
		return (INT_MIN);
	quick_sort(sorted, len);
	if (len % 2 == 0)
		result = (sorted[len / 2 - 1] + sorted[len / 2]) / 2;
	else
		result = sorted[len / 2];
	free(sorted);
	return (result);
}

int	lowest_number(int *arr, size_t len)
{
	int		min;
	size_t	i;

	if (!arr || len < 1)
		return (INT_MIN);
	min = arr[0];
	i = 1;
	while (++i <= len)
	{
		if (arr[i] < min)
			min = arr[i];
	}
	return (min);
}

int	highest_number(int *arr, size_t len)
{
	int		max;
	size_t	i;

	if (!arr || len < 1)
		return (INT_MIN);
	max = arr[0];
	i = 1;
	while (++i <= len)
	{
		if (arr[i] > max)
			max = arr[i];
	}
	return (max);
}
