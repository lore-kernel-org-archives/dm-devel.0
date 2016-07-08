From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 12/14] multipath-tools: list undocumented
	prioritizers in multipath.conf.5
Date: Fri,  8 Jul 2016 19:49:57 +0200
Message-ID: <1468000199-15566-13-git-send-email-xose.vazquez@gmail.com>
References: <1468000199-15566-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468000199-15566-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Manon Goo <manon.goo@dg-i.net>, device-mapper development <dm-devel@redhat.com>, Olivier Lambert <lambert.olivier@gmail.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Some text is needed.

Cc: Olivier Lambert <lambert.olivier@gmail.com>
Cc: Manon Goo <manon.goo@dg-i.net>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 2a4a54e..8ac9d5a 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -247,6 +247,12 @@ Generate a random priority between 1 and 10.
 Generate the path priority based on the regular expression and the
 priority provided as argument. requires prio_args keyword.
 .TP
+.I datacore
+???. Requires prio_args keyword.
+.TP
+.I iet
+???. Requires prio_args keyword.
+.TP
 Default value is: \fBconst\fR
 .RE
 .TP
@@ -274,6 +280,14 @@ If
 is set, paths with the TPGS pref bit set will always be in their own path
 group.
 .TP
+.I datacore
+.I preferredsds
+???
+.TP
+.I iet
+.I preferredip
+???
+.TP
 Default value is: \fB<unset>\fR
 .RE
 .TP
-- 
2.7.4
