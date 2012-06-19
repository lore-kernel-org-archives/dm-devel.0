From: Spelic <spelic@shiftmail.org>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Tue, 19 Jun 2012 15:52:15 +0200
Message-ID: <4FE0840F.2050704@shiftmail.org>
References: <4FDF9EBE.2030809@shiftmail.org> <20120619015745.GJ25389@dastard>
 <20120619031241.GA3884@redhat.com>
 <alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
 <20120619131649.GA6811@redhat.com>
 <alpine.LFD.2.00.1206191519320.21961@dhcp-1-248.brq.redhat.com>
 <20120619133041.GB6811@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-reply-to: <20120619133041.GB6811@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Mike Snitzer <msnitzer@redhat.com>
Cc: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>, Dave Chinner <david@fromorbit.com>, Spelic <spelic@shiftmail.org>, device-mapper development <dm-devel@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
List-Id: dm-devel.ids

On 06/19/12 15:30, Mike Snitzer wrote:
> I don't recall Spelic saying anything about EOPNOTSUPP. So what has 
> made you zero in on an -EOPNOTSUPP return (which should not be 
> happening)? 

Exactly: I do not know if EOPNOTSUPP is being returned or not.

If this helps, I have configured dm-thin via lvm2
   LVM version:     2.02.95(2) (2012-03-06)
   Library version: 1.02.74 (2012-03-06)
   Driver version:  4.22.0

from dmsetup table I only see one option : "skip_block_zeroing", if and 
only if I configure it with -Zn . I do not see anything regarding 
ignore_discard

      vg1-pooltry1-tpool: 0 20971520 thin-pool 252:1 252:2 2048 0 1 
skip_block_zeroing
      vg1-pooltry1_tdata: 0 20971520 linear 9:20 62922752
      vg1-pooltry1_tmeta: 0 8192 linear 9:20 83894272
      vg1-thinlv1: 0 31457280 thin 252:3 1


and in dmesg:
[   33.685200] device-mapper: thin: Discard unsupported by data device 
(dm-2): Disabling discard passdown.
[   33.709586] device-mapper: thin: Discard unsupported by data device 
(dm-6): Disabling discard passdown.


I do not know what is the mechanism for which xfs cannot unmap blocks 
from dm-thin, but it really can't.
If anyone has dm-thin installed he can try. This is 100% reproducible 
for me.


