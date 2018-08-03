From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] LVM snapshot broke between 4.14 and 4.16
Date: Fri, 3 Aug 2018 20:56:36 +0100
Message-ID: <20180803195636.GA31444@agk-dp.fab.redhat.com>
References: <CAOi1vP_tYG77e71CdDiOcszSSEWrp9Vfi+KB7yFAXVQChkjP5A@mail.gmail.com> <93bff248-6897-4867-841b-2dace11597de@torlan.ru> <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com> <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com> <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com> <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru> <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru> <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com> <20180803133102.GA3092@redhat.com> <20180803152034.GD32066@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180803152034.GD32066@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Mike Snitzer <snitzer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>, wgh@torlan.ru, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 03, 2018 at 11:20:34AM -0400, Theodore Y. Ts'o wrote:
> It *used* to be the case that users running RHEL 2 or RHEL 3 could try
> updating to the latest upstream kernel, and everything would break and
> fall apart.  This was universally considered to be a failure, and a
> Bad Thing.  So if LVM2 is not backwards compatible, and breaks in the
> face of newer kernels running older distributions, that is a bug.
 
Brings back memories!  For those who wonder what this is all about,
with LVM1, if the version of kernel and userspace didn't match it simply
stopped.  No booting into the previous version of your kernel after
upgrading unless you reverted userspace as well!  Led to all sorts of
not-so-fancy workarounds.

As a reaction to this, LVM2 (through libdevmapper and anything else
using the dm ioctls as documented in dm-ioctl.h) passes a version number
up to the kernel (to say "I know about kernels with dm up to and
including version x.y.z"), so there is an option for an in-kernel
workaround here to limit its compatibility mode to the broken userspace
versions.  

Anything passing in version 4.37.0 or earlier (which is the version in
dm-ioctl.h when this kernel patch was applied) could be assumed to
require the old behaviour.  check_version() is where this version is
seen, so it would either store it for later checking or do the check and
store a flag to invoke compatible behaviour later.

Alasdair
