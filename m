From: keld@keldix.com
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Fri, 13 Jul 2012 10:29:23 +0200
Message-ID: <20120713082923.GA19771@www5.open-std.org>
References: <1342057001.22214.6.camel@f16> <20120712162205.GA13485@www5.open-std.org> <331FD2B6-AD96-4513-AF37-4E1B9EE7A34F@redhat.com> <20120713011505.GA3099@www5.open-std.org> <20120713112717.3b15647c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120713112717.3b15647c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Brassow Jonathan <jbrassow@redhat.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Fri, Jul 13, 2012 at 11:27:17AM +1000, NeilBrown wrote:
> On Fri, 13 Jul 2012 03:15:05 +0200 keld@keldix.com wrote:
> 
> > I think the layout you described should not be promoted at all,
> > and only kept for backward compatibility. As there is no backward 
> > compatibility in your case I think it is an error to implement it.
> > I understand that you do not reuse any of the MD code here?
> 
> Not correct.  The whole point of this exercise is to reuse md code.

OK, I also think it is only sensible to reuse the code already done.
I misunderstood then your mail on not to repeat mistakes - which I took to mean that
Barrow should not implement things with mistakes. Maybe that means to not make hooks
to MD code that is a mistake?

So Barrow will implement the improved far layout once there is MD code for it, and
then he can make the neceessary hooks in DM code?

> > The flaw is worse than Neil described, as far as I understand.
> > With n=2 you can in the current implementation only have 1 disk failing,
> > for any numbers of drives in the array. With the suggested layout
> > then for 4 drives you have the probability of surviving 66 % 
> > of 2 drives failing. This get even better for 6, 8 .. disks in the array.
> > And you may even survive 3 or more disk failures, dependent on the number
> > of drives employed. The probability is the same as  for raid-1+0
> 
> Also not correct.  You can certainly have more than one failed device
> providing you don't have 'n' adjacent devices all failed.
> So e.g. if you have 2 drives in a far-2 layout then you can survive the
> failure of three devices if they are 0,2,4 or 1,3,5.

On further investigations I agree that you can survive more than one drive failing with
the current layout.

> > > When it is available to MD, I'll make it available to dm-raid also.
> > 
> > Please dont implement it in the flawed  way. It will just create a number of problems
> > for when to switch over and convert between the two formats, and then which should
> > be the default (I fear some would say the old flawed should be the default), and we need
> > to explain the two formats and implement two sets of repairs and so on.
> 
> This "flawed" arrangement is the only one that makes sense for an odd number
> of devices (assuming 2 copies).

Well, I have an idea for the odd number of devices:
Have the disks arranged in groups (for N=2 in pairs) and then the last group extended with
the leftover disks in the way it is done now.

For 2 copies, this would be a number of pairs, and then a rest group of 3 disks.
For 3 copies, this would be a number of triplets, and then 4 or 5 disks in the last group.

Can I assume, Neil, that you agree with the rest I wrote? :-)
Especially that we should only advice the new layout, and there is no reason for the
current implementation except for backwards compatibility?

best regards
keld
