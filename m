From: Dave Chinner <david@fromorbit.com>
Subject: Re: trouble with generic/081
Date: Fri, 6 Jan 2017 09:46:00 +1100
Message-ID: <20170105224600.GC4326@dastard>
References: <20161215063650.GJ4326@dastard>
	<20161215084224.GA14395@infradead.org>
	<c05b64b6-80d3-655d-db9b-6f49038e53ee@redhat.com>
	<20161216081523.GA13847@infradead.org>
	<5806882c-4807-cb2a-80dd-147de5bf176a@sandeen.net>
	<a0c8e06f-db87-393b-419d-d6f8c345fbc8@redhat.com>
	<86b3a61e-5088-4614-1a27-60a5d095ee24@sandeen.net>
	<577228bb-523c-2dbf-1387-e1cb03d07905@redhat.com>
	<18e7613b-5a83-d802-a38f-35a9a604fdb3@sandeen.net>
	<7b8fa79f-89f8-bb9a-a2fc-8a3b966a877d@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <7b8fa79f-89f8-bb9a-a2fc-8a3b966a877d@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Eric Sandeen <sandeen@sandeen.net>, eguan@redhat.com
List-Id: dm-devel.ids

On Thu, Jan 05, 2017 at 10:12:25PM +0100, Zdenek Kabelac wrote:
> Dne 5.1.2017 v 20:29 Eric Sandeen napsal(a):
> >On 1/5/17 1:13 PM, Zdenek Kabelac wrote:
> >>>Anyway, at this point I'm not convinced that anything but the filesystem
> >>>should be making decisions based on storage error conditions.
> >>
> >>So far I'm not convinced  doing nothing is better then trying at least unmount.
> >>
> >>Since doing nothing is known to cause  SEVERE filesystem damages,
> >>while I've haven't heard about them when 'unmount' is in the field.
> >
> >I'm pretty sure that's exactly what started this thread.  ;)
> >
> >Failing IOs should never cause "severe filesystem damage" - that is what
> >a journaling filesystem is /for/.  Can you explain further?
> 
> well all I know are user reports - which we capable to use 'XFS'
> with exhausted  thin-pool while  having 'snapshots' of their volumes.
> 
> Since there was no 'umount' and  XFS upon write error just retried
> endlessly to write block over and over -  system appeared

Which has already been fixed upstream.

And my 2c worth on the "lvm unmounting filesystems on error" - stop
it, now. It's the wrong thing to do, and it makes it impossible for
filesystems to handle the error and recover gracefully when
possible.

> to the users nice & usable for quite long time (especially when
> boxes had 32G of RAM or more...)
> 
> Maybe writes passed to 'uniquely' owned blocs....
> 
> Then after some day,two,free   OOM finally killed.
> Users realized thin-pool was out-of-space - added room to VG and pool
> and tried  xfs_repair - but whole FS was largely lost.

That sounds very much like a block device snapshot corruption
problem, not a filesystem problem. As always, the filesystem gets
blamed for data loss, regardless of where the problem really lies.

> Use  LV and make some thin snapshots.
> 
> Then change various parts of origin - at various moment before pool
> is out-of-space
> 
> So you will get lots of different scenarios of missing data.
> 
> You will mostly not get into those mentioned trouble if you
> have just single thinLV and you exhaust thin-pool while using it.
> 
> Games with snapshot are needed.

This really sounds like a problem with snapshot ENOSPC error
handling, not a filesystem issue - the filesystem is simply the
messenger here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
