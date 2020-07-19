From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 69/74] libmultipath: disassemble_map(): get
 rid of "is_daemon" argument
Date: Sun, 19 Jul 2020 00:26:17 -0500
Message-ID: <20200719052617.GY11089@octiron.msp.redhat.com>
References: <20200709105145.9211-1-mwilck@suse.com>
	<20200709105145.9211-17-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-17-mwilck@suse.com>
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

On Thu, Jul 09, 2020 at 12:51:40PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The reason for the is_daemon parameter in disassemble_map() lies
> deep in multipath-tools' past, in b96dead ("[multipathd] remove the
> retry login in uev_remove_path()"): By not adding paths from
> disassembled maps to the pathvec, we avoided to re-add removed paths on
> future map reloads (logic in update_mpp_paths()). As we can handle this with
> INIT_REMOVED now, we don't need to distinguish daemon and non-daemon
> mode any more. This fixes a memory leak, because only paths which are in
> pathvec will be freed on program exit.

I don't have any problems with the code in this patch. I just want to
reiterate that I don't think that multipathd should automatically be
adding paths, just because they were in a multipath device.  In my
opinion, multipathd should have the final decision as to what a
multipath device should look like.  If it sees an unexpected path, and
runs pathinfo on it, and finds that that path does belong, it's fine to
add it. But if pathinfo says that the path doesn't belong, multipathd
shouldn't add it to the pathvec. It should instead trigger a reload of
the device to remove path.

-Ben

 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathpersist/mpath_persist.c | 2 +-
