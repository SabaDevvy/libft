/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strlcpy.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/12/10 12:05:44 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/14 10:09:03 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdbool.h>

/*
 * @brief Copies size src bytes into dst null-terminating dst
 *
 * @param dst destination pointer
 * @param src source pointer
 * @param size number of bytes copied from src to dest, including NULL-term
 * @return len of src string
*/
size_t	ft_strlcpy(char *dst, const char *src, size_t size)
{
	size_t	src_len;
	size_t	i;

	i = -1;
	src_len = 0;
	while (src[src_len])
		src_len++;
	if (size > 0)
	{
		while (src[++i] && i < size - 1)
			dst[i] = src[i];
		dst[i] = '\0';
	}
	return (src_len);
}

/*
 * @brief Copies to dst starting from dst index dst_index all src and adds term
 *        if
 *
 * @param dst destination string pointer
 * @param src source string pointer
 * @param i dst index pointer
 * @param null_term 1 if null-termination needed
 * @return number of bytes copied
*/
size_t	ft_strcpy_at(char *dst, size_t *dst_index, const char *src)
{
	size_t	len;

	if (!dst || !src)
		return (0);
	len = ft_strlen(src);
	while (*src)
		dst[(*dst_index)++] = *src++;
	dst[*dst_index] = '\0';
	return (len);
}
