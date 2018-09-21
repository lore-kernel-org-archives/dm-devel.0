From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v3 06/19] libmultipath: fix set_int error path
Date: Fri, 21 Sep 2018 18:05:14 -0500
Message-ID: <1537571127-10143-7-git-send-email-bmarzins@redhat.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

set_int() wasn't checking if the line actually had a value before
converting it to an integer.  Found by coverity. Also, it should
be using set_value().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 32524d5..bf4701e 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -33,7 +33,10 @@ set_int(vector strvec, void *ptr)
 	int *int_ptr = (int *)ptr;
 	char * buff;
 
-	buff = VECTOR_SLOT(strvec, 1);
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
 	*int_ptr = atoi(buff);
 
 	return 0;
-- 
2.7.4
