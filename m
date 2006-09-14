From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: dm-userspace (no in-kernel cache version)
Date: Fri, 15 Sep 2006 00:51:38 +0900
Message-ID: <20060915005138A.fujita.tomonori@lab.ntt.co.jp>
References: <m3hczcpeyd.fsf@guaranine.beaverton.ibm.com>
	<20060913140454U.fujita.tomonori@lab.ntt.co.jp>
	<m3d59zq41e.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3d59zq41e.fsf@guaranine.beaverton.ibm.com>
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
Date: Wed, 13 Sep 2006 06:39:25 -0700

> FT> I'm not sure how this works. Have you explained the details of
> FT> this feature in the earlier thread?
> 
> For example, in our CoW case:
> 
> A write is made to a previously unremapped block.  We queue that block
> and let userspace make a mapping.  Then, we allow the write to happen,
> but intercept the completion (endio) and notify userspace that it has
> completed.  Then, userspace flushes its metadata to disk and notifies
> the kernel to allow the endio to complete.  Without this, a crash
> could result in an inconsistent CoW device.  (Note this only needs to
> happen on the _initial_ write to a block)

I see. Thanks.


> FT> I see. I don't think that you need to implement it now (simple
> FT> code is always better for mainline inclusion), however, it would
> FT> be nice to have dmu_event structure for this.
> 
> Well, it's crucial for our CoW work, so unless Alasdair would prefer
> me to leave it out in the initial upstream push, I would like to
> include it.  It was already implemented and working in my original
> version.

Of course, no problem if the maintainer agrees on it. I just meant
that user-kernel APIs must be ready for the future extensions because
you cannot change them easily after inclusion.
