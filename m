From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH][RESEND] multipath: add followover failback
	mode
Date: Fri, 17 Aug 2012 22:03:38 +0200
Message-ID: <1345233818.12286.2.camel@lapoo.opensvc.com>
References: <20120727205619.GK5299@ether.msp.redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120727205619.GK5299@ether.msp.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On ven., 2012-07-27 at 15:56 -0500, Benjamin Marzinski wrote:
> This patch adds a new failback mode, followover, to deal with multiple
> computers accessing the same active/passive storage devices.  In these
> cases, if only one node loses access to the primary paths, it will
> force a trespass to the secondary paths.  If the nodes are configured
> with immediate failback, the other nodes with trespass back to the
> primary paths, and the machines will ping-pong the storage. If the
> nodes are configured with manual failback, this won't happen. However
> when the primary path is restored on the node that lost access to it,
> the nodes won't automatically failback to it.  In followover mode, they
> will.
> 
> Followover mode works by only failing back when a path comes back online
> from a pathgroup that previously had no working paths.  For this to
> work, the paths need an additional attribute, chkrstate. This is just like
> the path state, except it is not updated when the paths state is changed
> by the kernel, only when the path checker function sees that the path is
> down.  This is necessary because when a trespass occurs, all the outstanding
> IO to the previously active paths will fail, and the kernel will mark the
> path as down.  But for failback to happen in followover mode, the paths must
> actually be down, not just in a ghost state.
> 
Applied.

