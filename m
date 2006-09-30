From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Latest dm-userspace kernel code
Date: Sat, 30 Sep 2006 20:13:35 +0900
Message-ID: <200609301113.k8UBDfWS015780@r-dd.iij4u.or.jp>
References: <m3hcyr4sit.fsf@guaranine.beaverton.ibm.com>
	<200609300221.k8U2L7UU001919@r-dd.iij4u.or.jp>
	<m3zmciyt59.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3zmciyt59.fsf@guaranine.beaverton.ibm.com>
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

Seems that 4th patch is delayed or lost. I'll post it again if it will
not be delivered until tomorrow.

From: Dan Smith <danms@us.ibm.com>
Subject: Re: [dm-devel] Latest dm-userspace kernel code
Date: Fri, 29 Sep 2006 19:39:46 -0700

> FT> - What is the purpose of dmu_request->deps? I guess that it is for
> FT> preventing I/O being reordered. if so, again, you don't need to do
> FT> that.
> 
> Well, the problem is that a block copy would overwrite other requests.
> I think that while a copy is happening, you have to be careful to not
> write into that block so that your writes are not lost.

On second thought, I think that it would be better to handle this in
user space.

If you add a feature to notify I/O completion of user space (I think
this feature is necessary for other reasons too), user-space programs
can take care about this easily. I prefer the dm-userspace kernel
module to just perform I/Os according to requests from user space.
