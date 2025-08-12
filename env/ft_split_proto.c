/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_split.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: srenaud <srenaud@student.42lausanne.ch>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/10/15 17:52:32 by srenaud           #+#    #+#             */
/*   Updated: 2024/10/24 14:14:59 by srenaud          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

char	**ft_split(char const *s, char c)
{
	char			**split;
	unsigned int	*start;
	size_t			*len;
	size_t			size;

	size = ft_count_word(s, c);
	start = malloc(sizeof(unsigned int) * size);
	if (!start)
		return (NULL);
	len = malloc(sizeof(size_t) * size);
	if (!len)
		return (ft_free_malloc(NULL, start, NULL));
	start_len(start, len, s, c);
	split = al_fi_sp(s, start, len, size);
	if (!split)
		return (ft_free_malloc(NULL, start, len));
	free(start);
	free(len);
	return (split);
}

static size_t	ft_count_word(const char *s, char c)
{
	size_t	i;
	size_t	word;

	i = 0;
	word = 0;
	while (s[i])
	{
		while (s[i] == c)
			i++;
		if (s[i] != c && s[i])
			word++;
		while (s[i] != c && s[i])
			i++;
	}
	return (word);
}

static char	**ft_free_malloc(char **split, unsigned int *start, size_t *len)
{
	unsigned int	i;

	i = 0;
	if (split)
	{
		while (split[i])
		{
			free(split[i]);
			i++;
		}
		free(split);
	}
	if (start)
		free(start);
	if (len)
		free(len);
	return (NULL);
}

static void	start_len(unsigned int *start, size_t *len, const char *s, char c)
{
	unsigned int	i;
	unsigned int	word;

	i = 0;
	word = 0;
	while (s[i])
	{
		while (s[i] == c)
			i++;
		if (s[i] != c && s[i])
		{
			start[word] = i;
			len[word] = 0;
			while (s[i + len[word]] != c && s[i + len[word]])
				len[word]++;
			word++;
		}
		while (s[i] != c && s[i])
			i++;
	}
}

char	**al_fi_sp(char const *s, unsigned int *start, size_t *len, size_t size)
{
	char			**split;
	unsigned int	word;

	split = malloc(sizeof(char *) * (size + 1));
	if (!split)
		return (NULL);
	word = 0;
	while (word < size)
	{
		split[word] = ft_substr(s, start[word], len[word]);
		if (!split[word])
		{
			ft_free_malloc(split, NULL, NULL);
			return (NULL);
		}
		word++;
	}
	split[word] = NULL;
	return (split);
}
