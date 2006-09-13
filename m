From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: dm-userspace (no in-kernel cache version)
Date: Wed, 13 Sep 2006 11:01:31 +0900
Message-ID: <200609130201.k8D21V3e014353@r-dd.iij4u.or.jp>
References: <20060912080748X.fujita.tomonori@lab.ntt.co.jp>
	<m3lkoopxf9.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3lkoopxf9.fsf@guaranine.beaverton.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Dan Smith <danms@us.ibm.com>
Subject: Re: [dm-devel] dm-userspace (no in-kernel cache version)
Date: Tue, 12 Sep 2006 14:50:02 -0700

> FT> As explained, this removes rmap (in-kernel cache) and use mmaped
> FT> buffer instead of read/write system calls for user/kernel
> FT> communication.
> 
> Ok, I got your code to work, and I have run some benchmarks.  I'll cut
> directly to the chase...
> 
> I used dbench with a single process, for 120 seconds on a dm-userspace
> device mapping directly to an LVM device.  I used my example.c and the
> example-rb.c provided with the ringbuffer version.  The results are:
> 
>   with cache, chardev:  251 MB/s
>   no cache, ringbuffer: 243 MB/s

Thanks. Looks very nice.


> I am very pleased with these results.  I assume that your code is not
> tuned for performance yet, which means we should be able to squeeze at
> least 8 MB/s more out to make it equal (or better).  Even still, the
> amount of code it saves is worth the hit, IMHO.

Yeah.


> I do have a couple of comments:
> 
> 1. You said that the ringbuffer saves the need for syscalls on each
>    batch read.  This is partially true, but you still use a write() to
>    signal completion so that the kernel will read the u->k ringbuffer.

Right. Practically, a user-space daemon needs to notify the kernel of
new events.


>    So, at best, the number of syscalls made is half of my
>    read()/write() method.  I think it's possible that another
>    signaling mechanism could be used, which would eliminate this call.

Yeah. There are other possible mechanisms for notifications. I just
chose a easy one.


>    I do think eliminating the copying with the ringbuffer approach is
>    very nice; I like it a lot.
> 
> 2. I was unable to get your code to perform well with multiple threads
>    of dbench.  While my code sustains performance with 16 threads, the
>    non-cache/ringbuffer version slows to a crawl (~1MB/s with 16
>    procs).  I noticed that the request list grows to over a 100,000
>    entries at times, which means that the response from userspace
>    requires searching that linearly, which may be the issue.

Surely, we need to replace the request list with hash list.

Another possible improvement is that simplifying dmu_ctl_write() by
using kernel thread. Now the user-space daemon calls dmu_ctl_write()
and does lots of work in kernel mode. It is better for a user-space
daemon to just notify kernel of new events, go back to user space, and
receive new events from kernel in SMP boxes. I like to create kernel
threads, dmu_ctl_write just wakes up the threads, and they call
dmu_event_recv().


> I am going to further study your changes, but I think in the end that
> I will incorporate most or all of them.  Some work will need to be
> done to incorporate support for some of the newer features (endio, for
> example), but I'll start looking into that.

Yep, I dropped some of the features because of my laziness, though if
endio means that the kernel notifies user-space of I/O completion, I
think that I implemented it.

One possible feature is support for multiple destinations. If user
space can tell kernel to write multiple devices, we can implement
kinda RAID daemons in user space.
