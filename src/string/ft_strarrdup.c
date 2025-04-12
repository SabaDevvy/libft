/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strarrdup.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <gsabatin@student.42roma.it>      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/04/11 15:31:16 by gsabatin          #+#    #+#             */
/*   Updated: 2025/04/12 04:23:22 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdlib.h>

/**
* @brief Duplicates an array of strings
*
* @param strarr Array of strings
* @return Ptr to the copied char **, NULL if error
*/
char	**ft_strarrdup(const char **strarr)
{
	size_t	strarr_len;
	char	**result;
	char	**dup;

	strarr_len = ft_strarrlen(strarr) + 1;
	dup = (char **)ft_calloc(sizeof(char *), strarr_len);
	if (!dup)
		return (NULL);
	result = dup;
	while (*strarr)
	{
		*dup = ft_strdup(*strarr);
		if (!*dup)
		{
			ft_strarrclear(&result);
			return (NULL);
		}
		dup++;
		strarr++;
	}
	return (result);
}
