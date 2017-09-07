From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 2/4] libmultipath: add_feature: skip
	pointless NULL check
Date: Thu, 7 Sep 2017 16:33:09 -0500
Message-ID: <20170907213309.GC3145@octiron.msp.redhat.com>
References: <20170828220536.13208-1-mwilck@suse.com>
	<20170828220536.13208-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170828220536.13208-2-mwilck@suse.com>
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

On Tue, Aug 29, 2017 at 12:05:34AM +0200, Martin Wilck wrote:
> The case f == NULL is already handled by the code from
> b1ecdd46b6ec "segment faulty occured in add_feature()" above.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/structs.c | 27 ++++++++++++---------------
>  1 file changed, 12 insertions(+), 15 deletions(-)
> 
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 28704676..11e33676 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -515,7 +515,7 @@ void setup_feature(struct multipath *mpp, char *feature)
>  
>  int add_feature(char **f, const char *n)
>  {
> -	int c = 0, d, l = 0;
> +	int c = 0, d, l;
>  	char *e, *p, *t;
>  	const char *q;
>  
> @@ -538,19 +538,18 @@ int add_feature(char **f, const char *n)
>  	}
>  
>  	/* Check if feature is already present */
> -	if (*f) {
> -		if (strstr(*f, n))
> -			return 0;
> +	if (strstr(*f, n))
> +		return 0;
>  
> -		/* Get feature count */
> -		c = strtoul(*f, &e, 10);
> -		if (*f == e)
> -			/* parse error */
> -			return 1;
> +	/* Get feature count */
> +	c = strtoul(*f, &e, 10);
> +	if (*f == e)
> +		/* parse error */
> +		return 1;
> +
> +	/* Check if we need to increase feature count space */
> +	l = strlen(*f) + strlen(n) + 1;
>  
> -		/* Check if we need to increase feature count space */
> -		l = strlen(*f) + strlen(n) + 1;
> -	}
>  	/* Count new features */
>  	if ((c % 10) == 9)
>  		l++;
> @@ -582,9 +581,7 @@ int add_feature(char **f, const char *n)
>  	snprintf(p, l + 2, "%0d ", c);
>  
>  	/* Copy the feature string */
> -	p = NULL;
> -	if (*f)
> -		p = strchr(*f, ' ');
> +	p = strchr(*f, ' ');
>  
>  	if (p) {
>  		while (*p == ' ')
> -- 
> 2.14.0
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

-Ben
