From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: DM-RAID1 data corruption
Date: Thu, 25 Jun 2009 10:47:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0906251044230.18768@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904141618220.701@hs20-bc2-1.build.redhat.com>
	<20090415031210.GA11881@us.ibm.com> <49E645DA.4010204@redhat.com>
	<20090416024959.GB19876@us.ibm.com> <49E7B029.20906@redhat.com>
	<Pine.LNX.4.64.0904200552590.27291@hs20-bc2-1.build.redhat.com>
	<20090623010930.GA13392@us.ibm.com> <4A41065D.10804@redhat.com>
	<19009.38782.225681.85214@notabene.brown> <4A424FC3.50809@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A424FC3.50809@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Takahiro Yasui <tyasui@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> > I would suggest that you simply get raid1 to block any write requests
> > until all drive failures have been acknowledged by userspace.
> > So you would need to differentiate between an acknowledged drive
> > failure and an unacknowledged failure.  Writes block when ever there
> > are unacknowledged failures.
> > Then you need a message that can be sent to the raid1 to acknowledge
> > the failure of a particular device.
> > 'suspend' would need to fail if there are any unacknowledged failures
> > as otherwise it would block.
> 
> As we discuss in this thread, your suggestion is quite similar to what
> malahal proposed more than one year ago.
> 
> malahal@us.ibm.com wrote:
> > > Look at this patch
> > > http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/4973
> > >
> > > It essentially generates an uevet and waits for the user level code to
> > > act on it and send a message to unblock it.
> 
> This is a simple approach, but all write I/Os are blocked before write
> errors are processed by userspace (dmeventd). Depending on the error,
> such as timeout, the recovery procedure in userspace may take a long
> time and application sensitive to delay will have another problem.
> 
> superblock approach may solve this data corruption issue without an
> additional delay. When dm-raid1 detects a write error, it can disable
> the mirror leg quickly and ask userspace to process aftertreatment.
> 
> I would like to continue discussion how to fix this issue.
> 
> Thanks,
> Taka

The current code already blocks all i/os if the log fails. So if your 
application is sensitive for it, you have to test for it anyway.

You can write new implementation dm-raid1.2 that will have two log devices 
(just like md-raid has two superblocks) and can perform without userspace 
intervention if any of the legs or logs fail.

But it is really more like rewrite --- I think it would be easier to write 
it from scratch than to patch it over existing dm-raid1 code.

Mikulas
