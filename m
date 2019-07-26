From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: delete outdated comment at
	multipath/multipath.conf.5
Date: Fri, 26 Jul 2019 21:19:28 +0200
Message-ID: <20190726191930.23630-1-xose.vazquez@gmail.com>
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 2 --
 1 file changed, 2 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index f7d21b4..880947f 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -4,8 +4,6 @@
 .\" groff -z -wall -b -e -t multipath/multipath.conf.5
 .\" man --warnings -E UTF-8 -l -Tutf8 -Z multipath/multipath.conf.5 >/dev/null
 .\"
-.\" TODO: Look for XXX and ???
-.\"
 .\" ----------------------------------------------------------------------------
 .
 .TH MULTIPATH.CONF 5 2018-05-21 Linux
-- 
2.21.0
