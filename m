From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 09/21] libmultipath/checkers: readsector0:
	use message id
Date: Thu, 25 Oct 2018 16:02:21 -0500
Message-ID: <20181025210221.GR7100@octiron.msp.redhat.com>
References: <20181011222707.3631-1-mwilck@suse.com>
	<20181011222707.3631-10-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181011222707.3631-10-mwilck@suse.com>
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

On Fri, Oct 12, 2018 at 12:26:55AM +0200, Martin Wilck wrote:

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/checkers/readsector0.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/libmultipath/checkers/readsector0.c b/libmultipath/checkers/readsector0.c
> index 1c2a868e..cf79e067 100644
> --- a/libmultipath/checkers/readsector0.c
> +++ b/libmultipath/checkers/readsector0.c
> @@ -6,9 +6,6 @@
>  #include "checkers.h"
>  #include "libsg.h"
>  
> -#define MSG_READSECTOR0_UP	"readsector0 checker reports path is up"
> -#define MSG_READSECTOR0_DOWN	"readsector0 checker reports path is down"
> -
>  struct readsector0_checker_context {
>  	void * dummy;
>  };
> @@ -35,10 +32,10 @@ int libcheck_check (struct checker * c)
>  	switch (ret)
>  	{
>  	case PATH_DOWN:
> -		MSG(c, MSG_READSECTOR0_DOWN);
> +		c->msgid = CHECKER_MSGID_DOWN;
>  		break;
>  	case PATH_UP:
> -		MSG(c, MSG_READSECTOR0_UP);
> +		c->msgid = CHECKER_MSGID_UP;
>  		break;
>  	default:
>  		break;
> -- 
> 2.19.0
