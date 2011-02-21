From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] Fix over-zealous flush_disk when changing
	device size.
Date: Mon, 21 Feb 2011 14:36:01 -0500
Message-ID: <x49hbbx18pq.fsf@segfault.boston.devel.redhat.com>
References: <20110217165057.5c50e566@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110217165057.5c50e566@notabene.brown> (NeilBrown's message of
	"Thu, 17 Feb 2011 16:50:57 +1100")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, dm-devel@redhat.com, Andrew Patterson <andrew.patterson@hp.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

NeilBrown <neilb@suse.de> writes:

> -int __invalidate_device(struct block_device *bdev)
> +int __invalidate_device2(struct block_device *bdev, bool kill_dirty)
>  {
>  	struct super_block *sb = get_super(bdev);
>  	int res = 0;
> @@ -1614,7 +1614,7 @@ int __invalidate_device(struct block_device *bdev)
>  		 * hold).
>  		 */
>  		shrink_dcache_sb(sb);
> -		res = invalidate_inodes(sb);
> +		res = invalidate_inodes(sb, kill_dirty);
>  		drop_super(sb);
>  	}
>  	invalidate_bdev(bdev);

Neil, I think you also need to change the EXPORT_SYMBOL from
__invalidate_device to __invalidate_device2.  The floppy module won't
build without that change.

Cheers,
Jeff
