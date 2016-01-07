From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm ioctl: Access user-land memory through safe functions.
Date: Wed, 6 Jan 2016 21:07:37 -0500
Message-ID: <20160107020737.GA1658@redhat.com>
References: <565DE2B8.7040709@eng.utah.edu>
 <566720D0.8080509@eng.utah.edu>
 <20160105201649.GA30512@redhat.com>
 <20160105211310.GC30512@redhat.com>
 <568DBDDF.50708@eng.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <568DBDDF.50708@eng.utah.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Scotty Bauer <sbauer@eng.utah.edu>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com, jmoyer@redhat.com
List-Id: dm-devel.ids

On Wed, Jan 06 2016 at  8:22pm -0500,
Scotty Bauer <sbauer@eng.utah.edu> wrote:

> 
> 
> On 01/05/2016 02:13 PM, Mike Snitzer wrote:
> > On Tue, Jan 05 2016 at  3:16pm -0500,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> >> On Tue, Dec 08 2015 at  1:26pm -0500,
> >> Scotty Bauer <sbauer@eng.utah.edu> wrote:
> >>
> >>> Friendly ping, is anyone interested in this?
> >>
> >> The passed @user argument is flagged via __user so it can be
> >> deferenced directly.  It does look like directly deferencing
> >> user->version is wrong.
> >>
> >> But even if such indirect access is needed (because __user flag is only
> >> applicable to @user arg, not the contained version member) we could more
> >> easily just do something like this no?:
> >>
> >>   uint32_t __user *versionp = (uint32_t __user *)user->version;
> >>   ...
> >>   if (copy_from_user(version, versionp, sizeof(version)))
> >>      return -EFAULT;
> >>
> >> I've staged the following, thanks:
> >> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.5&id=bffc9e237a0c3176712bcd93fc6a184a61e0df26
> > 
> > Alasdair helped me understand that we do need your original fix.
> > I've staged it for 4.5 (and stable@) here:
> > https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.5&id=ead3db62bf10fe143bec99e7b7ff370d7a6d23ef
> > 
> > Thanks again,
> > Mike
> > --
> 
> This broke linux-next because I'm dumb and didn't test it. I thought it was a trivial enough of a patch that I wouldn't screw it up, but I did.
> 
> I incorrectly assumed that user->version was essentially a pointer in userland, not a flat chunk of memory. Ie it was a pointer to some malloc'd region, not an inlined version[3].
> 
> I thought it was this:
> struct dm_ioctl {
> 
> uint32_t *version;
> ...
> }
> 
> It is really this:
> 
> struct dm_ioctl {
> 
> uint32_t version[3];
> 
> }
> 
> I was trying to get the values out of *version, which would have been a pointer, but instead what the code ended up doing was actually getting 8 bytes of the version (think 4,3,1) out and trying to access that version as a memory address, oops.
> 
> It turns out that the original code is correct and doesn't actually touch user memory without a copy_from_user().  Gcc is smart enough to see that version[3] is inlined, and it can emit code which simply takes the userland pointer (struct dm_ioctl __user user), and calculates on offset based on the pointer, thus no actual user dereference occurs. Had the struct looked like the first example I believe the patch would work.
> 
> I'm wondering now if we should switch the code a bit to make it less ambiguous, so someone like me doesn't come along again thinking the code dereferences userland memory and waste everyones time.
> 
> I've attached a patch based off linux-next-20150616 which reverts my broken code but adds an & to the front of user->version so it looks like the code is doing the right thing.
> 
> If I should be basing my patch off something other than linux-next let me know and I'll rewrite it, or we can just revert the old patch and ignore this one.
> 
> Thanks and very sorry for the confusion and breakage.

You're fine, no worries.

But I've just dropped the offending original commit from linux-next and
it obviously won't be included in 4.5

I'll revisit whether we need to bother with the extra & change you're
suggesting while coming to terms with why I was able to be lulled into
thinking your original patch was correct ;)
