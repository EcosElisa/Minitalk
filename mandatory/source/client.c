/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   client.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: esobrinh <esobrinh@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/06/02 18:55:53 by esobrinh          #+#    #+#             */
/*   Updated: 2023/06/09 18:59:23 by esobrinh         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/minitalk.h"

t_client	g_client;

static void	mensager(char *error_msg)
{
	ft_putstr_fd("ERROR: ", 1);
	ft_putstr_fd(error_msg, 1);
	ft_putstr_fd("\n", 1);
	exit(1);
}

static void	signal_handle(int signal, siginfo_t *info, void *context)
{
	if (signal == SIGUSR1 || signal == SIGUSR2)
		g_client.send_signal = 0;
	(void)info;
	(void)context;
}

static void	bit_by_bit(char byte)
{
	int	bit;
	int	signal;

	bit = 0;
	while (bit < 8)
	{
		g_client.send_signal = 1;
		if ((128 >> bit) & byte)
			signal = SIGUSR1;
		else
			signal = SIGUSR2;
		if (kill(g_client.pid, signal))
			mensager("Server offline or invalid PID.");
		while (g_client.send_signal)
			usleep(SLEEP_TIME);
		bit++;
	}
}

int	main(int argc, char **argv)
{
	size_t				count;
	struct sigaction	sig_action;

	if (argc == 3)
	{
		sig_action = (struct sigaction){0};
		sig_action.sa_sigaction = signal_handle;
		sig_action.sa_flags = 0;
		sigemptyset(&sig_action.sa_mask);
		if (sigaction(SIGUSR1, &sig_action, NULL))
			mensager("Fail to use sigaction in SIGUSR1 signal.");
		if (sigaction(SIGUSR2, &sig_action, NULL))
			mensager("Fail to use sigaction in SIGUSR2 signal.");
		g_client.pid = ft_atoi(argv[1]);
		if (g_client.pid <= 0)
			mensager("Invalid PID.");
		count = 0;
		while (argv[2][count] != '\0')
			bit_by_bit(argv[2][count++]);
		bit_by_bit('\n');
	}
	else
		mensager("Invalid number of arguments."
			" Try <./client> <PID server> <message>.");
	return (0);
}
