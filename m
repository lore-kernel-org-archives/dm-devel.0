From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] libmultipath: fix memory leak in
	_check_bindings_file
Date: Mon, 21 Sep 2020 15:25:17 -0500
Message-ID: <20200921202517.GB11108@octiron.msp.redhat.com>
References: <20200916162658.3818-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200916162658.3818-1-mwilck@suse.com>
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

On Wed, Sep 16, 2020 at 06:26:58PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> We must pass "&line" to the cleanup function, not "line".


Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
 
> Fixes: "libmultipath: add consistency check for alias settings"
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c | 2 +-
>  libmultipath/util.c  | 8 ++++++++
>  libmultipath/util.h  | 1 +
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index de28f25..a7ba485 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -580,7 +580,7 @@ static int _check_bindings_file(const struct config *conf, FILE *file,
>  	size_t line_len = 0;
>  	ssize_t n;
>  
> -	pthread_cleanup_push(free, line);
> +	pthread_cleanup_push(cleanup_free_ptr, &line);
>  	while ((n = getline(&line, &line_len, file)) >= 0) {
>  		char *c, *alias, *wwid, *saveptr;
>  		const char *mpe_wwid;
> diff --git a/libmultipath/util.c b/libmultipath/util.c
> index 8412d30..395c710 100644
> --- a/libmultipath/util.c
> +++ b/libmultipath/util.c
> @@ -406,6 +406,14 @@ void cleanup_mutex(void *arg)
>  	pthread_mutex_unlock(arg);
>  }
>  
> +void cleanup_free_ptr(void *arg)
> +{
> +	void **p = arg;
> +
> +	if (p && *p)
> +		free(*p);
> +}
> +
>  struct bitfield *alloc_bitfield(unsigned int maxbit)
>  {
>  	unsigned int n;
> diff --git a/libmultipath/util.h b/libmultipath/util.h
> index 94ed872..21a4088 100644
> --- a/libmultipath/util.h
> +++ b/libmultipath/util.h
> @@ -49,6 +49,7 @@ int should_exit(void);
>  
>  void close_fd(void *arg);
>  void cleanup_mutex(void *arg);
> +void cleanup_free_ptr(void *arg);
>  
>  struct scandir_result {
>  	struct dirent **di;
> -- 
> 2.28.0
