From: Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 2/4] dm verity: separate function for parsing opt
	args
Date: Thu,  5 Nov 2015 02:02:32 +0000
Message-ID: <1446688954-29589-3-git-send-email-samitolvanen@google.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Sami Tolvanen <samitolvanen@google.com>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

Move optional argument parsing into a separate function to make it
easier to add more of them without making verity_ctr even longer.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 drivers/md/dm-verity.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 487cb66..da76f77 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -34,6 +34,8 @@
 #define DM_VERITY_OPT_LOGGING		"ignore_corruption"
 #define DM_VERITY_OPT_RESTART		"restart_on_corruption"
 
+#define DM_VERITY_OPTS_MAX		1
+
 static unsigned dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
 
 module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, S_IRUGO | S_IWUSR);
@@ -725,6 +727,21 @@ static void verity_dtr(struct dm_target *ti)
 	kfree(v);
 }
 
+static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
+				 const char *opt_string)
+{
+	if (!strcasecmp(opt_string, DM_VERITY_OPT_LOGGING)) {
+		v->mode = DM_VERITY_MODE_LOGGING;
+		return 0;
+	} else if (!strcasecmp(opt_string, DM_VERITY_OPT_RESTART)) {
+		v->mode = DM_VERITY_MODE_RESTART;
+		return 0;
+	}
+
+	v->ti->error = "Invalid feature arguments";
+	return -EINVAL;
+}
+
 /*
  * Target parameters:
  *	<version>	The current format is version 1.
@@ -752,7 +769,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	char dummy;
 
 	static struct dm_arg _args[] = {
-		{0, 1, "Invalid number of feature args"},
+		{0, DM_VERITY_OPTS_MAX, "Invalid number of feature args"},
 	};
 
 	v = kzalloc(sizeof(struct dm_verity), GFP_KERNEL);
@@ -912,15 +929,11 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 				goto bad;
 			}
 
-			if (!strcasecmp(opt_string, DM_VERITY_OPT_LOGGING))
-				v->mode = DM_VERITY_MODE_LOGGING;
-			else if (!strcasecmp(opt_string, DM_VERITY_OPT_RESTART))
-				v->mode = DM_VERITY_MODE_RESTART;
-			else {
-				ti->error = "Invalid feature arguments";
-				r = -EINVAL;
+			r = verity_parse_opt_args(&as, v, opt_string);
+			if (r < 0)
 				goto bad;
-			}
+
+			opt_params -= r;
 		}
 	}
 
-- 
2.6.0.rc2.230.g3dd15c0
