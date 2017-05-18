From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 5/7] Move the declaration of
 mpath_mx_alloc_len to a header file
Date: Thu, 18 May 2017 15:06:15 -0500
Message-ID: <20170518200615.GS22856@octiron.msp.redhat.com>
References: <20170517154309.17787-1-bart.vanassche@sandisk.com>
	<20170517154309.17787-6-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170517154309.17787-6-bart.vanassche@sandisk.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, May 17, 2017 at 08:43:07AM -0700, Bart Van Assche wrote:
> This allows the compiler to verify consistency of declaration and
> definition.

I get why you did this, but I'm not totally happy with where the extern
declaration is.  libmpathpersist is actually a public library, unlike
libmultipath, and mpath_persist.h is that header for that library.  As
such, I'd rather not add things to it that users aren't supposed to mess
with.  So, is your intention to let users set the max alloc length. If
so, we should probably give them a function, or at the very least some
comments telling them what this variable does. If we only want the
mpathpersist program to be able to change this, then we probably
should probably put the declaration in a different header file, perhaps
mpath_pr_ioctl.c. Now that I'm looking at this, I see that this option
(-l) isn't even documented in the mpathpersist manpage. So right now
this seems likely a completely unused feature. I guess since it exists,
I'd lean towards actually documenting it and putting it in the
libmpathpersist API in a more useful way.

-Ben

> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  libmpathpersist/mpath_persist.h | 3 +++
>  mpathpersist/main.c             | 1 -
>  multipathd/main.c               | 2 --
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
> index 79de5b5b..3faa8c9e 100644
> --- a/libmpathpersist/mpath_persist.h
> +++ b/libmpathpersist/mpath_persist.h
> @@ -81,6 +81,9 @@ extern "C" {
>  
>  
>  
> +extern unsigned int mpath_mx_alloc_len;
> +
> +
>  
>  struct prin_readdescr
>  {
> diff --git a/mpathpersist/main.c b/mpathpersist/main.c
> index 2e0aba3c..9de52b98 100644
> --- a/mpathpersist/main.c
> +++ b/mpathpersist/main.c
> @@ -40,7 +40,6 @@ void mpath_print_transport_id(struct prin_fulldescr *fdesc);
>  int construct_transportid(const char * inp, struct transportid transid[], int num_transportids);
>  
>  int logsink;
> -unsigned int mpath_mx_alloc_len;
>  struct config *multipath_conf;
>  
>  struct config *get_multipath_config(void)
> diff --git a/multipathd/main.c b/multipathd/main.c
> index b167cb4c..81c76cab 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -104,8 +104,6 @@ struct mpath_event_param
>  	struct multipath *mpp;
>  };
>  
> -unsigned int mpath_mx_alloc_len;
> -
>  int logsink;
>  int verbosity;
>  int bindings_read_only;
> -- 
> 2.12.2
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
