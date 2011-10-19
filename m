From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 2 - v2] DM log userspace: Minor fix-ups
Date: Wed, 19 Oct 2011 16:02:13 -0500
Message-ID: <1319058133.4668.1.camel@f14.redhat.com>
References: <1318533312.28595.4.camel@f14.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1318533312.28595.4.camel@f14.redhat.com>
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

dm-log-userspace: comment fixes

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-log-userspace-base.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-log-userspace-base.c
+++ linux-upstream/drivers/md/dm-log-userspace-base.c
@@ -146,7 +146,7 @@ static int build_constructor_string(stru
  *	<UUID> <other args>
  * Where 'other args' is the userspace implementation specific log
  * arguments.  An example might be:
- *	<UUID> clustered_disk <arg count> <log dev> <region_size> [[no]sync]
+ *	<UUID> clustered-disk <arg count> <log dev> <region_size> [[no]sync]
  *
  * So, this module will strip off the <UUID> for identification purposes
  * when communicating with userspace about a log; but will pass on everything
Index: linux-upstream/Documentation/device-mapper/dm-log.txt
===================================================================
--- linux-upstream.orig/Documentation/device-mapper/dm-log.txt
+++ linux-upstream/Documentation/device-mapper/dm-log.txt
@@ -48,7 +48,7 @@ kernel and userspace, 'connector' is use
 communication.
 
 There are currently two userspace log implementations that leverage this
-framework - "clustered_disk" and "clustered_core".  These implementations
+framework - "clustered-disk" and "clustered-core".  These implementations
 provide a cluster-coherent log for shared-storage.  Device-mapper mirroring
 can be used in a shared-storage environment when the cluster log implementations
 are employed.
