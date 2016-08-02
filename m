From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] multipathd: fix issue in 'map $map
 getprstatus' reply
Date: Tue, 2 Aug 2016 08:19:24 -0700
Message-ID: <d7657727-1541-955f-95c0-ce452cc4217d@sandisk.com>
References: <1470101235-8616-1-git-send-email-peng.liang5@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470101235-8616-1-git-send-email-peng.liang5@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: peng.liang5@zte.com.cn, christophe varoqui <christophe.varoqui@free.fr>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com
List-Id: dm-devel.ids

On 08/01/2016 06:27 PM, peng.liang5@zte.com.cn wrote:
> From: peng liang <peng.liang5@zte.com.cn>
>
> add missing newline to 'map|multipath $map getprstatus' reply
>
> Signed-off-by: peng liang <peng.liang5@zte.com.cn>
> ---
>  multipathd/cli_handlers.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 8ff4362..0b04504 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -1285,13 +1285,13 @@ cli_getprstatus (void * v, char ** reply, int * len, void * data)
>
>  	condlog(3, "%s: prflag = %u", param, (unsigned int)mpp->prflag);
>
> -	*reply =(char *)malloc(2);
> -	*len = 2;
> -	memset(*reply,0,2);
> +	*reply =(char *)malloc(3);
> +	*len = 3;
> +	memset(*reply,0,3);
>
>
> -	sprintf(*reply,"%d",mpp->prflag);
> -	(*reply)[1]='\0';
> +	sprintf(*reply,"%d\n",mpp->prflag);
> +	(*reply)[2]='\0';

Hello Peng,

Please use asprintf() instead of malloc() + memset() + sprintf(). See 
also https://www.gnu.org/software/libc/manual/html_node/Dynamic-Output.html

Thanks,

Bart.
