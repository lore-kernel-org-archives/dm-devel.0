From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 13/19] libmultipath: simplify devt2devname()
Date: Wed, 21 Nov 2018 11:18:33 +0100
Message-ID: <20181121101839.30784-14-mwilck@suse.com>
References: <20181121101839.30784-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181121101839.30784-1-mwilck@suse.com>
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

Since 1e79548, we don't fallback from /sys/dev/block to
/proc/partitions anyway. The strncmp() at "skip_proc"
is doomed to fail. So we might as well return immediately.

Also, decrease the log level; whether this failure is
noteworthy is rather up to the callers to decide.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index b5d2e706..28eb7577 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -191,7 +191,8 @@ int devt2devname(char *devname, int devname_len, char *devt)
 				return 0;
 			}
 		}
-		goto skip_proc;
+		condlog(4, "%s is invalid", block_path);
+		return 1;
 	}
 	memset(block_path, 0, sizeof(block_path));
 
@@ -220,7 +221,7 @@ int devt2devname(char *devname, int devname_len, char *devt)
 		}
 	}
 	fclose(fd);
-skip_proc:
+
 	if (strncmp(block_path,"/sys/block", 10)) {
 		condlog(3, "No device found for %u:%u", major, minor);
 		return 1;
-- 
2.19.1
