From: James Cloos <cloos@jhcloos.com>
Subject: Re: disk/crypto performance regression 2.6.31 -> 2.6.32 (mmap problem?)
Date: Tue, 23 Feb 2010 21:25:30 -0500
Message-ID: <m37hq3id3h.fsf@lugabout.jhcloos.org>
References: <alpine.DEB.1.10.1002191729220.28940@uplift.swm.pp.se>
	<alpine.DEB.1.10.1002221337170.28940@uplift.swm.pp.se>
	<20100223044818.GD22370@discord.disaster>
	<alpine.DEB.1.10.1002230820110.12694@uplift.swm.pp.se>
	<20100223133219.GB16175@discord.disaster>
	<alpine.DEB.1.10.1002232138021.12694@uplift.swm.pp.se>
	<20100223224111.GC16175@discord.disaster>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100223224111.GC16175@discord.disaster> (Dave Chinner's message
	of "Wed, 24 Feb 2010 09:41:11 +1100")
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

M> You're right, it doesn't say that anymore in 2.6.31, so I think I'm 
M> indeed running with barriers on.

When barriers were added to ext4, I saw a similar slowdown on lock- and
sync- heavy workloads.

Based on a recent thread on the ext4 list I've started using deadline
rather than cfq on that disk.  There are some slowdowns on that disk's
other partition, but the overall throughput is significantly better than
using the combination of cfq, ext4 and barriers.

You might want to test out deadline and/or noop.

Cf:  /sys/block/*/queue/scheduler

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
