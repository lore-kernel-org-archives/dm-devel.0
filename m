From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/3] Library with an exit()
Date: Sun, 09 Mar 2014 13:27:21 +0100
Message-ID: <531C5E29.6050805@acm.org>
References: <1394366195-3053-1-git-send-email-rrs@debian.org>
	<1394366195-3053-3-git-send-email-rrs@debian.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1394366195-3053-3-git-send-email-rrs@debian.org>
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

On 03/09/14 12:56, Ritesh Raj Sarraf wrote:
> Signed-off-by: Ritesh Raj Sarraf <rrs@debian.org>
> ---
>  libmpathpersist/mpath_persist.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
> index bd30125..6b6901e 100644
> --- a/libmpathpersist/mpath_persist.c
> +++ b/libmpathpersist/mpath_persist.c
> @@ -585,11 +585,12 @@ int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
>  	rc = pthread_create(&thread, &attr, mpath_prout_pthread_fn, (void *)(&param));
>  	if (rc){
>  		condlog (3, "%s: failed to create thread %d", dev, rc);
> -		exit(-1);
>  	}
> -	/* Free attribute and wait for the other threads */
> -	pthread_attr_destroy(&attr);
> -	rc = pthread_join(thread, NULL);
> +	else {
> +		/* Free attribute and wait for the other threads */
> +		pthread_attr_destroy(&attr);
> +		rc = pthread_join(thread, NULL);
> +	}
>  
>  	return (param.status);
>  }

pthread_attr_destroy() should also be called if pthread_create() fails.

Bart.
