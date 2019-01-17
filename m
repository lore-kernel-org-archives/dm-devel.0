From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 08/12] libmultipath(coverity): fix "enum
 misuse" for find_multipaths
Date: Thu, 17 Jan 2019 13:55:28 -0600
Message-ID: <20190117195528.GZ11315@octiron.msp.redhat.com>
References: <20190108225409.15977-1-mwilck@suse.com>
	<20190108225409.15977-9-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190108225409.15977-9-mwilck@suse.com>
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

On Tue, Jan 08, 2019 at 11:54:05PM +0100, Martin Wilck wrote:
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/dict.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index fd29abc..eaad4f1 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -327,7 +327,7 @@ def_find_multipaths_handler(struct config *conf, vector strvec)
>  	int i;
>  
>  	if (set_yes_no_undef(strvec, &conf->find_multipaths) == 0 &&
> -	    conf->find_multipaths != YNU_UNDEF)
> +	    conf->find_multipaths != FIND_MULTIPATHS_UNDEF)
>  		return 0;

Is there some reason that I don't understand why YNU_UNDEF is
problematic here, but not later in the function at the:

        if (conf->find_multipaths == YNU_UNDEF) {
                condlog(0, "illegal value for find_multipaths: %s", buff);
                conf->find_multipaths = DEFAULT_FIND_MULTIPATHS;
        }

check?

-Ben

>  
>  	buff = set_value(strvec);
> -- 
> 2.19.2
