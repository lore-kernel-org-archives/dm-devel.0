From: heinzm@sourceware.org
Subject: dmraid/lib/format/ataraid pdc.c
Date: 14 Dec 2009 14:33:14 -0000
Message-ID: <20091214143314.18834.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2009-12-14 14:33:14

Modified files:
	lib/format/ataraid: pdc.c 

Log message:
	pdc: fix offset.dat file (Neil Brown)

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/pdc.c.diff?cvsroot=dm&r1=1.7&r2=1.8

--- dmraid/lib/format/ataraid/pdc.c	2009/11/02 13:20:40	1.7
+++ dmraid/lib/format/ataraid/pdc.c	2009/12/14 14:33:13	1.8
@@ -202,8 +202,11 @@
 							break;
 
 					/* Memorize main metadata sector. */
-					} else if (!info->u32)
+					} else if (!info->u32) {
 						info->u32 = *s;
+						*offset = sub ? di->sectors - *s :
+								*s;
+					}
 				}
 			}
 		}
