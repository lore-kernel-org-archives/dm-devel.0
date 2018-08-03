From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] LVM snapshot broke between 4.14 and 4.16
Date: Fri, 3 Aug 2018 21:08:17 +0100
Message-ID: <20180803200817.GB31444@agk-dp.fab.redhat.com>
References: <93bff248-6897-4867-841b-2dace11597de@torlan.ru> <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com> <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com> <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com> <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru> <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru> <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com> <20180803133102.GA3092@redhat.com> <20180803152034.GD32066@thunk.org> <20180803195636.GA31444@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180803195636.GA31444@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Mike Snitzer <snitzer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>, wgh@torlan.ru, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 03, 2018 at 08:56:36PM +0100, Alasdair G Kergon wrote:
> Anything passing in version 4.37.0 or earlier (which is the version in

If taking this approach, it might be better to use the current version
i.e.  where we add the kernel-side fix.  IOW anything compiling against
a uapi header taken from a kernel up to now will see the old behaviour,
but anything newer (after we next increment the kernel dm version) will
be required to change its userspace code if it has this problem in it.

The problematic versions of lvm2 ship with versions up to and including
4.36.0 in this field so should be caught either way.

Alasdair
