From: mwilck@suse.com
Subject: [PATCH 35/35] kpartx: add missing newline
Date: Thu,  9 Jul 2020 12:16:20 +0200
Message-ID: <20200709101620.6786-36-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
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

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 86731ea..3efd6df 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -618,7 +618,7 @@ remove_partmap(const char *name, void *data)
 
 	if (dm_get_opencount(name)) {
 		if (rd->verbose)
-			printf("%s is in use. Not removing", name);
+			printf("%s is in use. Not removing\n", name);
 		return 1;
 	}
 	if (!dm_simplecmd(DM_DEVICE_REMOVE, name, 0, 0)) {
-- 
2.26.2
