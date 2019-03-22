From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH -next] dm integrity: Make dm_integrity_init
 and dm_integrity_exit static
Date: Fri, 22 Mar 2019 15:56:09 +0100
Message-ID: <a238ebca-7e1a-e3e0-ea3a-79cd0135b6e0@redhat.com>
References: <20190322141634.20664-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190322141634.20664-1-yuehaibing@huawei.com>
Content-Language: en-MW
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 3/22/19 3:16 PM, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
>
> Fix sparse warnings:
>
> drivers/md/dm-integrity.c:3619:12: warning:
>   symbol 'dm_integrity_init' was not declared. Should it be static?
> drivers/md/dm-integrity.c:3638:6: warning:
>   symbol 'dm_integrity_exit' was not declared. Should it be static?


Yes, both should be static.

Once on it, declare 'static void __exit dm_integrity_exit(void);'

Heinz


>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/md/dm-integrity.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index d57d997..0932c32 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -3616,7 +3616,7 @@ static struct target_type integrity_target = {
>   	.io_hints		= dm_integrity_io_hints,
>   };
>   
> -int __init dm_integrity_init(void)
> +static int __init dm_integrity_init(void)
>   {
>   	int r;
>   
> @@ -3635,7 +3635,7 @@ int __init dm_integrity_init(void)
>   	return r;
>   }
>   
> -void dm_integrity_exit(void)
> +static void dm_integrity_exit(void)
>   {
>   	dm_unregister_target(&integrity_target);
>   	kmem_cache_destroy(journal_io_cache);
