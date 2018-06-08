From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 03/28] libmultipath: remove superfluous
	conditionals in load_config()
Date: Fri,  8 Jun 2018 12:20:16 +0200
Message-ID: <20180608102041.22904-4-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

In load_config(), conf is freshly allocated, there's no point in checking
previously set values.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 8769441c..ce7bedac 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -607,8 +607,7 @@ load_config (char * file)
 	/*
 	 * internal defaults
 	 */
-	if (!conf->verbosity)
-		conf->verbosity = DEFAULT_VERBOSITY;
+	conf->verbosity = DEFAULT_VERBOSITY;
 
 	get_sys_max_fds(&conf->max_fds);
 	conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
@@ -634,12 +633,9 @@ load_config (char * file)
 	/*
 	 * preload default hwtable
 	 */
-	if (conf->hwtable == NULL) {
-		conf->hwtable = vector_alloc();
-
-		if (!conf->hwtable)
+	conf->hwtable = vector_alloc();
+	if (!conf->hwtable)
 			goto out;
-	}
 	if (setup_default_hwtable(conf->hwtable))
 		goto out;
 
-- 
2.17.0
