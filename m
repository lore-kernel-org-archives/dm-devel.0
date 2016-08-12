From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH V6 1/3] multipath-tools: New way to limit the
 IPC command length.
Date: Fri, 12 Aug 2016 16:35:59 -0500
Message-ID: <20160812213559.GP26062@octiron.msp.redhat.com>
References: <1453953120-7023-1-git-send-email-fge@redhat.com>
	<20160712065038.17565-1-fge@redhat.com>
	<20160712065038.17565-2-fge@redhat.com>
	<20160715213545.GP8095@octiron.msp.redhat.com>
	<c9179069-b0a9-f409-860b-7b889a3cd654@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <c9179069-b0a9-f409-860b-7b889a3cd654@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Gris Ge <fge@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Aug 12, 2016 at 08:57:51AM -0700, Bart Van Assche wrote:
> On 07/15/2016 02:35 PM, Benjamin Marzinski wrote:
> >On Tue, Jul 12, 2016 at 02:50:36PM +0800, Gris Ge wrote:
> >
> >The only thing that I wonder about with this patch is, when previously
> >the multipath client code would have failed with EPIPE, and (at least in
> >some cases) spit out a semi-useful message, the program will now
> >terminate because of the SIGPIPE signal.  I'm not sure it makes any real
> >difference, since we weren't very diligent with returning useful error
> >messages in this case, and the client code isn't very likely to get
> >SIGPIPE.
> >
> >I'm not very concerned if nobody else thinks this is important, I just
> >though I should bring it up.
> 
> Hello Ben,
> 
> How about modifying SIGPIPE handling in multipath/multipathd as in the
> attached patch?
> 
> Thanks,
> 
> Bart.

> >From 2d834fcb135084805ab9ee219b663a4febb9c5d6 Mon Sep 17 00:00:00 2001
> From: Bart Van Assche <bart.vanassche@sandisk.com>
> Date: Fri, 12 Aug 2016 08:25:10 -0700
> Subject: [PATCH] libmultipath, multipathd: Rework SIGPIPE handling
> 
> The behavior we want is as follows:
> * If stdout is closed then multipathd stops due to SIGPIPE.

I still don't understand why we ever what multipathd quitting with
SIGPIPE.  I would much rather that the call return EPIPE and multipathd
printed a useful error message, instead of simply quitting.

Also, I don't really like putting stuff that messes with signals in the
libmpathcmd library.  Some users might want their program to get get
those SIGPIPEs so they can handle them a certain way.  It seems like,
since it isn't necessary to block the signal for this to work correctly,
we should not be blocking it in the library, and multipathd should
continue to make sure that it is ignoring the SIGPIPEs.

-Ben

> * Sending data to a socket that has been closed by the receiver
>   does not cause multipathd to stop.
> 
> Hence unblock SIGPIPE and use MSG_NOSIGNAL when sending data over
> a socket.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  libmpathcmd/mpath_cmd.c |  4 ++--
>  libmultipath/uxsock.c   | 17 ++---------------
>  multipathd/main.c       |  8 +-------
>  3 files changed, 5 insertions(+), 24 deletions(-)
> 
> diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
> index 2290ecb..3a94d83 100644
> --- a/libmpathcmd/mpath_cmd.c
> +++ b/libmpathcmd/mpath_cmd.c
> @@ -33,7 +33,7 @@ static ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout)
>  			return -1;
>  		} else if (!pfd.revents & POLLIN)
>  			continue;
> -		n = read(fd, buf, len);
> +		n = recv(fd, buf, len, 0);
>  		if (n < 0) {
>  			if ((errno == EINTR) || (errno == EAGAIN))
>  				continue;
> @@ -56,7 +56,7 @@ static size_t write_all(int fd, const void *buf, size_t len)
>  	size_t total = 0;
>  
>  	while (len) {
> -		ssize_t n = write(fd, buf, len);
> +		ssize_t n = send(fd, buf, len, MSG_NOSIGNAL);
>  		if (n < 0) {
>  			if ((errno == EINTR) || (errno == EAGAIN))
>  				continue;
> diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
> index 775e278..880257f 100644
> --- a/libmultipath/uxsock.c
> +++ b/libmultipath/uxsock.c
> @@ -81,7 +81,7 @@ size_t write_all(int fd, const void *buf, size_t len)
>  	size_t total = 0;
>  
>  	while (len) {
> -		ssize_t n = write(fd, buf, len);
> +		ssize_t n = send(fd, buf, len, MSG_NOSIGNAL);
>  		if (n < 0) {
>  			if ((errno == EINTR) || (errno == EAGAIN))
>  				continue;
> @@ -138,20 +138,7 @@ ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout)
>   */
>  int send_packet(int fd, const char *buf)
>  {
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
> +	return mpath_send_cmd(fd, buf);
>  }
>  
>  /*
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 54abfef..2be6cb2 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2125,18 +2125,12 @@ sigusr2 (int sig)
>  static void
>  signal_init(void)
>  {
> -	sigset_t set;
> -
> -	sigemptyset(&set);
> -	sigaddset(&set, SIGPIPE);
> -	pthread_sigmask(SIG_SETMASK, &set, NULL);
> -
>  	signal_set(SIGHUP, sighup);
>  	signal_set(SIGUSR1, sigusr1);
>  	signal_set(SIGUSR2, sigusr2);
>  	signal_set(SIGINT, sigend);
>  	signal_set(SIGTERM, sigend);
> -	signal(SIGPIPE, SIG_IGN);
> +	signal_set(SIGPIPE, sigend);
>  }
>  
>  static void
> -- 
> 2.9.2
> 
