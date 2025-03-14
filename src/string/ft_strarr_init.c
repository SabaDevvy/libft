/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strarr_init.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/13 15:36:23 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/14 10:09:45 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../includes/libft.h"
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

	new_arr = (char **)malloc(sizeof(char *) * 2);
	if (!new_arr)
		return (NULL);
	new_arr[0] = ft_strdup_safe(str);
	if (str && !new_arr[0])
	{
		free(new_arr);
		return (NULL);
	}
	new_arr[1] = NULL;
	return (new_arr);
}
