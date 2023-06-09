/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   server_bonus.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: esobrinh <esobrinh@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/06/09 15:34:53 by esobrinh          #+#    #+#             */
/*   Updated: 2023/06/09 15:39:09 by esobrinh         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minitalk_bonus.h"

static void	mensager(char *error_msg)
{
	ft_putstr_fd("ERROR: ", 1);
	ft_putstr_fd(error_msg, 1);
	ft_putstr_fd("\n", 1);
	exit(1);
}

static void	print_pid(void)
{
	ft_putstr_fd("Server PID is: ", 1);
	ft_putnbr_fd(getpid(), 1);
	ft_putstr_fd(".\n", 1);
}

static void	signal_handler(int signal, siginfo_t *info, void *context)
{
	static int	bit = 0;
	static char	byte = 0;

	(void)context;
	if (signal == SIGUSR1)
		byte = byte | 128 >> bit;
	bit++;
	if (bit == 8)
	{
		ft_putchar_fd(byte, 1);
		bit = 0;
		byte = 0;
	}
	if (kill(info->si_pid, signal))
		mensager("Error communicating with Client.");
}

int	main(int argc, char **argv)
{
	struct sigaction	sig_action;

	(void)argv;
	if (argc == 1)
	{
		print_pid();
		sig_action = (struct sigaction){0};
		sig_action.sa_sigaction = signal_handler;
		sigemptyset(&sig_action.sa_mask);
		sig_action.sa_flags = SA_SIGINFO;
		if (sigaction(SIGUSR1, &sig_action, NULL))
			mensager("Fail to use sigaction in SIGUSR1 signal.");
		if (sigaction(SIGUSR2, &sig_action, NULL))
			mensager("Fail to use sigaction in SIGUSR2 signal.");
		while (1)
			pause();
	}
	else
		mensager("Invalid number of arguments. Try only <.server>.");
	return (0);
}
