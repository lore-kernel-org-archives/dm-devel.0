From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: dm-userspace (no in-kernel cache version)
Date: Fri, 15 Sep 2006 00:48:07 +0900
Message-ID: <20060915004807D.fujita.tomonori@lab.ntt.co.jp>
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

> 2. I was unable to get your code to perform well with multiple threads
>    of dbench.  While my code sustains performance with 16 threads, the
>    non-cache/ringbuffer version slows to a crawl (~1MB/s with 16
>    procs).  I noticed that the request list grows to over a 100,000
>    entries at times, which means that the response from userspace
>    requires searching that linearly, which may be the issue.

Have you tried SCHED_FIFO?

By the way, can you upload or post the latest kernel and user-space
code?
