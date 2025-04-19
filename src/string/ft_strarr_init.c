/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strarr_init.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/13 15:36:23 by gsabatin          #+#    #+#             */
/*   Updated: 2025/04/19 19:40:43 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdlib.h>

/**
 * @brief Creates a new array with just one string
 *
 * @param str The string to add (can be NULL)
 *
 * @return New array or NULL on allocation failure
 */
char	**ft_strarrinit(const char *str)
{
	char	**new_arr;
	size_t	nmemb;

	if (str)
		nmemb = 2;
	else
		nmemb = 1;
	new_arr = (char **)ft_calloc(sizeof(char *), nmemb);
	if (!new_arr)
		return (NULL);
	new_arr[0] = ft_strdup_safe(str);
	if (str && !new_arr[0])
	{
		free(new_arr);
		return (NULL);
	}
	return (new_arr);
}
