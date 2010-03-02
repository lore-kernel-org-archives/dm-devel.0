From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 14/14] dm-multisnap-daniel
Date: Tue, 2 Mar 2010 09:57:31 +0900
Message-ID: <20100302095648E.fujita.tomonori@lab.ntt.co.jp>
References: <1267489438-6271-1-git-send-email-snitzer@redhat.com>
	<1267489438-6271-15-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1267489438-6271-15-git-send-email-snitzer@redhat.com>
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
Cc: mpatocka@redhat.com
List-Id: dm-devel.ids

On Mon,  1 Mar 2010 19:23:58 -0500
Mike Snitzer <snitzer@redhat.com> wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> An implementation of snapshot store.
> Designed by Daniel Phillips, ported to kernelspace by Fujita Tomonorig.

Thanks for putting my name here, however, I prefer "Fujita Tomonori" :)


> This implementation plugs as a module into dm-multisnapshot interface.
> 
> The interface is almost the same as in Mikulas' exception store. You have to
> specify "daniel" instead of "mikulas" as a type of exception store.
> The only supported chunk size is 16384 bytes (but the code is general enough and
> this restriction may be removed in the future).
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> ---
>  drivers/md/Kconfig               |   14 +
>  drivers/md/Makefile              |    2 +
>  drivers/md/dm-multisnap-daniel.c | 1711 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1727 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/md/dm-multisnap-daniel.c
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 0c3ce3b..c30bf70 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -268,6 +268,20 @@ config DM_MULTISNAPSHOT_MIKULAS
>  	  A B+-tree-based log-structured storage allowing unlimited
>  	  number of snapshots.
>  
> +config DM_MULTISNAPSHOT_DANIEL
> +	tristate "Daniel's snapshot store"
> +	depends on DM_MULTISNAPSHOT
> +	---help---
> +	  Daniel Philips' exception store. The data structures were
> +	  designed by Daniel Phillips for Zumastore project, a porting
> +	  to kernel space was done by Fujita Tomonorig.

s/Tomonorig/Tomonori/;


(snip)

> +static int __init dm_multisnapshot_daniel_module_init(void)
> +{
> +	return dm_multisnap_register_exception_store(&dm_multisnap_daniel_store);
> +}
> +
> +static void __exit dm_multisnapshot_daniel_module_exit(void)
> +{
> +	dm_multisnap_unregister_exception_store(&dm_multisnap_daniel_store);
> +}
> +
> +module_init(dm_multisnapshot_daniel_module_init);
> +module_exit(dm_multisnapshot_daniel_module_exit);
> +
> +MODULE_DESCRIPTION(DM_NAME " multisnapshot Fujita/Daniel's exceptions store");
> +MODULE_AUTHOR("Fujita Tomonorig, Daniel Phillips");

s/Tomonorig/Tomonori/;

> +MODULE_LICENSE("GPL");


Thanks,
