From: WGH <wgh@torlan.ru>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Fri, 3 Aug 2018 00:39:22 +0300
Message-ID: <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
References: <226835ba-2197-b850-6e5b-8ba14f7fd016@torlan.ru>
 <CAOi1vP_tYG77e71CdDiOcszSSEWrp9Vfi+KB7yFAXVQChkjP5A@mail.gmail.com>
 <93bff248-6897-4867-841b-2dace11597de@torlan.ru>
 <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
 <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
 <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
 <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Ilya Dryomov <idryomov@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 08/03/2018 12:32 AM, WGH wrote:
> On 08/02/2018 09:32 PM, Linus Torvalds wrote:
>> WGH (sorry, no idea what your real name is) - what's the source of the
>> script that broke? Was it some system script you got from outside and
>> likely to affect others too?
>>
>> Or was it just some local thing you wrote yourself and was
>> unintentionally buggy and nobody else is likely to hit this?
>>
>> Because if the latter, if you can work around it and you're the only
>> user this hits, we might just be able to ignore it.
> The script in question is written by me and contains literally two lines:
>
>     lvcreate --size 5G --snapshot --name snap0 --permission r
> /dev/mapper/vg0-lvol_rootfs
>     mount /dev/mapper/vg0-snap0 /mnt/rootfs_snapshot
>
> The script is not buggy (I think), it was written under simple
> assumption that --permission r works. And it does - unless you happen to
> have combination of kernel >=4.16 and lvm2 <2.02.178.
>
> The commit in question appeared only in 4.16, and this kernel version is
> not widespread yet. You have to be running both recent kernel and
> not-so-recent lvm2 to be bitten by this. This probably explains why no
> one else reported this problem.
>
> Workaround certainly exists: I can just create read-write snapshot, but
> mount it read-only. The reason why I didn't discover the workaround
> earlier is that after unsuccessful read-only snapshot creation system
> ends up in some weird state where read-write snapshots are also failing
> with the same error (until reboot). So I got a wrong impression that
> read-write snapshots were broken as well.
>
I've just found one public report of this bug, though:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=900442
