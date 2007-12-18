From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: [PATCH] Document queue_if_no_path behavior
Date: Wed, 19 Dec 2007 01:12:33 +0530
Message-ID: <1198006953-7677-1-git-send-email-rrs@researchut.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Ritesh Raj Sarraf <rrs@researchut.com>
List-Id: dm-devel.ids

Document the queue_if_no_path behavior in situations where
all the paths to the LUN go offline.

Signed-off-by: Ritesh Raj Sarraf <rrs@researchut.com>
---
 multipath/multipath.conf.5 |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index c8ab6b0..c66d7fc 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -374,6 +374,15 @@ section:
 .RE
 .PD
 .LP
+.SH "KNOWN ISSUES"
+The usage of
+.B queue_if_no_path
+option can lead to
+.B D state
+processes being hung and not killable in situations where all the paths to the LUN go offline.
+It is advisable to use the
+.B no_path_retry
+option instead.
 .SH "SEE ALSO"
 .BR udev (8),
 .BR dmsetup (8)
-- 
1.5.3.7
