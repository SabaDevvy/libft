/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_stroccurences.c                                 :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/10 00:44:10 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/14 10:10:27 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

/*
 * @brief Counts the number of occurrences of a substring in a string
 * @details Searches for all non-overlapping occurrences of the
 * substring 'little' within the string 'str'.
 *
 * @param str The string to search in
 * @param little The substring to search for
 *
 * @return int The number of occurrences, 0 if none found or invalid input
*/
int	ft_stroccurences(const char *str, const char *little)
{
	int	count;
	int	little_len;

	if (!str || !little || !little[0])
		return (0);
	little_len = 0;
	while (little[little_len])
		little_len++;
	count = 0;
	while (*str)
	{
		if (ft_strncmp(str, little, little_len) == 0)
		{
			count++;
			str += little_len;
		}
		else
			str++;
	}
	return (count);
}
