From: Dave Chinner <david@fromorbit.com>
Subject: Re: [dm-devel] [RFC PATCH] block: xfs: dm thin: train XFS to give up
	on retrying IO if thinp is out of space
Date: Fri, 24 Jul 2015 09:05:09 +1000
Message-ID: <20150723230509.GD3902@dastard>
References: <20150720151849.GA2282@redhat.com> <20150720223610.GV7943@dastard>
	<55AE6670.40903@redhat.com> <20150721174753.GA8563@redhat.com>
	<20150722000923.GB7943@dastard> <20150722010056.GC7943@dastard>
	<alpine.LRH.2.02.1507231306160.16526@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1507231306160.16526@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: axboe@kernel.dk, Eric Sandeen <sandeen@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, hch@lst.de, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 23, 2015 at 01:08:36PM -0400, Mikulas Patocka wrote:
> On Wed, 22 Jul 2015, Dave Chinner wrote:
> > On Wed, Jul 22, 2015 at 10:09:23AM +1000, Dave Chinner wrote:
> > > On Tue, Jul 21, 2015 at 01:47:53PM -0400, Mike Snitzer wrote:
> > > | $ cat
> > > | /sys/fs/xfs/vda/meta_write_errors/enospc/transient_fail_at_umount
> > > | 1

[...]

> You can just stop retrying the I/Os when the user attempts to unmount the 
> filesystem - then, you don't need any configuration option.

See above - the default will do that, but there are users who do not
want that unmount behaviour....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
