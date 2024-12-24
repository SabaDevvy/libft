/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_split.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <gsabatin@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/12/14 20:25:48 by gsabatin          #+#    #+#             */
/*   Updated: 2024/12/14 20:25:49 by gsabatin         ###   ########.fr       */
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

char	**ft_split(char const *s, char c)
{
	char	**split;
	size_t	word_count;
	size_t	i;
	size_t	word_start;

	if (!s)
		return (NULL);
	word_count = count_words(s, c);
	split = (char **)malloc(sizeof(char *) * (word_count + 1));
	if (!split)
		return (NULL);
	i = 0;
	word_start = 0;
	while (i < word_count)
	{
		split[i] = get_word(s, &word_start, c);
		if (!split[i])
		{
			free_split(split, i);
			return (NULL);
		}
		i++;
	}
	split[i] = NULL;
	return (split);
}
