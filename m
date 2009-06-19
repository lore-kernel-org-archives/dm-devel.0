From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 0/4] use block-layer's clone interface in
	request-based dm
Date: Fri, 19 Jun 2009 16:40:04 +0900
Message-ID: <4A3B40D4.1040905@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
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
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

This patch-set changes request-based dm to use the block-layer's
clone setup interface, blk_rq_prep_clone().
(Before that, some clean-ups for request-based dm are included.)

This patch-set can be applied on top of your linux-next patches
including request-based dm (v3):
    http://marc.info/?l=dm-devel&m=124392590507004&w=2

Summary of the patch-set
------------------------
  1/4: dm core: use BUG_ON in dm_end_request()
  2/4: dm core: clean up completion handling of clone bio
  3/4: dm core: remove 'md' argument from free_rq_tio()
  4/4: dm core: use generic clone setup interface

 drivers/md/dm.c |  160 ++++++++++++++++++--------------------------------------
 1 file changed, 52 insertions(+), 108 deletions(-)

Thanks,
Kiyoshi Ueda
