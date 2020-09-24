From: mwilck@suse.com
Subject: [PATCH 13/23] multipathd: print error message if config
	can't be loaded
Date: Thu, 24 Sep 2020 15:40:44 +0200
Message-ID: <20200924134054.14632-14-mwilck@suse.com>
References: <20200924134054.14632-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924134054.14632-1-mwilck@suse.com>
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
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 3c8f893..483b3c7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3074,8 +3074,10 @@ child (__attribute__((unused)) void *param)
 	condlog(2, "read " DEFAULT_CONFIGFILE);
 
 	conf = load_config(DEFAULT_CONFIGFILE);
-	if (!conf)
+	if (!conf) {
+		condlog(0, "failed to load configuration");
 		goto failed;
+	}
 
 	if (verbosity)
 		conf->verbosity = verbosity;
-- 
2.28.0
