From: mwilck@suse.com
Subject: [PATCH 30/35] libmultipath: alloc_path(): initialize
	pp->initialized
Date: Thu,  9 Jul 2020 12:16:15 +0200
Message-ID: <20200709101620.6786-31-mwilck@suse.com>
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

INIT_NEW is 0, but being explicit is better here.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 2dd378c..9407462 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -92,6 +92,7 @@ alloc_path (void)
 	pp = (struct path *)MALLOC(sizeof(struct path));
 
 	if (pp) {
+		pp->initialized = INIT_NEW;
 		pp->sg_id.host_no = -1;
 		pp->sg_id.channel = -1;
 		pp->sg_id.scsi_id = -1;
-- 
2.26.2
