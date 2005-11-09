From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] dm: memory leak in failed table_load()
Date: Wed, 09 Nov 2005 17:07:32 -0500 (EST)
Message-ID: <20051109.170732.41627574.k-ueda@ct.jp.nec.com>
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
To: agk@redhat.com, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Alasdair,

This patch fixes following two problems which occur when "dmsetup load foo"
is executed before the map of the "foo" is created.

  o memory leak.
  o unable to unload the dm_mod module.

Please consider to apply.

How to reproduce the problem:
  # echo "0 10 linear 8:16 0" | dmsetup load foo
  (Need to change "8:16" appropriately.)

Patch for 2.6.14:
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -up 2.6.14/drivers/md/dm-ioctl.c fix/drivers/md/dm-ioctl.c
--- 2.6.14/drivers/md/dm-ioctl.c	2005-10-27 20:02:08.000000000 -0400
+++ fix/drivers/md/dm-ioctl.c	2005-11-09 15:29:59.000000000 -0500
@@ -974,6 +974,7 @@ static int table_load(struct dm_ioctl *p
 	if (!hc) {
 		DMWARN("device doesn't appear to be in the dev hash table.");
 		up_write(&_hash_lock);
+		dm_table_put(t);
 		return -ENXIO;
 	}

Thanks,
Kiyoshi Ueda
