From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/6] libmultipath: Remove a data structure that
 has been commented out
Date: Mon, 15 Aug 2016 08:25:58 -0700
Message-ID: <aa9af767-0e91-f4f1-53f7-bbad76829d58@sandisk.com>
References: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/structs_vec.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 8ef547d..46f30af 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -4,11 +4,7 @@
 #include "vector.h"
 #include "config.h"
 #include "lock.h"
-/*
-struct mutex_lock {
-	pthread_mutex_t *mutex;
-	int depth;
-}; */
+
 struct vectors {
 	struct mutex_lock lock; /* defined in lock.h */
 	vector pathvec;
-- 
2.9.2
