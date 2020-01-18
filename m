From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH 10/15] libmultipath: change how the checker
	async	is set
Date: Sat, 18 Jan 2020 12:43:49 -0500
Message-ID: <24099.17365.933723.879139@quad.stoffel.home>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-11-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1579227500-17196-11-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

>>>>> "Benjamin" == Benjamin Marzinski <bmarzins@redhat.com> writes:

Benjamin> The way that the checkers async mode worked in multipathd didn't make
Benjamin> much sense. When multipathd starts up, all checker classes are in the
Benjamin> sync mode, and any pathinfo() calls on devices would run the checker in
Benjamin> sync mode. However, the First time a checker class was used in
Benjamin> checkerloop, it would set that checker class to async (assuming
Benjamin> force_sync wasn't set).  After that, no matter when a checker from that
Benjamin> class was called, it would always run in async mode.  Multipathd doesn't
Benjamin> need to run checkers in sync mode at all, so don't.

Sorry, I had a hard time parsing this description, especially the last
sentence.  Do you mean that checkers should default to async then,
instead of sync mode?  And from looking at the code, don't you mean
that you force sync mode?  I guess the question is whether checker
classes should default sync, or async.  And if they move to async,
should they stay there?
    


Benjamin> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Benjamin> ---
Benjamin>  libmpathpersist/mpath_persist.c |  2 +-
Benjamin>  libmultipath/discovery.c        | 10 ++++------
Benjamin>  multipath/main.c                |  1 +
Benjamin>  3 files changed, 6 insertions(+), 7 deletions(-)

Benjamin> diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
Benjamin> index 603cfc3b..b2238f00 100644
Benjamin> --- a/libmpathpersist/mpath_persist.c
Benjamin> +++ b/libmpathpersist/mpath_persist.c
Benjamin> @@ -47,7 +47,7 @@ mpath_lib_init (void)
Benjamin>  		condlog(0, "Failed to initialize multipath config.");
Benjamin>  		return NULL;
Benjamin>  	}
Benjamin> -
Benjamin> +	conf->force_sync = 1;
Benjamin>  	set_max_fds(conf->max_fds);
 
Benjamin>  	return conf;
Benjamin> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
Benjamin> index d2773c3a..1ab093f4 100644
Benjamin> --- a/libmultipath/discovery.c
Benjamin> +++ b/libmultipath/discovery.c
Benjamin> @@ -1643,12 +1643,10 @@ get_state (struct path * pp, struct config *conf, int daemon, int oldstate)
Benjamin>  	if (pp->mpp && !c->mpcontext)
Benjamin>  		checker_mp_init(c, &pp->mpp->mpcontext);
Benjamin>  	checker_clear_message(c);
Benjamin> -	if (daemon) {
Benjamin> -		if (conf->force_sync == 0)
Benjamin> -			checker_set_async(c);
Benjamin> -		else
Benjamin> -			checker_set_sync(c);
Benjamin> -	}
Benjamin> +	if (conf->force_sync == 0)
Benjamin> +		checker_set_async(c);
Benjamin> +	else
Benjamin> +		checker_set_sync(c);
Benjamin>  	if (!conf->checker_timeout &&
Benjamin>  	    sysfs_get_timeout(pp, &(c->timeout)) <= 0)
c-> timeout = DEF_TIMEOUT;
Benjamin> diff --git a/multipath/main.c b/multipath/main.c
Benjamin> index 4f4d8e89..aebabd9b 100644
Benjamin> --- a/multipath/main.c
Benjamin> +++ b/multipath/main.c
Benjamin> @@ -905,6 +905,7 @@ main (int argc, char *argv[])
Benjamin>  		exit(RTVL_FAIL);
Benjamin>  	multipath_conf = conf;
conf-> retrigger_tries = 0;
Benjamin> +	conf->force_sync = 1;
Benjamin>  	while ((arg = getopt(argc, argv, ":adcChl::FfM:v:p:b:BrR:itTquUwW")) != EOF ) {
Benjamin>  		switch(arg) {
Benjamin>  		case 1: printf("optarg : %s\n",optarg);
Benjamin> -- 
Benjamin> 2.17.2

Benjamin> --
Benjamin> dm-devel mailing list
Benjamin> dm-devel@redhat.com
Benjamin> https://www.redhat.com/mailman/listinfo/dm-devel
