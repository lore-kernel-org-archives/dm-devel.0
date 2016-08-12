From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH V7 2/4] multipath-tools: New way to limit the
 IPC command length.
Date: Fri, 12 Aug 2016 16:53:43 -0500
Message-ID: <20160812215343.GQ26062@octiron.msp.redhat.com>
References: <1453953120-7023-1-git-send-email-fge@redhat.com>
	<20160812121240.47796-1-fge@redhat.com>
	<20160812121240.47796-3-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160812121240.47796-3-fge@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gris Ge <fge@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Aug 12, 2016 at 08:12:38PM +0800, Gris Ge wrote:

Perhaps a better way would be to keep your v6 code, and just make the
client ignore the SIGPIPE signals. Personally, I'm fine with always
ignoring them, since the writes will still fail with EPIPE, and
the multipathd client code should be dealing with failed writes
correctly.  If people are worried that ignoring SIGPIPE will cause
unchecked failures to stdout/stderr. Then I'm fine with just blocking
SIGPIPE during socket writes, so that we can print out a useful error
message before we die.

-Ben

> Problem:
> 
>     mpath_recv_reply() return -EINVAL on command 'show maps json' with 2k paths.
> 
> Root cause:
> 
>     Commit 174e717d351789a3cb29e1417f8e910baabcdb16 introduced the
>     limitation on max bytes(65535) of reply string from multipathd.
>     With 2k paths(1k mpaths) simulated by scsi_debug, the 'show maps json'
>     requires 1633217 bytes which trigged the EINVAL error.
> 
> Fix:
>     * Remove the limitation of MAX_REPLY_LEN in libmpathcmd.
> 
>     * Remove uxsock.h from libmultipath, changed all non-daemon usage to
>       libmpathcmd instead.
> 
>     * Rename send_packet() to send_packet_daemon_only() which is
>       dedicated for multipathd socket listener.
> 
>     * Rename recv_packet() to recv_packet_daemon_only() which is
>       dedicate for multipathd socket listener.
> 
>     * Enforce limitation(255) of IPC command string in
>       recv_packet_daemon_only().
> 
>     * Removed unused read_all() from uxsock.h.
> 
>     * Moved write_all() to file.h of libmultipath as all usage of
>       write_all() is against file rather than socket.
> 
> Changes caused by patch:
> 
>     * Data sent from IPC client(including multipathd -k) to multipathd
>       is limited to 255 bytes maximum. This prevent malicious IPC client
>       send something like 'fffffffffffffffffake command' to daemon which
>       lead daemon to allocate a big chunk of memory.
> 
>     * Due to the removal of uxsock.h from libmultipath, all IPC connection
>       except (multipathd daemon) should use libmpathcmd instead.
> 
> Signed-off-by: Gris Ge <fge@redhat.com>
> ---
>  libmpathcmd/mpath_cmd.c               |  2 -
>  libmpathcmd/mpath_cmd.h               |  2 -
>  libmpathpersist/mpath_updatepr.c      |  8 +---
>  libmultipath/Makefile                 |  2 +-
>  libmultipath/alias.c                  |  1 -
>  libmultipath/configure.c              |  5 +-
>  libmultipath/file.c                   | 24 +++++++++-
>  libmultipath/file.h                   |  1 +
>  libmultipath/uxsock.h                 |  6 ---
>  libmultipath/wwids.c                  |  1 -
>  multipath/main.c                      |  1 -
>  multipathd/Makefile                   |  2 +-
>  multipathd/uxclnt.c                   | 16 +++----
>  multipathd/uxlsnr.c                   | 10 ++--
>  {libmultipath => multipathd}/uxsock.c | 89 +++--------------------------------
>  multipathd/uxsock.h                   |  8 ++++
>  16 files changed, 55 insertions(+), 123 deletions(-)
>  delete mode 100644 libmultipath/uxsock.h
>  rename {libmultipath => multipathd}/uxsock.c (57%)
>  create mode 100644 multipathd/uxsock.h
> 
> diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
> index 0daaf53..b400038 100644
> --- a/libmpathcmd/mpath_cmd.c
> +++ b/libmpathcmd/mpath_cmd.c
> @@ -156,8 +156,6 @@ int mpath_recv_reply(int fd, char **reply, unsigned int timeout)
>  	len = mpath_recv_reply_len(fd, timeout);
>  	if (len <= 0)
>  		return len;
> -	if (len > MAX_REPLY_LEN)
> -		return -EINVAL;
>  	*reply = malloc(len);
>  	if (!*reply)
>  		return -1;
> diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
> index 7293d91..de366a8 100644
> --- a/libmpathcmd/mpath_cmd.h
> +++ b/libmpathcmd/mpath_cmd.h
> @@ -26,8 +26,6 @@ extern "C" {
>  
>  #define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
>  #define DEFAULT_REPLY_TIMEOUT	1000
> -#define MAX_REPLY_LEN		65536
> -
>  
>  /*
>   * DESCRIPTION:
> diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
> index 9ff4b30..2504b6e 100644
> --- a/libmpathpersist/mpath_updatepr.c
> +++ b/libmpathpersist/mpath_updatepr.c
> @@ -7,13 +7,9 @@
>  #include <fcntl.h>
>  #include <sys/ioctl.h>
>  #include <sys/types.h>
> -#include <sys/socket.h>
> -#include <sys/un.h>
> -#include <poll.h>
>  #include <errno.h>
>  #include "debug.h"
>  #include "mpath_cmd.h"
> -#include "uxsock.h"
>  #include "memory.h"
>  
>  unsigned long mem_allocated;    /* Total memory used in Bytes */
> @@ -33,12 +29,12 @@ int update_prflag(char * arg1, char * arg2, int noisy)
>  
>  	snprintf(str,sizeof(str),"map %s %s", arg1, arg2);
>  	condlog (2, "%s: pr flag message=%s", arg1, str);
> -	if (send_packet(fd, str) != 0) {
> +	if (mpath_send_cmd(fd, str) != 0) {
>  		condlog(2, "%s: message=%s send error=%d", arg1, str, errno);
>  		mpath_disconnect(fd);
>  		return -2;
>  	}
> -	ret = recv_packet(fd, &reply, DEFAULT_REPLY_TIMEOUT);
> +	ret = mpath_recv_reply(fd, &reply, DEFAULT_REPLY_TIMEOUT);
>  	if (ret < 0) {
>  		condlog(2, "%s: message=%s recv error=%d", arg1, str, errno);
>  		ret = -2;
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index e44397b..9550b3e 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -21,7 +21,7 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
>  	hwtable.o blacklist.o util.o dmparser.o config.o \
>  	structs.o discovery.o propsel.o dict.o \
>  	pgpolicies.o debug.o defaults.o uevent.o \
> -	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
> +	switchgroup.o print.o alias.o log_pthread.o \
>  	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
>  	lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o
>  
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index b86843a..2f08992 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -10,7 +10,6 @@
>  #include <stdio.h>
>  
>  #include "debug.h"
> -#include "uxsock.h"
>  #include "alias.h"
>  #include "file.h"
>  #include "vector.h"
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 707e6be..ae2852f 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -37,7 +37,6 @@
>  #include "alias.h"
>  #include "prio.h"
>  #include "util.h"
> -#include "uxsock.h"
>  #include "wwids.h"
>  
>  /* group paths in pg by host adapter
> @@ -727,12 +726,12 @@ int check_daemon(void)
>  	if (fd == -1)
>  		return 0;
>  
> -	if (send_packet(fd, "show daemon") != 0)
> +	if (mpath_send_cmd(fd, "show daemon") != 0)
>  		goto out;
>  	conf = get_multipath_config();
>  	timeout = conf->uxsock_timeout;
>  	put_multipath_config(conf);
> -	if (recv_packet(fd, &reply, timeout) != 0)
> +	if (mpath_recv_reply(fd, &reply, conf->uxsock_timeout) != 0)
>  		goto out;
>  
>  	if (strstr(reply, "shutdown"))
> diff --git a/libmultipath/file.c b/libmultipath/file.c
> index 74cde64..b5b58b7 100644
> --- a/libmultipath/file.c
> +++ b/libmultipath/file.c
> @@ -15,7 +15,6 @@
>  
>  #include "file.h"
>  #include "debug.h"
> -#include "uxsock.h"
>  
>  
>  /*
> @@ -178,3 +177,26 @@ fail:
>  	close(fd);
>  	return -1;
>  }
> +
> +/*
> + * keep writing until it's all sent
> + */
> +size_t write_all(int fd, const void *buf, size_t len)
> +{
> +	size_t total = 0;
> +
> +	while (len) {
> +		ssize_t n = write(fd, buf, len);
> +		if (n < 0) {
> +			if ((errno == EINTR) || (errno == EAGAIN))
> +				continue;
> +			return total;
> +		}
> +		if (!n)
> +			return total;
> +		buf = n + (char *)buf;
> +		len -= n;
> +		total += n;
> +	}
> +	return total;
> +}
> diff --git a/libmultipath/file.h b/libmultipath/file.h
> index 4f96dbf..5ea9bd3 100644
> --- a/libmultipath/file.h
> +++ b/libmultipath/file.h
> @@ -7,5 +7,6 @@
>  
>  #define FILE_TIMEOUT 30
>  int open_file(char *file, int *can_write, char *header);
> +size_t write_all(int fd, const void *buf, size_t len);
>  
>  #endif /* _FILE_H */
> diff --git a/libmultipath/uxsock.h b/libmultipath/uxsock.h
> deleted file mode 100644
> index c1cf81f..0000000
> --- a/libmultipath/uxsock.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -/* some prototypes */
> -int ux_socket_listen(const char *name);
> -int send_packet(int fd, const char *buf);
> -int recv_packet(int fd, char **buf, unsigned int timeout);
> -size_t write_all(int fd, const void *buf, size_t len);
> -ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout);
> diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
> index a7c3249..c0d7d79 100644
> --- a/libmultipath/wwids.c
> +++ b/libmultipath/wwids.c
> @@ -10,7 +10,6 @@
>  #include "vector.h"
>  #include "structs.h"
>  #include "debug.h"
> -#include "uxsock.h"
>  #include "file.h"
>  #include "wwids.h"
>  #include "defaults.h"
> diff --git a/multipath/main.c b/multipath/main.c
> index 93376a9..7d59213 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -56,7 +56,6 @@
>  #include <sys/time.h>
>  #include <sys/resource.h>
>  #include "wwids.h"
> -#include "uxsock.h"
>  #include "mpath_cmd.h"
>  
>  int logsink;
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 092b74b..68b0edf 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -31,7 +31,7 @@ LDFLAGS += -ludev -ldl \
>  #
>  # object files
>  #
> -OBJS = main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o
> +OBJS = main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o uxsock.o
>  
>  
>  #
> diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
> index 62ff6f4..bb93b47 100644
> --- a/multipathd/uxclnt.c
> +++ b/multipathd/uxclnt.c
> @@ -12,14 +12,10 @@
>  #include <errno.h>
>  #include <sys/ioctl.h>
>  #include <sys/types.h>
> -#include <sys/socket.h>
> -#include <sys/un.h>
> -#include <poll.h>
>  #include <readline/readline.h>
>  #include <readline/history.h>
>  
>  #include "mpath_cmd.h"
> -#include "uxsock.h"
>  #include "memory.h"
>  #include "defaults.h"
>  
> @@ -85,8 +81,8 @@ static void process(int fd, unsigned int timeout)
>  		if (need_quit(line, llen))
>  			break;
>  
> -		if (send_packet(fd, line) != 0) break;
> -		ret = recv_packet(fd, &reply, timeout);
> +		if (mpath_send_cmd(fd, line) != 0) break;
> +		ret = mpath_recv_reply(fd, &reply, timeout);
>  		if (ret != 0) break;
>  
>  		print_reply(reply);
> @@ -104,16 +100,16 @@ static void process_req(int fd, char * inbuf, unsigned int timeout)
>  	char *reply;
>  	int ret;
>  
> -	if (send_packet(fd, inbuf) != 0) {
> +	if (mpath_send_cmd(fd, inbuf) != 0) {
>  		printf("cannot send packet\n");
>  		return;
>  	}
> -	ret = recv_packet(fd, &reply, timeout);
> +	ret = mpath_recv_reply(fd, &reply, timeout);
>  	if (ret < 0) {
> -		if (ret == -ETIMEDOUT)
> +		if (errno == -ETIMEDOUT)
>  			printf("timeout receiving packet\n");
>  		else
> -			printf("error %d receiving packet\n", ret);
> +			printf("error %d receiving packet\n", errno);
>  	} else {
>  		printf("%s", reply);
>  		FREE(reply);
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index f114e59..e1fe7ae 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -28,7 +28,6 @@
>  #include "vector.h"
>  #include "structs.h"
>  #include "structs_vec.h"
> -#include "uxsock.h"
>  #include "defaults.h"
>  #include "config.h"
>  #include "mpath_cmd.h"
> @@ -36,6 +35,7 @@
>  #include "main.h"
>  #include "cli.h"
>  #include "uxlsnr.h"
> +#include "uxsock.h"
>  
>  struct timespec sleep_time = {5, 0};
>  
> @@ -236,8 +236,9 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
>  				}
>  				if (gettimeofday(&start_time, NULL) != 0)
>  					start_time.tv_sec = 0;
> -				if (recv_packet(c->fd, &inbuf,
> -						uxsock_timeout) != 0) {
> +				if (recv_packet_daemon_only(c->fd, &inbuf,
> +							    uxsock_timeout)
> +				    != 0) {
>  					dead_client(c);
>  					continue;
>  				}
> @@ -246,8 +247,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
>  				uxsock_trigger(inbuf, &reply, &rlen,
>  					       trigger_data);
>  				if (reply) {
> -					if (send_packet(c->fd,
> -							reply) != 0) {
> +					if (mpath_send_cmd(c->fd, reply) != 0) {
>  						dead_client(c);
>  					} else {
>  						condlog(4, "cli[%d]: "
> diff --git a/libmultipath/uxsock.c b/multipathd/uxsock.c
> similarity index 57%
> rename from libmultipath/uxsock.c
> rename to multipathd/uxsock.c
> index 775e278..bde66f2 100644
> --- a/libmultipath/uxsock.c
> +++ b/multipathd/uxsock.c
> @@ -14,7 +14,6 @@
>  #include <sys/socket.h>
>  #include <sys/un.h>
>  #include <poll.h>
> -#include <signal.h>
>  #include <errno.h>
>  #ifdef USE_SYSTEMD
>  #include <systemd/sd-daemon.h>
> @@ -24,6 +23,9 @@
>  #include "memory.h"
>  #include "uxsock.h"
>  #include "debug.h"
> +
> +#define _MAX_IPC_CMD_LEN	255
> +
>  /*
>   * create a unix domain socket and start listening on it
>   * return a file descriptor open on the socket
> @@ -74,90 +76,9 @@ int ux_socket_listen(const char *name)
>  }
>  
>  /*
> - * keep writing until it's all sent
> - */
> -size_t write_all(int fd, const void *buf, size_t len)
> -{
> -	size_t total = 0;
> -
> -	while (len) {
> -		ssize_t n = write(fd, buf, len);
> -		if (n < 0) {
> -			if ((errno == EINTR) || (errno == EAGAIN))
> -				continue;
> -			return total;
> -		}
> -		if (!n)
> -			return total;
> -		buf = n + (char *)buf;
> -		len -= n;
> -		total += n;
> -	}
> -	return total;
> -}
> -
> -/*
> - * keep reading until its all read
> - */
> -ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout)
> -{
> -	size_t total = 0;
> -	ssize_t n;
> -	int ret;
> -	struct pollfd pfd;
> -
> -	while (len) {
> -		pfd.fd = fd;
> -		pfd.events = POLLIN;
> -		ret = poll(&pfd, 1, timeout);
> -		if (!ret) {
> -			return -ETIMEDOUT;
> -		} else if (ret < 0) {
> -			if (errno == EINTR)
> -				continue;
> -			return -errno;
> -		} else if (!pfd.revents & POLLIN)
> -			continue;
> -		n = read(fd, buf, len);
> -		if (n < 0) {
> -			if ((errno == EINTR) || (errno == EAGAIN))
> -				continue;
> -			return -errno;
> -		}
> -		if (!n)
> -			return total;
> -		buf = n + (char *)buf;
> -		len -= n;
> -		total += n;
> -	}
> -	return total;
> -}
> -
> -/*
> - * send a packet in length prefix format
> - */
> -int send_packet(int fd, const char *buf)
> -{
> -	int ret = 0;
> -	sigset_t set, old;
> -
> -	/* Block SIGPIPE */
> -	sigemptyset(&set);
> -	sigaddset(&set, SIGPIPE);
> -	pthread_sigmask(SIG_BLOCK, &set, &old);
> -
> -	ret = mpath_send_cmd(fd, buf);
> -
> -	/* And unblock it again */
> -	pthread_sigmask(SIG_SETMASK, &old, NULL);
> -
> -	return ret;
> -}
> -
> -/*
>   * receive a packet in length prefix format
>   */
> -int recv_packet(int fd, char **buf, unsigned int timeout)
> +int recv_packet_daemon_only(int fd, char **buf, unsigned int timeout)
>  {
>  	int err;
>  	ssize_t len;
> @@ -166,6 +87,8 @@ int recv_packet(int fd, char **buf, unsigned int timeout)
>  	len = mpath_recv_reply_len(fd, timeout);
>  	if (len <= 0)
>  		return len;
> +	if (len > _MAX_IPC_CMD_LEN)
> +		return -EINVAL;
>  	(*buf) = MALLOC(len);
>  	if (!*buf)
>  		return -ENOMEM;
> diff --git a/multipathd/uxsock.h b/multipathd/uxsock.h
> new file mode 100644
> index 0000000..fc77cf9
> --- /dev/null
> +++ b/multipathd/uxsock.h
> @@ -0,0 +1,8 @@
> +/* some prototypes */
> +int ux_socket_listen(const char *name);
> +
> +/*
> + * recv_packet_daemon_only() is dedicated for multipathd socket listener.
> + * Other application should use mpathcmd.h instead.
> + */
> +int recv_packet_daemon_only(int fd, char **buf, unsigned int timeout);
> -- 
> 2.9.2
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
