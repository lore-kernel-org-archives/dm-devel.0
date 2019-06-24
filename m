From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 07/30] libmultipath/libmpathcmd: use target
	length for unix socket sun_path
Date: Mon, 24 Jun 2019 11:27:33 +0200
Message-ID: <20190624092756.7769-9-mwilck@suse.com>
References: <20190624092756.7769-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190624092756.7769-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Note that sun_path doesn't necessarily need to be 0-terminated for an abstract
socket name for ux_socket_listen(), this means we need to use memcpy to avoid
a spurious warning.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathcmd/mpath_cmd.c | 4 +++-
 libmultipath/uxsock.c   | 7 +++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index b681311b..f00bf7e1 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -103,8 +103,10 @@ int __mpath_connect(int nonblocking)
 	memset(&addr, 0, sizeof(addr));
 	addr.sun_family = AF_LOCAL;
 	addr.sun_path[0] = '\0';
+	strncpy(&addr.sun_path[1], DEFAULT_SOCKET, sizeof(addr.sun_path) - 1);
 	len = strlen(DEFAULT_SOCKET) + 1 + sizeof(sa_family_t);
-	strncpy(&addr.sun_path[1], DEFAULT_SOCKET, len);
+	if (len > sizeof(struct sockaddr_un))
+		len = sizeof(struct sockaddr_un);
 
 	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
 	if (fd == -1)
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index 7e5a1449..9b4e9784 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -66,9 +66,12 @@ int ux_socket_listen(const char *name)
 	memset(&addr, 0, sizeof(addr));
 	addr.sun_family = AF_LOCAL;
 	addr.sun_path[0] = '\0';
-	len = strlen(name) + 1 + sizeof(sa_family_t);
-	strncpy(&addr.sun_path[1], name, len);
+	len = strlen(name) + 1;
+	if (len >= sizeof(addr.sun_path))
+		len = sizeof(addr.sun_path) - 1;
+	memcpy(&addr.sun_path[1], name, len);
 
+	len += sizeof(sa_family_t);
 	if (bind(fd, (struct sockaddr *)&addr, len) == -1) {
 		condlog(3, "Couldn't bind to ux_socket, error %d", errno);
 		close(fd);
-- 
2.21.0
