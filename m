From: keld@keldix.com
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Wed, 18 Jul 2012 09:20:42 +0200
Message-ID: <20120718072042.GA18608@www5.open-std.org>
References: <1342057001.22214.6.camel@f16> <20120712162205.GA13485@www5.open-std.org> <331FD2B6-AD96-4513-AF37-4E1B9EE7A34F@redhat.com> <20120713011505.GA3099@www5.open-std.org> <20120713112717.3b15647c@notabene.brown> <20120713082923.GA19771@www5.open-std.org> <20120716161431.42749a15@notabene.brown> <20120716082843.GA30247@www5.open-std.org> <20120717124059.59d1f8b0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120717124059.59d1f8b0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Brassow Jonathan <jbrassow@redhat.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Tue, Jul 17, 2012 at 12:40:59PM +1000, NeilBrown wrote:
> On Mon, 16 Jul 2012 10:28:43 +0200 keld@keldix.com wrote:
> 
> > On Mon, Jul 16, 2012 at 04:14:31PM +1000, NeilBrown wrote:
> > > On Fri, 13 Jul 2012 10:29:23 +0200 keld@keldix.com wrote:
> > > 
> > > > On Fri, Jul 13, 2012 at 11:27:17AM +1000, NeilBrown wrote:
> > > > > On Fri, 13 Jul 2012 03:15:05 +0200 keld@keldix.com wrote:
> > > > > 
> > > > Well, I have an idea for the odd number of devices:
> > > > Have the disks arranged in groups (for N=2 in pairs) and then the last group extended with
> > > > the leftover disks in the way it is done now.
> > > > 
> > > > For 2 copies, this would be a number of pairs, and then a rest group of 3 disks.
> > > > For 3 copies, this would be a number of triplets, and then 4 or 5 disks in the last group.
> > > 
> > > Certainly possible, but it feels clumsy.  I'm not convinced it is a good idea.
> > 
> > Well, it is for this time only a proposal. I do think it preserves all the benefits of raid10,far
> > especially the striping for reading, and I believe it brings redundancy beyond 1 drive up
> > from zero for odd-drive arrays to almost raid-1+0 - in my mind this is as good as it can get theoretically.
> > In my guts it feels like good design. I am exited about it:-)
> > 
> > Why do you feel it is clumsy? Because it is not as general as the current code, but it would take a few more lines to do it?
> > We do gain a lot of redundancy for say 20 more lines of code.
> 
> Yes, because it is not general.   That makes it hard to explain or describe.
> That in turn makes mistake easier.

Well, it is a bit more complicated, I agree, but the explanation I did:
"pairs, as long as possible, and then the rest in a group shifted 1."
Is done in just one line...

> That doesn't mean that I am dead-set against it, but I'm not sure I want to
> encourage it.
> I don't think RAID10 array with 'odd' numbers of drives are that common in
> the first place.
> You suggestion would make no difference for 3 devices, a small difference for
> 5 (4 vulnerable pairs instead of 5) and only becomes significant with 7 or
> more devices.  Are people going to make arrays with 7 devices (with 5
> vulnerable pairs) instead of 8 devices (with 4 vulnerable pairs)?

Well, my suggestion does make a difference, and it is not complicated,
and it moves redundancy to kind of raid-1+0 also for odd numbers.
And we are not going to do these changes very often. So why not do it now.
IMHO the patch will make it almost the same for redundancy
whether they use an even or an odd number of disks, making even/odd
a less concern. And some will use it, I know!

> 
> > 
> > > Maybe that is sensible, but only if someone steps forwards and actually
> > > implements the "new" approach.
> > 
> > I would have hoped you would do it!
> 
> In my copious spare time.

Sounds good!


best regards
keld
