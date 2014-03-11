From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Don't exit() from library
Date: Tue, 11 Mar 2014 09:45:14 +0100
Message-ID: <531ECD1A.8050807@acm.org>
References: <1394518211-8245-1-git-send-email-rrs@debian.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1394518211-8245-1-git-send-email-rrs@debian.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, christophe.varoqui@opensvc.com
Cc: Ritesh Raj Sarraf <rrs@debian.org>
List-Id: dm-devel.ids

On 03/11/14 07:10, Ritesh Raj Sarraf wrote:
> Also call pthread_attr_destroy() on thread creation failure
> 
> Signed-off-by: Ritesh Raj Sarraf <rrs@debian.org>
> ---
>  libmpathpersist/mpath_persist.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
> index bd30125..b74ce4e 100644
> --- a/libmpathpersist/mpath_persist.c
> +++ b/libmpathpersist/mpath_persist.c
> @@ -585,11 +585,14 @@ int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
>  	rc = pthread_create(&thread, &attr, mpath_prout_pthread_fn, (void *)(&param));
>  	if (rc){
>  		condlog (3, "%s: failed to create thread %d", dev, rc);
> -		exit(-1);
> +		/* Destroy the thread attribute since we failed to create */
> +		pthread_attr_destroy(&attr);
> +	}
> +	else {
> +		/* Free attribute and wait for the other threads */
> +		pthread_attr_destroy(&attr);
> +		rc = pthread_join(thread, NULL);
>  	}
> -	/* Free attribute and wait for the other threads */
> -	pthread_attr_destroy(&attr);
> -	rc = pthread_join(thread, NULL);
>  
>  	return (param.status);
>  }

Hello Ritesh,

Maybe there is something I'm not aware of, but is there any reason why
the pthread_attr_destroy() call occurs twice in this patch instead of
invoking it before the "if (rc) {" statement ? From the
pthread_attr_destroy() man page: "Destroying a thread  attributes object
has no effect on threads that were created using that object".

Thanks,

Bart.
