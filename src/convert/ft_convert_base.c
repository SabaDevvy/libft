/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_convert_base.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <gsabatin@student.42roma.it>      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/04/29 18:49:38 by gsabatin          #+#    #+#             */
/*   Updated: 2025/05/15 18:07:23 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdlib.h>

static int	count_malloc(int nbr, int base_len)
{
	int	counter;

	if (nbr <= 0)
		counter = 1;
	else
		counter = 0;
	while (nbr)
	{
		counter++;
		nbr /= base_len;
	}
	return (counter);
}

static void	fill_base(int nbr, char *dest, int *pos, const char *base)
{
	int	len;

	len = ft_strlen(base);
	if (nbr == -2147483648)
	{
		fill_base(nbr / len, dest, pos, base);
		dest[(*pos)++] = base[-(nbr % len)];
		return ;
	}
	if (nbr < 0)
	{
		dest[(*pos)++] = '-';
		nbr = -nbr;
	}
	if (nbr >= len)
		fill_base(nbr / len, dest, pos, base);
	dest[(*pos)++] = base[nbr % len];
}

static int	isvalidbase(const char *base)
{
	int	i;
	int	j;
	int	len;

	len = ft_strlen(base);
	if (len < 2)
		return (0);
	i = 0;
	while (base[i])
	{
		if (base[i] <= 32 || base[i] == 127 || base[i] == '+'
			|| base[i] == '-')
			return (0);
		j = i + 1;
		while (base[j])
		{
			if (base[j] == base[i])
				return (0);
			j++;
		}
		i++;
	}
	return (1);
}

char	*ft_convert_base(char *nbr, const char *base_from, const char *base_to)
{
	char	*result;
	int		num;
	int		pos;
	int		size;

	if (!isvalidbase(base_from) || !isvalidbase(base_to))
		return (NULL);
	num = ft_atoi_base(nbr, base_from);
	size = count_malloc(num, ft_strlen(base_to));
	if (num < 0)
		size++;
	result = malloc(sizeof(char) * (size + 1));
	if (!result)
		return (NULL);
	pos = 0;
	fill_base(num, result, &pos, base_to);
	result[pos] = '\0';
	return (result);
}
