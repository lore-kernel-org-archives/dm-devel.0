From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] Correctly ignore empty prio names
Date: Wed, 8 May 2013 11:28:04 -0500
Message-ID: <20130508162803.GV6253@ether.msp.redhat.com>
References: <1368004423-8338-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1368004423-8338-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Christope Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Wed, May 08, 2013 at 11:13:43AM +0200, Hannes Reinecke wrote:
> This is a partial revert of commit
> 'Stop annoying prio_lookup warning messages',
> as that patch would only fix the 'prio_put' case.
> However, as the prio name might be empty even in
> in prio_get() we should rather fix this in
> prio_lookup() and handle both cases.

My feeling was that you would want to get that warning message if you
failed to get the prioritizer in prio_get() because the name was empty.
With this change it will silently fail unless you have the verbosity set
to 3, in which case you'll get a message like

sdb: prio =  (config file default)

Which doesn't really look that much like an error.

On the other hand, if you never got a prioritizer at all, you don't want
a warning message when you try to free it in prio_put() since that's
only happening because there is nothing to free.

What you you think?

-Ben

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> diff --git a/libmultipath/prio.c b/libmultipath/prio.c
> index 186cc4d..05a8cf1 100644
> --- a/libmultipath/prio.c
> +++ b/libmultipath/prio.c
> @@ -64,6 +64,9 @@ struct prio * prio_lookup (char * name)
>  {
>  	struct prio * p;
>  
> +	if (!name || !strlen(name))
> +		return NULL;
> +
>  	list_for_each_entry(p, &prioritizers, node) {
>  		if (!strncmp(name, p->name, PRIO_NAME_LEN))
>  			return p;
> @@ -162,10 +165,7 @@ void prio_put (struct prio * dst)
>  	if (!dst)
>  		return;
>  
> -	if (!strlen(dst->name))
> -		src = NULL;
> -	else
> -		src = prio_lookup(dst->name);
> +	src = prio_lookup(dst->name);
>  	memset(dst, 0x0, sizeof(struct prio));
>  	free_prio(src);
>  }
