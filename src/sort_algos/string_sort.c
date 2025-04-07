/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   string_sort.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <gsabatin@student.42roma.it>      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/04/07 02:55:01 by gsabatin          #+#    #+#             */
/*   Updated: 2025/04/07 15:49:22 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

static void	ft_swap_strings(char **a, char **b)
{
	char	*temp;

	temp = *a;
	*a = *b;
	*b = temp;
}

void	sort_str(char **array, size_t size)
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
			if (ft_strcmp(array[j], array[j + 1]) > 0)
			{
				ft_swap_strings(&array[j], &array[j + 1]);
				swapped = 1;
			}
			j++;
		}
		if (!swapped)
			break ;
		i++;
	}
}
