/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_num_from.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/27 13:51:45 by gsabatin          #+#    #+#             */
/*   Updated: 2025/03/20 02:05:02 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../includes/libft.h"
#include <stdarg.h>
#include <stdlib.h>

static int	get_from_two(int num1, int num2, const char *criteria)
{
	if (ft_strnstr(criteria, MAX_CRITERIA, 3))
	{
		if (num1 >= num2)
			return (num1);
		else
			return (num2);
	}
	else if (ft_strnstr(criteria, MIN_CRITERIA, 3))
	{
		if (num1 < num2)
			return (num1);
		else
			return (num2);
	}
	return (INT_MIN);
}

static int	execute(const char *criteria, int *arr, size_t len, va_list *ap)
{
	t_find_number	function;
	int				num;

	if (len == 2)
	{
		num = get_from_two(va_arg(*ap, int),
				va_arg(*ap, int), va_arg(*ap, char *));
		return (num);
	}
	else if (ft_strnstr(criteria, MAX_CRITERIA, 3))
		function = &highest_number;
	else if (ft_strnstr(criteria, MIN_CRITERIA, 3))
		function = &lowest_number;
	else if (ft_strnstr(criteria, MED_CRITERIA, 3))
		function = &median_number;
	else
		function = va_arg(*ap, t_find_number);
	num = function(arr, len);
	free(arr);
	return (num);
}

static int	*create_arr(size_t len, va_list *ap)
{
	int		*arr;
	size_t	i;

	if (len < 1)
		return (NULL);
	arr = malloc(sizeof(int) * len);
	if (!arr)
		return (NULL);
	i = -1;
	while (++i < len)
		arr[i] = va_arg(*ap, int);
	return (arr);
}

/**
 * @brief Extracts a specific int from an array based on selection criteria
 * @details This function extracts a value from an integer array according to
 * criteria such as highest, lowest, median, but it also takes custom function
 * pointers as input.
 * It supports two input methods:
 *   - Using an existing array ("arr")
 *   - Providing individual integers inline ("nums")
 * The function can use built-in comparators ("min", "max", "med")
 * or a custom function pointer for specialized selection logic.
 *
 * @param [type] string defining the array source: "two", "arr" or "nums"
 * @param [...] Variable arguments based on the type parameter
 *
 * @example "arr":	["arr", len, *arr, func]
 * @example "two":	["two", num1, num2, MIN/MAX]
 * @example "nums":	["nums", len, num1, num2, num3..., func]
 *
 * Custom functions prototype: int	(*t_find_number)(int *, size_t)
 *
 * @return Desired value from array/numbers, INT_MIN if error.
 *
 **/
int	get_num_from(const char *type, ...)
{
	va_list	ap;
	int		num;
	int		*arr;
	char	*criteria;
	size_t	len;

	va_start(ap, type);
	arr = NULL;
	len = 2;
	if (ft_strnstr(type, ARR, 3))
	{
		len = va_arg(ap, int);
		arr = ft_arrdup(va_arg(ap, int *), len);
		criteria = va_arg(ap, char *);
	}
	else if (ft_strnstr(type, NUMS, 4))
	{
		len = va_arg(ap, int);
		arr = create_arr(len, &ap);
		criteria = va_arg(ap, char *);
	}
	num = execute(criteria, arr, len, &ap);
	va_end(ap);
	return (num);
}