Good feature indeed.

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/dict.c        |   12 ++++++++++++
>  libmultipath/discovery.c   |    6 +++---
>  libmultipath/print.c       |    2 ++
>  libmultipath/structs.h     |    4 +++-
>  multipath/main.c           |    2 +-
>  multipath/multipath.conf.5 |    5 +++++
>  multipathd/main.c          |   35 ++++++++++++++++++++++++++++++++++-
>  7 files changed, 60 insertions(+), 6 deletions(-)
> 
> Index: multipath-tools-120518/libmultipath/dict.c
> ===================================================================
> --- multipath-tools-120518.orig/libmultipath/dict.c
> +++ multipath-tools-120518/libmultipath/dict.c
> @@ -398,6 +398,8 @@ default_failback_handler(vector strvec)
>  		conf->pgfailback = -FAILBACK_MANUAL;
>  	else if (strlen(buff) == 9 && !strcmp(buff, "immediate"))
>  		conf->pgfailback = -FAILBACK_IMMEDIATE;
> +	else if (strlen(buff) == 10 && !strcmp(buff, "followover"))
> +		conf->pgfailback = -FAILBACK_FOLLOWOVER;
>  	else
>  		conf->pgfailback = atoi(buff);
>  
> @@ -1053,6 +1055,8 @@ hw_failback_handler(vector strvec)
>  		hwe->pgfailback = -FAILBACK_MANUAL;
>  	else if (strlen(buff) == 9 && !strcmp(buff, "immediate"))
>  		hwe->pgfailback = -FAILBACK_IMMEDIATE;
> +	else if (strlen(buff) == 10 && !strcmp(buff, "followover"))
> +		hwe->pgfailback = -FAILBACK_FOLLOWOVER;
>  	else
>  		hwe->pgfailback = atoi(buff);
>  
> @@ -1351,6 +1355,8 @@ mp_failback_handler(vector strvec)
>  		mpe->pgfailback = -FAILBACK_MANUAL;
>  	else if (strlen(buff) == 9 && !strcmp(buff, "immediate"))
>  		mpe->pgfailback = -FAILBACK_IMMEDIATE;
> +	else if (strlen(buff) == 10 && !strcmp(buff, "followover"))
> +		mpe->pgfailback = -FAILBACK_FOLLOWOVER;
>  	else
>  		mpe->pgfailback = atoi(buff);
>  
> @@ -1769,6 +1775,8 @@ snprint_mp_failback (char * buff, int le
>  		return snprintf(buff, len, "manual");
>  	case -FAILBACK_IMMEDIATE:
>  		return snprintf(buff, len, "immediate");
> +	case -FAILBACK_FOLLOWOVER:
> +		return snprintf(buff, len, "followover");
>  	default:
>  		return snprintf(buff, len, "%i", mpe->pgfailback);
>  	}
> @@ -2130,6 +2138,8 @@ snprint_hw_failback (char * buff, int le
>  		return snprintf(buff, len, "manual");
>  	case -FAILBACK_IMMEDIATE:
>  		return snprintf(buff, len, "immediate");
> +	case -FAILBACK_FOLLOWOVER:
> +		return snprintf(buff, len, "followover");
>  	default:
>  		return snprintf(buff, len, "%i", hwe->pgfailback);
>  	}
> @@ -2394,6 +2404,8 @@ snprint_def_failback (char * buff, int l
>  		return snprintf(buff, len, "manual");
>  	case -FAILBACK_IMMEDIATE:
>  		return snprintf(buff, len, "immediate");
> +	case -FAILBACK_FOLLOWOVER:
> +		return snprintf(buff, len, "followover");
>  	default:
>  		return snprintf(buff, len, "%i", conf->pgfailback);
>  	}
> Index: multipath-tools-120518/libmultipath/print.c
> ===================================================================
> --- multipath-tools-120518.orig/libmultipath/print.c
> +++ multipath-tools-120518/libmultipath/print.c
> @@ -143,6 +143,8 @@ snprint_failback (char * buff, size_t le
>  {
>  	if (mpp->pgfailback == -FAILBACK_IMMEDIATE)
>  		return snprintf(buff, len, "immediate");
> +	if (mpp->pgfailback == -FAILBACK_FOLLOWOVER)
> +		return snprintf(buff, len, "followover");
>  
>  	if (!mpp->failback_tick)
>  		return snprintf(buff, len, "-");
> Index: multipath-tools-120518/libmultipath/structs.h
> ===================================================================
> --- multipath-tools-120518.orig/libmultipath/structs.h
> +++ multipath-tools-120518/libmultipath/structs.h
> @@ -39,7 +39,8 @@ enum rr_weight_mode {
>  enum failback_mode {
>  	FAILBACK_UNDEF,
>  	FAILBACK_MANUAL,
> -	FAILBACK_IMMEDIATE
> +	FAILBACK_IMMEDIATE,
> +	FAILBACK_FOLLOWOVER
>  };
>  
>  enum sysfs_buses {
> @@ -151,6 +152,7 @@ struct path {
>  	int offline;
>  	int state;
>  	int dmstate;
> +	int chkrstate;
>  	int failcount;
>  	int priority;
>  	int pgindex;
> Index: multipath-tools-120518/multipathd/main.c
> ===================================================================
> --- multipath-tools-120518.orig/multipathd/main.c
> +++ multipath-tools-120518/multipathd/main.c
> @@ -995,6 +995,32 @@ mpvec_garbage_collector (struct vectors
>  	}
>  }
>  
> +/* This is called after a path has started working again. It the multipath
> + * device for this path uses the followover failback type, and this is the
> + * best pathgroup, and this is the first path in the pathgroup to come back
> + * up, then switch to this pathgroup */
> +static int
> +followover_should_failback(struct path * pp)
> +{
> +	struct pathgroup * pgp;
> +	struct path *pp1;
> +	int i;
> +
> +	if (pp->mpp->pgfailback != -FAILBACK_FOLLOWOVER ||
> +	    !pp->mpp->pg || !pp->pgindex ||
> +	    pp->pgindex != pp->mpp->bestpg)
> +		return 0;
> +
> +	pgp = VECTOR_SLOT(pp->mpp->pg, pp->pgindex - 1);
> +	vector_foreach_slot(pgp->paths, pp1, i) {
> +		if (pp1 == pp)
> +			continue;
> +		if (pp1->chkrstate != PATH_DOWN && pp1->chkrstate != PATH_SHAKY)
> +			return 0;
> +	}
> +	return 1;
> +}
> +
>  static void
>  defered_failback_tick (vector mpvec)
>  {
> @@ -1092,6 +1118,8 @@ check_path (struct vectors * vecs, struc
>  {
>  	int newstate;
>  	int new_path_up = 0;
> +	int chkr_new_path_up = 0;
> +	int oldchkrstate = pp->chkrstate;
>  
>  	if (!pp->mpp)
>  		return;
> @@ -1130,6 +1158,7 @@ check_path (struct vectors * vecs, struc
>  			pp->dev);
>  		pp->dmstate = PSTATE_UNDEF;
>  	}
> +	pp->chkrstate = newstate;
>  	if (newstate != pp->state) {
>  		int oldstate = pp->state;
>  		pp->state = newstate;
> @@ -1182,6 +1211,9 @@ check_path (struct vectors * vecs, struc
>  
>  		new_path_up = 1;
>  
> +		if (oldchkrstate != PATH_UP && oldchkrstate != PATH_GHOST)
> +			chkr_new_path_up = 1;
> +
>  		/*
>  		 * if at least one path is up in a group, and
>  		 * the group is disabled, re-enable it
> @@ -1233,7 +1265,8 @@ check_path (struct vectors * vecs, struc
>  		    (new_path_up || pp->mpp->failback_tick <= 0))
>  			pp->mpp->failback_tick =
>  				pp->mpp->pgfailback + 1;
> -		else if (pp->mpp->pgfailback == -FAILBACK_IMMEDIATE)
> +		else if (pp->mpp->pgfailback == -FAILBACK_IMMEDIATE ||
> +			 (chkr_new_path_up && followover_should_failback(pp)))
>  			switch_pathgroup(pp->mpp);
>  	}
>  }
> Index: multipath-tools-120518/multipath/multipath.conf.5
> ===================================================================
> --- multipath-tools-120518.orig/multipath/multipath.conf.5
> +++ multipath-tools-120518/multipath/multipath.conf.5
> @@ -254,6 +254,11 @@ active paths.
>  .B manual
>  Do not perform automatic failback.
>  .TP
> +.B followover
> +Only perform automatic failback when the first path of a pathgroup
> +becomes active. This keeps a node from automatically failing back when
> +another node requested the failover.
> +.TP
>  .B values > 0
>  deferred failback (time to defer in seconds)
>  .TP
> Index: multipath-tools-120518/libmultipath/discovery.c
> ===================================================================
> --- multipath-tools-120518.orig/libmultipath/discovery.c
> +++ multipath-tools-120518/libmultipath/discovery.c
> @@ -878,13 +878,13 @@ pathinfo (struct path *pp, vector hwtabl
>  
>  	if (mask & DI_CHECKER) {
>  		if (path_state == PATH_UP) {
> -			pp->state = get_state(pp, 0);
> +			pp->chkrstate = pp->state = get_state(pp, 0);
>  			if (pp->state == PATH_UNCHECKED ||
>  			    pp->state == PATH_WILD)
>  				goto blank;
>  		} else {
>  			condlog(3, "%s: path inaccessible", pp->dev);
> -			pp->state = path_state;
> +			pp->chkrstate = pp->state = path_state;
>  		}
>  	}
>  
> @@ -912,7 +912,7 @@ blank:
>  	 * Recoverable error, for example faulty or offline path
>  	 */
>  	memset(pp->wwid, 0, WWID_SIZE);
> -	pp->state = PATH_DOWN;
> +	pp->chkrstate = pp->state = PATH_DOWN;
>  
>  	return 0;
>  }
> Index: multipath-tools-120518/multipath/main.c
> ===================================================================
> --- multipath-tools-120518.orig/multipath/main.c
> +++ multipath-tools-120518/multipath/main.c
> @@ -144,7 +144,7 @@ update_paths (struct multipath * mpp)
>  					/*
>  					 * path is not in sysfs anymore
>  					 */
> -					pp->state = PATH_DOWN;
> +					pp->chkrstate = pp->state = PATH_DOWN;
>  					continue;
>  				}
>  				pp->mpp = mpp;
