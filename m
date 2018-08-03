From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [dm-devel] LVM snapshot broke between 4.14 and 4.16
Date: Fri, 3 Aug 2018 11:20:34 -0400
Message-ID: <20180803152034.GD32066@thunk.org>
References: <226835ba-2197-b850-6e5b-8ba14f7fd016@torlan.ru>
 <CAOi1vP_tYG77e71CdDiOcszSSEWrp9Vfi+KB7yFAXVQChkjP5A@mail.gmail.com>
 <93bff248-6897-4867-841b-2dace11597de@torlan.ru>
 <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
 <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
 <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
 <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru>
 <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
 <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
 <20180803133102.GA3092@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180803133102.GA3092@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>, wgh@torlan.ru, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 03, 2018 at 09:31:03AM -0400, Mike Snitzer wrote:
> 
> Debian is notorious for having a stale and/or custom lvm2.
> Generally speaking, it is recommended that lvm2 not be older than the
> kernel (but the opposite is fine).

On Fri, Aug 03, 2018 at 03:31:18PM +0200, Zdenek Kabelac wrote:
> IMHO (as the author of fixing lvm2 patch) user should not be upgrading
> kernels and keep running older lvm2 user-land tool (and there are very good
> reasons for this).

I'm going to have to strenuously disagree.

In *general* it's quite common for users to update their kernel
without updating their userspace.  For example, I as a *developer*, I
am often running bleeding kernels (e.g., at the moment I am running
something based on 4.18-rc6 on a Debian testing system; and it's not
at all uncommon for users to run a newer kernel on older
distribution).

This is the *first* I've heard that I should be continuously updating
lvm because I'm running bleeding edge kernels --- and I would claim
that this is entirely unreasonable.

I'll also note that very often users will update kernels while running
distribution userspace.  And if you are using Linode, very often
*Linode* will offer a newer kernel to better take advantage of the
Linode VM, and this is done without needing to install the Linode
kernel into the userspace.

It *used* to be the case that users running RHEL 2 or RHEL 3 could try
updating to the latest upstream kernel, and everything would break and
fall apart.  This was universally considered to be a failure, and a
Bad Thing.  So if LVM2 is not backwards compatible, and breaks in the
face of newer kernels running older distributions, that is a bug.

If there is a fundamental bug in the userspace API, and it can't be
fixed without a serious security bug, sometimes we need to have an
exception to the "you can't mandate newer userspace" rule.  But I
don't think this falls into this category; how would a user "exploit"
what people are calling a "security bug" to break root?

    	      	      	      	    		   	- Ted
