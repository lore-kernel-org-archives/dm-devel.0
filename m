From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH RFC] dm snapshot: shared exception store
Date: Tue, 12 Aug 2008 22:14:24 +0900
Message-ID: <20080812221448N.fujita.tomonori@lab.ntt.co.jp>
References: <20080804171242V.fujita.tomonori@lab.ntt.co.jp>
	<200808120556.57314.phillips@phunq.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200808120556.57314.phillips@phunq.net>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Tue, 12 Aug 2008 05:56:57 -0700
Daniel Phillips <phillips@phunq.net> wrote:

> Hi tomonori,
> 
> An impressive patch.

Thanks, and thanks a lot for the nice snapshot code.


>  You just want to use getblk for alloc_chunk_buffer,
> not vmalloc.

I think that it means that we cache all the chunks, both btree chunks
and the data chunks (which are passed to the upper layer such as file
systems). I think that we don't want cache the latter in dm.


> That is what the buffer cache is for, and that is why I
> emulated it in userspace.
> 
> More comments later.

Thanks.

I'll post a new patchset in a more reasonable format shortly (tomorrow
or day after tomorrow, hopefully).
