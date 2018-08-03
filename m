From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Fri, 3 Aug 2018 14:39:32 -0400
Message-ID: <20180803183932.GA3258@redhat.com>
References: <CAOi1vP_tYG77e71CdDiOcszSSEWrp9Vfi+KB7yFAXVQChkjP5A@mail.gmail.com>
	<93bff248-6897-4867-841b-2dace11597de@torlan.ru>
	<CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
	<CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
	<CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
	<d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru>
	<1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
	<CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
	<20180803133102.GA3092@redhat.com>
	<20180803152034.GD32066@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180803152034.GD32066@thunk.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>, wgh@torlan.ru, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 03 2018 at 11:20am -0400,
Theodore Y. Ts'o <tytso@mit.edu> wrote:

> On Fri, Aug 03, 2018 at 09:31:03AM -0400, Mike Snitzer wrote:
> > 
> > Debian is notorious for having a stale and/or custom lvm2.
> > Generally speaking, it is recommended that lvm2 not be older than the
> > kernel (but the opposite is fine).
> 
> On Fri, Aug 03, 2018 at 03:31:18PM +0200, Zdenek Kabelac wrote:
> > IMHO (as the author of fixing lvm2 patch) user should not be upgrading
> > kernels and keep running older lvm2 user-land tool (and there are very good
> > reasons for this).
> 
> I'm going to have to strenuously disagree.
> 
> In *general* it's quite common for users to update their kernel
> without updating their userspace.  For example, I as a *developer*, I
> am often running bleeding kernels (e.g., at the moment I am running
> something based on 4.18-rc6 on a Debian testing system; and it's not
> at all uncommon for users to run a newer kernel on older
> distribution).
> 
> This is the *first* I've heard that I should be continuously updating
> lvm because I'm running bleeding edge kernels --- and I would claim
> that this is entirely unreasonable.

It isn't a hard requirement.  But relative to a newer kernel, you simply
cannot deny that a newer lvm2 will work better than on older lvm2.  Not
even speaking about this block regression.  Lessons are learned, fixes
are made, support for the newer kernel's targets are available, etc etc.

That is where the suggestion to keep lvm2 updated along with the kernel
comes from.

It isn't about "oh we regress _all_ the time.. screw users!".

> I'll also note that very often users will update kernels while running
> distribution userspace.  And if you are using Linode, very often
> *Linode* will offer a newer kernel to better take advantage of the
> Linode VM, and this is done without needing to install the Linode
> kernel into the userspace.
> 
> It *used* to be the case that users running RHEL 2 or RHEL 3 could try
> updating to the latest upstream kernel, and everything would break and
> fall apart.  This was universally considered to be a failure, and a
> Bad Thing.  So if LVM2 is not backwards compatible, and breaks in the
> face of newer kernels running older distributions, that is a bug.

Please stop with the overreaction and making this something it isn't.
