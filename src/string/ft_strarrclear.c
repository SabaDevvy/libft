/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strarrclear.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/06 16:16:59 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/13 15:38:21 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdlib.h>

/*
 * @brief Frees a NULL-terminated array of strings and its contents.
 *        Sets the pointer to NULL after freeing to prevent use-after-free errors
 *
 * @param str_arr address of the char pointer pointer
*/
void	ft_strarrclear(char ***str_arr)
{
	size_t	i;

	if (!str_arr || !*str_arr)
		return ;
	i = 0;
	while ((*str_arr)[i])
	{
		free((*str_arr)[i]);
		(*str_arr)[i] = NULL;
		i++;
	}
	free(*str_arr);
	*str_arr = NULL;
}
