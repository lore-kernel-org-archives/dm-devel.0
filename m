From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] multipathd: fix issue in 'map $map
 getprstatus' reply
Date: Wed, 12 Oct 2016 07:43:44 -0700
Message-ID: <2024ba47-6117-da6b-52cf-2450ddd7c30b@sandisk.com>
References: <OF841ED337.71FB1AB0-ON4825804A.000FE81D-4825804A.0010D15C@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF841ED337.71FB1AB0-ON4825804A.000FE81D-4825804A.0010D15C@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: peng.liang5@zte.com.cn, christophe.varoqui@opensvc.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

On 10/11/16 20:03, peng.liang5@zte.com.cn wrote:
> From: peng liang <peng.liang5@zte.com.cn>
> 
> -add missing newline to 'map|multipath $map getprstatus' reply
> -use asprintf instead of sprintf
> 
> Signed-off-by: peng liang <peng.liang5@zte.com.cn>
> ---
> multipathd/cli_handlers.c | 14 ++++++--------
> 1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 8ff4362..16445ea 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -1,6 +1,9 @@
> /*
>  * Copyright (c) 2005 Christophe Varoqui
>  */
> +#define _GNU_SOURCE
> +
> +#include <stdio.h>
> #include "checkers.h"
> #include "memory.h"
> #include "vector.h"
> @@ -1285,14 +1288,9 @@ cli_getprstatus (void * v, char ** reply, int *
> len, void * data)
> 
>                  condlog(3, "%s: prflag = %u", param, (unsigned int)mpp->prflag);
> 
> -                 *reply =(char *)malloc(2);
> -                 *len = 2;
> -                 memset(*reply,0,2);
> -
> -
> -                 sprintf(*reply,"%d",mpp->prflag);
> -                 (*reply)[1]='\0';
> -
> +                 *len = asprintf(reply, "%d\n", mpp->prflag);
> +                 if (*len < 0)
> +                                  return 1;
> 
>                  condlog(3, "%s: reply = %s", param, *reply);

Hello Peng,

Sorry but returning 1 looks somewhat inconsistent to me. This function
is called indirectly by uxsock_trigger() and that function expects that
cli_getprstatus() either returns a positive error code (E...) or a
negative error code. Please change this patch such that ENOMEM is
returned instead of 1 if asprintf() fails.

Thanks,

Bart.
