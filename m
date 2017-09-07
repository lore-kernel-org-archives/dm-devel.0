From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 3/4] libmultipath: add_feature: allow only 1
	feature
Date: Thu, 7 Sep 2017 16:42:09 -0500
Message-ID: <20170907214209.GD3145@octiron.msp.redhat.com>
References: <20170828220536.13208-1-mwilck@suse.com>
	<20170828220536.13208-3-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170828220536.13208-3-mwilck@suse.com>
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

On Tue, Aug 29, 2017 at 12:05:35AM +0200, Martin Wilck wrote:
> The existing test "if feature is already present" doesn't work for
> multiple features, and we are only using add_feature() for single
> feature additions anyway. Simplify the code by not allowing spaces
> in the feature string to be added. This way we can drop the
> complex "count new features" code. Moreover, print an error message if
> the existing features string is malformed.
> 
> The old code calculated the width of the feature count twice, and the
> second time messed up the buffer length field passed to snprintf(); fix
> that, too.  Finally, replace several strcat() invocations by one
> strncpy() call to make the code easier to review.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/structs.c | 64 +++++++++++++++++---------------------------------
>  1 file changed, 21 insertions(+), 43 deletions(-)
> 
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 11e33676..828e7907 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -516,8 +516,7 @@ void setup_feature(struct multipath *mpp, char *feature)
>  int add_feature(char **f, const char *n)
>  {
>  	int c = 0, d, l;
> -	char *e, *p, *t;
> -	const char *q;
> +	char *e, *t;
>  
>  	if (!f)
>  		return 1;
> @@ -526,6 +525,11 @@ int add_feature(char **f, const char *n)
>  	if (!n || *n == '0')
>  		return 0;
>  
> +	if (strchr(n, ' ') != NULL) {
> +		condlog(0, "internal error: feature \"%s\" contains spaces", n);
> +		return 1;
> +	}
> +
>  	/* default feature is null */
>  	if(!*f)
>  	{
> @@ -543,55 +547,29 @@ int add_feature(char **f, const char *n)
>  
>  	/* Get feature count */
>  	c = strtoul(*f, &e, 10);
> -	if (*f == e)
> -		/* parse error */
> +	if (*f == e || (*e != ' ' && *e != '\0')) {
> +		condlog(0, "parse error in feature string \"%s\"", *f);
>  		return 1;
> -
> -	/* Check if we need to increase feature count space */
> -	l = strlen(*f) + strlen(n) + 1;
> -
> -	/* Count new features */
> -	if ((c % 10) == 9)
> -		l++;
> -	c++;
> -	q = n;
> -	while (*q != '\0') {
> -		if (*q == ' ' && q[1] != '\0' && q[1] != ' ') {
> -			if ((c % 10) == 9)
> -				l++;
> -			c++;
> -		}
> -		q++;
>  	}
>  
> +	/* Add 1 digit and 1 space */
> +	l = strlen(e) + strlen(n) + 2;
> +
> +	c++;
> +	/* Check if we need more digits for feature count */
> +	for (d = c; d >= 10; d /= 10)
> +		l++;
> +
>  	t = MALLOC(l + 1);
>  	if (!t)
>  		return 1;
>  
> -	memset(t, 0, l + 1);
> +	/* e: old feature string with leading space, or "" */
> +	if (*e == ' ')
> +		while (*(e + 1) == ' ')
> +			e++;
>  
> -	/* Update feature count */
> -	d = c;
> -	l = 1;
> -	while (d > 9) {
> -		d /= 10;
> -		l++;
> -	}
> -	p = t;
> -	snprintf(p, l + 2, "%0d ", c);
> -
> -	/* Copy the feature string */
> -	p = strchr(*f, ' ');
> -
> -	if (p) {
> -		while (*p == ' ')
> -			p++;
> -		strcat(t, p);
> -		strcat(t, " ");
> -	} else {
> -		p = t + strlen(t);
> -	}
> -	strcat(t, n);
> +	snprintf(t, l + 1, "%0d%s %s", c, e, n);

Just one nit, that I know I'm guilty of too (so Coverity says).  If
you're sure that you have enough size for the string, you don't need
snprintf. If you want to make sure that the string isn't too big, you
should probably use "l" instead of "l + 1", so that you know that the
string will get null termintated (from your earlier memset), and you
won't read off the end of the array later. Otherwise, ACK. 

>  
>  	FREE(*f);
>  	*f = t;
> -- 
> 2.14.0

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

-Ben
