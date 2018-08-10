From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: don't decrease device limits
Date: Fri, 10 Aug 2018 12:11:41 -0400
Message-ID: <20180810161141.GB22384@redhat.com>
References: <alpine.LRH.2.02.1808101123110.16981@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1808101123110.16981@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 10 2018 at 11:23am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> dm-crypt should only increase device limits, it should not decrease them.
> 
> This fixes a bug where the user could create a crypt device with 1024
> sector size on the top of scsi device that had 4096 logical sectors. The
> limit 4096 would be lost and the user could incorrectly send 1024-I/Os to
> the crypt device.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-crypt.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-crypt.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-crypt.c	2018-08-10 15:02:26.700000000 +0200
> +++ linux-2.6/drivers/md/dm-crypt.c	2018-08-10 15:28:02.170000000 +0200
> @@ -3072,11 +3072,9 @@ static void crypt_io_hints(struct dm_tar
>  	 */
>  	limits->max_segment_size = PAGE_SIZE;
>  
> -	if (cc->sector_size != (1 << SECTOR_SHIFT)) {
> -		limits->logical_block_size = cc->sector_size;
> -		limits->physical_block_size = cc->sector_size;
> -		blk_limits_io_min(limits, cc->sector_size);
> -	}
> +	limits->logical_block_size = max(limits->logical_block_size, cc->sector_size);
> +	limits->physical_block_size = max(limits->physical_block_size, (unsigned)cc->sector_size);
> +	blk_limits_io_min(limits, cc->sector_size);
>  }
>  
>  static struct target_type crypt_target = {

tweaked and staged for 4.19 here:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.19&id=08575fd060d7f88f674509461b32d86b272093d9

I switched to using max_t() and stacked io_min rather than impose that
it is cc->sector_size.
