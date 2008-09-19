From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 0/2] dm: cleanup for request-based dm-multipath
Date: Fri, 19 Sep 2008 10:59:58 -0400 (EDT)
Message-ID: <20080919.105958.78703932.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

Hi Alasdair,

The following patches are clean-ups of dm for preparation of
request-based dm-multipath.
The patches are created on top of 2.6.27-rc6 + your linux-next
patches (*1).  But there is no functional dependency to the linux-next
patches.

(*1) The patches shown between "NEXT_PATCHES_START" and "NEXT_PATCHES_END"
ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing-quilt/patches/series.html


Please review and apply.
The request-based dm-multipath patches (*2) depend on these clean-ups.
I hope both patches are pushed to linux-next for 2.6.28.

(*2) http://lkml.org/lkml/2008/9/12/100


Summary of the patches:
  1/2: dm core: remove unused DM_WQ_FLUSH_ALL
  2/2: dm core: tidy local_init

(PATCH 1/2 is also included in the Milan's barrier support patch-set.)

Thanks,
Kiyoshi Ueda
