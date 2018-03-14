From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 03/12] libmultipath: set dm_conf_verbosity
Date: Wed, 14 Mar 2018 12:46:36 -0500
Message-ID: <1521049605-22050-4-git-send-email-bmarzins@redhat.com>
References: <1521049605-22050-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521049605-22050-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>, christophe.varoqui@free.fr
List-Id: dm-devel.ids

dm_conf_verbosity was created to keep dm_write_log from needing
access to the multipath config. However it never was set.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 767d87c..ef1fd2b 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -95,6 +95,7 @@ dm_write_log (int level, const char *file, int line, const char *f, ...)
 
 void dm_init(int v)
 {
+	dm_conf_verbosity = v;
 	dm_log_init(&dm_write_log);
 	dm_log_init_verbose(v + 3);
 }
-- 
2.7.4
