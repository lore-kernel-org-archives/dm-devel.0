From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Latest dm-userspace kernel code
Date: Sun, 01 Oct 2006 02:35:02 +0900
Message-ID: <20061001023502S.fujita.tomonori@lab.ntt.co.jp>
References: <m3zmciyt59.fsf@guaranine.beaverton.ibm.com>
	<200609301113.k8UBDfWS015780@r-dd.iij4u.or.jp>
	<m3mz8hz76i.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3mz8hz76i.fsf@guaranine.beaverton.ibm.com>
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
Date: Sat, 30 Sep 2006 08:48:53 -0700

> FT> If you add a feature to notify I/O completion of user space (I
> FT> think this feature is necessary for other reasons too), user-space
> FT> programs can take care about this easily. I prefer the
> FT> dm-userspace kernel module to just perform I/Os according to
> FT> requests from user space.
> 
> I have thought about this approach before, and perhaps it makes sense,
> as it will simplify the kernel module and move all of the CoW-like
> behavior back out to userspace.

I think that it would be better for the kerne module to provide only
generic mechanisms.


> In order for this to perform well, we will need to use AIO, right?

I'm not sure about this. Can you elaborate?
