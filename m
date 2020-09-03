From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 05/14] multipathd: use MALLOC and check
 return value in, cli_getprkey func
Date: Thu, 03 Sep 2020 21:13:04 +0200
Message-ID: <4a51a6797398562b475e3320220112c2cd0d2186.camel@suse.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<5edc1c2b-eb21-198b-9880-3be6621496f9@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5edc1c2b-eb21-198b-9880-3be6621496f9@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Wed, 2020-09-02 at 15:18 +0800, lixiaokeng wrote:
> In cli_getprkey func, we use MALLOC instead of malloc, and check
> the return value of MALLOC.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>
> ---
>  multipathd/cli_handlers.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 27e4574f..d345afd3 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -1535,7 +1535,11 @@ cli_getprkey(void * v, char ** reply, int *
> len, void * data)
>  	if (!mpp)
>  		return 1;
> 
> -	*reply = malloc(26);
> +	*reply = MALLOC(26);
> +	if (!*reply) {
> +		condlog(0, "malloc *reply failed.");
> +		return 1;
> +	}

MALLOC is not necessary (*reply isn't left uninialized), nor is the
error message.

Regards,
Martin
