/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strarrclear.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/06 16:16:59 by gsabatin          #+#    #+#             */
/*   Updated: 2025/04/19 19:39:28 by gsabatin         ###   ########.fr       */
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
void	ft_strarrclear(char ***str_arr_ref)
{
	size_t	i;

	if (!str_arr_ref || !*str_arr_ref)
		return ;
	i = (size_t)-1;
	while ((*str_arr_ref)[++i])
	{
		free((*str_arr_ref)[i]);
		(*str_arr_ref)[i] = NULL;
	}
	free(*str_arr_ref);
	*str_arr_ref = NULL;
}
