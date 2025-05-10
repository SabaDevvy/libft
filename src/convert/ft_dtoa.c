/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_dtoa.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <gsabatin@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/05/10 16:03:52 by gsabatin          #+#    #+#             */
/*   Updated: 2025/05/10 16:05:20 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdlib.h>

static int	numlen(long n)
{
	int	len;

	len = 0;
	if (n <= 0)
		len = 1;
	while (n != 0)
	{
		n /= 10;
		len++;
	}
	return (len);
}

static void	fill_integer_digits(char *str, long num, int pos)
{
	while (num > 0)
	{
		pos--;
		str[pos] = (num % 10) + '0';
		num /= 10;
	}
}

static void	handle_integer_part(char *str, long num, int pos, int sign)
{
	if (num == 0)
		str[0] = '0';
	if (sign)
		str[0] = '-';
	fill_integer_digits(str, num, pos);
}

static void	fill_decimal_digits(char *str, double frac, int pos)
{
	int	i;
	int	digit;

	i = 0;
	while (i < 6)
	{
		frac *= 10;
		digit = (int)frac;
		str[pos + i] = digit + '0';
		frac -= digit;
		i++;
	}
}

char	*ft_dtoa(double n)
{
	char	*str;
	long	int_part;
	int		sign;
	int		int_len;
	int		total_len;

	sign = 0;
	if (n < 0)
	{
		sign = 1;
		n = -n;
	}
	int_part = (long)n;
	int_len = numlen(int_part);
	total_len = int_len + sign + 7;
	str = (char *)malloc(sizeof(char) * (total_len + 1));
	if (!str)
		return (NULL);
	str[total_len] = '\0';
	handle_integer_part(str, int_part, int_len + sign, sign);
	str[int_len + sign] = '.';
	fill_decimal_digits(str, n - int_part, int_len + sign + 1);
	return (str);
}
