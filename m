From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: dm-userspace (no in-kernel cache version)
Date: Wed, 13 Sep 2006 14:04:54 +0900
Message-ID: <20060913140454U.fujita.tomonori@lab.ntt.co.jp>
References: <m3lkoopxf9.fsf@guaranine.beaverton.ibm.com>
	<200609130201.k8D21V3e014353@r-dd.iij4u.or.jp>
	<m3hczcpeyd.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3hczcpeyd.fsf@guaranine.beaverton.ibm.com>
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
Date: Tue, 12 Sep 2006 21:28:58 -0700

> FT> Surely, we need to replace the request list with hash list.
> 
> I have done that now.  It helps performance quite a bit, although it
> does not perform at the same level with lots of threads.  I'll keep
> working on it.

I see. Thanks.


> FT> Yep, I dropped some of the features because of my laziness, though
> FT> if endio means that the kernel notifies user-space of I/O
> FT> completion, I think that I implemented it.
> 
> We need more than just notification of endio, but also the ability to
> delay the endio completion until userspace has acknowledged the
> endio.  This is crucial for us to maintain metadata consistency in the
> CoW case.

I'm not sure how this works. Have you explained the details of this
feature in the earlier thread?


> FT> One possible feature is support for multiple destinations. If user
> FT> space can tell kernel to write multiple devices, we can implement
> FT> kinda RAID daemons in user space.
> 
> Yes, my original version supported this, which would allow RAID from
> userspace, as well as lots of other neat tricks :)

I see. I don't think that you need to implement it now (simple code is
always better for mainline inclusion), however, it would be nice to
have dmu_event structure for this.
