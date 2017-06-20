From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] libmpathpersist: use extern struct udev from
 main program
Date: Tue, 20 Jun 2017 17:03:56 -0500
Message-ID: <20170620220355.GJ2940@octiron.msp.redhat.com>
References: <20170326134947.24993-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170326134947.24993-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Mar 26, 2017 at 03:49:47PM +0200, Martin Wilck wrote:
> Use the global variable "udev" - the internal one is not
> initialized, causing current libudev calls to fail.
> In the main program "mpathpersist", use a globally visible
> variable "udev" rather than a local variable in main().
> This imitates the way the global variable "udev" is used
> in multipath and multipathd.
> 
> Removed the "udev" parameter from mpath_lib_init() to
> clarify that it isn't used.
> 

ACK

-Ben

> Fixes: b87454988 "libmultipath: separate out 'udev' config entry"
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathpersist/mpath_persist.c | 4 ++--
>  libmpathpersist/mpath_persist.h | 2 +-
>  mpathpersist/main.c             | 5 +++--
>  3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
> index 982c7954..9bca7764 100644
> --- a/libmpathpersist/mpath_persist.c
> +++ b/libmpathpersist/mpath_persist.c
> @@ -34,10 +34,10 @@
>  
>  #define __STDC_FORMAT_MACROS 1
>  
> -struct udev *udev;
> +extern struct udev *udev;
>  
>  struct config *
> -mpath_lib_init (struct udev *udev)
> +mpath_lib_init (void)
>  {
>  	struct config *conf;
>  
> diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
> index 79de5b5b..7422322d 100644
> --- a/libmpathpersist/mpath_persist.h
> +++ b/libmpathpersist/mpath_persist.h
> @@ -174,7 +174,7 @@ struct prout_param_descriptor {		/* PROUT parameter descriptor */
>   *
>   * RETURNS: struct config ->Success, NULL->Failed.
>   */
> -extern struct config * mpath_lib_init (struct udev *udev);
> +extern struct config * mpath_lib_init (void);
>  
>  
>  /*
> diff --git a/mpathpersist/main.c b/mpathpersist/main.c
> index 2e0aba3c..e1aac8fa 100644
> --- a/mpathpersist/main.c
> +++ b/mpathpersist/main.c
> @@ -57,6 +57,8 @@ void rcu_register_thread_memb(void) {}
>  
>  void rcu_unregister_thread_memb(void) {}
>  
> +struct udev *udev;
> +
>  int main (int argc, char * argv[])
>  {
>  	int fd, c, res;
> @@ -86,7 +88,6 @@ int main (int argc, char * argv[])
>  	int num_transport =0;
>  	void *resp = NULL;
>  	struct transportid * tmp;
> -	struct udev *udev = NULL;
>  	struct config *conf;
>  
>  	if (optind == argc)
> @@ -104,7 +105,7 @@ int main (int argc, char * argv[])
>  	}
>  
>  	udev = udev_new();
> -	conf = mpath_lib_init(udev);
> +	conf = mpath_lib_init();
>  	if(!conf) {
>  		udev_unref(udev);
>  		exit(1);
> -- 
> 2.12.0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
