/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_calloc.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/12/10 17:40:22 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/14 10:23:54 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdlib.h>
#include <stdint.h>

/*
 * @brief Allocates memory for an array and initializes it to zero
 * @details Allocates memory for 'nmemb' elements of 'size' bytes each
 *          and initializes all bytes to zero. Checks for integer overflow
 *          before performing allocation.
 *
 * @param nmemb Number of elements to allocate
 * @param size Size of each element in bytes
 *
 * @return Pointer to allocated and zeroed memory, or NULL if allocation fails
*/
void	*ft_calloc(size_t nmemb, size_t size)
{
	void	*ptr;

	if (nmemb != 0 && size > SIZE_MAX / nmemb)
		return (NULL);
	ptr = malloc(nmemb * size);
	if (!ptr)
		return (NULL);
	ft_bzero(ptr, nmemb * size);
	return (ptr);
}
