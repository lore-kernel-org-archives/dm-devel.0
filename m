From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 01/12] libmultipath: disable
	user_friendly_names for NetApp
Date: Fri,  8 Mar 2019 17:11:54 -0600
Message-ID: <1552086725-18476-2-git-send-email-bmarzins@redhat.com>
References: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

NetApp has tools that rely on devices using WWID names. To avoid
breaking these, NetApp devices should continue to use WWID names, even
if the default config is set to enable user_friendly_names. If users
want to use user_friendly_names on NetApp devices, the must specifically
override the device config.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index d3a8d9b..8776411 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -719,6 +719,7 @@ static struct hwentry default_hw[] = {
 		.flush_on_last_del = FLUSH_ENABLED,
 		.dev_loss      = MAX_DEV_LOSS_TMO,
 		.prio_name     = PRIO_ONTAP,
+		.user_friendly_names = USER_FRIENDLY_NAMES_OFF,
 	},
 	{
 		/*
-- 
2.17.2
