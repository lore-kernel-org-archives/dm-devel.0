From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] dm-cache-target: check for allocation failure
Date: Fri, 1 Mar 2013 23:26:41 +0300
Message-ID: <20130301202641.GA22066@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org, kbuild@01.org
List-Id: dm-devel.ids

The allocation here isn't checked.  I changed it to using kcalloc()
as a cleanup.  It adds integer overflow checking as well which makes
the code easier to audit.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I expect that kbuild will complain about this soon?

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 908d554..40753b4 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1957,8 +1957,11 @@ bad:
 static int copy_ctr_args(struct cache *cache, int argc, const char **argv)
 {
 	unsigned i;
-	const char **copy = kzalloc(sizeof(*copy) * argc, GFP_KERNEL);
+	const char **copy;
 
+	copy = kcalloc(argc, sizeof(*copy), GFP_KERNEL);
+	if (!copy)
+		return -ENOMEM;
 	for (i = 0; i < argc; i++) {
 		copy[i] = kstrdup(argv[i], GFP_KERNEL);
 		if (!copy[i]) {
