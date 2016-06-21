From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 8/9] multipath-tools: fix syntax in
	mpath_persistent_reserve_out.3
Date: Tue, 21 Jun 2016 02:36:03 +0200
Message-ID: <1466469364-14446-8-git-send-email-xose.vazquez@gmail.com>
References: <1466469364-14446-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466469364-14446-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

./libmpathpersist/mpath_persistent_reserve_out.3:91: warning: tab character in unquoted macro argument

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathpersist/mpath_persistent_reserve_out.3 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathpersist/mpath_persistent_reserve_out.3 b/libmpathpersist/mpath_persistent_reserve_out.3
index 7e57d2b..8a3b52c 100644
--- a/libmpathpersist/mpath_persistent_reserve_out.3
+++ b/libmpathpersist/mpath_persistent_reserve_out.3
@@ -88,5 +88,5 @@ sends PR OUT command to the DM device and gets the response.
 
 
 .SH "SEE ALSO"
-.I  mpath_persistent_reserve_in		mpathpersist     /usr/share/doc/mpathpersist/README
+.I mpath_persistent_reserve_in mpathpersist /usr/share/doc/mpathpersist/README
 .br
-- 
2.5.5
