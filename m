From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Re: [PATCH v2] dm: add topology support
Date: Wed, 10 Jun 2009 18:06:36 -0400
Message-ID: <yq1k53j68wj.fsf@sermon.lab.mkp.net>
References: <1244524492-2292-1-git-send-email-snitzer@redhat.com>
	<yq1ski860ok.fsf@sermon.lab.mkp.net>
	<20090610140028.GD25088@redhat.com>
	<yq1ocsw55t6.fsf@sermon.lab.mkp.net>
	<20090610211235.GF25088@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090610211235.GF25088@redhat.com> (Mike Snitzer's message of
	"Wed, 10 Jun 2009 17:12:36 -0400")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

>>>>> "Mike" =3D=3D Mike Snitzer <snitzer@redhat.com> writes:

Mike> When a table is pushed to DM each target device in the table may
Mike> have different limits.  There is no one-size-fits-all default.

But incrementally finding the one size that does fit all (DM dev as well
as targets) is the raison d'=C3=AAtre for blk_stack_limits().

The default limits should all be set by the block layer when setting up
the request queue.  So my reason for inquiring was to figure out whether
check_for_valid_limits() actually makes any difference?


Mike> With DM, the underlying device that you're sending IO to is a
Mike> function of offset into the DM device.  Therefore, the associated
Mike> IO limits should really be a function of offset.

This was one of the discussion topics at the Storage and Filesystems
workshop a couple of months ago.  My original topology code actually
permitted a list of topologies for a block device.  With all that
entails of nightmares splicing and dicing lists in the stacking
function.  It was not pretty, and the general consensus at the workshop
was that this was way too complex.  I agreed and the code was gutted.

And even having a topology list failed to correctly describe some valid
configurations.  One pathological case is having a 512-byte
logical/physical in a mirror with a 512/4KB odd-aligned one.  How do you
define a topology for that?  The solution is to adjust the alignment and
scale up io_min to match the 4K drive.  I.e. to change things for the
drive that isn't the "problem".


Mike> That means we use a device's alignment_offset in userland LVM2 to
Mike> push down a data area whose start+size is aligned.  This gives us
Mike> the guarantee that each device in a given DM table is aligned.

*nod*


Mike> But blk_stack_limits() leads to a situation where the combined
Mike> limits (io_min, logical_block_size) are not ideal for all offsets
Mike> into the resulting DM device (e.g. issuing larger IOs to some
Mike> target devices than would otherwise be needed).

Yup.  But not smaller.  That's the whole point.  Making sure we align to
the lowest common denominator and never incur a read-modify-write cycle
on any storage device.

--=20
Martin K. Petersen	Oracle Linux Engineering
