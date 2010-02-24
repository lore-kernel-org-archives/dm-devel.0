From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: disk/crypto performance regression 2.6.31 -> 2.6.32 (mmap
 problem?)
Date: Wed, 24 Feb 2010 06:20:11 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002240612400.12694@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1002191729220.28940@uplift.swm.pp.se> <alpine.DEB.1.10.1002221337170.28940@uplift.swm.pp.se> <20100223044818.GD22370@discord.disaster> <alpine.DEB.1.10.1002230820110.12694@uplift.swm.pp.se> <20100223133219.GB16175@discord.disaster>
 <alpine.DEB.1.10.1002232138021.12694@uplift.swm.pp.se> <20100223224111.GC16175@discord.disaster> <m37hq3id3h.fsf@lugabout.jhcloos.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <m37hq3id3h.fsf@lugabout.jhcloos.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Cloos <cloos@jhcloos.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 23 Feb 2010, James Cloos wrote:

> Based on a recent thread on the ext4 list I've started using deadline
> rather than cfq on that disk.  There are some slowdowns on that disk's
> other partition, but the overall throughput is significantly better than
> using the combination of cfq, ext4 and barriers.
>
> You might want to test out deadline and/or noop.
>
> Cf:  /sys/block/*/queue/scheduler

I have been running deadline on the drives itself for years, I've tried 
both with cfq and deadline in this case, and it doesn't really help.

Another question is what the recommended scheduler setup when it comes to 
my different layers drive->md->crypto(dm)->lvm(dm). For now I have only 
been changing scheduler to deadline on the drive layer.

I guess the different layers doesn't really know that much about each 
other? I can imagine a few different scenarios where one only wants to do 
most of the scheduling on the lvm layer, and then wants to keep the 
queueing to a minimum on the other layers and keep the queue as small as 
possible there, so it can do the proper re-ordering.

Anyone has any thoughts to share on this? I don't have much experience 
with this when it comes to block devices, I'm a network engineer and I'm 
trying to use my experience in QoS/packet schedulers in different layers, 
where for instance when one runs an IP QoS scheduler, one doesn't want a 
lot of buffering on the underlying ATM layer, because it makes the IP 
schedulers job much harder.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
