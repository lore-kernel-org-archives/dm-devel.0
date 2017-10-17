From: Arnon Yaari <arnony@infinidat.com>
Subject: [PATCH v3] libmultipath: update INFINIDAT builtin config
Date: Tue, 17 Oct 2017 10:55:36 +0300
Message-ID: <CAK2gM1vmua3z7ZQtudyeTQbxivw0qxkGt5K2kJQFJN9UsQL6CQ@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Based on the manufacturer documentation:
https://support.infinidat.com/hc/en-us/articles/202319222

INFINIDAT recommends round-robin path selector using
a different path per IO. Timeout and path recovery values
are adjusted for error-free hot upgrade scenarios.

Signed-off-by: Arnon Yaari <arnony@infinidat.com>
---
Changes in v2:
 - Added maintainer information
 - Removed default values
Changes in v3:
 - Changed patch message

libmultipath/hwtable.c | 13 ++++++++++++-
1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 9e14ec1e..aa0ced53 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -964,13 +964,24 @@ static struct hwentry default_hw[] = {
    },
    /*
     * Infinidat
+    *
+    * Maintainer: Arnon Yaari
+    * Mail: arnony@infinidat.com
     */
    {
        .vendor        = "NFINIDAT",
        .product       = "InfiniBox",
        .pgpolicy      = GROUP_BY_PRIO,
-       .pgfailback    = -FAILBACK_IMMEDIATE,
+       .pgfailback    = 30,
        .prio_name     = PRIO_ALUA,
+       .selector      = "round-robin 0",
+       .rr_weight     = RR_WEIGHT_PRIO,
+       .no_path_retry = NO_PATH_RETRY_FAIL,
+       .minio         = 1,
+       .minio_rq      = 1,
+       .flush_on_last_del = FLUSH_ENABLED,
+       .fast_io_fail  = 15,
+       .dev_loss      = 15,
    },
    /*
     * Nimble Storage
--
2.11.0
