From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/7] assemble_map: no newline at end of params
	string
Date: Wed, 17 Jan 2018 08:49:33 +0100
Message-ID: <20180117074939.7795-2-mwilck@suse.com>
References: <20180117074939.7795-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180117074939.7795-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Ritika Srivastava <ritika.srivastava@oracle.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This newline is superfluous for device-mapper, and causes ugly
debug output.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dmparser.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 642f44fb0439..027ae989781e 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -114,7 +114,6 @@ assemble_map (struct multipath * mp, char * params, int len)
 			APPEND(p, end, " %s %d", pp->dev_t, tmp_minio);
 		}
 	}
-	APPEND(p, end, "\n");
 
 	FREE(f);
 	condlog(3, "%s: assembled map [%s]", mp->alias, params);
-- 
2.15.1
