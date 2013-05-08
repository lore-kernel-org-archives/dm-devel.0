From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] Correctly ignore empty prio names
Date: Wed, 08 May 2013 11:52:44 +0200
Message-ID: <1368006764.9444.0.camel@lapoo.opensvc.com>
References: <1368004423-8338-1-git-send-email-hare@suse.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On mer., 2013-05-08 at 11:13 +0200, Hannes Reinecke wrote:
> This is a partial revert of commit
> 'Stop annoying prio_lookup warning messages',
> as that patch would only fix the 'prio_put' case.
> However, as the prio name might be empty even in
> in prio_get() we should rather fix this in
> prio_lookup() and handle both cases.
> 
Sorry I overlooked your comments on this patch.
Applied.

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
