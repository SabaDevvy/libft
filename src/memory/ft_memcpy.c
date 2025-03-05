/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_memcpy.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/12/09 17:59:06 by gsabatin          #+#    #+#             */
/*   Updated: 2024/12/19 19:40:51 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void	*ft_memcpy(void *dest, const void *src, size_t n)
{
	void	*original;

	if (!dest && !src)
		return (NULL);
	original = dest;
	while (n--)
		*((unsigned char *)dest++) = *((unsigned char *)src++);
	return (original);
}
