From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_btree_cur leak with 3.5-rc4
Date: Tue, 3 Jul 2012 10:26:11 +1000
Message-ID: <20120703002611.GW19223@dastard>
References: <20120702191412.GA3617@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20120702191412.GA3617@redhat.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, xfs@oss.sgi.com
List-Id: dm-devel.ids

On Mon, Jul 02, 2012 at 03:14:12PM -0400, Mike Snitzer wrote:
> I get kmemleak reports against XFS when I run the thinp-test-suite
> against 3.5-rc4.  I didn't see any XFS leaks with 3.4.

Already fixed in 3.5-rc5:

76d0953 xfs: fix allocbt cursor leak in xfs_alloc_ag_vextent_near

Thanks for reporting it, though, Mike.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
