From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 07/30] libmpathcmd: use target length in
	strncpy() call
Date: Fri,  7 Jun 2019 15:05:29 +0200
Message-ID: <20190607130552.13203-8-mwilck@suse.com>
References: <20190607130552.13203-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190607130552.13203-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathcmd/mpath_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index b681311b..05b69316 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -104,7 +104,7 @@ int __mpath_connect(int nonblocking)
 	addr.sun_family = AF_LOCAL;
 	addr.sun_path[0] = '\0';
 	len = strlen(DEFAULT_SOCKET) + 1 + sizeof(sa_family_t);
-	strncpy(&addr.sun_path[1], DEFAULT_SOCKET, len);
+	strncpy(&addr.sun_path[1], DEFAULT_SOCKET, sizeof(addr.sun_path) - 1);
 
 	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
 	if (fd == -1)
-- 
2.21.0
