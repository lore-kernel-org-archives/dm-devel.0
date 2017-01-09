From: Christoph Hellwig <hch@infradead.org>
Subject: Re: trouble with generic/081
Date: Mon, 9 Jan 2017 07:01:26 -0800
Message-ID: <20170109150126.GA7501@infradead.org>
References: <20161216081523.GA13847@infradead.org>
	<5806882c-4807-cb2a-80dd-147de5bf176a@sandeen.net>
	<a0c8e06f-db87-393b-419d-d6f8c345fbc8@redhat.com>
	<86b3a61e-5088-4614-1a27-60a5d095ee24@sandeen.net>
	<577228bb-523c-2dbf-1387-e1cb03d07905@redhat.com>
	<18e7613b-5a83-d802-a38f-35a9a604fdb3@sandeen.net>
	<7b8fa79f-89f8-bb9a-a2fc-8a3b966a877d@redhat.com>
	<20170105224600.GC4326@dastard>
	<20170109133919.GB19577@infradead.org>
	<15605149-0590-1555-6522-38d2eff69026@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <15605149-0590-1555-6522-38d2eff69026@redhat.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, dm-devel@redhat.com, Dave Chinner <david@fromorbit.com>, eguan@redhat.com
List-Id: dm-devel.ids

On Mon, Jan 09, 2017 at 03:22:00PM +0100, Zdenek Kabelac wrote:
> lvm2 will initiate lazy umount of ALL thin devices from a thin-pool
> when it gets about 95% fullness  (so it's a bit sooner then 100%
> with still some 5% 'free-space'.

Yes, and we want this not to be done.  Not for XFS and not for any
other file system.  umounting is something neither lvm nor the
filesystem should do, but instead the administrator.

> So it should get into EXACT same state as  is advocated here - do nothing
> case - without invoking 'lazy umount' but significantly later
> (so IMHO causing possibly more damage to a user).

The lazy unmount does not help.  If LVM want to give the fs a headups
about running out of space please do so, this would be useful as we
could then do sensible things, like doing a discard of all free blocks
or an explicit, early fs shutdown.  But don't just lazy unmount the fs
which only creates lots of problems.

> But could anyone from XFS specify -  why  umount is causing some 'more'
> damage, then  no umount at all ?

It is causing damage because unmount cause additional I/O, at a point
where we possibly might not want more I/O.  It also doesn't let the
file system to do useful things.  And last but not least it changes the
namespace (aka mount topology) in an absolutely unexpected way, which
might even introduce security issues because now users could write
into otherwise hidden directories in the parent mountpoint.

> Also please note - since its mentioned namespaces here - if this is
> something Docker related - be aware for Docker thins  - lvm2 for awhile is
> leaving such volumes intact already (-> no umount for docker thins volume).

The filesystem namespace has nothing to do with docker at all.
