/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   quick_sort.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/27 16:05:52 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/20 02:05:50 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

static void	swap(int *x, int *y)
{
	int	temp;

	temp = *x;
	*x = *y;
	*y = temp;
}

static int	partition(int *arr, int low, int high)
{
	int	pivot_value;
	int	i;
	int	j;

	pivot_value = arr[high];
	i = low;
	j = low;
	while (j < high)
	{
		if (arr[j] <= pivot_value)
		{
			swap(&arr[i], &arr[j]);
			i++;
		}
		j++;
	}
	swap(&arr[i], &arr[high]);
	return (i);
}

static void	quick_sort_recursion(int *arr, int low, int high)
{
	int	pivot_index;

	if (low < high)
	{
		pivot_index = partition(arr, low, high);
		quick_sort_recursion(arr, low, pivot_index - 1);
		quick_sort_recursion(arr, pivot_index + 1, high);
	}
}

void	quick_sort(int *arr, size_t len)
{
	quick_sort_recursion(arr, 0, len - 1);
}
