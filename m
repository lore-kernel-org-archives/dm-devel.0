From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Tue, 17 Jul 2012 15:30:54 -0500
Message-ID: <6CC78E36-3B8F-4F9B-B4CA-7A4D0C677DF4@redhat.com>
References: <1342057001.22214.6.camel@f16> <20120712162205.GA13485@www5.open-std.org> <331FD2B6-AD96-4513-AF37-4E1B9EE7A34F@redhat.com> <20120713011505.GA3099@www5.open-std.org> <20120713112717.3b15647c@notabene.brown> <20120713082923.GA19771@www5.open-std.org> <20120716161431.42749a15@notabene.brown> <20120716082843.GA30247@www5.open-std.org> <B5AB774E-C433-4DDC-B878-F1A50AD03AB2@redhat.com> <20120717122914.4d6d160f@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120717122914.4d6d160f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: keld@keldix.com, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids


On Jul 16, 2012, at 9:29 PM, NeilBrown wrote:

> The layout with data stored on device 'x' is mirrored on device 'x^1' has
> N/2 pairs which are vulnerable. 
> An alternate way to gain this low level of vulnerability would be to mirror
> data on X onto 'X+N/2'  This is the same as your arrangement for N==4.
> For N==6 it would be:
> 
> A  B  C  D  E  F
> G  H  I  J  K  L
> ....
> D  E  F  A  B  C
> J  K  L  G  H  I
> ...
> 
> so the vulnerable pairs are 0,3 1,4 2,5
> This might be slightly easier to implement (as you suggest: have a
> dev_stride, only set it to raid_disks/fc*nc).

Yes, that looks nice.  Plus, it doesn't have as many conditions as my idea.

> 
>> 
>> This should require a new bit in 'layout' (bit 17) to signify a different calculation in the way the copy device selection happens.  We then need to replace 'd += geo->near_copies' with 'd += geo->dev_stride' and set dev_stride in 'setup_geo'.  I'm not certain how much work it is beyond that, but I don't *think* it looks that bad and I'd be happy to do it.
> 
> I'm tempted to set bit 31 to mean "bits 0xFF are number of copies and bits
> 0xFF00 define the layout of those copies".. but just adding a bit17 probably
> makes more sense.
> 
> If you create and test a patch using the calculation I suggested, I'll be
> happy to review it.

ok.  Might come after my current dm-raid patch (that will skip over the current "far" implementations.

If the 17th bit makes it simple to change the 'far' algorithms, that's probably the right idea.  We could save the very last bits for when we need a completely changed view of how the variable is used.  I don't think we are there yet.

 brassow