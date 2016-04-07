From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 09/18] libmultipath: check correct function
	for define
Date: Thu,  7 Apr 2016 18:20:03 -0500
Message-ID: <1460071212-21018-10-git-send-email-bmarzins@redhat.com>
References: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

multipath was setting LIBUDEV_API_RECVBUF in the makefile if
udev_monitor_set_resolve_buffer_size existed. However the correct
fuction name (and the one used in the code) is
udev_monitor_set_receive_buffer_size. As a result, multipath was never
setting the receive buffer size. This patch simply fixes the Makefile
define.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 11750c2..1ee968e 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -37,7 +37,7 @@ ifneq ($(strip $(LIBDM_API_COOKIE)),0)
 	CFLAGS += -DLIBDM_API_COOKIE
 endif
 
-LIBUDEV_API_RECVBUF = $(shell grep -Ecs '^[a-z]*[[:space:]]+udev_monitor_set_resolve_buffer_size' /usr/include/libudev.h)
+LIBUDEV_API_RECVBUF = $(shell grep -Ecs '^[a-z]*[[:space:]]+udev_monitor_set_receive_buffer_size' /usr/include/libudev.h)
 
 ifneq ($(strip $(LIBUDEV_API_RECVBUF)),0)
 	CFLAGS += -DLIBUDEV_API_RECVBUF
-- 
1.8.3.1
