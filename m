From: NeilBrown <neilb@suse.de>
Subject: [PATCH dmraid 1/1] Ensure metadata dump of pdc metadata
	has the correct offset.
Date: Fri, 11 Dec 2009 14:27:11 +1100
Message-ID: <20091211033030.695580934@suse.de>
References: <20091211032710.161471708@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=pdc-metadata-dump-fix
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

a read_metadata function needds to set *offset so that file_metadata
can create the correct xxx/dev-offset file.
pdf_read_metadata does not set *offset.

This patch add the appropriate setting.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 1.0.0.rc16/lib/format/ataraid/pdc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- dmraid.orig/1.0.0.rc16/lib/format/ataraid/pdc.c
+++ dmraid/1.0.0.rc16/lib/format/ataraid/pdc.c
@@ -202,8 +202,11 @@ pdc_read_metadata(struct lib_context *lc
 							break;
 
 					/* Memorize main metadata sector. */
-					} else if (!info->u32)
+					} else if (!info->u32) {
 						info->u32 = *s;
+						*offset = sub ? di->sectors - *s : *s;
+					}
+
 				}
 			}
 		}
