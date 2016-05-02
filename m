From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 19/57] multipathd: Do not print misleading
 message 'not found in pathvec'
Date: Mon, 2 May 2016 10:40:29 -0500
Message-ID: <20160502154029.GQ26117@octiron.msp.redhat.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-20-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1461755458-29225-20-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Wed, Apr 27, 2016 at 01:10:20PM +0200, Hannes Reinecke wrote:
> When looking up a path in the existing configuration it is perfectly
> possible for the path not to be present.
> This should not generate a message as it might be errorneously
> interpreted as an error.
> 

Do you feel really strongly that these messages should go? I don't think
that they are essential, but they can be useful when debugging an issue
to see the route the code took. We could move them to level 4, but
personally, I find the amount of messages generated at log level 4 to be
so high that it's a pain to use to track bugs that don't occur right
away. Another possibility would be to change the message to something
more innocuous.

Thoughts?

-Ben

> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/structs.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index b773d1c..39b2e05 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -404,7 +404,6 @@ find_path_by_dev (vector pathvec, char * dev)
>  		if (!strcmp(pp->dev, dev))
>  			return pp;
>  
> -	condlog(3, "%s: not found in pathvec", dev);
>  	return NULL;
>  }
>  
> @@ -421,7 +420,6 @@ find_path_by_devt (vector pathvec, char * dev_t)
>  		if (!strcmp(pp->dev_t, dev_t))
>  			return pp;
>  
> -	condlog(3, "%s: not found in pathvec", dev_t);
>  	return NULL;
>  }
>  
> -- 
> 2.6.6
