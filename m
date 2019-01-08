From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 12/12] libmultipath(coverity): fix possible NULL
	dereference
Date: Tue,  8 Jan 2019 23:54:09 +0100
Message-ID: <20190108225409.15977-13-mwilck@suse.com>
References: <20190108225409.15977-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190108225409.15977-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

coverity warns that recv_packet may set reply to NULL.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 64a1f7b..970b913 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1042,7 +1042,7 @@ int check_daemon(void)
 	if (recv_packet(fd, &reply, timeout) != 0)
 		goto out;
 
-	if (strstr(reply, "shutdown"))
+	if (reply && strstr(reply, "shutdown"))
 		goto out_free;
 
 	ret = 1;
-- 
2.19.2
