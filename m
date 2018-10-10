From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 4/8] multipath.rules: add comment about
	DM_MULTIPATH_DEVICE_PATH=2
Date: Wed, 10 Oct 2018 22:05:02 +0200
Message-ID: <20181010200506.15796-5-mwilck@suse.com>
References: <20181010200506.15796-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181010200506.15796-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, Adam Williamson <awilliam@redhat.com>
List-Id: dm-devel.ids

See dm-devel discussion "Changes in DM_MULTIPATH_DEVICE_PATH in
multipath-tools 0.7.7" (Sep. 2018) for rationale.

Cc: Adam Williamson <awilliam@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.rules | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index d658073f..9df11a95 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -45,6 +45,10 @@ ENV{DM_MULTIPATH_DEVICE_PATH}!="2", \
 # Code below here is only run in "smart" mode.
 # multipath -u has indicated this is "maybe" multipath.
 
+# Note that DM_MULTIPATH_DEVICE_PATH has the value 2 at this point.
+# This value will never propagate to other rules files, because
+# it will be reset to 1 in the "pretend_multipath" section below.
+
 # This shouldn't happen, just in case.
 ENV{FIND_MULTIPATHS_WAIT_UNTIL}!="?*", GOTO="end_mpath"
 
-- 
2.19.0
