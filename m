From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 11/32] mpathpersist: add missing --param-rk usage
	info
Date: Wed,  1 Aug 2018 15:56:57 -0500
Message-ID: <1533157038-3924-12-git-send-email-bmarzins@redhat.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 mpathpersist/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 99151fe..0e4d3f2 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -705,6 +705,7 @@ static void usage(void)
 			"    --param-alltgpt|-Y         PR Out parameter 'ALL_TG_PT\n"
 			"    --param-aptpl|-Z           PR Out parameter 'APTPL'\n"
 			"    --read-keys|-k             PR In: Read Keys\n"
+			"    --param-rk=RK|-K RK        PR Out parameter reservation key\n"
 			"    --param-sark=SARK|-S SARK  PR Out parameter service "
 			"action\n"
 			"                               reservation key (SARK is in "
-- 
2.7.4
