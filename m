From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V3 06/14] kpartx: check return value of
 malloc in main func
Date: Tue, 08 Sep 2020 16:25:11 +0200
Message-ID: <f13f55dcfdf6a17702c1c4a3b61b6956e68e0b91.camel@suse.com>
References: <2fb59aa1-eafa-49b6-08aa-a279565ec234@huawei.com>
	<686d0ca6-2bbf-095d-63bc-346ca609061a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <686d0ca6-2bbf-095d-63bc-346ca609061a@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Tue, 2020-09-08 at 16:49 +0800, lixiaokeng wrote:
> In main func of kpartx.c, we should check return value of
> malloc before using it.
> 
> V1->V2: change malloc to xmalloc
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> ---
>  kpartx/kpartx.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index 98f6176e..6de3c9c4 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -61,6 +61,9 @@ struct pt {
>  int ptct = 0;
>  int udev_sync = 1;
> 
> +extern void *
> +xmalloc (size_t size);
> +

Please don't use "extern". It's misleading, because this function is
defined in the same file. You should actually change xmalloc() to a
static function.

Regards,
Martin
