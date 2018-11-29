From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 08/19] libmultipath: decrease log level of
	word splitting
Date: Thu, 29 Nov 2018 14:49:45 -0600
Message-ID: <20181129204944.GK5077@octiron.msp.redhat.com>
References: <20181121101839.30784-1-mwilck@suse.com>
	<20181121101839.30784-9-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181121101839.30784-9-mwilck@suse.com>
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

On Wed, Nov 21, 2018 at 11:18:28AM +0100, Martin Wilck wrote:
> This will make log level 4 actually usable.

condlog doesn't actually handle verbosity levels gerater than 4
correctly when logging to syslog (there is no loglevel 8).  I didn't
even realize that there were any condlog(5, ...) calls.  I am all for
using them to make log level 4 usable, but we should cap prio at 7 in
log_safe(), to make syslog happy (not that syslog is used much
anymore).

Otherwise, I'm fine with this

-Ben
 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/util.c b/libmultipath/util.c
> index 66c47611..b5d2e706 100644
> --- a/libmultipath/util.c
> +++ b/libmultipath/util.c
> @@ -104,7 +104,7 @@ get_word (char * sentence, char ** word)
>  	}
>  	strncpy(*word, sentence, len);
>  	strchop(*word);
> -	condlog(4, "*word = %s, len = %i", *word, len);
> +	condlog(5, "*word = %s, len = %i", *word, len);
>  
>  	if (*p == '\0')
>  		return 0;
> -- 
> 2.19.1
