From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Latest dm-userspace kernel code
Date: Sun, 01 Oct 2006 12:51:24 +0900
Message-ID: <200610010351.k913pOSL020042@r-dd.iij4u.or.jp>
References: <m3mz8hz76i.fsf@guaranine.beaverton.ibm.com>
	<20061001023502S.fujita.tomonori@lab.ntt.co.jp>
	<m364f5yomi.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m364f5yomi.fsf@guaranine.beaverton.ibm.com>
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
Subject: Re: [dm-devel] Latest dm-userspace kernel code
Date: Sat, 30 Sep 2006 15:29:41 -0700

> >> In order for this to perform well, we will need to use AIO, right?
> FT> I'm not sure about this. Can you elaborate?
> 
> Well, assuming that a copy operation (and an fsync() to make sure it
> is on-disk) is a non-trivial operation, it would be good to allow the
> copy to happen in the background while still being able to service
> other requests from the kernel.

Seems that we ara not talking about the same thing.

I'm talking about removing dmu_request->deps (dependent request
feature). Seems that you are talking about DMU_FLAG_COPY_FIRST
feature (it's ok for me).

My point is that the dependent request feature can be done in user
space easily. If a user-space program gets a request trying to perform
I/Os in the same block that an outgoing request with
DMU_FLAG_COPY_FIRST are performing I/Os too, it waits for the I/O
completion and then submit the new request to kernel space.


> In cowd, I need to write metadata when blocks are mapped, and fsync()
> them to make sure they are on disk before I allow the IO to complete.
> If I do this with a normal write()/fsync() (or open the file O_SYNC),
> then cowd is blocked until the write is complete.  This means that
> other requests that are in the queue, which may not require a copy,
> are also blocked unnecessarily.  I assume that unless copy operations
> are performed asynchronously (as they are now by letting the kernel do
> it), the problem will get even worse.

I think that AIO is essential for the metadata issue even with
DMU_FLAG_COPY_FIRST and dependent request features, though the
DMU_FLAG_COPY_FIRST feature is important for writing a newly allocated
cow block.

I thought your user-space programs uses AIO like blktap does, though
the current AIO implementation lacks some important features.
