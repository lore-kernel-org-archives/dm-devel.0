From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/11] Document 'wwids_file' and 'reservation_key'
Date: Fri, 13 Dec 2013 13:14:05 +0100
Message-ID: <1386936854-8399-3-git-send-email-hare@suse.de>
References: <1386936854-8399-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386936854-8399-1-git-send-email-hare@suse.de>
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

Add documentation for 'wwids_file' and 'reservation_key' to
multipath.conf.annotated.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath.conf.annotated | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index a20302c..235e130 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -275,7 +275,22 @@
 #	#           the user_friendly_names option.
 #	# values  : <full_pathname>
 #	# default : "/var/lib/multipath/bindings"
-#	bindings_file "/etc/multipath_bindings"
+#	bindings_file "/etc/multipath/bindings"
+#
+#	# name    : wwids_file
+#	# scope   : multipath
+#	# desc    : The location of the wwids file multipath uses to
+#       #           keep track of the created multipath devices.
+#	# values  : <full_pathname>
+#	# default : "/var/lib/multipath/wwids"
+#	wwids_file "/etc/multipath/wwids"
+#
+#	# name    : reservation_key
+#	# scope   : multipath
+#	# desc    : Service action reservation key used by mpathpersist.
+#	# values  : <key>
+#	# default : (null)
+#	reservation_key "mpathkey"
 #
 #}
 #	
-- 
1.8.1.4
