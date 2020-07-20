From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 71/74] multipath: use update_pathvec_from_dm()
Date: Sun, 19 Jul 2020 21:57:52 -0500
Message-ID: <20200720025752.GZ11089@octiron.msp.redhat.com>
References: <20200709105145.9211-1-mwilck@suse.com>
	<20200709105145.9211-19-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-19-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jul 09, 2020 at 12:51:42PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The multipath-specific function update_paths() can now be replaced with
> a call to update_pathvec_from_dm().
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/main.c | 67 +++---------------------------------------------
>  1 file changed, 3 insertions(+), 64 deletions(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index 8a2a6f7..435c5d5 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -187,63 +187,6 @@ usage (char * progname)
>  
>  }
>  
> -static int
> -update_paths (struct multipath * mpp, int quick)
> -{
> -	int i, j;
> -	struct pathgroup * pgp;
> -	struct path * pp;
> -	struct config *conf;
> -
> -	if (!mpp->pg)
> -		return 0;
> -
> -	vector_foreach_slot (mpp->pg, pgp, i) {
> -		if (!pgp->paths)
> -			continue;
> -
> -		vector_foreach_slot (pgp->paths, pp, j) {
> -			if (!strlen(pp->dev)) {
> -				if (devt2devname(pp->dev, FILE_NAME_SIZE,
> -						 pp->dev_t)) {
> -					/*
> -					 * path is not in sysfs anymore
> -					 */
> -					pp->chkrstate = pp->state = PATH_DOWN;
> -					pp->offline = 1;
> -					continue;
> -				}
> -				pp->mpp = mpp;
> -				if (quick)
> -					continue;
> -				conf = get_multipath_config();
> -				if (pathinfo(pp, conf, DI_ALL))
> -					pp->state = PATH_UNCHECKED;
> -				put_multipath_config(conf);
> -				continue;
> -			}
> -			pp->mpp = mpp;
> -			if (quick)
> -				continue;
> -			if (pp->state == PATH_UNCHECKED ||
> -			    pp->state == PATH_WILD) {
> -				conf = get_multipath_config();
> -				if (pathinfo(pp, conf, DI_CHECKER))
> -					pp->state = PATH_UNCHECKED;
> -				put_multipath_config(conf);
> -			}
> -
> -			if (pp->priority == PRIO_UNDEF) {
> -				conf = get_multipath_config();
> -				if (pathinfo(pp, conf, DI_PRIO))
> -					pp->priority = PRIO_UNDEF;
> -				put_multipath_config(conf);
> -			}
> -		}
> -	}
> -	return 0;
> -}
> -
>  static int
>  get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
>  {
> @@ -273,13 +216,8 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
>  		condlog(3, "status = %s", status);
>  
>  		disassemble_map(pathvec, params, mpp);
> -
> -		/*
> -		 * disassemble_map() can add new paths to pathvec.
> -		 * If not in "fast list mode", we need to fetch information
> -		 * about them
> -		 */
> -		update_paths(mpp, (cmd == CMD_LIST_SHORT));
> +		update_pathvec_from_dm(pathvec, mpp,
> +				       (cmd == CMD_LIST_SHORT ? 0 : DI_ALL));

I personally don't think that "multipath -l" should be opening the path
fd. Checking sysfs seems like the limit of what we want to do for fast
listing. So, I would prefer

update_pathvec_from_dm(pathvec, mpp,
		       (cmd == CMD_LIST_SHORT ? DI_NOIO : DI_ALL));

That will make pathinfo exit early.

-Ben

>  
>  		if (cmd == CMD_LIST_LONG)
>  			mpp->bestpg = select_path_group(mpp);
> @@ -353,6 +291,7 @@ static int check_usable_paths(struct config *conf,
>  	dm_get_map(mpp->alias, &mpp->size, params);
>  	dm_get_status(mpp->alias, status);
>  	disassemble_map(pathvec, params, mpp);
> +	update_pathvec_from_dm(pathvec, mpp, 0);
>  	disassemble_status(status, mpp);
>  
>  	vector_foreach_slot (mpp->pg, pg, i) {
> -- 
> 2.26.2
