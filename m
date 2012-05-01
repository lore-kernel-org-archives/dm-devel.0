From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thin f.req. : SEEK_DATA / SEEK_HOLE / SEEK_DISCARD
Date: Tue, 1 May 2012 15:10:24 +0100
Message-ID: <20120501141023.GA20313@ubuntu>
References: <4F9FDCC2.2080905@shiftmail.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4F9FDCC2.2080905@shiftmail.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, May 01, 2012 at 02:53:22PM +0200, Spelic wrote:
> Dear dm-thin developers,
> I thought that it would be immensely useful to have a SEEK_DATA /
> SEEK_HOLE implementation for dm-thin and/or even for the older
> non-thin snapshotting mechanism.
> This would allow to implement a mechanism like the acclaimed "zfs
> send" with dm snapshots, i.e. cheaply replicate a thin snapshot
> remotely once the parent snapshot has been replicated already.
> Extremely useful imho.
> Is there any plan to do that?

I'm planning to do replication via userland.  There's a new message
that allows userland to access a read-only copy of the metadata.  From
this, and using some intermediate snapshots we can work out what data
is changing and replicate it (asynchronously).

> The "HOLE" would mean "data comes from parent snapshot/device",
> while DATA is "data that has changed since the parent snapshot".

This sounds like the external snapshots feature that I just added.
See documentation in latest kernel.

> Another question / feature request: I would like to know if reading
> an area of a thin device after a discard is guaranteed to return
> zeroes (and/or can be identified as empty from userspace via a
> seek_data / seek_hole or equivalent mechanism).

A great question.  If the discard exactly covers some dm-thin blocks,
then the mappings will be removed.  Any future io to that block will
trigger the block to be reprovisioned.  Depending whether you've set
the block zeroing flag in the pool, you are guaranteed to have zeroes
come out.

Any partial block discards will get passed down to the underlying data
device (assuming you've selected that option).  Any zeroing side
effects depend on the underlying device.

As for identifying empty blocks from userland: there is an inherant
race here.  What would you do with the info?

- Joe
