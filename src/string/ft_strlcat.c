/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strlcat.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/12/09 18:36:08 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/07 00:49:26 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../includes/libft.h"

/*
 * @brief Concatenates the string src to the end of dst, but at most size-1
 *        characters and ensures null-termination if there is room in dst.
 *
 * @param dst  Destination string pointer where src will be appended
 * @param src  Source string pointer containing characters to be appended
 * @param size Size of the destination buffer or till when in dest you
 *             you want to cat. Include \0 is size count.
 *
 * @return The combined length of both src and dst strings if concatenation
 *         was successful, or (size + src_len) if dst was too small
 *
 * @details
 * - If size == 0 and dst is NULL, returns length of src
 * - If size <= dst_len, returns size + src_len (truncation occurred)
 * - Safe from buffer overflows as it will not write beyond size bytes
 * - Always ensures null-termination of the result if size > 0
 */
size_t	ft_strlcat(char *dst, const char *src, size_t size)
{
	size_t	dst_len;
	size_t	src_len;
	size_t	i;

	if (!size && !dst)
		return (ft_strlen(src));
	dst_len = 0;
	src_len = 0;
	while (dst[dst_len] && dst_len < size)
		dst_len++;
	while (src[src_len])
		src_len++;
	if (size <= dst_len)
		return (size + src_len);
	i = 0;
	while (src[i] && (dst_len + i) < size - 1)
	{
		dst[dst_len + i] = src[i];
		i++;
	}
	dst[dst_len + i] = '\0';
	return (dst_len + src_len);
}

/*
#include <stdio.h>
#include <string.h>
int main()
{
        char msg[] = "prova";
        char msg2[] = "gatto";
        printf("%zu\n", ft_strlcat(msg, msg2, 13));
//	printf("%d\n", strlcat(msg, msg2, 4));
}*/
