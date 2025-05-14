/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   libft.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gsabatin <gsabatin@student.42roma.it>      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/18 15:00:02 by gsabatin          #+#    #+#             */
/*   Updated: 2025/05/16 04:27:07 by gsabatin         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef LIBFT_H
# define LIBFT_H

# include <stddef.h>
# include <stdbool.h>
# include <limits.h>

# include "inline_functions.h"
# include "colors.h"

# define NUMS "nums"
# define ARR "arr"

# define MAX_CRITERIA "MAX"
# define MIN_CRITERIA "MIN"
# define MED_CRITERIA "MED"

/* Type definitions */
typedef int	(*t_find_number)(int *, size_t);

/* List structure definition */
typedef struct s_list
{
	void			*content;
	struct s_list	*next;
}	t_list;

/* Character classification functions */
int		ft_isalpha(int c);
int		ft_isdigit(int c);
int		ft_isalnum(int c);
int		ft_isascii(int c);
int		ft_isprint(int c);
int		ft_toupper(int c);
int		ft_tolower(int c);

/* Number manipulation */
int		*ft_arrdup(const int *src, size_t size);

/* String manipulation */
size_t	ft_strlen(const char *s);
size_t	ft_strlen_safe(const char *s);
size_t	ft_strlcpy(char *dst, const char *src, size_t size);
size_t	ft_strcpy_at(char *dst, size_t *dst_index, const char *src);
size_t	ft_strlcat(char *dst, const char *src, size_t size);
int		ft_strcmp(const char *s1, const char *s2);
int		ft_strncmp(const char *s1, const char *s2, size_t n);
int		ft_stroccurences(const char *str, const char *little);
char	*ft_strchr(const char *s, int c);
char	*ft_strrchr(const char *s, int c);
char	*ft_strnstr(const char *big, const char *little, size_t len);
char	*ft_strdup(const char *s);
char	*ft_strdup_safe(const char *str);
char	*ft_strappend(char *s1, const char *s2);
char	*ft_strappend_sep_term(char *s1, const char *s2,
			const char *sep, const char *term);
char	*ft_strappend_clear(char *s1, char **s2_ptr);
char	*ft_strappend_substr(char *s1,
			const char *str, size_t start, size_t len);
int		ft_strappend_replace(char **s1_ptr, char **s2_ptr, bool clear_s2);

/* String transformation */
char	*ft_substr(char const *s, unsigned int start, size_t len);
char	*ft_strjoin(char const *s1, char const *s2);
char	*ft_strjoin_sep_term(const char *s1, const char *s2,
			const char *sep, const char *term);
char	*ft_strtrim(char const *s1, char const *set);
char	**ft_split(char const *s, char c);
char	**ft_split_argv(char const *s, char c);
int		ft_atoi(const char *nptr);
int		ft_atoi_base(char *str, const char *base);
char	*ft_convert_base(char *nbr, const char *base_from, const char *base_to);
long	ft_atol(const char *str);
char	*ft_itoa(int n);
char	*ft_strmapi(char const *s, char (*f)(unsigned int, char));
void	ft_striteri(char *s, void (*f)(unsigned int, char*));

/* String array */
char	**ft_strarrinit(const char *str);
size_t	ft_strarrlen(const char **str_arr);
size_t	ft_strarrlen_safe(const char **str_arr);
char	**ft_strarrjoin(char **str_arr, const char *str);
char	**ft_strarrappend(char **str_arr, const char *str);
char	**ft_strarrappend_shallow(char **str_arr, char *str);
char	**ft_strarrappend_free(char **str_arr, char *str);
char	**ft_strarrappend_clear_s2(char **str_arr, char **str_ptr);
int		ft_strarrappend_replace(char ***str_arr_ptr, char **str_ptr,
			int clear_s2);
char	**ft_strarrdup(const char **strarr);
char	**strarrmerge(const char **strarr1, const char **strarr2);
char	**ft_strarrmerge_clear(char ***strarr1_ptr, char ***strarr2_ptr);

/* Clear */
void	ft_strclear(char **str);
void	ft_strarrclear(char ***str_arr);

/* Memory manipulation */
void	*ft_memset(void *s, int c, size_t n);
void	ft_bzero(void *s, size_t n);
void	*ft_memcpy(void *dest, const void *src, size_t n);
void	*ft_memmove(void *dest, const void *src, size_t n);
void	*ft_memchr(const void *s, int c, size_t n);
void	*ft_calloc(size_t nmemb, size_t size);
int		ft_memcmp(const void *s1, const void *s2, size_t n);

/* Output */
void	ft_putchar_fd(char c, int fd);
void	ft_putstr_fd(char *s, int fd);
void	ft_putendl_fd(char *s, int fd);
void	ft_putnbr_fd(int n, int fd);

/* List manipulation */
t_list	*ft_lstlast(t_list *lst);
t_list	*ft_lstnew(void *content);
t_list	*ft_lstmap(t_list *lst, void *(*f)(void *), void (*del)(void *));
int		ft_lstsize(t_list *lst);
void	ft_lstadd_front(t_list **lst, t_list *new);
void	ft_lstadd_back(t_list **lst, t_list *new);
void	ft_lstdelone(t_list *lst, void (*del)(void*));
void	ft_lstclear(t_list **lst, void (*del)(void*));
void	ft_lstiter(t_list *lst, void (*f)(void *));

/* Sort Algos*/
void	quick_sort(int *arr, size_t len);
void	bubble_sort(int *array, size_t size);
void	ft_strsort(char **array, size_t size);

/* Math functions */
int		get_num_from(const char *type, ...);

/* Math helpers */
int		highest_number(int *arr, size_t len);
int		lowest_number(int *arr, size_t len);
int		median_number(int *arr, size_t len);

#endif
