/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strrchr.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/12/10 13:01:48 by gsabatin          #+#    #+#             */
/*   Updated: 2024/12/10 13:09:33 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

char	*ft_strrchr(const char *s, int c)
{
	unsigned char	uc;
	char			*temp;

	uc = (unsigned char)c;
	temp = NULL;
	while (*s)
	{
		if ((unsigned char)*s == uc)
			temp = (char *)s;
		s++;
	}
	if (c == '\0')
		return ((char *)s);
	else
		return (temp);
}
