From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 8/17] bottom-layer barrier support
Date: Mon, 27 Apr 2009 20:02:22 +0100
Message-ID: <20090427190222.GE23302@agk.fab.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 20, 2009 at 03:58:20AM -0400, Mikulas Patocka wrote:
> dm-flush-make-empty-barrier.patch
> Modify dm_flush so that is passes empty barrier flushes to the targets.
 
> +	md->barrier_bio.bi_bdev = md->bdev;

There is no md->bdev in my tree - have I missed a dependency here?

Alasdair
-- 
agk@redhat.com
