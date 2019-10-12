From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 36/72] multipath: delegate_to_multipathd: mark
 unused arguments
Date: Sat, 12 Oct 2019 21:28:22 +0000
Message-ID: <20191012212703.12989-37-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

... for now.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index b3f8c99b..c2ef8c7b 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -811,8 +811,10 @@ enum {
 	NOT_DELEGATED = 1,
 };
 
-int delegate_to_multipathd(enum mpath_cmds cmd, const char *dev,
-			   enum devtypes dev_type, const struct config *conf)
+int delegate_to_multipathd(enum mpath_cmds cmd,
+			   __attribute__((unused)) const char *dev,
+			   __attribute__((unused)) enum devtypes dev_type,
+			   const struct config *conf)
 {
 	int fd;
 	char command[1024], *p, *reply = NULL;
-- 
2.23.0
