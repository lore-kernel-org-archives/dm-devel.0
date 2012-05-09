From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thin f.req. : SEEK_DATA / SEEK_HOLE / SEEK_DISCARD
Date: Wed, 9 May 2012 08:55:46 +0100
Message-ID: <20120509075543.GA6235@ubuntu>
References: <4F9FDCC2.2080905@shiftmail.org> <20120501141023.GA20313@ubuntu>
	<4FA006CD.3050204@shiftmail.org> <20120503091428.GB5351@ubuntu>
	<4FA40F04.8040006@shiftmail.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4FA40F04.8040006@shiftmail.org>
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

On Fri, May 04, 2012 at 07:16:52PM +0200, Spelic wrote:
> On 05/03/12 11:14, Joe Thornber wrote:
> >On Tue, May 01, 2012 at 05:52:45PM +0200, Spelic wrote:
> >>I'm looking at it right now
> >>Well, I was thinking at a parent snapshot and child snapshot (or
> >>anyway an older and a more recent snapshot of the same device) so
> >>I'm not sure that's the feature I needed... probably I'm missing
> >>something and need to study more
> >I'm not really following you here.  You can have arbitrary depth of
> >snapshots (snaps of snaps) if that helps.
> 
> I'm not following you either (you pointed me to the external
> snapshot feature but this would not be an "external origin"
> methinks...?),

Yes, it's a snapshot of an external origin.

> With your implementation there's the problem of fragmentation and
> RAID alignment vs discards implementation.

This is always going to be an issue with thin provisioning.

> (such as one RAID stripe), block unmapping on discards is not likely
> to work because one discard per file would be received but most
> files would be smaller than a thinpool block (smaller than a RAID
> stripe: in fact it is recommended that the raid chunk is made equal
> to the prospected average file size so average file size and average
> discard size would be 1/N of the thinpool block size) so nothing
> would be unprovisioned.

You're right.  In general discard is an expensive operation (on all
devices, not just thin), so you want to use it infrequently and on
large chunks.  I suspect that most people, rather than turning on
discard withing the file system, will just periodically run a cleanup
program that inspects the fs and discards unused blocks.

> There would be another way to do it (pls excuse my obvious arrogance
> and I know I should write code instead of write emails) two layers:
> blocksize for provisioning is e.g. 64M (this one should be
> customizable like you have now), while blocksize for tracking writes
> and discards is e.g. 4K. You make the btree only for the 64M blocks,
> and inside that you keep 2 bitmaps for tracking its 16384
> 4K-blocks.

Yes, we could track discards and aggregate them into bigger blocks.
Doing so would require more metadata, and more commits (which are
synchronous operations).  The 2 blocks size approach has a lot going
for it, but it does add a lot of complexity - I deliberately kept thin
simple.  One concern I have is that it demotes the snapshots to second
class citizens since they're composed of the smaller blocks and will
not have the adjacency properties of the thin that is provisioned
solely with big blocks.  I'd rather just do the CoW on the whole
block, and boost performance by putting an SSD (via a caching target)
in front of the data device.  That way the CoW would complete
v. quickly, and could be written back to the device slowly in the
background iff it's infrequently used.

- Joe
