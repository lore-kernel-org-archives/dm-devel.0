From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] libmultipath: simplify failed wwid code
Date: Fri, 8 May 2020 11:32:00 -0500
Message-ID: <20200508163200.GQ5907@octiron.msp.redhat.com>
References: <1588372766-21317-1-git-send-email-bmarzins@redhat.com>
	<55e6cd5b0826a0393bbd2cd15e3cf9f31f8f0986.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <55e6cd5b0826a0393bbd2cd15e3cf9f31f8f0986.camel@suse.com>
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
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, May 08, 2020 at 09:15:32AM +0000, Martin Wilck wrote:
> On Fri, 2020-05-01 at 17:39 -0500, Benjamin Marzinski wrote:
> > The (is|mark|unmark)_failed_wwid code is needlessly complicated.
> > Locking a file is necssary if multiple processes could otherwise be
> > writing to it at the same time. That is not the case with the
> > failed_wwids files. They can simply be empty files in a
> > directory.  Even
> > with all the locking in place, two processes accessing or modifying a
> > file at the same time will still race. And even without the locking,
> > if
> > two processes try to access or modify a file at the same time, they
> > will
> > both see a reasonable result, and will leave the files in a valid
> > state
> > afterwards.
> > 
> > Instead of doing all the locking work (which made it necessary to
> > write
> > a file, even just to check if a file existed), simply check for files
> > with lstat(), create them with open(), and remove them with unlink().
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/wwids.c | 131 ++++++++++++++++++-----------------------
> > --
> >  1 file changed, 56 insertions(+), 75 deletions(-)
> 
> I agree, almost :-)
> 
> Please consider adding the attached patch on top, which switches back
> to atomic creation of the failed_wwids file, with just a little bit
> more compexity. I prefer the creation of the file to be atomic on the
> file system level. IMO that's how "flag" files like this should be
> handled in principle, and doing it correctly makes me feel better, even
> though I have to concur that an actual race is hardly possible.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

Or where you looking for me to respin with this included? Either way is
fine.
 
> Regards,
> Martin
> 

> From d0e4669c92863f98cdbe7b41a8a9b64223958bec Mon Sep 17 00:00:00 2001
> From: Martin Wilck <mwilck@suse.com>
> Date: Fri, 8 May 2020 00:51:50 +0200
> Subject: [PATCH] libmultipath: use atomic linkat() in mark_failed_wwid()
> 
> This keeps (almost) the simplicity of the previous patch, while
> making sure that the return value of mark_failed_wwid()
> (WWID_FAILED_CHANGED vs. WWID_FAILED_UNCHANGED) is correct, even
> if several processes access this WWID at the same time.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/wwids.c | 42 +++++++++++++++++++++++++++++-------------
>  1 file changed, 29 insertions(+), 13 deletions(-)
> 
> diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
> index b15b146b..ccdd13d2 100644
> --- a/libmultipath/wwids.c
> +++ b/libmultipath/wwids.c
> @@ -374,7 +374,7 @@ int is_failed_wwid(const char *wwid)
>  
>  	if (safe_sprintf(path, "%s/%s", shm_dir, wwid)) {
>  		condlog(1, "%s: path name overflow", __func__);
> -		return -1;
> +		return WWID_FAILED_ERROR;
>  	}
>  
>  	if (lstat(path, &st) == 0)
> @@ -390,27 +390,43 @@ int is_failed_wwid(const char *wwid)
>  
>  int mark_failed_wwid(const char *wwid)
>  {
> -	char path[PATH_MAX];
> -	int r, fd;
> +	char tmpfile[WWID_SIZE + 2 * sizeof(long) + 1];
> +	int r = WWID_FAILED_ERROR, fd, dfd;
>  
> -	if (safe_sprintf(path, "%s/%s", shm_dir, wwid)) {
> -		condlog(1, "%s: path name overflow", __func__);
> -		return -1;
> +	dfd = open(shm_dir, O_RDONLY|O_DIRECTORY);
> +	if (dfd == -1 && errno == ENOENT) {
> +		char path[sizeof(shm_dir) + 2];
> +
> +		/* arg for ensure_directories_exist() must not end with "/" */
> +		safe_sprintf(path, "%s/_", shm_dir);
> +		ensure_directories_exist(path, 0700);
> +		dfd = open(shm_dir, O_RDONLY|O_DIRECTORY);
>  	}
> -	if (ensure_directories_exist(path, 0700) < 0) {
> -		condlog(1, "%s: can't setup directories", __func__);
> -		return -1;
> +	if (dfd == -1) {
> +		condlog(1, "%s: can't setup %s: %m", __func__, shm_dir);
> +		return WWID_FAILED_ERROR;
>  	}
>  
> -	fd = open(path, O_RDONLY | O_CREAT | O_EXCL, S_IRUSR);
> -	if (fd >= 0) {
> +	safe_sprintf(tmpfile, "%s.%lx", wwid, (long)getpid());
> +	fd = openat(dfd, tmpfile, O_RDONLY | O_CREAT | O_EXCL, S_IRUSR);
> +	if (fd >= 0)
>  		close(fd);
> +	else
> +		goto out_closedir;
> +
> +	if (linkat(dfd, tmpfile, dfd, wwid, 0) == 0)
>  		r = WWID_FAILED_CHANGED;
> -	} else if (errno == EEXIST)
> +	else if (errno == EEXIST)
>  		r = WWID_FAILED_UNCHANGED;
>  	else
>  		r = WWID_FAILED_ERROR;
>  
> +	if (unlinkat(dfd, tmpfile, 0) == -1)
> +		condlog(2, "%s: failed to unlink %s/%s: %m",
> +			__func__, shm_dir, tmpfile);
> +
> +out_closedir:
> +	close(dfd);
>  	print_failed_wwid_result("mark_failed", wwid, r);
>  	return r;
>  }
> @@ -422,7 +438,7 @@ int unmark_failed_wwid(const char *wwid)
>  
>  	if (safe_sprintf(path, "%s/%s", shm_dir, wwid)) {
>  		condlog(1, "%s: path name overflow", __func__);
> -		return -1;
> +		return WWID_FAILED_ERROR;
>  	}
>  
>  	if (unlink(path) == 0)
> -- 
> 2.26.2
> 
