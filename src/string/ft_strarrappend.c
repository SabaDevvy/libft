/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strarrappend.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/06 16:08:08 by gsabatin          #+#    #+#             */
/*   Updated: 2025/04/12 02:32:59 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdlib.h>

/*
 * @brief Appends a string to a string array
 * @details Appends a string to a string array and frees original.
 *          Creates a new array, copies the strings, adds the new one,
 *          and frees original. All the strings in the new_arr are
 *          ft_strduplicated
 *
 * @param str_arr Original array (can be NULL) (will be FREED)
 * @param str String to append (can be NULL) -> if it's NULL it will terminate
 *                                              the new strarr
 *
 * @attention original str_arr is always freed
 *
 * @return New array with string appended, or NULL on failure
*/
char	**ft_strarrappend(char **str_arr, const char *str)
{
	char	**new_arr;
	size_t	len;
	size_t	i;

	if (!str_arr)
		return (ft_strarrinit(str));
	len = ft_strarrlen_safe((const char **)str_arr);
	new_arr = (char **)ft_calloc(sizeof(char *), (len + 2));
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
	ft_strarrclear(&str_arr);
	return (new_arr);
}

/*
 * @brief ft_strarr_append shallow copy version;
 *        instead of ft_dup every string it attaches all the str_arr char *
 *        and the str char * to the new_strarr
 *
 * @param str_arr Original array (can be NULL) (will be FREED)
 * @param str String to append (can be NULL) -> if it's NULL it will terminate
 *                                              the new strarr
 *
 * @attention original str_arr is always freed
 *
 * @return New array with string appended, or NULL on failure
*/
char	**ft_strarrappend_shallow(char **str_arr, char *str)
{
	char	**new_arr;
	size_t	len;
	size_t	i;

	if (!str_arr)
		return (ft_strarrinit(str));
	len = ft_strarrlen_safe((const char **)str_arr);
	new_arr = (char **)ft_calloc(sizeof(char *), (len + 2));
	if (!new_arr)
		return (NULL);
	i = -1;
	while (++i < len)
		new_arr[i] = str_arr[i];
	new_arr[len] = str;
	new_arr[len + 1] = NULL;
	free(str_arr);
	return (new_arr);
}

/*
 * @brief ft_strarr_append clear_s2 version:
 * @details does ft_strarr_append_free stuff and clears s2.
*/
char	**ft_strarrappend_clear_s2(char **str_arr, char **str_ptr)
{
	char	**new_strarr;
	char	*str;

	if (str_ptr)
		str = *str_ptr;
	else
		str = NULL;
	new_strarr = ft_strarrappend(str_arr, str);
	if (str_ptr && *str_ptr)
	{
		free(*str_ptr);
		*str_ptr = NULL;
	}
	return (new_strarr);
}

/*
 * @brief Decide between normal or clear_s2 ft_strappend version and
 *        both pointers get automatically updated
 *
 * @attention Pass the address of both str_arr and str
 * @example ft_strarr_append_replace(&matrix, &str_to_add, 0 or 1)
 *
 * @return 1 if successful, 0 if errors
*/
int	ft_strarrappend_replace(char ***str_arr_ptr, char **str_ptr, int clear_s2)
{
	char	**new_arr;
	char	*str;

	if (!str_arr_ptr)
		return (0);
	if (!str_ptr)
		str = NULL;
	else
		str = *str_ptr;
	if (clear_s2)
		new_arr = ft_strarrappend_clear_s2(*str_arr_ptr, str_ptr);
	else
		new_arr = ft_strarrappend(*str_arr_ptr, str);
	if (!new_arr)
		return (0);
	*str_arr_ptr = new_arr;
	return (1);
}
