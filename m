From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 17/33] multipathd: imply -n if find_multipaths is
	set
Date: Tue, 28 Feb 2017 17:23:13 +0100
Message-ID: <20170228162329.14517-18-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
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
List-Id: dm-devel.ids

Automatic detection of new devices with find_multipaths
doesn't work correctly currently. Therefore, for now,
imply ignore_new_devs if find_multipaths is seen.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index cf44778b..8f464bfb 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2183,6 +2183,10 @@ reconfigure (struct vectors * vecs)
 		conf->verbosity = verbosity;
 	if (bindings_read_only)
 		conf->bindings_read_only = bindings_read_only;
+	if (conf->find_multipaths) {
+		condlog(2, "find_multipaths is set: -n is implied");
+		ignore_new_devs = 1;
+	}
 	if (ignore_new_devs)
 		conf->ignore_new_devs = ignore_new_devs;
 	uxsock_timeout = conf->uxsock_timeout;
-- 
2.11.0
