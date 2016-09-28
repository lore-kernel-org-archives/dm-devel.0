From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 03/10] md/dm-crypt: Rename a jump label in crypt_message()
Date: Wed, 28 Sep 2016 17:40:14 +0200
Message-ID: <db29ff0c-8da9-e7ba-054d-a35f8b4fd2d7@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 28 Sep 2016 14:54:39 +0200

Adjust a jump label according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-crypt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 88a3b62..08e3de2 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2016,7 +2016,7 @@ static int crypt_message(struct dm_target *ti, unsigned argc, char **argv)
 	int ret = -EINVAL;
 
 	if (argc < 2)
-		goto error;
+		goto show_warning;
 
 	if (!strcasecmp(argv[0], "key")) {
 		if (!test_bit(DM_CRYPT_SUSPENDED, &cc->flags)) {
@@ -2040,8 +2040,7 @@ static int crypt_message(struct dm_target *ti, unsigned argc, char **argv)
 			return crypt_wipe_key(cc);
 		}
 	}
-
-error:
+show_warning:
 	DMWARN("unrecognised message received.");
 	return -EINVAL;
 }
-- 
2.10.0

