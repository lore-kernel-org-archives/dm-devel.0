From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] libmultipath: fix segfault when vector is
	null
Date: Tue,  8 Jan 2013 13:36:34 -0600
Message-ID: <1357673794-4894-1-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@gmail.com
List-Id: dm-devel.ids

From: Mike Christie <michaelc@cs.wisc.edu>

While performing tests that caused paths to get added
and deleted, we hit a segfault. We traced it to the
vector struct being NULL. This patch fixes the problem
by checking for a NULL vector before accessing it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 libmultipath/vector.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/vector.c b/libmultipath/vector.c
index 652f118..0564224 100644
--- a/libmultipath/vector.c
+++ b/libmultipath/vector.c
@@ -94,6 +94,9 @@ find_slot(vector v, void * addr)
 {
 	int i;
 
+	if (!v)
+		return -1;
+
 	for (i = 0; i < (v->allocated / VECTOR_DEFAULT_SIZE); i++)
 		if (v->slot[i] == addr)
 			return i;
-- 
1.7.11.2
