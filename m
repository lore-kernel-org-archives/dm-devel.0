From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Thoughts on removing the remap cache
Date: Sun, 01 Oct 2006 01:27:38 +0900
Message-ID: <20061001012738C.fujita.tomonori@lab.ntt.co.jp>
References: <m3d59e1hj9.fsf@guaranine.beaverton.ibm.com>
	<200609300246.k8U2khwi004095@r-dd.iij4u.or.jp>
	<m3ven5z7dx.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3ven5z7dx.fsf@guaranine.beaverton.ibm.com>
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
Subject: Re: [dm-devel] Thoughts on removing the remap cache
Date: Sat, 30 Sep 2006 08:44:26 -0700

> FT> I guess that dbench generates relatively large size I/Os than
> FT> common workloads, which is more sensitive to latency.
> 
> Right, that is what I am thinking.  However, dbench inside a domU does
> not perform well either.  Even running dbench inside a domU, the
> batches that the userspace daemon sees are only about 10 requests,
> compared to several thousand at times when running on bare metal.
> 
> FT> Seems that Xen camp is pretty happy with blktap. So dm-userspace
> FT> should be ok with domU. Maybe it's time to try ring buffer stuff
> FT> again. :)
> 
> You think that the ring buffer has the potential to be lower latency
> due to fewer memcpy()'s right?

Yeah, though there might be other factors, I guess.

Anyway, could you try the new ring buffer patch that I posted?
