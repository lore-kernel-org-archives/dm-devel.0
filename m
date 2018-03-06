From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/6] libmultipath: config parser: don't strip
	whitepace between quotes
Date: Tue,  6 Mar 2018 23:56:30 +0100
Message-ID: <20180306225633.12028-4-mwilck@suse.com>
References: <20180306225633.12028-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180306225633.12028-1-mwilck@suse.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Between double quotes, the parser currently strips leading (but not
trailing) whitespace. That's inconsistent and unexpected. Fix it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/parser.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 5caa2019a1a4..3d9656f47945 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -262,7 +262,8 @@ alloc_strvec(char *string)
 		}
 		vector_set_slot(strvec, token);
 
-		while ((isspace((int) *cp) || !isascii((int) *cp))
+		while ((!in_string &&
+			(isspace((int) *cp) || !isascii((int) *cp)))
 		       && *cp != '\0')
 			cp++;
 		if (*cp == '\0' || *cp == '!' || *cp == '#')
-- 
2.16.1
