From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 11/14] multipath-tools: add cciss_tur
	path_checker to multipath.conf.5
Date: Fri,  8 Jul 2016 19:49:56 +0200
Message-ID: <1468000199-15566-12-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

cciss_tur is for HP/COMPAQ Smart Array(CCISS) controllers.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index edcf4dc..2a4a54e 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -332,6 +332,10 @@ Series, and OEM arrays from IBM DELL SGI STK and SUN.
 deprecated, it will cause spurious path failures under high load.
 Please use \fItur\fR instead.
 .TP
+.I cciss_tur
+(Hardware-dependent)
+Check the path state for HP/COMPAQ Smart Array(CCISS) controllers.
+.TP
 Default value is: \fBtur\fR
 .RE
 .TP
-- 
2.7.4
