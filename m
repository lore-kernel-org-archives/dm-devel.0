From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm snapshot: add discard support to the
 snapshot-origin target [was: Re: Testing TRIM with LVM]
Date: Wed, 13 Apr 2011 19:48:54 -0400
Message-ID: <20110413234854.GA19793@redhat.com>
References: <20110412234706.GA11244@redhat.com>
	<20cf301cbef67d323104a0c2ff52@google.com>
	<20110413224025.GA18589@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110413224025.GA18589@redhat.com>
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

On Wed, Apr 13 2011 at  6:40pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Apr 12 2011 at  9:47pm -0400,
> DarkNovaNick@gmail.com <DarkNovaNick@gmail.com> wrote:
> 
> > I get 0 back when I do "cat
> > /sys/block/sda/queue/discard_zeroes_data" so does this mean that my
> > drive doesn't zero out the TRIMed blocks? I don't really care if it
> > does or does not, I just want to make sure the drive is getting the
> > TRIM commands as the benchmarks I've seen show performance
> > degradation if they aren't used.
> 
> Right, means TRIM doesn't zero the TRIM'd blocks.
> 
> But otherwise it looks like you're in good shape relative to TRIM.
>  
> > Regarding snapshot targets, the only instance of "discard not
> > supported" came as I did a snapshot today:
> > 
> > Apr 12 15:27:58 darknovanick kernel: [65147.211211] EXT4-fs warning
> > (device dm-0): release_blocks_on_commit:2672: discard not supported,
> > disabling
> > Apr 12 15:28:16 darknovanick kernel: [65166.103061] EXT4-fs (dm-1):
> > 72 orphan inodes deleted
> > Apr 12 15:28:16 darknovanick kernel: [65166.103062] EXT4-fs (dm-1):
> > recovery complete
> > Apr 12 15:28:17 darknovanick kernel: [65166.232257] EXT4-fs (dm-1):
> > mounted filesystem with ordered data mode. Opts: (null)
> > 
> > This snapshot was of a LV on the SSD, but the snapshot itself was
> > being stored on a mechanical hard drive. Does this message mean that
> > discard was just disabled for the snapshot itself (which was deleted
> > a half hour later), or is it now disabled for the entire volume now
> > that I've done a snapshot, even though its been removed?
> 
> Unfortunately, the failed discard to the snapshot-origin device disables
> ext4's discards for the entire volume (even after you remove the
> snapshot).
> 
> But the following patch fixes that:
> 
> Subject: dm snapshot: add discard support to the snapshot-origin target
> 
> Allow the snapshot-origin target to pass discards to the origin device
> (after any copyout of the region being discarded; but generally speaking
> that copyout won't be needed as the region will have already been copied
> to the cow).
> 
> So for example, when you remove a file from an ext4 mounted origin
> volume it triggers copyout to the snapshot.  When the DISCARD is then
> issued during the subsequent journal commit no copyout is needed.

It should be noted that discards are treated as writes.  This means that
a snapshot should not be taken of an origin volume before a filesystem
is placed on that origin.  Doing so may result in the entire origin
volume being discarded (mkfs.ext4 does this) which would cause copyout
of the entire origin volume to the snapshot.

Mike
