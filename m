From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: Clustered RAID1 performance
Date: Fri, 31 May 2013 10:58:35 -0500
Message-ID: <6948BCF9-4B9B-420F-B95E-150F38A6D567@redhat.com>
References: <20130530095955.GE11926@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130530095955.GE11926@suse.de>
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


On May 30, 2013, at 4:59 AM, Lars Marowsky-Bree wrote:

> Hi all,
> 
> we see a significant performance hit when mirroring is used for a cLVM2
> LV.
> 
> That's clearly due to the performance overhead of bouncing to user-space
> (and worse, to the network) for locking etc.
> 
> I wonder if consideration has been given to how this could be improved?
> Using the in-kernel DLM and holding locks for regions the local node
> writes to for longer, exclusive locks while noone is reading,
> parallelizing the resync ...? How is the long-term perspective for this
> given the dm-raid/md raid stuff?
> 
> Before we go drafting I wanted to ask for ideas that are already
> floating around ;-) Anyone working on this?

There isn't any active work being done in this area right now.

What is your test set-up in which you are seeing the performance hit?  In the past when I have tested with GFS2, I did see some performance degradation, but it's not what I would have called significant.  I was not testing with SSDs at the time though.  Also, people are using cluster mirrors in different ways these days.  They may have the mirror active on multiple hosts concurrently, but they only really use it from one host.  Clearly in that case, the ideas you mentioned could make a difference.

I have given some thought to making MD RAID1 cluster-aware.  (RAID10 would come for free, but RAID4/5/6 would be excluded.)  Device-mapper would then make use of this code via the dm-raid.c wrapper.  My idea for the new implementation would have been to keep a separate bitmap area for each machine.  This way, there would be no locking and no need to keep the log state collectively in-sync during nominal operation.  When machines come, go or fail, their bitmaps would have to be merged and responsibility for recovery/initialization/scrubbing would have to be decided.  Additionally, handling device failures is more tricky in MD RAID.  This is because MD RAID (and by extension, the device-mapper targets that leverage it) simply marks a device as failed in the superblock and keeps working while
  DM "mirror" blocks I/O until the failed device is cleared.  This makes a difference in the cluster because one machine may suffer a device failure due to connectivity and another machine m!
 ay not.  If the machine suffering the failure simply marks the failure in the superblock (which will also need to be coordinated) and proceeds, the other machine may then attempt a read from the device and grab a copy of data that is stale.

So, there are some things to think through, but nothing insurmountable.

thanks for your interest,
 brassow
