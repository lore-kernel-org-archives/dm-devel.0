From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] Add userspace device-mapper target
Date: Fri, 9 Feb 2007 00:48:01 +0900 (JST)
Message-ID: <20070209004800A.fujita.tomonori@lab.ntt.co.jp>
References: <m3lkjltq1x.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3lkjltq1x.fsf@guaranine.beaverton.ibm.com>
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
Subject: [dm-devel] [PATCH 1/2] Add userspace device-mapper target
Date: Mon, 29 Jan 2007 14:40:26 -0800

> This adds the dm-userspace kernel device-mapper target.  It contains
> my latest changes, as well as Fujita's ringbuffer transport.

Some comments:

- The current ring buffer interface is the producer/consumer pointer
scheme. It's simple but it doesn't work for multi processes/threads.
Seems that kevent has a better ring buffer interface. And it's trying
to introduce new system calls for its ring buffer. They might work for
dm-user.

- DMU_FLAG_SYNC needs two round-trips between kernel and user
space. This leads to large latency (the poor performance of CoW). 
DMU_FLAG_SYNC COW scheme (user space needs AIO writes to perform
another I/O from kernel) doen't sound good (dead lock prone).

With two minor modifications, dmu can do more efficiently, I think.

  - enable an user-space to pass the kernel data to write

    If you add u64 (user's address) to struct dmu_msg_map_response,
    the kernel can map user's pages and add them to a bio. the write
    is done in a zero-copy manner. A user-space process can simply
    mmap a file and pass the address of the metadata (for CoW) to the
    kernel. 2.6.20/drivers/scsi/scsi_tgt_lib.c does the same thing.

  - Introduing DMU_FLAG_LINKED

    If userspace uses DMU_FLAG_LINKED to ask the kernel to perform
    multiple commands atomically and sequentially. For example, if
    userspace needs to one data block and a metadata block (for the
    data block) for CoW, userspace can send two dmu_msg_map_response
    to the kernel. The former for the data block is with DMU_FLAG_LINKED and
    the latter is for the metadata block (usespace uses the above
    feature). The kernel performs two writes sequentially and then
    completes the original I/O (endio).

    DMU_FLAG_LINKED can be usefule for something like RAID
    (possibly it would be better to split DMU_FLAG_LINKED into
    DMU_FLAG_LINKED and DMU_FLAG_ORDERED).
