From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 4/8] Turn off user_friendly_names for netapp
	devices
Date: Fri, 28 Jun 2013 18:26:17 -0500
Message-ID: <1372461981-6333-5-git-send-email-bmarzins@redhat.com>
References: <1372461981-6333-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1372461981-6333-1-git-send-email-bmarzins@redhat.com>
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

Netapp has requested that even if user friendly names is enabled in the
defaults section, they would like it disabled for their devices.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index c317cde..197a1d7 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -794,6 +794,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ONTAP,
 		.prio_args     = NULL,
 		.retain_hwhandler = RETAIN_HWHANDLER_ON,
+		.user_friendly_names = USER_FRIENDLY_NAMES_OFF,
 		.detect_prio   = DETECT_PRIO_ON,
 	},
 	/*
-- 
1.8.2
