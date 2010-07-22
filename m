From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/2] multipath-tools: Assign correct pointer from
	REALLOC
Date: Thu, 22 Jul 2010 18:36:47 +0200
Message-ID: <20100722163918.159875000@de.ibm.com>
References: <20100722163646.585967000@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=fix-vector-realloc.diff
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
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Assign the pointer returned from REALLOC to v->slot; this is the memory area to
be changed.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 libmultipath/vector.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/libmultipath/vector.c
+++ b/libmultipath/vector.c
@@ -96,7 +96,7 @@ vector_del_slot(vector v, int slot)
 		v->slot = NULL;
 	}
 	else
-		v = REALLOC(v->slot, sizeof (void *) * v->allocated);
+		v->slot = REALLOC(v->slot, sizeof (void *) * v->allocated);
 }
 
 void
