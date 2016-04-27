From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/4] multipath-tools: fix mistyped kpartx in
	README
Date: Wed, 27 Apr 2016 17:14:32 +0200
Message-ID: <1461770074-13428-2-git-send-email-xose.vazquez@gmail.com>
References: <1461770074-13428-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461770074-13428-1-git-send-email-xose.vazquez@gmail.com>
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

replace kpartxrtx with kpartx

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/README b/README
index 89d5e19..a81666c 100644
--- a/README
+++ b/README
@@ -6,7 +6,7 @@ Device Mapper multipathing driver:
 multipath - Device mapper target autoconfig.
 multipathd - Multipath daemon.
 mpathpersist - Manages SCSI persistent reservations on dm multipath devices.
-kpartxrtx - Create device maps from partition tables.
+kpartx - Create device maps from partition tables.
 
 To get latest code: git clone http://git.opensvc.com/multipath-tools/.git
 
-- 
2.5.5
