From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 14/33] multipath -ll: set DI_SERIAL
Date: Tue, 28 Feb 2017 17:23:10 +0100
Message-ID: <20170228162329.14517-15-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.de>

Without DI_SERIAL, multipath -ll will not be able to obtain correct
PG priorities in certain configurations (e.g. prio "weightedpath",
prio_args "serial..."). We do not set DI_SERIAL for the multipath -l
case, where information is supposed to come from sysfs+device mapper
only.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/main.c b/multipath/main.c
index 5811630c..8ce87a08 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -367,7 +367,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 
 	if (cmd == CMD_LIST_LONG)
 		/* extended path info '-ll' */
-		di_flag |= DI_SYSFS | DI_CHECKER;
+		di_flag |= DI_SYSFS | DI_CHECKER | DI_SERIAL;
 	else if (cmd == CMD_LIST_SHORT)
 		/* minimum path info '-l' */
 		di_flag |= DI_SYSFS;
-- 
2.11.0
