From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm snapshot: add discard support to the
 snapshot-origin target [was: Re: Testing TRIM with LVM]
Date: Tue, 26 Apr 2011 13:32:14 -0400
Message-ID: <20110426173213.GA19604@redhat.com>
References: <20110412234706.GA11244@redhat.com>
	<20cf301cbef67d323104a0c2ff52@google.com>
	<20110413224025.GA18589@redhat.com>
	<20110413234854.GA19793@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110413234854.GA19793@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: DarkNovaNick@gmail.com
Cc: dm-devel@redhat.com, LVM general discussion and development <linux-lvm@redhat.com>
List-Id: dm-devel.ids

On Wed, Apr 13 2011 at  7:48pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Apr 13 2011 at  6:40pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
> > Unfortunately, the failed discard to the snapshot-origin device disables
> > ext4's discards for the entire volume (even after you remove the
> > snapshot).
> > 
> > But the following patch fixes that:
> > 
> > Subject: dm snapshot: add discard support to the snapshot-origin target
> > 
> > Allow the snapshot-origin target to pass discards to the origin device
> > (after any copyout of the region being discarded; but generally speaking
> > that copyout won't be needed as the region will have already been copied
> > to the cow).
> > 
> > So for example, when you remove a file from an ext4 mounted origin
> > volume it triggers copyout to the snapshot.  When the DISCARD is then
> > issued during the subsequent journal commit no copyout is needed.
> 
> It should be noted that discards are treated as writes.  This means that
> a snapshot should not be taken of an origin volume before a filesystem
> is placed on that origin.  Doing so may result in the entire origin
> volume being discarded (mkfs.ext4 does this) which would cause copyout
> of the entire origin volume to the snapshot.

Just a quick follow-up.  We had a discussion on snapshot-origin discard
support and arrived at this needing to be done in 2 steps:
1) have snapshot-origin ignore discard but return success
2) process the discard, discard treated as a write to the origin, if
   user passes an option to enable it

The concern is that the patch I proposed can break existing scripts that
create filesystems on pristine origin devices (that have a snapshot(s)).
Instead of only copying out the various minimalist changes that mkfs
does (when discard isn't used) the entire origin device would be copied
out (when the entire device is discarded early in mkfs.ext4).

I'll circle back to working on this in a few weeks (the annoying bit is
the userspace change to make the snapshot-origin's discard behavior
configurable via lvcreate -s --enable-origin-discards ...; maybe someone
else will get to it before I do :)

Mike
