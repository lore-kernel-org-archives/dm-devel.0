From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] dm verity fec: Fix memory leak in
 verity_fec_ctr
Date: Wed, 18 Mar 2020 16:44:27 +0100
Message-ID: <a96e4bee-598f-a565-e9c6-10883d723c9d@redhat.com>
References: <20200317091212.GA18241@harshini.x.shetty@sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200317091212.GA18241@harshini.x.shetty@sony.com>
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
To: "Shetty, Harshini X (EXT-Sony Mobile)" <Harshini.X.Shetty@sony.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "Takeuchi, Shingo (SOMC)" <Shingo.Takeuchi@sony.com>, "Khasnis,
	Soumya X (EXT-Sony Mobile)" <Soumya.Khasnis@sony.com>, "Nagaraju, Srinavasa (SOMC)" <Srinavasa.Nagaraju@sony.com>, "Takahashi, Masaya (SOMC)" <Masaya.Takahashi@sony.com>
List-Id: dm-devel.ids

Once we are on this, we should put conditionals on those mempool_exit 
and kmem_cache_destroy
calls in the fec dtr, because the target calls that destructor at any 
time on its error path thus part
of the pools or even the cache won't be defined.

Heinz

On 3/17/20 10:15 AM, Shetty, Harshini X (EXT-Sony Mobile) wrote:
> Fix below kmemleak detected in verity_fec_ctr.
> output_pool is allocated for each dm-target device.
> But it is not freed when dm-table for the target
> is removed.Hence Free the output buffer in destructor
> function verity_fec_dtr
>
> unreferenced object 0xffffffffa574d000 (size 4096):
>    comm "init", pid 1667, jiffies 4294894890 (age 307.168s)
>    hex dump (first 32 bytes):
>      8e 36 00 98 66 a8 0b 9b 00 00 00 00 00 00 00 00  .6..f...........
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<0000000060e82407>] __kmalloc+0x2b4/0x340
>      [<00000000dd99488f>] mempool_kmalloc+0x18/0x20
>      [<000000002560172b>] mempool_init_node+0x98/0x118
>      [<000000006c3574d2>] mempool_init+0x14/0x20
>      [<0000000008cb266e>] verity_fec_ctr+0x388/0x3b0
>      [<000000000887261b>] verity_ctr+0x87c/0x8d0
>      [<000000002b1e1c62>] dm_table_add_target+0x174/0x348
>      [<000000002ad89eda>] table_load+0xe4/0x328
>      [<000000001f06f5e9>] dm_ctl_ioctl+0x3b4/0x5a0
>      [<00000000bee5fbb7>] do_vfs_ioctl+0x5dc/0x928
>      [<00000000b475b8f5>] __arm64_sys_ioctl+0x70/0x98
>      [<000000005361e2e8>] el0_svc_common+0xa0/0x158
>      [<000000001374818f>] el0_svc_handler+0x6c/0x88
>      [<000000003364e9f4>] el0_svc+0x8/0xc
>      [<000000009d84cec9>] 0xffffffffffffffff
>
> Signed-off-by: Harshini Shetty <harshini.x.shetty@sony.com>
> ---
>   drivers/md/dm-verity-fec.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
> index 3ceeb6b..49147e6 100644
> --- a/drivers/md/dm-verity-fec.c
> +++ b/drivers/md/dm-verity-fec.c
> @@ -551,6 +551,7 @@ void verity_fec_dtr(struct dm_verity *v)
>   	mempool_exit(&f->rs_pool);
>   	mempool_exit(&f->prealloc_pool);
>   	mempool_exit(&f->extra_pool);
> +	mempool_exit(&f->output_pool);
>   	kmem_cache_destroy(f->cache);
>   
>   	if (f->data_bufio)
