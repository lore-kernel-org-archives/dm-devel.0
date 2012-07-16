From: keld@keldix.com
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Mon, 16 Jul 2012 10:28:43 +0200
Message-ID: <20120716082843.GA30247@www5.open-std.org>
References: <1342057001.22214.6.camel@f16> <20120712162205.GA13485@www5.open-std.org> <331FD2B6-AD96-4513-AF37-4E1B9EE7A34F@redhat.com> <20120713011505.GA3099@www5.open-std.org> <20120713112717.3b15647c@notabene.brown> <20120713082923.GA19771@www5.open-std.org> <20120716161431.42749a15@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120716161431.42749a15@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Brassow Jonathan <jbrassow@redhat.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Jul 16, 2012 at 04:14:31PM +1000, NeilBrown wrote:
> On Fri, 13 Jul 2012 10:29:23 +0200 keld@keldix.com wrote:
> 
> > On Fri, Jul 13, 2012 at 11:27:17AM +1000, NeilBrown wrote:
> > > On Fri, 13 Jul 2012 03:15:05 +0200 keld@keldix.com wrote:
> > > 
> > Well, I have an idea for the odd number of devices:
> > Have the disks arranged in groups (for N=2 in pairs) and then the last group extended with
> > the leftover disks in the way it is done now.
> > 
> > For 2 copies, this would be a number of pairs, and then a rest group of 3 disks.
> > For 3 copies, this would be a number of triplets, and then 4 or 5 disks in the last group.
> 
> Certainly possible, but it feels clumsy.  I'm not convinced it is a good idea.

Well, it is for this time only a proposal. I do think it preserves all the benefits of raid10,far
especially the striping for reading, and I believe it brings redundancy beyond 1 drive up
from zero for odd-drive arrays to almost raid-1+0 - in my mind this is as good as it can get theoretically.
In my guts it feels like good design. I am exited about it:-)

Why do you feel it is clumsy? Because it is not as general as the current code, but it would take a few more lines to do it?
We do gain a lot of redundancy for say 20 more lines of code.

> > Especially that we should only advice the new layout, and there is no reason for the
> > current implementation except for backwards compatibility?
> 
> The main reason for the current implementation is that is currently
> implemented.
> Until an alternate implementation exists, it seems pointless to recommend
> that people use it.

That is not the intention. The intention is for new implementers not
to implement the old scheme. That is, for new implementers to do it right.

> Maybe you are suggesting that dmraid should not support raid10-far or
> raid10-offset until the "new" approach is implemented.

I don't know. It may take a while to get it implemented as long as no seasoned 
kernel hackers are working on it. As it is implemented now by Barrow, why not then go
forward as planned. 

For the offset layout I don't have a good idea on how to improve the redundancy.
Maybe you or others have good ideas. Or is the offset layout an implementation
of a standard layout? Then there is not much ado. Except if we could find a layout that has
the same advantages but with better redundancy.

> Maybe that is sensible, but only if someone steps forwards and actually
> implements the "new" approach.

I would have hoped you would do it!

I am not a seasoned kernel hacker like you, but could you point me to the code where
the sequence of the blocks is done for far and offset? I would think it would only be a few places.

And then how to handle the two different layouts, and how to do a migration? Where would that be done?

Best regards
keld
