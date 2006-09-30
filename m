From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Latest dm-userspace kernel code
Date: Sun, 01 Oct 2006 02:27:48 +0900
Message-ID: <20061001022748A.fujita.tomonori@lab.ntt.co.jp>
References: <m3zmciyt59.fsf@guaranine.beaverton.ibm.com>
	<200609300314.k8U3EvGF006445@r-dd.iij4u.or.jp>
	<m3r6xtz7b1.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3r6xtz7b1.fsf@guaranine.beaverton.ibm.com>
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
Date: Sat, 30 Sep 2006 08:46:10 -0700

> FT> I thought that dm-userpsace supports a feature to map a single
> FT> request to multiple devices for kinda raid. For that, I guess that
> FT> struct dmu_msg_map_response includes several sets of dst_maj and
> FT> dst_min. Or you might use 'linked' dmu_msg_map_response, which
> FT> enables a user-space daemon to send multiple dmu_msg_map_responses
> FT> for one dmu_msg_map_request (if a dmu_msg_map_response is marked
> FT> 'linked', dm-userspace module clones the bio and does not free
> FT> struct the dmu_request).
> 
> Hmm, I had not planned to implement this kind of behavior, but I can
> see the benefit.  I think it would be best to focus on performance for
> now and add that capability later.

As I said before, once the code is merged into mainline (hopefully),
you cannot touch dm-usersapce.h. So at least, you need to have a
proper kernel/user interface for possible features.

OK. Let me work on this.
