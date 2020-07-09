From: mwilck@suse.com
Subject: [PATCH 53/54] multipath: call strchop() on command line
	argument
Date: Thu,  9 Jul 2020 12:36:22 +0200
Message-ID: <20200709103623.8302-12-mwilck@suse.com>
References: <20200709103623.8302-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709103623.8302-1-mwilck@suse.com>
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

From: Martin Wilck <mwilck@suse.com>

It's useful to sanitize these right away. We can't do this for DEV_DEVMAP,
as aliases with trailing whitespace aren't strictly forbidden, but for
the other types we can.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/multipath/main.c b/multipath/main.c
index 4c43314..cfb85dc 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -1028,6 +1028,8 @@ main (int argc, char *argv[])
 			condlog(0, "'%s' is not a valid argument\n", dev);
 			goto out;
 		}
+		if (dev_type == DEV_DEVNODE || dev_type == DEV_DEVT)
+			strchop(dev);
 	}
 	if (dev_type == DEV_UEVENT) {
 		openlog("multipath", 0, LOG_DAEMON);
-- 
2.26.2
