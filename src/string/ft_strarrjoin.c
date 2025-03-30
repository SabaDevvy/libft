/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strarrjoin.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/10 02:50:48 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/14 10:17:19 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdlib.h>

/**
 * @brief Joins a string to a string array without modifying the originals
 * @details Creates a new array containing copies of str_arr strings plus str
 *          NULL pointers may be included in the middle of the str_arr
 *          Unlike ft_strarrappend, this function does not free the originals
 *
 * @param str_arr Original array (can be NULL)
 * @param str String to append (can be NULL) -> if it's NULL it will terminate
 *                                              the new strarr
 *
 * @return New array with string appended, or NULL on failure
 */
char	**ft_strarrjoin(char **str_arr, const char *str)
{
	char	**new_arr;
	size_t	len;
	size_t	i;

	if (!str_arr)
		return (ft_strarrinit(str));
	len = ft_strarrlen_safe(str_arr);
	new_arr = (char **)malloc(sizeof(char *) * (len + 2));
	if (!new_arr)
		return (NULL);
	i = -1;
	while (++i < len)
	{
		new_arr[i] = ft_strdup_safe(str_arr[i]);
		if (!new_arr[i] && str_arr[i])
		{
			ft_strarrclear(&new_arr);
			return (NULL);
		}
	}
	new_arr[len] = ft_strdup_safe(str);
	new_arr[len + 1] = NULL;
	return (new_arr);
}
