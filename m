From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Mon, 16 Jul 2012 17:53:53 -0500
Message-ID: <B5AB774E-C433-4DDC-B878-F1A50AD03AB2@redhat.com>
References: <1342057001.22214.6.camel@f16> <20120712162205.GA13485@www5.open-std.org> <331FD2B6-AD96-4513-AF37-4E1B9EE7A34F@redhat.com> <20120713011505.GA3099@www5.open-std.org> <20120713112717.3b15647c@notabene.brown> <20120713082923.GA19771@www5.open-std.org> <20120716161431.42749a15@notabene.brown> <20120716082843.GA30247@www5.open-std.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120716082843.GA30247@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: NeilBrown <neilb@suse.de>, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids


On Jul 16, 2012, at 3:28 AM, keld@keldix.com wrote:

>> 
>> Maybe you are suggesting that dmraid should not support raid10-far or
>> raid10-offset until the "new" approach is implemented.
> 
> I don't know. It may take a while to get it implemented as long as no seasoned 
> kernel hackers are working on it. As it is implemented now by Barrow, why not then go
> forward as planned. 
> 
> For the offset layout I don't have a good idea on how to improve the redundancy.
> Maybe you or others have good ideas. Or is the offset layout an implementation
> of a standard layout? Then there is not much ado. Except if we could find a layout that has
> the same advantages but with better redundancy.

Excuse me, s/Barrow/Brassow/ - my parents insist.

I've got a "simple" idea for improving the redundancy of the "far" algorithms.  Right now, when calculating the device on which the far copy will go, we perform:
	d += geo->near_copies;
	d %= geo->raid_disks;
This effectively "shifts" the copy rows over by 'near_copies' (1 in the simple case), as follows:
	disk1	disk2	or	disk1	disk2	disk3
	=====	=====		=====	=====	=====
	 A1	 A2		 A1	 A2	 A3
	 ..	 ..		 ..	 ..	 ..
	 A2	 A1		 A3	 A1	 A2
For all odd numbers of 'far' copies, this is what we should do.  However, for an even number of far copies, we should shift "near_copies + 1" - unless (far_copies == (raid_disks / near_copies)), in which case it should be simply "near_copies".  This should provide maximum redundancy for all cases, I think.  I will call the number of devices the copy is shifted the "device stride", or dev_stride.  Here are a couple examples:
	2-devices, near=1, far=2, offset=0/1: dev_stride = nc (SAME AS CURRENT ALGORITHM)

	3-devices, near=1, far=2, offset=0/1: dev_stride = nc + 1.  Layout changes as follows:
	disk1	disk2	disk3
	=====	=====	=====
	 A1	 A2	 A3
	 ..	 ..	 ..
	 A2	 A3	 A1

	4-devices, near=1, far=2, offset=0/1: dev_stride = nc + 1.  Layout changes as follows:
	disk1	disk2	disk3	disk4
	=====	=====	=====   =====
	 A1	 A2	 A3	 A4
	 ..	 ..	 ..	 ..
	 A3	 A4	 A1	 A2
This gives max redundancy for 3, 4, 5, etc far copies too, as long as each stripe that's copied is laid down at: 	d += geo->dev_stride * copy#;  (where far=2, copy# would be 0 and 1.  Far=3, copy# would be 0, 1, 2).
Here's a couple more quick examples to make that clear:
	3-devices, near=1, far=3, offset=0/1: dev_stride = nc (SHOULD BE SAME AS CURRENT)
	disk1	disk2	disk3
	=====	=====	=====
	 A1	 A2	 A3
	 ..	 ..	 ..
	 A3	 A1	 A2
	 ..	 ..	 ..
	 A2	 A3	 A1  -- Each copy "shifted" 'nc' from the last
	 ..	 ..	 ..

	5-devices, near=1, far=4, offset=0/1: dev_stride = nc + 1.  Layout changes to:
	disk1	disk2	disk3	disk4	disk5
	=====	=====	=====   =====	=====
	 A1	 A2	 A3	 A4	 A5
	 ..	 ..	 ..	 ..	 ..
	 A4	 A5	 A1	 A2	 A3
	 ..	 ..	 ..	 ..	 ..
	 A2	 A3	 A4	 A5	 A1  -- Each copy "shifted" (nc + 1) from the last
	 ..	 ..	 ..	 ..	 ..
	 A5	 A1	 A2	 A3	 A4
	 ..	 ..	 ..	 ..	 ..

This should require a new bit in 'layout' (bit 17) to signify a different calculation in the way the copy device selection happens.  We then need to replace 'd += geo->near_copies' with 'd += geo->dev_stride' and set dev_stride in 'setup_geo'.  I'm not certain how much work it is beyond that, but I don't *think* it looks that bad and I'd be happy to do it.

So, should I allow the current "far" and "offset" in dm-raid, or should I simply allow "near" for now?

 brassow

