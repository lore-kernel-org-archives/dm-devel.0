From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: [PATCH] Fix minor error in multipath.conf manpage
Date: Wed, 29 Jul 2009 18:07:03 +0530
Message-ID: <1248871023-2161-1-git-send-email-rsarraf@netapp.com>
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
Cc: rrs@researchut.com, Ritesh Raj Sarraf <rsarraf@netapp.com>
List-Id: dm-devel.ids


Signed-off-by: Ritesh Raj Sarraf <rsarraf@netapp.com>
---
 multipath/multipath.conf.5 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index df1f3b4..33b8747 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -76,8 +76,8 @@ directory where udev creates its device nodes; default is
 .TP
 .B verbosity
 default verbosity. Higher values increase the verbosity level. Valid
-levels are between 0 and 6; default is 2.
-.I /dev
+levels are between 0 and 6; default is
+.I 2
 .TP
 .B selector
 The default path selector algorithm to use; they are offered by the
-- 
1.6.3.3
