From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
Date: Thu, 26 Mar 2009 16:26:53 +0100
Message-ID: <E1LmrTq-0001wg-2i@be1.7eggert.dyndns.org>
References: <ciXHh-39c-37@gated-at.bofh.it> <cjfuL-6vJ-43@gated-at.bofh.it> <cjfEl-6J2-45@gated-at.bofh.it> <cjfNX-6Wh-27@gated-at.bofh.it> <cjfXx-78D-9@gated-at.bofh.it> <cjg7h-7lM-29@gated-at.bofh.it> <cjgqC-80G-21@gated-at.bofh.it> <cjD3I-22U-7@gated-at.bofh.it> <cjDdE-2g3-31@gated-at.bofh.it> <cjJVv-4vp-13@gated-at.bofh.it> <cjXlS-uM-1@gated-at.bofh.it>
Reply-To: 7eggert@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758511AbZCZP1U@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, device-mapper development <dm-devel@redhat.com>, Linux
List-Id: dm-devel.ids

Chris Mason <chris.mason@oracle.com> wrote:
> On Wed, 2009-03-25 at 18:39 -0400, Mikulas Patocka wrote:

>> > The error handling is complex, no doubt
>> > about that. But the trial barrier test is pretty trivial and even could
>> > be easily abstracted out. If a later barrier write fails, then that's
>> > really no different than if a normal write fails. Error handling is not
>> > easy in that case.
>> 
>> I had a discussion with Andi about it some times ago. The conclusion was
>> that all the current filesystems handle barriers failing in the middle of
>> the operation without functionality loss, but it makes barriers useless
>> for any performance-sensitive tasks (commits that wouldn't block
>> concurrent activity). Non-blocking commits could only be implemented if
>> barriers don't fail.
>> 
> 
> If a barrier fails at runtime, the filesystems do fall back to not doing
> barriers without real problems.

That's because there are no real problems in not honoring barriers - unless
your system crashes.

> But, that's because they don't actually 
> rely on the barriers to decide if an async commit is a good idea.

As long as they cannot rely on barriers - how should they?

[...]
> In general, async commits happen with threads and they aren't related to
> barriers.

If my filesystem said "First update b, then let a point to b", where the H
is the thread?

> Barriers don't really give us error handling,

Each request should give you error handling, but you are right: The whole
queue after the barrier must be aborted, too. (Or better: The part depending
on the barrier.)

> and they are at  
> the very end of a long chain of technical problems around commits that
> don't block concurrent activity.

You lost me here, but I guess the end will be a major rewrite.
