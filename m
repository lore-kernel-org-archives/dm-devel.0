From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 10/30] multipath-tools tests: omit timestamp in
	log messages
Date: Fri,  7 Jun 2019 15:05:32 +0200
Message-ID: <20190607130552.13203-11-mwilck@suse.com>
References: <20190607130552.13203-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190607130552.13203-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/globals.c | 2 +-
 tests/hwtable.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/globals.c b/tests/globals.c
index 07d970ea..aeb7723f 100644
--- a/tests/globals.c
+++ b/tests/globals.c
@@ -3,7 +3,7 @@
 
 /* Required globals */
 struct udev *udev;
-int logsink = 0;
+int logsink = -1;
 struct config conf = {
 	.uid_attrs = "sd:ID_BOGUS",
 	.verbosity = 4,
diff --git a/tests/hwtable.c b/tests/hwtable.c
index ad863b08..13da1d99 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -54,7 +54,7 @@ struct hwt_state {
 
 static struct config *_conf;
 struct udev *udev;
-int logsink;
+int logsink = -1;
 
 struct config *get_multipath_config(void)
 {
-- 
2.21.0
