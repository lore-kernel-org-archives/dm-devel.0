From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add info about how to get a
	release directly from gitweb
Date: Fri, 12 Jan 2018 17:56:41 +0100
Message-ID: <20180112165641.4130-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

gitweb is able to extract and serve a release right away.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/README b/README
index 570224d..89bab74 100644
--- a/README
+++ b/README
@@ -20,7 +20,8 @@ git archive --format=tar.gz --prefix=multipath-tools-X.Y.Z/ X.Y.Z > ../multipath
 
 Alternatively it may be obtained from gitweb, go to:
 https://git.opensvc.com/?p=multipath-tools/.git;a=tags
-select a release-tag and then click on "snapshot".
+select a release-tag and then click on "snapshot". Or get it with
+wget "https://git.opensvc.com/?p=multipath-tools/.git;a=snapshot;sf=tgz;h=refs/tags/X.Y.Z" -O multipath-tools-X.Y.Z.tar.gz
 
 
 Source code
-- 
2.14.3
