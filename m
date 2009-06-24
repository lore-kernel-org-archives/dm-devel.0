From: Neil Brown <neilb@suse.de>
Subject: Re: DM-RAID1 data corruption
Date: Wed, 24 Jun 2009 13:03:26 +1000
Message-ID: <19009.38782.225681.85214@notabene.brown>
References: <Pine.LNX.4.64.0904141618220.701@hs20-bc2-1.build.redhat.com>
	<20090415031210.GA11881@us.ibm.com> <49E645DA.4010204@redhat.com>
	<20090416024959.GB19876@us.ibm.com> <49E7B029.20906@redhat.com>
	<Pine.LNX.4.64.0904200552590.27291@hs20-bc2-1.build.redhat.com>
	<20090623010930.GA13392@us.ibm.com> <4A41065D.10804@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Takahiro Yasui on Tuesday June 23
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: mpatocka@redhat.com
List-Id: dm-devel.ids

On Tuesday June 23, tyasui@redhat.com wrote:
> >> MD-RAID1 solves this problem by having counters in superblocks on both 
> >> legs. If some leg dies, the counter on the other devices is increased. If 
> >> the dead disk comes online again, it is found that it has old counter and 
> >> cannot be trusted.
> >>
> >> Would it be possible to extend a logical volume when converting it to a 
> >> raid1 and use the last area of the volume as a superblock?
> >>
> >> Mikulas
> > 
> > This is an old thread, I am just trying to revitalize it! :-) How about
> > dm-raid1 taking superblock storage as arguments in the command line,
> > just like the log device? The superblock storage is entirely managed by
> > the kernel, LVM just allocates it. Error handling can be instant this
> > way. LVM can auto convert the exiting mirrors to this kind of mirrors if
> > space is available.
> 
> Interesting idea. The superblock storage managed by kernel is really
> important to handle an error quickly inside the kernel.

I don't think that it is important to handle errors quickly - they
really shouldn't happen often enough that speed is an issue.  All you
need to do is handle errors correctly.

I would suggest that you simply get raid1 to block any write requests
until all drive failures have been acknowledged by userspace.
So you would need to differentiate between an acknowledged drive
failure and an unacknowledged failure.  Writes block when ever there
are unacknowledged failures.
Then you need a message that can be sent to the raid1 to acknowledge
the failure of a particular device.
'suspend' would need to fail if there are any unacknowledged failures
as otherwise it would block.

NeilBrown
