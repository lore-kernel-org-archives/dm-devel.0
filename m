From: mwilck@suse.com
Subject: [PATCH 34/35] kpartx: print an error message if removing
	a partition fails
Date: Thu,  9 Jul 2020 12:16:19 +0200
Message-ID: <20200709101620.6786-35-mwilck@suse.com>
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
 kpartx/kpartx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index c24ad6d..5f59e15 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -635,6 +635,8 @@ main(int argc, char **argv){
 
 				if (!dm_simplecmd(DM_DEVICE_REMOVE,
 						  partname, 1, 0)) {
+					fprintf(stderr, "failed to remove %s",
+						partname);
 					r++;
 					continue;
 				}
-- 
2.26.2
