/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_split_argv.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <gsabatin@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/12/14 20:25:48 by gsabatin          #+#    #+#             */
/*   Updated: 2025/02/24 00:28:42 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdlib.h>

static size_t	count_words(char const *s, char c)
{
	size_t	count;

	count = 0;
	while (*s)
	{
		while (*s && *s == c)
			s++;
		if (*s)
			count++;
		while (*s && *s != c)
			s++;
	}
	return (count);
}

static char	*get_word(const char *s, size_t *word_start, int c)
{
	char	*word;
	size_t	word_end;

	while (s[*word_start] && s[*word_start] == c)
		(*word_start)++;
	word_end = *word_start;
	while (s[word_end] && s[word_end] != c)
		word_end++;
	word = malloc(sizeof(char) * (word_end - *word_start + 1));
	if (!word)
		return (NULL);
	ft_strlcpy(word, &s[*word_start], word_end - *word_start + 1);
	*word_start = word_end;
	return (word);
}

static void	free_split(char **split, size_t word_added)
{
	size_t	i;

	i = 0;
	while (i < word_added)
	{
		free(split[i]);
		i++;
	}
	free(split);
}

char	*add_placeholder(char **split)
{
	char	*ptr;

	ptr = malloc(sizeof(char));
	if (!ptr)
	{
		free_split(split, 0);
		return (NULL);
	}
	*ptr = '\0';
	return (ptr);
}

char	**ft_split_argv(char const *s, char c)
{
	char	**split;
	size_t	word_count;
	size_t	i;
	size_t	word_start;

	word_count = count_words(s, c);
	split = (char **)malloc(sizeof(char *) * (word_count + 2));
	if (!s || !split)
		return (NULL);
	split[0] = add_placeholder(split);
	if (!split[0])
		return (NULL);
	i = 1;
	word_start = 0;
	while (i < word_count + 1)
	{
		split[i++] = get_word(s, &word_start, c);
		if (!split[i - 1])
		{
			free_split(split, i - 1);
			return (NULL);
		}
	}
	split[i] = NULL;
	return (split);
}
