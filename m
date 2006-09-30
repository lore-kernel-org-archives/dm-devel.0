From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/4] dm-userspace: fix DMU_FLAG_SYNC
Date: Sun, 01 Oct 2006 01:12:11 +0900
Message-ID: <20061001011211M.fujita.tomonori@lab.ntt.co.jp>
References: <200609301044.k8UAifNn013346@r-dd.iij4u.or.jp>
	<m3irj5z73q.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3irj5z73q.fsf@guaranine.beaverton.ibm.com>
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
Subject: Re: [dm-devel] [PATCH 3/4] dm-userspace: fix DMU_FLAG_SYNC
Date: Sat, 30 Sep 2006 08:50:33 -0700

> FT> Seems that DMU_FLAG_SYNC flag is always set. Is this intentional?
> 
> Yes.  We set this flag so that in endio we can decide whether or not
> to send a notification to userspace before we allow it to complete.
> Perhaps this should be named something more descriptive, like
> DELAY_COMPLETE or something like that.

My point is that the kernel module always sets DMU_FLAG_SYNC flag
regardless of user space. As the patch does, should dmu_cpy_flag be
used instead of cmu_set_flag? This enables a user-space programs to
choose the behavior.
