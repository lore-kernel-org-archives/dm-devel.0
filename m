From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] dm ebs: make symbol 'dm_ebs_init',
 'dm_ebs_exit' static
Date: Wed, 29 Apr 2020 14:24:35 +0200
Message-ID: <23da0d30-d053-5a2c-d7c4-e7bdcea20968@redhat.com>
References: <20200429015231.107422-1-zhengbin13@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200429015231.107422-1-zhengbin13@huawei.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zheng Bin <zhengbin13@huawei.com>, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On 4/29/20 3:52 AM, Zheng Bin wrote:
> Fix sparse warnings:
>
> drivers/md/dm-ebs-target.c:423:12: warning: symbol 'dm_ebs_init' was not declared. Should it be static?
> drivers/md/dm-ebs-target.c:433:6: warning: symbol 'dm_ebs_exit' was not declared. Should it be static?
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---
>   drivers/md/dm-ebs-target.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
> index a412647b7acc..19125dd85214 100644
> --- a/drivers/md/dm-ebs-target.c
> +++ b/drivers/md/dm-ebs-target.c
> @@ -420,7 +420,7 @@ static struct target_type ebs_target = {
>   	.iterate_devices = ebs_iterate_devices,
>   };
>
> -int __init dm_ebs_init(void)
> +static int __init dm_ebs_init(void)
>   {
>   	int r = dm_register_target(&ebs_target);
>
> @@ -430,7 +430,7 @@ int __init dm_ebs_init(void)
>   	return r;
>   }
>
> -void dm_ebs_exit(void)
> +static void dm_ebs_exit(void)
>   {
>   	dm_unregister_target(&ebs_target);
>   }
> --
> 2.26.0.106.g9fadedd
>

Acked, thanks.

Heinz

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
