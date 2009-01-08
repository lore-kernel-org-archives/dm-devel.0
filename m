From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [2.6.29 PATCH 01] dm table: rework reference counting
	fix
Date: Thu, 8 Jan 2009 14:36:02 -0600
Message-ID: <811CE9C9-6716-45B7-A7E2-80E60C0A9FB6@redhat.com>
References: <20090107131403.GS5098@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090107131403.GS5098@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>

  brassow

On Jan 7, 2009, at 7:14 AM, Alasdair G Kergon wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
>
> Fix an error introduced in dm-table-rework-reference-counting.patch.
>
> When there is failure after table initialization, we need to use
> dm_table_destroy, not dm_table_put, to free the table.
>
> dm_table_put may be used only after dm_table_get.
>
> Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> ---
> drivers/md/dm-ioctl.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-2.6.28/drivers/md/dm-ioctl.c
> ===================================================================
> --- linux-2.6.28.orig/drivers/md/dm-ioctl.c	2009-01-06  
> 15:07:04.000000000 +0000
> +++ linux-2.6.28/drivers/md/dm-ioctl.c	2009-01-06 21:36:12.000000000  
> +0000
> @@ -1064,7 +1064,7 @@ static int table_load(struct dm_ioctl *p
>
> 	r = populate_table(t, param, param_size);
> 	if (r) {
> -		dm_table_put(t);
> +		dm_table_destroy(t);
> 		goto out;
> 	}
>
> @@ -1072,7 +1072,7 @@ static int table_load(struct dm_ioctl *p
> 	hc = dm_get_mdptr(md);
> 	if (!hc || hc->md != md) {
> 		DMWARN("device has been removed from the dev hash table.");
> -		dm_table_put(t);
> +		dm_table_destroy(t);
> 		up_write(&_hash_lock);
> 		r = -ENXIO;
> 		goto out;
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
