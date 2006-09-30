From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Latest dm-userspace kernel code
Date: Sat, 30 Sep 2006 12:14:51 +0900
Message-ID: <200609300314.k8U3EvGF006445@r-dd.iij4u.or.jp>
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
> 
> Am I over-thinking it?

Oh, I see. I think that you are right. That should not happen.


> FT> - How does the current kernel/user interface support multiple
> FT> destination feature?
> 
> I'm not sure what you mean here.  Can you elaborate?

I thought that dm-userpsace supports a feature to map a single request
to multiple devices for kinda raid. For that, I guess that struct
dmu_msg_map_response includes several sets of dst_maj and dst_min. Or
you might use 'linked' dmu_msg_map_response, which enables a
user-space daemon to send multiple dmu_msg_map_responses for one
dmu_msg_map_request (if a dmu_msg_map_response is marked 'linked',
dm-userspace module clones the bio and does not free struct
the dmu_request).
