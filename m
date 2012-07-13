From: keld@keldix.com
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Fri, 13 Jul 2012 03:15:05 +0200
Message-ID: <20120713011505.GA3099@www5.open-std.org>
References: <1342057001.22214.6.camel@f16> <20120712162205.GA13485@www5.open-std.org> <331FD2B6-AD96-4513-AF37-4E1B9EE7A34F@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <331FD2B6-AD96-4513-AF37-4E1B9EE7A34F@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

On Thu, Jul 12, 2012 at 02:00:35PM -0500, Brassow Jonathan wrote:
> Thanks for the suggestion.  The documentation is correct, as far as I can tell.  What you take issue with is that a higher level of redundancy can be achieved by laying down the copies differently.  Neil touched on that in this message:
> 	http://marc.info/?l=linux-raid&m=134136516029779&w=2

Thanks for the info. Well, I corrected the wikipedia description to the one that I 
suggested, as this was more in line with what I understood was the current implementation.
I have missed the email from Neil that you quoted above.
I believe it was me writing up the Wikipedia text anyway, at least I did all of
the initial writeup of the Wikipedia text on raid10.

And then I saw that you were implementing a description on raid10,far that
was less than optimal. That description should not be around as it is a flawed design.
(I did the design of raid10,far).
There  should only be one layout for "far". I think when we  discussed
the "far" layout initially, we were not aware of the consequences of the
layout then wrt how many disk failures the layout can survive..

I think the layout you described should not be promoted at all,
and only kept for backward compatibility. As there is no backward 
compatibility in your case I think it is an error to implement it.
I understand that you do not reuse any of the MD code here?

I hestitate now changing the wikipedia description of MD raid10,far back.
I fear that some implementers would code it as to that spec!
Well, there should probably be something about it, I will write
up something. 

The flaw is worse than Neil described, as far as I understand.
With n=2 you can in the current implementation only have 1 disk failing,
for any numbers of drives in the array. With the suggested layout
then for 4 drives you have the probability of surviving 66 % 
of 2 drives failing. This get even better for 6, 8 .. disks in the array.
And you may even survive 3 or more disk failures, dependent on the number
of drives employed. The probability is the same as  for raid-1+0

> When it is available to MD, I'll make it available to dm-raid also.

Please dont implement it in the flawed  way. It will just create a number of problems
for when to switch over and convert between the two formats, and then which should
be the default (I fear some would say the old flawed should be the default), and we need
to explain the two formats and implement two sets of repairs and so on.

Best regards
Keld

>  brassow
> 
> 
> On Jul 12, 2012, at 11:22 AM, keld@keldix.com wrote:
> 
> > On Wed, Jul 11, 2012 at 08:36:41PM -0500, Jonathan Brassow wrote:
> >> +        [raid10_copies   <# copies>]
> >> +        [raid10_format   <near|far|offset>]
> >> +		These two options are used to alter the default layout of
> >> +		a RAID10 configuration.  The number of copies is can be
> >> +		specified, but the default is 2.  There are also three
> >> +		variations to how the copies are laid down - the default
> >> +		is "near".  Near copies are what most people think of with
> >> +		respect to mirroring.  If these options are left unspecified,
> >> +		or 'raid10_copies 2' and/or 'raid10_format near' are given,
> >> +		then the layouts for 2, 3 and 4 devices	are:
> >> +		2 drives         3 drives          4 drives
> >> +		--------         ----------        --------------
> >> +		A1  A1           A1  A1  A2        A1  A1  A2  A2
> >> +		A2  A2           A2  A3  A3        A3  A3  A4  A4
> >> +		A3  A3           A4  A4  A5        A5  A5  A6  A6
> >> +		A4  A4           A5  A6  A6        A7  A7  A8  A8
> >> +		..  ..           ..  ..  ..        ..  ..  ..  ..
> >> +		The 2-device layout is equivalent 2-way RAID1.  The 4-device
> >> +		layout is what a traditional RAID10 would look like.  The
> >> +		3-device layout is what might be called a 'RAID1E - Integrated
> >> +		Adjacent Stripe Mirroring'.
> >> +
> >> +		If 'raid10_copies 2' and 'raid10_format far', then the layouts
> >> +		for 2, 3 and 4 devices are:
> >> +		2 drives             3 drives             4 drives
> >> +		--------             --------------       --------------------
> >> +		A1  A2               A1   A2   A3         A1   A2   A3   A4
> >> +		A3  A4               A4   A5   A6         A5   A6   A7   A8
> >> +		A5  A6               A7   A8   A9         A9   A10  A11  A12
> >> +		..  ..               ..   ..   ..         ..   ..   ..   ..
> >> +		A2  A1               A3   A1   A2         A4   A1   A2   A3
> >> +		A4  A3               A6   A4   A5         A8   A5   A6   A7
> >> +		A6  A5               A9   A7   A8         A12  A9   A10  A11
> > 
> > The trick here for 4 drives is to keep the array running even if some 2 drives fail.
> > Your layout does not so so. Only one drive may fail at any time.
> > 
> > I think a better layout is (for 4 drives)
> > 
> >          A1  A2  A3  A4
> >          A5  A6  A7  A8
> > 
> >          .................
> > 
> >          A2  A1  A4  A3  (Swich in pairs for N=2)
> >          A6  A5  A8  A7
> > 
> > Here all of the drive combinations 1+3, 1+4, 2+3, 2+4 may fail, and the array should
> > still be running.. 1+2 and 3+4 could not fail without destroying the array.
> > This would give a 66,7 % chance of the array surviving 2 disk crashes.
> > That is better than the 0 % that the documented scheme has.
> > 
> > the same scheme could go for all even numbers of N in a raid10,far layout.
> > consider the drives in pairs, and switch the blocks within a pair.
> > 
> > I think this could be generalized to N-copies: treat every group N drives,
> > as N copies of the same set of selection of blocks.
> > Then any N-1 of the disks in the group could fail and the arry still
> > be running. Works then for arrays with straight multipla of N disks .
> > 
> > I am not sure that ordinary raid10 does so, but Neil has indicated so.
> > I would be grateful if you could check this, and
> > also test what happens with your code if you have any combination of 2 drives
> > fail for the 4 drive case.
> > 
> >> +
> >> +		If 'raid10_copies 2' and 'raid10_format offset', then the
> >> +		layouts for 2, 3 and 4 devices are:
> >> +		2 drives       3 drives           4 drives
> >> +		--------       ------------       -----------------
> >> +		A1  A2         A1  A2  A3         A1  A2  A3  A4
> >> +		A2  A1         A3  A1  A2         A4  A1  A2  A3
> >> +		A3  A4         A4  A5  A6         A5  A6  A7  A8
> >> +		A4  A3         A6  A4  A5         A8  A5  A6  A7
> >> +		A5  A6         A7  A8  A9         A9  A10 A11 A12
> >> +		A6  A5         A9  A7  A8         A12 A9  A10 A11
> > 
> > The same problem here with 2 failing drives (for the 4 drive case).
> > However I dont see an easy solution to this problem.
> > 
> >> +		Here we see layouts closely akin to 'RAID1E - Integrated
> >> +		Offset Stripe Mirroring'.
> >> +
> >> +		Thanks wikipedia 'Non-standard RAID levels' for the layout
> >> +		figures:
> >> +		http://en.wikipedia.org/wiki/Non-standard_RAID_levels
> > 
> > Wikipedia may be in error wrt. the block orders.
> > 
> > besT regards
> > Keld
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