>  libmultipath/dmparser.c         | 6 ++----
>  libmultipath/dmparser.h         | 2 +-
>  libmultipath/structs_vec.c      | 9 ++++-----
>  libmultipath/structs_vec.h      | 6 ++----
>  multipath/main.c                | 4 ++--
>  multipathd/main.c               | 8 ++++----
>  7 files changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
> index 3da7a6c..cb3182f 100644
> --- a/libmpathpersist/mpath_persist.c
> +++ b/libmpathpersist/mpath_persist.c
> @@ -391,7 +391,7 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
>  		condlog(3, "params = %s", params);
>  		dm_get_status(mpp->alias, status);
>  		condlog(3, "status = %s", status);
> -		disassemble_map (pathvec, params, mpp, 0);
> +		disassemble_map (pathvec, params, mpp);
>  
>  		/*
>  		 * disassemble_map() can add new paths to pathvec.
> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> index e6f2cbe..233a1b8 100644
> --- a/libmultipath/dmparser.c
> +++ b/libmultipath/dmparser.c
> @@ -122,8 +122,7 @@ err:
>  
>  #undef APPEND
>  
> -int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
> -		    int is_daemon)
> +int disassemble_map(vector pathvec, char *params, struct multipath *mpp)
>  {
>  	char * word;
>  	char * p;
> @@ -311,8 +310,7 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
>  					strlcpy(pp->wwid, mpp->wwid,
>  						WWID_SIZE);
>  				}
> -				/* Only call this in multipath client mode */
> -				if (!is_daemon && store_path(pathvec, pp))
> +				if (store_path(pathvec, pp))
>  					goto out1;
>  			} else {
>  				if (!strlen(pp->wwid) &&
> diff --git a/libmultipath/dmparser.h b/libmultipath/dmparser.h
> index e1badb0..1b45df0 100644
> --- a/libmultipath/dmparser.h
> +++ b/libmultipath/dmparser.h
> @@ -1,3 +1,3 @@
>  int assemble_map (struct multipath *, char *, int);
> -int disassemble_map (vector, char *, struct multipath *, int);
> +int disassemble_map (vector, char *, struct multipath *);
>  int disassemble_status (char *, struct multipath *);
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 8651b98..73a7221 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -370,7 +370,7 @@ extract_hwe_from_path(struct multipath * mpp)
>  }
>  
>  int
> -update_multipath_table (struct multipath *mpp, vector pathvec, int is_daemon)
> +update_multipath_table (struct multipath *mpp, vector pathvec)
>  {
>  	int r = DMP_ERR;
>  	char params[PARAMS_SIZE] = {0};
> @@ -384,7 +384,7 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int is_daemon)
>  		return r;
>  	}
>  
> -	if (disassemble_map(pathvec, params, mpp, is_daemon)) {
> +	if (disassemble_map(pathvec, params, mpp)) {
>  		condlog(3, "%s: cannot disassemble map", mpp->alias);
>  		return DMP_ERR;
>  	}
> @@ -474,7 +474,7 @@ void sync_paths(struct multipath *mpp, vector pathvec)
>  }
>  
>  int
> -update_multipath_strings(struct multipath *mpp, vector pathvec, int is_daemon)
> +update_multipath_strings(struct multipath *mpp, vector pathvec)
>  {
>  	struct pathgroup *pgp;
>  	int i, r = DMP_ERR;
> @@ -489,10 +489,9 @@ update_multipath_strings(struct multipath *mpp, vector pathvec, int is_daemon)
>  	free_pgvec(mpp->pg, KEEP_PATHS);
>  	mpp->pg = NULL;
>  
> -	r = update_multipath_table(mpp, pathvec, is_daemon);
> +	r = update_multipath_table(mpp, pathvec);
>  	if (r != DMP_OK)
>  		return r;
> -
>  	sync_paths(mpp, pathvec);
>  
>  	r = update_multipath_status(mpp);
> diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
> index 4c28148..32cad60 100644
> --- a/libmultipath/structs_vec.h
> +++ b/libmultipath/structs_vec.h
> @@ -24,8 +24,7 @@ int verify_paths(struct multipath *mpp);
>  bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
>  			    int pathinfo_flags);
>  int update_mpp_paths(struct multipath * mpp, vector pathvec);
> -int update_multipath_strings (struct multipath *mpp, vector pathvec,
> -			      int is_daemon);
> +int update_multipath_strings (struct multipath *mpp, vector pathvec);
>  void extract_hwe_from_path(struct multipath * mpp);
>  
>  #define PURGE_VEC 1
> @@ -41,8 +40,7 @@ struct multipath * add_map_with_path (struct vectors * vecs,
>  				struct path * pp, int add_vec);
>  void update_queue_mode_del_path(struct multipath *mpp);
>  void update_queue_mode_add_path(struct multipath *mpp);
> -int update_multipath_table (struct multipath *mpp, vector pathvec,
> -			    int is_daemon);
> +int update_multipath_table (struct multipath *mpp, vector pathvec);
>  int update_multipath_status (struct multipath *mpp);
>  vector get_used_hwes(const struct _vector *pathvec);
>  
> diff --git a/multipath/main.c b/multipath/main.c
> index cfb85dc..8a2a6f7 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -272,7 +272,7 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
>  		dm_get_status(mpp->alias, status);
>  		condlog(3, "status = %s", status);
>  
> -		disassemble_map(pathvec, params, mpp, 0);
> +		disassemble_map(pathvec, params, mpp);
>  
>  		/*
>  		 * disassemble_map() can add new paths to pathvec.
> @@ -352,7 +352,7 @@ static int check_usable_paths(struct config *conf,
>  
>  	dm_get_map(mpp->alias, &mpp->size, params);
>  	dm_get_status(mpp->alias, status);
> -	disassemble_map(pathvec, params, mpp, 0);
> +	disassemble_map(pathvec, params, mpp);
>  	disassemble_status(status, mpp);
>  
>  	vector_foreach_slot (mpp->pg, pg, i) {
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 0cd0ee6..66ca4e3 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -409,7 +409,7 @@ int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
>  		goto out;
>  	}
>  
> -	if (update_multipath_strings(mpp, vecs->pathvec, 1) != DMP_OK) {
> +	if (update_multipath_strings(mpp, vecs->pathvec) != DMP_OK) {
>  		condlog(0, "%s: failed to setup multipath", mpp->alias);
>  		goto out;
>  	}
> @@ -551,7 +551,7 @@ add_map_without_path (struct vectors *vecs, const char *alias)
>  	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
>  	put_multipath_config(conf);
>  
> -	if (update_multipath_table(mpp, vecs->pathvec, 1) != DMP_OK)
> +	if (update_multipath_table(mpp, vecs->pathvec) != DMP_OK)
>  		goto out;
>  	if (update_multipath_status(mpp) != DMP_OK)
>  		goto out;
> @@ -1410,7 +1410,7 @@ map_discovery (struct vectors * vecs)
>  		return 1;
>  
>  	vector_foreach_slot (vecs->mpvec, mpp, i)
> -		if (update_multipath_table(mpp, vecs->pathvec, 1) != DMP_OK ||
> +		if (update_multipath_table(mpp, vecs->pathvec) != DMP_OK ||
>  		    update_multipath_status(mpp) != DMP_OK) {
>  			remove_map(mpp, vecs, 1);
>  			i--;
> @@ -2153,7 +2153,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
>  	/*
>  	 * Synchronize with kernel state
>  	 */
> -	ret = update_multipath_strings(pp->mpp, vecs->pathvec, 1);
> +	ret = update_multipath_strings(pp->mpp, vecs->pathvec);
>  	if (ret != DMP_OK) {
>  		if (ret == DMP_NOT_FOUND) {
>  			/* multipath device missing. Likely removed */
> -- 
> 2.26.2
