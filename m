From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Latest dm-userspace kernel code
Date: Tue, 19 Sep 2006 19:46:41 +0900
Message-ID: <20060919194641P.fujita.tomonori@lab.ntt.co.jp>
References: <m38xkhmdkv.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m38xkhmdkv.fsf@guaranine.beaverton.ibm.com>
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
Subject: [dm-devel] Latest dm-userspace kernel code
Date: Mon, 18 Sep 2006 07:52:48 -0700

> This is the latest dm-userspace kernel code.  I have removed the
> in-kernel remap cache and cleaned up a lot of code as a result.
> Performance of the map cache/no cache versions seem to be about the
> same.
> 
> I also tweaked the message protocol to be more rigid.  It now looks
> more like the ringbuffer messages, which should allow an easier
> transition to a ringbuffer approach.  This is not completely clean,
> but I wanted to post it for visibility now that it seems to be stable
> for me.

Thanks.

Have you already started to write the ring buffer interface for the
performance comparison? Or would you like me to implement it?
