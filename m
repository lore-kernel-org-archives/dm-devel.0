From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 19/19] mpathpersist: remove logsink and udev
Date: Mon, 21 Sep 2020 15:15:44 -0500
Message-ID: <20200921201544.GZ11108@octiron.msp.redhat.com>
References: <20200916153718.582-1-mwilck@suse.com>
	<20200916153718.582-20-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200916153718.582-20-mwilck@suse.com>
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

On Wed, Sep 16, 2020 at 05:37:18PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> We can use libmultipath's internal symbols now.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  mpathpersist/main.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/mpathpersist/main.c b/mpathpersist/main.c
> index 0f0db4b..729857f 100644
> --- a/mpathpersist/main.c
> +++ b/mpathpersist/main.c

I'm pretty sure that without this patch, mpathpersist is not directly
calling functions from libmultipath, and if so, it should stay that way.
I don't see any problem with adding the libmultipath_init() and
libmultipath_exit() calls to libmpathpersist_init() and
libmpathpersist_exit().

-Ben 

> @@ -42,13 +42,10 @@ void * mpath_alloc_prin_response(int prin_sa);
>  void mpath_print_transport_id(struct prin_fulldescr *fdesc);
>  int construct_transportid(const char * inp, struct transportid transid[], int num_transportids);
>  
> -int logsink;
> -
>  void rcu_register_thread_memb(void) {}
>  
>  void rcu_unregister_thread_memb(void) {}
>  
> -struct udev *udev;
>  
>  static int verbose, loglevel, noisy;
>  
> @@ -608,16 +605,17 @@ int main(int argc, char *argv[])
>  		exit (1);
>  	}
>  
> -	udev = udev_new();
> +	if (libmultipath_init())
> +		exit(1);
>  	if (libmpathpersist_init()) {
> -		udev_unref(udev);
> +		libmultipath_exit();
>  		exit(1);
>  	}
>  
>  	ret = handle_args(argc, argv, 0);
>  
>  	libmpathpersist_exit();
> -	udev_unref(udev);
> +	libmultipath_exit();
>  
>  	return (ret >= 0) ? ret : MPATH_PR_OTHER;
>  }
> -- 
> 2.28.0
