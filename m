From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] LVM snapshot broke between 4.14 and 4.16
Date: Fri, 3 Aug 2018 12:30:49 -0700
Message-ID: <CA+55aFzyNMWfkaWvFuMaLCBjcWvBQgBAe+GY=WDPiGd1YDTs=Q@mail.gmail.com>
References: <226835ba-2197-b850-6e5b-8ba14f7fd016@torlan.ru>
 <CAOi1vP_tYG77e71CdDiOcszSSEWrp9Vfi+KB7yFAXVQChkjP5A@mail.gmail.com>
 <93bff248-6897-4867-841b-2dace11597de@torlan.ru> <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
 <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
 <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
 <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru> <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
 <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
 <b2bbd8ec-ac5b-fa8a-d3f7-8615d87f73c3@redhat.com> <CA+55aFwWZX=CXmWDTkDGb36kf12XmTehmQjbiMPCqCRG2hi9kw@mail.gmail.com>
 <bc71118d-3003-6260-6ab3-ddcc4277aeed@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bc71118d-3003-6260-6ab3-ddcc4277aeed@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>, wgh@torlan.ru
List-Id: dm-devel.ids

On Fri, Aug 3, 2018 at 12:18 PM Zdenek Kabelac <zkabelac@redhat.com> wrote:
>
>  From my userland POV - leaving kernel write to devices that are supposed to
> be read-only  'just because' it's kernel is wrong - the fact it has NOT been
> discover for so long means - there are not many users and not many testers of
> this combination.

Sure. But at the same time, the "read-only" issue from a _security_
standpoint should never be about some device state.

Why? Because the Unix security rules aren't about "read-only devices".
They are about permissions, and if you don't want your users to have
write permissions to a device, then they shouldn't have those
permissions.

So the "set_disk_ro()" interface is simply not for security. Anybody
who uses it for security is seriously confused.

No, the "set_disk_ro()" interface is so that you can say "you
physically cannot write to this medium". It's meant for things like
CD-ROM devices, or for a floppy device when you notice that the
controller reports that the floppy itself is physically
write-protected.

THAT is what the new code checks for, and that is also why ignoring
the check really shouldn't be a security issue.

Because if it turns out that somebody wrote to it, and the write
succeeded, then obviously the "set_disk_ro()" usage was simply wrong.

Now, I do agree that it 100% makes sense to have a layer like md/lvm
be able to virtually mark volumes read-only. If only exactly to
emulate the "this is like a write-protected floppy or a cd-rom"
behavior.

So the DM_READONLY_FLAG makes conceptual sense.

But at the same time, if the DM_READONLY_FLAG was _wrong_, then it
also makes a ton of sense to just say "oh, it was wrong, we'll ignore
it".

Exactly because it was never supposed to be about security, and it was
about other things.

See?

              Linus
