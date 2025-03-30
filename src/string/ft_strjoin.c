/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strjoin.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <gsabatin@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/12/14 20:23:00 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/14 12:23:53 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdlib.h>
#include <stdbool.h>

/*
** @brief Joins two strings without modifying either
** @param s1 First string (not modified)
** @param s2 Second string (not modified)
**
** @return new joined string (must be freed by caller) or NULL on error
*/
char	*ft_strjoin(char const *s1, char const *s2)
{
	char	*ptr;
	size_t	i;

	if (!s1)
		s1 = "";
	if (!s2)
		s2 = "";
	ptr = malloc(sizeof(char) * (ft_strlen(s1) + ft_strlen(s2) + 1));
	if (!ptr)
		return (NULL);
	i = 0;
	while (*s1)
		ptr[i++] = *s1++;
	while (*s2)
		ptr[i++] = *s2++;
	ptr[i] = '\0';
	return (ptr);
}

char	*ft_strjoin_sep_term(const char *s1, const char *s2,
		const char *sep, const char *term)
{
	char	*ptr;
	size_t	i;

	if (!s1)
		s1 = "";
	if (!s2)
		s2 = "";
	ptr = malloc(ft_strlen(s1) + ft_strlen(s2)
			+ ft_strlen_safe(sep) + ft_strlen_safe(term) + 1);
	if (!ptr)
		return (NULL);
	i = 0;
	ft_strcpy_at(ptr, &i, s1);
	if (sep)
		ft_strcpy_at(ptr, &i, sep);
	ft_strcpy_at(ptr, &i, s2);
	if (term)
		ft_strcpy_at(ptr, &i, term);
	return (ptr);
}
