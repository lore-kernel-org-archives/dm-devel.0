From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/2] multipath-tools: tarballs from gitweb
Date: Sat,  4 Jun 2016 01:54:37 +0200
Message-ID: <1464998078-20041-1-git-send-email-xose.vazquez@gmail.com>
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

Releases can be got also from gitweb, more convenient
for untrained people or w/o a development environment.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/README b/README
index 25a194e..77b79b8 100644
--- a/README
+++ b/README
@@ -16,6 +16,10 @@ cd multipath-tools
 git tag
 git archive --format=tar.gz --prefix=multipath-tools-X.Y.Z/ X.Y.Z > ../multipath-tools-X.Y.Z.tar.gz
 
+Alternatively it may be obtained from gitweb, go to:
+http://git.opensvc.com/?p=multipath-tools/.git;a=tags
+select a release-tag and then click on "snapshot".
+
 
 To get latest devel code: git clone http://git.opensvc.com/multipath-tools/.git
 
-- 
2.5.5
