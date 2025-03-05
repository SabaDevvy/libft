/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_arrdup.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/27 13:58:43 by gsabatin          #+#    #+#             */
/*   Updated: 2025/02/27 20:05:47 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdlib.h>

int	*ft_arrdup(const int *src, size_t size)
{
	int		*arr;
	size_t	i;

	if (!src || size < 1)
		return (NULL);
	arr = malloc(sizeof(int) * size);
	if (!arr)
		return (NULL);
	i = -1;
	while (++i < size)
		arr[i] = src[i];
	return (arr);
}
