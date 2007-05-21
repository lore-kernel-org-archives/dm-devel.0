From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 20/21] [kpartx] Update BSD slice handling
Date: Mon, 21 May 2007 11:24:32 +0200
Message-ID: <20070521092432.E2077D44CB@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Now that we have the logic to stack dm-tables for partitions we can
handle BSD 'c' slices (which span the entire disk) properly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/bsd.c |   39 +++++++++++++++++++++++++++++++++++----
 1 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/kpartx/bsd.c b/kpartx/bsd.c
index 3ae2dc4..f87175e 100644
--- a/kpartx/bsd.c
+++ b/kpartx/bsd.c
@@ -10,7 +10,7 @@ struct bsd_disklabel {
 	short int	d_type;		/* drive type */
 	short int	d_subtype;	/* controller/d_type specific */
 	char	d_typename[16];		/* type name, e.g. "eagle" */
-	char	d_packname[16];		/* pack identifier */ 
+	char	d_packname[16];		/* pack identifier */
 	unsigned int	d_secsize;	/* # of bytes per sector */
 	unsigned int	d_nsectors;	/* # of data sectors per track */
 	unsigned int	d_ntracks;	/* # of tracks per cylinder */
@@ -50,12 +50,12 @@ int
 read_bsd_pt(int fd, struct slice all, struct slice *sp, int ns) {
 	struct bsd_disklabel *l;
 	struct bsd_partition *p;
-	unsigned int offset = all.start;
+	unsigned int offset = all.start, end;
 	int max_partitions;
 	char *bp;
-	int n = 0;
+	int n = 0, i, j;
 
-	bp = getblock(fd, offset+1); 	/* 1 sector suffices */
+	bp = getblock(fd, offset+1);    /* 1 sector suffices */
 	if (bp == NULL)
 		return -1;
 
@@ -79,5 +79,36 @@ read_bsd_pt(int fd, struct slice all, st
 			break;
 		}
 	}
+	/*
+	 * Convention has it that the bsd disklabel will always have
+	 * the 'c' partition spanning the entire disk.
+	 * So we have to check for contained slices.
+	 */
+	for(i = 0; i < n; i++) {
+		if (sp[i].size == 0)
+			continue;
+
+		end = sp[i].start + sp[i].size;
+		for(j = 0; j < n; j ++) {
+			if ( i == j )
+				continue;
+			if (sp[j].size == 0)
+				continue;
+
+			if (sp[i].start < sp[j].start) {
+				if (end > sp[j].start &&
+				    end < sp[j].start + sp[j].size) {
+					/* Invalid slice */
+					fprintf(stderr,
+						"bsd_disklabel: slice %d overlaps with %d\n", i , j);
+					sp[i].size = 0;
+				}
+			} else {
+				if (end <= sp[j].start + sp[j].size) {
+					sp[i].container = j + 1;
+				}
+			}
+		}
+	}
 	return n;
 }
-- 
1.4.3.4
