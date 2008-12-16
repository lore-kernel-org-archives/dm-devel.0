From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] Memory leak when deleting and re-adding
	device-mapper entries.
Date: Tue, 16 Dec 2008 10:54:54 -0500
Message-ID: <1229442897-3765-3-git-send-email-konrad@virtualiron.com>
References: <1229442897-3765-1-git-send-email-konrad@virtualiron.com>
	<1229442897-3765-2-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1229442897-3765-2-git-send-email-konrad@virtualiron.com>
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

From: Konrad Rzeszutek <konrad@mars.virtualiron.com>

 If we remove a map (with configuration details specified in the multipath.conf file)
 and later re-add it, the pointer to the config is over-written without first
 de-allocating the values.

Signed-off-by: Konrad Rzeszutek <konrad@virtualiron.com>
---
 libmultipath/configure.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 285a8a2..83ee0ae 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -50,6 +50,11 @@ setup_map (struct multipath * mpp)
 	}
 
 	/*
+	 * free features, selector, and hwhandler properties if they are being reused
+	 */
+	free_multipath_attributes(mpp);
+
+	/*
 	 * properties selectors
 	 */
 	select_pgfailback(mpp);
-- 
1.5.4.1
