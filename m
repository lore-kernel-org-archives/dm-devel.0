From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH 3/3] sysfs representation of stacked devices (md)
	(rev.2)
Date: Wed, 22 Feb 2006 11:13:11 -0500
Message-ID: <43FC8D97.9080102@ce.jp.nec.com>
References: <43FC8C00.5020600@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080802050506060906040303"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43FC8C00.5020600@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>, Greg KH <gregkh@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------080802050506060906040303
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

This patch modifies md driver to call bd_claim_by_kobject
and bd_release_from_kobject.

-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.

--------------080802050506060906040303
Content-Type: text/x-patch;
 name="md.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md.patch"

Exporting stacked device relationship to sysfs (md)

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

--- linux-2.6.15/drivers/md/md.c	2006-01-02 22:21:10.000000000 -0500
+++ linux-2.6.15/drivers/md/md.c	2006-02-21 19:11:16.000000000 -0500
@@ -1226,6 +1226,7 @@ static int bind_rdev_to_array(mdk_rdev_t
 	else
 		ko = &rdev->bdev->bd_disk->kobj;
 	sysfs_create_link(&rdev->kobj, ko, "block");
+	bd_claim_by_kobject(rdev->bdev, rdev, &mddev->gendisk->slave_dir);
 	return 0;
 }
 
@@ -1236,6 +1237,7 @@ static void unbind_rdev_from_array(mdk_r
 		MD_BUG();
 		return;
 	}
+	bd_release_from_kobject(rdev->bdev, &rdev->mddev->gendisk->slave_dir);
 	list_del_init(&rdev->same_set);
 	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
 	rdev->mddev = NULL;

--------------080802050506060906040303
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------080802050506060906040303--
