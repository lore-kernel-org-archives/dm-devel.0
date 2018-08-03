From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Fri, 3 Aug 2018 11:57:34 -0700
Message-ID: <CA+55aFwGGjs_imFFkEPJ4g99Kseam=4Qppv4G6Q=ZfZXdzF7Vw@mail.gmail.com>
References: <CAOi1vP_tYG77e71CdDiOcszSSEWrp9Vfi+KB7yFAXVQChkjP5A@mail.gmail.com>
 <93bff248-6897-4867-841b-2dace11597de@torlan.ru> <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
 <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
 <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
 <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru> <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
 <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
 <20180803133102.GA3092@redhat.com> <20180803152034.GD32066@thunk.org> <20180803183932.GA3258@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180803183932.GA3258@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>, wgh@torlan.ru, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 3, 2018 at 11:39 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> Please stop with the overreaction and making this something it isn't.

It's not an overreaction when people get their scripts broken, and
some developers then argue "that's not a serious bug".

Guys, this needs to be fixed.  With all the stupid and fundamentyally
incorrect excuses, I am now no longer even willing to maintain any
other course of action.

If you develop for the Linux kernel, you need to realize that
"breaking user space" is simply not acceptable. And if you cannot live
with that, then you should stop working on the kernel. Because I will
refuse to continue to pull from you as a developer.

At worst, I'll just revert the original commit entirely. I was hoping
we'd be able to avoid that, partly because the commit looks fine, but
partly because it also doesn't revert cleanly.

Or I'll just do something like this, since it seems like it's the lvm
people who have the hardest time with understanding the simple rules:

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index b810ea77e6b1..fcfab812e025 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1049,7 +1049,12 @@ static int do_resume(struct dm_ioctl *param)
                        return PTR_ERR(old_map);
                }

-               if (dm_table_get_mode(new_map) & FMODE_WRITE)
+               /*
+                * This used to do
+                *    dm_table_get_mode(new_map) & FMODE_WRITE
+                * but the lvm tools got this wrong, and will
+                * continue to write to "read-only" volumes.
+               if (0)
                        set_disk_ro(dm_disk(md), 0);
                else
                        set_disk_ro(dm_disk(md), 1);

which seems to target the actual problem more directly.

              Linus
