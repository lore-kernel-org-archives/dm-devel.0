From: egoggin@emc.com
Subject: FW: bug fixes
Date: Tue, 7 Mar 2006 13:01:32 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321B09E@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids



> ______________________________________________ 
> From: 	goggin, edward  
> Sent:	Tuesday, March 07, 2006 12:59 PM
> To:	'dm-devel@redhat.com'
> Cc:	'Christophe Varoqui'
> Subject:	bug fixes
> 
> Christophe,
> 
> This patch below attempts to do the following.
> 
> (1) checker_put() now only tries to call the free callout if there is one
> defined.  There may not be one defined if there was a transport error
> during path discovery.
> I was getting a segment fault in multipathd whenever I started it with one
> of my paths in an "offline" state.
> 
> (2) emc_clariion path checker was mistakenly thinking that a logical
> unit's identity had changed because a variable in its checker context was
> not initialized.
> 
> (3) I added code to display the path checker's log message whenever the
> checker check function is called, either from multipathd or multipath.
> This is a very
> useful debugging aid.
> 
> (4) The patch contains several changes in order to minimize the number of
> events that will cause a failback to a device's highest priority path
> group.  The major
> reason to do this is to minimize the likelihood of changing the currently
> active path group for an active/passive storage system back to the highest
> priority path
> group if a path group which is not the highest priority path group has
> been made the active path group by means external to the multipathing
> software on that host.
> This could be done by SAN storage management software running on a
> management station, storage array software, or by the multipathing
> software running on
> a peer host in a cluster.  Whenever this happens, it is best for the
> multipathing software to not change the active path group (back to the
> highest priority one for
> instance) unless absolutely necessary, e.g., all paths in the non-default
> path group are failed.
> 
> It will be significantly difficult to eliminate all unnecessary failbacks
> without kernel changes and more upheaval to the failback mechanism.  I'm
> thinking that this compromise solution is sufficient.
> 
> (a) The path priority refresh code in checkerloop in multipathd now checks
> if a path group failback needs to happen IFF the path's priority has
> actually changed.
> 
> (b) If update_multipath sees that a path's dmstate is down and that the
> user multipath state does not reflect this, update_multipath now calls the
> path
> checker for the path to verify the path's state instead of simply marking
> the user multipath state as down.  If the path tests successfully, the
> dmstate for
> the path is reinstated.  This is particularly useful for the
> active/passive storage systems (which are not making use of the ghost path
> state keeping) where
> an IO has failed due to the fact that what had previously been an active
> path has been changed to an passive path by external means.  The path's
> state
> (user and kernel) is still active in this case.
> 
> (c) There is a new path group failback option
> FAILBACK_IMMEDIATE_AND_FOLLOW and it is set this up as the default for the
> clariion.  The difference between
> FAILBACK_IMMEDIATE_AND_FOLLOW and FAILBACK_IMMEDIATE is that
> FAILBACK_IMMEDIATE_AND_FOLLOW will only failback to the highest priority
> path group when the highest priority path group transitions from having no
> active paths to having a single active path.
> 
> 
> diff --git a/libcheckers/checkers.c b/libcheckers/checkers.c
> index 646cd70..53770a6 100644
> --- a/libcheckers/checkers.c
> +++ b/libcheckers/checkers.c
> @@ -82,7 +82,8 @@ int checker_init (struct checker * c)
>  
>  void checker_put (struct checker * c)
>  {
> -	c->free(c);
> +	if (c->free)
> +		c->free(c);
>  	memset(c, 0x0, sizeof(struct checker));
>  }
>  
> diff --git a/libcheckers/emc_clariion.c b/libcheckers/emc_clariion.c
> index 30ad56e..1d7b684 100644
> --- a/libcheckers/emc_clariion.c
> +++ b/libcheckers/emc_clariion.c
> @@ -29,6 +29,7 @@ int emc_clariion_init (struct checker * 
>  	c->context = malloc(sizeof(struct emc_clariion_checker_context));
>  	if (!c->context)
>  		return 1;
> +	((struct emc_clariion_checker_context *)c->context)->wwn_set = 0;
>  	return 0;
>  }
>  
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 9ca228a..249b2a4 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -171,6 +171,8 @@ default_failback_handler(vector strvec)
>  		conf->pgfailback = -FAILBACK_MANUAL;
>  	else if (strlen(buff) == 9 && !strcmp(buff, "immediate"))
>  		conf->pgfailback = -FAILBACK_IMMEDIATE;
> +	else if (strlen(buff) == 20 && !strcmp(buff,
> "immediate_and_follow"))
> +		conf->pgfailback = -FAILBACK_IMMEDIATE_AND_FOLLOW;
>  	else
>  		conf->pgfailback = atoi(buff);
>  
> @@ -509,6 +511,8 @@ hw_failback_handler(vector strvec)
>  		hwe->pgfailback = -FAILBACK_MANUAL;
>  	else if (strlen(buff) == 9 && !strcmp(buff, "immediate"))
>  		hwe->pgfailback = -FAILBACK_IMMEDIATE;
> +	else if (strlen(buff) == 20 && !strcmp(buff,
> "immediate_and_follow"))
> +		hwe->pgfailback = -FAILBACK_IMMEDIATE_AND_FOLLOW;
>  	else
>  		hwe->pgfailback = atoi(buff);
>  
> @@ -701,6 +705,8 @@ mp_failback_handler(vector strvec)
>  		mpe->pgfailback = -FAILBACK_MANUAL;
>  	else if (strlen(buff) == 9 && !strcmp(buff, "immediate"))
>  		mpe->pgfailback = -FAILBACK_IMMEDIATE;
> +	else if (strlen(buff) == 20 && !strcmp(buff,
> "immediate_and_follow"))
> +		mpe->pgfailback = -FAILBACK_IMMEDIATE_AND_FOLLOW;
>  	else
>  		mpe->pgfailback = atoi(buff);
>  
> @@ -843,6 +849,8 @@ snprint_mp_failback (char * buff, int le
>  		return snprintf(buff, len, "manual");
>  	case -FAILBACK_IMMEDIATE:
>  		return snprintf(buff, len, "immediate");
> +	case -FAILBACK_IMMEDIATE_AND_FOLLOW:
> +		return snprintf(buff, len, "immediate_and_follow");
>  	default:
>  		return snprintf(buff, len, "%i", mpe->pgfailback);
>  	}
> @@ -1038,6 +1046,8 @@ snprint_hw_failback (char * buff, int le
>  		return snprintf(buff, len, "manual");
>  	case -FAILBACK_IMMEDIATE:
>  		return snprintf(buff, len, "immediate");
> +	case -FAILBACK_IMMEDIATE_AND_FOLLOW:
> +		return snprintf(buff, len, "immediate_and_follow");
>  	default:
>  		return snprintf(buff, len, "%i", hwe->pgfailback);
>  	}
> @@ -1217,6 +1227,8 @@ snprint_def_failback (char * buff, int l
>  		return snprintf(buff, len, "manual");
>  	case -FAILBACK_IMMEDIATE:
>  		return snprintf(buff, len, "immediate");
> +	case -FAILBACK_IMMEDIATE_AND_FOLLOW:
> +		return snprintf(buff, len, "immediate_and_follow");
>  	default:
>  		return snprintf(buff, len, "%i", conf->pgfailback);
>  	}
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 966434d..fb9d591 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -619,6 +619,8 @@ get_state (struct path * pp)
>  	}
>  	pp->state = checker_check(c);
>  	condlog(3, "%s: state = %i", pp->dev, pp->state);
> +	if (pp->state == PATH_DOWN)
> +		condlog(2, "%s checker msg is %s", pp->dev,
> checker_message(c));
>  	return 0;
>  }
>  
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 5c7d625..ce1d5e8 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -150,7 +150,7 @@ static struct hwentry default_hw[] = {
>  		.hwhandler     = "1 emc",
>  		.selector      = DEFAULT_SELECTOR,
>  		.pgpolicy      = GROUP_BY_PRIO,
> -		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.pgfailback    = -FAILBACK_IMMEDIATE_AND_FOLLOW,
>  		.rr_weight     = RR_WEIGHT_NONE,
>  		.no_path_retry = (300 / DEFAULT_CHECKINT),
>  		.minio         = DEFAULT_MINIO,
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 6cc63e2..2e65ab2 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -110,6 +110,8 @@ snprint_failback (char * buff, size_t le
>  {
>  	if (mpp->pgfailback == -FAILBACK_IMMEDIATE)
>  		return snprintf(buff, len, "immediate");
> +	if (mpp->pgfailback == -FAILBACK_IMMEDIATE_AND_FOLLOW)
> +		return snprintf(buff, len, "immediate_and_follow");
>  
>  	if (!mpp->failback_tick)
>  		return snprintf(buff, len, "-");
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index c6692f3..024e790 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -340,17 +340,28 @@ find_path_by_devt (vector pathvec, char 
>  }
>  
>  extern int
> +pathcountgr (struct pathgroup * pgp, int state)
> +{
> +	struct path *pp;
> +	int count = 0;
> +	int i;
> +
> +	vector_foreach_slot (pgp->paths, pp, i)
> +		if ((pp->state == state) || (state < 0))
> +			count++;
> +
> +	return count;
> +}
> +
> +extern int
>  pathcount (struct multipath * mpp, int state)
>  {
>  	struct pathgroup *pgp;
> -	struct path *pp;
> -	int i, j;
>  	int count = 0;
> +	int i;
>  
>  	vector_foreach_slot (mpp->pg, pgp, i)
> -		vector_foreach_slot (pgp->paths, pp, j)
> -			if ((pp->state == state) || (state < 0))
> -				count++;
> +		count += pathcountgr(pgp, state);
>  
>  	return count;
>  }
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index b46b700..93eb90e 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -32,7 +32,8 @@ enum rr_weight_mode {
>  enum failback_mode {
>  	FAILBACK_UNDEF,
>  	FAILBACK_MANUAL,
> -	FAILBACK_IMMEDIATE
> +	FAILBACK_IMMEDIATE,
> +	FAILBACK_IMMEDIATE_AND_FOLLOW
>  };
>  
>  enum sysfs_buses {
> @@ -184,6 +185,7 @@ struct multipath * find_mp_by_minor (vec
>  struct path * find_path_by_devt (vector pathvec, char * devt);
>  struct path * find_path_by_dev (vector pathvec, char * dev);
>  
> +int pathcountgr (struct pathgroup *, int);
>  int pathcount (struct multipath *, int);
>  
>  char sysfs_path[FILE_NAME_SIZE];
> diff --git a/multipathd/main.c b/multipathd/main.c
> index a0d33fe..c9f8ce5 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -78,6 +78,13 @@
>  #define lock_cleanup_pop(a) pthread_cleanup_pop(1);
>  #endif
>  
> +#define FIRST_ACTIVE_PATH(pp)
> ((pathcountgr(VECTOR_SLOT(pp->mpp->pg,        \
> +
> pp->mpp->bestpg-1), \
> +					            PATH_UP) +
> \
> +				  pathcountgr(VECTOR_SLOT(pp->mpp->pg,
> \
> +
> pp->mpp->bestpg-1), \
> +						    PATH_GHOST)) == 1)
> +
>  pthread_cond_t exit_cond = PTHREAD_COND_INITIALIZER;
>  pthread_mutex_t exit_mutex = PTHREAD_MUTEX_INITIALIZER;
>  
> @@ -283,19 +290,32 @@ update_multipath (struct vectors *vecs, 
>  
>  			if (pp->state != PATH_DOWN) {
>  				int oldstate = pp->state;
> -				condlog(2, "%s: mark as failed", pp->dev_t);
> -				mpp->stat_path_failures++;
> -				pp->state = PATH_DOWN;
> -				if (oldstate == PATH_UP ||
> -				    oldstate == PATH_GHOST)
> -					update_queue_mode_del_path(mpp);
> +				int newstate;
>  
>  				/*
> -				 * if opportune,
> -				 * schedule the next check earlier
> +				 * Use checker to verify that path is down.
>  				 */
> -				if (pp->tick > conf->checkint)
> -					pp->tick = conf->checkint;
> +				if (checker_selected(&pp->checker))
> +					newstate =
> checker_check(&pp->checker);
> +				if (newstate == PATH_DOWN) {
> +					condlog(2, "%s: mark as failed",
> pp->dev_t);
> +					mpp->stat_path_failures++;
> +					pp->state = newstate;
> +					if (oldstate == PATH_UP ||
> +				    	    oldstate == PATH_GHOST)
> +
> update_queue_mode_del_path(mpp);
> +
> +					/*
> +				 	 * if opportune,
> +				 	 * schedule the next check earlier
> +				 	 */
> +					if (pp->tick > conf->checkint)
> +						pp->tick = conf->checkint;
> +				}
> +				else if (newstate == PATH_UP ||
> +			    	    	 newstate == PATH_GHOST) {
> +					reinstate_path(pp, 1);
> +				}
>  			}
>  		}
>  	}
> @@ -1202,6 +1222,8 @@ checkerloop (void *ap)
>  		condlog(4, "tick");
>  
>  		vector_foreach_slot (vecs->pathvec, pp, i) {
> +			int prio;
> +
>  			if (!pp->mpp)
>  				continue;
>  
> @@ -1282,6 +1304,11 @@ checkerloop (void *ap)
>  				else if (pp->mpp->pgfailback ==
> -FAILBACK_IMMEDIATE &&
>  				    need_switch_pathgroup(pp->mpp, 1))
>  					switch_pathgroup(pp->mpp);
> +				else if ((pp->mpp->pgfailback ==
> -FAILBACK_IMMEDIATE_AND_FOLLOW) &&
> +				         need_switch_pathgroup(pp->mpp, 1)
> &&
> +				         FIRST_ACTIVE_PATH(pp)) {
> +					switch_pathgroup(pp->mpp);
> +				}
>  
>  				/*
>  				 * if at least one path is up in a group,
> and
> @@ -1304,24 +1331,35 @@ checkerloop (void *ap)
>  				pp->tick = pp->checkint;
>  				condlog(4, "%s: delay next check %is",
>  						pp->dev_t, pp->tick);
> -
>  			}
> +			else if (newstate == PATH_DOWN)
> +				LOG_MSG(2, checker_message(&pp->checker));
> +
>  			pp->state = newstate;
>  
>  			/*
>  			 * path prio refreshing
>  			 */
>  			condlog(4, "path prio refresh");
> +			prio = pp->priority; 
>  			pathinfo(pp, conf->hwtable, DI_PRIO);
>  
> -			if (need_switch_pathgroup(pp->mpp, 0)) {
> -				if (pp->mpp->pgfailback > 0 &&
> -				    pp->mpp->failback_tick <= 0)
> -					pp->mpp->failback_tick =
> -						pp->mpp->pgfailback + 1;
> -				else if (pp->mpp->pgfailback ==
> -						-FAILBACK_IMMEDIATE)
> -					switch_pathgroup(pp->mpp);
> +			/*
> +			 * Consider failback to highest priority path group
> +			 * IFF the priority of this path has changed.
> +			 */
> +			if (pp->priority != prio) {
> +				if (need_switch_pathgroup(pp->mpp, 0)) {
> +					if (pp->mpp->pgfailback > 0 &&
> +				    	    pp->mpp->failback_tick <= 0)
> +						pp->mpp->failback_tick =
> +					        	pp->mpp->pgfailback
> + 1;
> +					else if ((pp->mpp->pgfailback ==
> +						-FAILBACK_IMMEDIATE) ||
> +						 (pp->mpp->pgfailback ==
> +
> -FAILBACK_IMMEDIATE_AND_FOLLOW))
> +						switch_pathgroup(pp->mpp);
> +				}
>  			}
>  		}
>  		defered_failback_tick(vecs->mpvec);
