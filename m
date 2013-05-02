From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 06/16] Fix hardware entry matching code
Date: Thu,  2 May 2013 16:46:27 -0500
Message-ID: <1367531197-8987-7-git-send-email-bmarzins@redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

When a user defined hardware table entry's identifiers exactly
match a built-in one's, the built-in one is removed, and the list
is rescaned.  However, the built-in entry is not freed, and on the
rescan, the first user defined entry is treated as a built-in
entry. This patch frees the built-in entry, and decrements the
number of built-in entries, so that the rescan works as expected.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 25d3e3d..da676df 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -436,6 +436,8 @@ restart:
 			merge_hwe(hwe2, hwe1);
 			if (hwe_strmatch(hwe2, hwe1) == 0) {
 				vector_del_slot(hw, i);
+				free_hwe(hwe1);
+				n -= 1;
 				/*
 				 * Play safe here; we have modified
 				 * the original vector so the outer
-- 
1.8.2
