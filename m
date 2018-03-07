From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/4] multipath: fix clang warning in
	delegate_to_multipathd
Date: Thu,  8 Mar 2018 00:08:58 +0100
Message-ID: <20180307230859.14926-4-mwilck@suse.com>
References: <20180307230859.14926-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307230859.14926-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Fixes this warning from clang:

main.c:628:11: warning: variable 'reply' is used uninitialized
whenever 'if' condition is true [-Wsometimes-uninitialized]
...
main.c:609:32: note: initialize the variable 'reply' to silence this warning

Fixes: 506d253b7f89 "multipath: delegate dangerous commands to multipathd"
Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/main.c b/multipath/main.c
index 8732cf8bd930..716203eab56c 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -606,7 +606,7 @@ int delegate_to_multipathd(enum mpath_cmds cmd, const char *dev,
 			   enum devtypes dev_type, const struct config *conf)
 {
 	int fd;
-	char command[1024], *p, *reply;
+	char command[1024], *p, *reply = NULL;
 	int n, r = 0;
 
 	fd = mpath_connect();
-- 
2.16.1
