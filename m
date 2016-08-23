From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: [RFC] Some fixes to allow for more than 128 md devices.
Date: Tue, 23 Aug 2016 14:37:15 -0600
Message-ID: <CAANLjFqgOzB0Paavo5FfZ3quRaJJvdOo85Nn05MV2Z5R4TiWOw@mail.gmail.com>
References: <1471659031-30688-1-git-send-email-robert@leblancnet.us> <CAANLjFqv33upkC5tLN8i77ysZCcFWqRYpqVUduBaCCAEOcZAqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAANLjFqv33upkC5tLN8i77ysZCcFWqRYpqVUduBaCCAEOcZAqA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dm-devel@redhat.com, Robert LeBlanc <robert@leblancnet.us>
List-Id: dm-devel.ids

I found an email thread [0] talking about the new way to do this. I
did find a buffer overrun and will submit a patch for it.

Robert LeBlanc

[0] http://www.spinics.net/lists/raid/msg52300.html
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Mon, Aug 22, 2016 at 10:03 AM, Robert LeBlanc <robert@leblancnet.us> wrote:
> Apparently, the mdadm source on git-kernel.org (commit 13db17bd)
> already has the fixes to properly create the device nodes, but I still
> have the unexpected failure opening /dev/md1048574.
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
>
> On Fri, Aug 19, 2016 at 8:10 PM, Robert LeBlanc <robert@leblancnet.us> wrote:
>> I'm stuck and need some help getting this across the finish line. This
>> is in no way complete, but to help show what I'm working on.
>>
>> When we added more than 128 md devices, we started getting failures.
>> Looking through the code it seems that the minor dev number was being
>> stored in an int and causing overflow and wrecking havoc on everything.
>> I finally got the mknod in mdadm to correctly make the dev node with
>> minors up to 1048574 as expected in the mdadm code. However, I can
>> only create md devices up to 511. Trying to create an md higher than
>> that has an error where the device can't be read/opened strace reports:
>> open("/dev/.tmp.md.15341:9:1048574", O_RDWR|O_EXCL|O_DIRECT) = -1 ENXIO
>> (No such device or address)
>> while Python reports:
>> IOError: [Errno 6] No such device or address: '/dev/.tmp.md.3279:9:512'
>>
>> A corresponding node is not created in /sys/block/md* for mds over 511.
>>
>> I believe that there may be a bug in the kernel code that is now being
>> hit. After looking through the kernel code, I can't seem to find where
>> this might be. Please help me by either pointing me to the source
>> location that this might be a problem or fixing it based on these
>> patches I've worked on so far. I'm using 4.7.0 currently.
>>
>> I'm using this for testing:
>> ./mdadm --create /dev/md1048574 --assume-clean --verbose --level=1 \
>> --raid-devices=2 /dev/loop0 missing
>>
>> Yes, we have a real need for more than 128 and 512 md devices.
>>
>> Please include me in any replies as I'm not on the ML.
>>
>> Thank you.
>>
>> Robert LeBlanc (1):
>>   Some fixes to allow for more than 128 md devices.
>>
>>  Manage.c |  5 +++--
>>  lib.c    |  2 +-
>>  mdadm.h  |  6 +++---
>>  util.c   | 25 +++++++++++++------------
>>  4 files changed, 20 insertions(+), 18 deletions(-)
>>
>> --
>> 2.8.1
>>
