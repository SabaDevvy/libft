/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strappend.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/06 18:49:04 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/15 22:44:21 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../includes/libft.h"
#include <stdlib.h>
#include <stdarg.h>

/*
 * @brief Creates a new string by appending s2 to s1
 * @param s1 First string (will be freed)
 * @param s2 String to append (not modified)
 *
 * If s1 is NULL, treats it as an empty string.
 * The original s1 is always freed.
 *
 * @attention don't pass non mallocd s1
 *
 * @return Newly allocated string containing s1+s2, or NULL on error
 *
 * @note Version used in get_next_line
*/
char	*ft_strappend(char *s1, const char *s2)
{
	char	*ptr;
	char	*orig;
	size_t	i;

	orig = s1;
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
	if (orig)
		free(orig);
	return (ptr);
}

/*
 * @brief Creates a new string by appending s2 to s1, separated by a space
 *
 * @param s1 First string (will be freed)
 * @param s2 String to append (not modified)
 * @param sep String which separates s1 and s2
 * @param term String that terminates the append
 *
 * If s1/s2 is null, treats it as an empty string.
 * @attention The original s1 is always freed. Don't pass non mallocd s1.
 *
 * @return Newly allocated string containing s1+s2, or NULL on error
 *
 * @note Version used in get_next_line
*/
char	*ft_strappend_sep_term(char *s1, const char *s2,
		const char *sep, const char *term)
{
	char	*ptr;
	char	*orig;
	size_t	i;

	orig = s1;
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
	else
		ptr[i] = '\0';
	if (orig)
		free(orig);
	return (ptr);
}

/*
 * @brief Creates a new string by appending s2 to s1
 * @details Like ft_strappend but clears s2.
 *
 * @param s1 First string pointer (will be cleared)
 * @param s2 Pointer to the string to append (will be cleared)
 *
 * @attention don't pass non mallocd s1/s2
 *
 * @return Newly allocated string containing s1+s2, or NULL on error
 *         Clears s2 before returning.
*/
char	*ft_strappend_clear_s2(char *s1, char **s2_ptr)
{
	char	*result;
	char	*s2;

	if (!s2_ptr)
		s2 = NULL;
	else
		s2 = *s2_ptr;
	result = ft_strappend(s1, s2);
	if (!result)
		return (NULL);
	if (!s2_ptr || !*s2_ptr)
		return (result);
	free(*s2_ptr);
	*s2_ptr = NULL;
	return (result);
}

/*
 * @brief Appends s2 to s1, updating the s1 pointer
 * @details On success, frees the original string and updates *s1to point to
 *          the new combined string. On failure, it doesn't modify pointer and
 *          returns 0.
 *
 * @param s1 Pointer to the string to modify (will be updated)
 * @param s2 String to append (not modified if clear_s2 is false)
 * @param bool true if s2 has to be freed, false if not
 *
 * @return 1 on success, 0 on error
*/
int	ft_strappend_replace(char **s1_ptr, char **s2_ptr, bool clear_s2)
{
	char	*result;
	char	*s1;
	char	*s2;

	if (!s1_ptr)
		s1 = NULL;
	else
		s1 = *s1_ptr;
	if (!s2_ptr)
		s2 = NULL;
	else
		s2 = *s2_ptr;
	if (!clear_s2)
		result = ft_strappend(s1, s2);
	else
		result = ft_strappend_clear_s2(s1, s2_ptr);
	*s1_ptr = result;
	return (1);
}

// /*
//  * @brief Joins multiple strings with an separator and terminator
//  *
//  * @param sep separator string char pointer
//  * @param term terminator string char pointer
//  * @param ... Variable arguments:
//  *            - Every char pointer needed to be joined
//  *
//  * @attention Must end with NULL to terminate the argument list
//  *
//  * @return Newly allocated joined string (must be freed by caller)
//  *         or NULL on error
//  *
//  * @example
//  * - With separator:
//  * char *str = ft_strjoin_multi(" ", "\n", "Hello", "world", NULL);
//  *             Returns "Hello world\n"
// */
// char	*ft_strappend_multi(char *sep, char *term, ...)
// {
// 	va_list	ap;
// 	char	*result;
// 	char	*current2;

// 	va_start(ap, term);
// 	result = va_arg(ap, char *);
// 	current2 = va_arg(ap, char *);
// 	while (result && current2)
// 	{
// 		result = ft_strappend_sep_term(result, current2, sep, NULL);
// 		current2 = va_arg(ap, char *);
// 	}
// 	va_end(ap);
// 	return (result);
// }
