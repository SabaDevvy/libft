/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strarrmerge.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <gsabatin@student.42roma.it>      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/04/11 15:04:10 by gsabatin          #+#    #+#             */
/*   Updated: 2025/04/12 04:24:02 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdlib.h>

/**
* @brief Creates a new string array that merges 2 arrays
*
* @param strarr1, strarr2 String arrays
* @return Malloc'd merged string array, or NULL if both NULL/error
*/
char	**strarrmerge(const char **strarr1, const char **strarr2)
{
	size_t	strarr_len;
	char	**result;
	char	**strarr;

	if ((!strarr1 || !strarr1[0]) && (!strarr2 || !strarr2[0]))
		return (NULL);
	if (!strarr1 || !strarr1[0])
		return (ft_strarrdup(strarr2));
	if (!strarr2 || !strarr2[0])
		return (ft_strarrdup(strarr1));
	strarr_len = ft_strarrlen(strarr1) + ft_strarrlen(strarr2) + 1;
	strarr = (char **)ft_calloc(strarr_len, sizeof(char *));
	if (!strarr)
		return (NULL);
	result = strarr;
	while (*strarr1)
		*strarr++ = ft_strdup(*strarr1++);
	while (*strarr2)
		*strarr++ = ft_strdup(*strarr2++);
	return (result);
}

/**
 * @brief Copies strings from source arrays to destination array
 * @param dest Destination array
 * @param strarr1 First source array
 * @param strarr2 Second source array
 * @return Pointer to the end of the filled destination array
 */
static void	fill_merged_array(char **dest, char **strarr1, char **strarr2)
{
	char	**write_ptr;

	write_ptr = dest;
	if (strarr1)
	{
		while (*strarr1)
			*write_ptr++ = *strarr1++;
	}
	if (strarr2)
	{
		while (*strarr2)
			*write_ptr++ = *strarr2++;
	}
	return ;
}

/**
 * @brief Creates a new string array that merges 2 arrays,
 *        clearing the 2 string arrays, moving char *'s to the new one
 * @param strarr1_ptr, strarr2_ptr Pointers to string arrays
 * @return Malloc'd merged string array, NULL if both empty/errors
 */
char	**ft_strarrmerge_clear(char ***strarr1_ptr, char ***strarr2_ptr)
{
	size_t	len;
	char	**result;
	char	**strarr1;
	char	**strarr2;

	if (!strarr1_ptr || !strarr2_ptr)
		return (NULL);
	strarr1 = *strarr1_ptr;
	strarr2 = *strarr2_ptr;
	if ((!strarr1 || !strarr1[0]) && (!strarr2 || !strarr2[0]))
		return (NULL);
	len = ft_strarrlen((const char **)strarr1)
		+ ft_strarrlen((const char **)strarr2) + 1;
	result = (char **)ft_calloc(len, sizeof(char *));
	if (!result)
		return (NULL);
	fill_merged_array(result, strarr1, strarr2);
	free(*strarr1_ptr);
	free(*strarr2_ptr);
	*strarr1_ptr = NULL;
	*strarr2_ptr = NULL;
	return (result);
}
