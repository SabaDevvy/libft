/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strarrlen.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/06 16:10:40 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/10 01:02:38 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../includes/libft.h"

/*
* @brief Counts the number of elements in a NULL-terminated string array
* @attention Don't pass str_arr = NULL
* @param [str_arr] array of char pointers
*
* @return number of elements in strarr
*/
size_t	ft_strarrlen(char **str_arr)
{
	size_t	len;

	len = 0;
	while (str_arr[len])
		len++;
	return (len);
}

/*
 * @brief Counts the number of elements in a NULL-terminated string array
 * @param [str_arr] array of char pointers
 *
 * @return number of elements in strarr. 0 if 0 elements of str_arr = NULL
*/
size_t	ft_strarrlen_safe(char **str_arr)
{
	size_t	len;

	len = 0;
	if (!str_arr)
		return (0);
	while (str_arr[len])
		len++;
	return (len);
}
