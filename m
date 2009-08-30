From: Andras Korn <korn-dmdevel@elan.rulez.org>
Subject: Reverting/merging an LVM snapshot - possible?
Date: Sun, 30 Aug 2009 21:47:16 +0200
Message-ID: <20090830194716.GN25876@hellgate.intra.guy>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: mingo@elte.hu
List-Id: dm-devel.ids

Hi,

this has already been brought up earlier and elsewhere, but afaict nothing
conclusive came of it.

Is there a good, efficient way to "revert" an origin volume to the state
reflected by a snapshot? (I put "revert" in quotes because the snapshot
might have been modified since it was taken; maybe "merge" would be a more
correct term.)

Traditional wisdom seems to hold that if you expect the need to revert,
don't write to the origin volume at all; write to the snapshot instead. This
is mostly well and good if you do expect the need to revert.

However, imagine for example a scenario where you're testing a complex-ish
software upgrade. It might work, or it might not. You can either first try
on a snapshot, or on the origin volume. If you try on a snapshot and it
works, you want to "revert" (or, in this case, apply the changes to) the
origin volume. Otoh, if you test on the origin volume and the upgrade fails,
you want to restore it to the state it was in when the snapshot was taken.

Just copying the files, or dd'ing from the snapshot to the origin volume is
inefficient and will even fail if the snapshot is not somewhat larger than
the origin volume (if the snapshot has exactly the same amount of physical
extents as the origin volume, then it still doesn't have space for all
sectors of the origin volume because it also needs to store quite a bit of
metadata).

Ideally, reverting the origin volume would also free up space in the
snapshot.

So, I believe what is missing is a clever user-space tool that does the
reverting/merging and some kernel functionality to mark all relevant areas
in all relevant snapshots as "free" again.

Am I missing something? Is this functionality, perhaps, already there?

Andras

-- 
 Andras Korn <korn at elan.rulez.org> - <http://chardonnay.math.bme.hu/~korn/>
           Contrary to popular opinion, God's last name isn't Damn.
