/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strclear.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/06 19:10:53 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/13 15:49:18 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../includes/libft.h"
#include <stdlib.h>

/*
** @brief Frees a string and sets the pointer to NULL

** @param str Pointer to the string to be freed
*/
void	ft_strclear(char **str)
{
	if (!str || !*str)
		return ;
	free(*str);
	*str = NULL;
}
