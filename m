From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 03/20] libmultipath: condlog: log to stderr
Date: Sat, 13 Jan 2018 22:19:21 +0100
Message-ID: <20180113211938.31552-4-mwilck@suse.com>
References: <20180113211938.31552-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180113211938.31552-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Calling 'multipath' might result in various error messages, all
of which should be directed to stderr.
Having them intermixed with the actual output on stdout makes
parsing really hard.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/debug.c b/libmultipath/debug.c
index f89b26443ea5..f95a3e5f97f5 100644
--- a/libmultipath/debug.c
+++ b/libmultipath/debug.c
@@ -37,9 +37,9 @@ void dlog (int sink, int prio, const char * fmt, ...)
 					 "%b %d %H:%M:%S", tb);
 				buff[sizeof(buff)-1] = '\0';
 
-				fprintf(stdout, "%s | ", buff);
+				fprintf(stderr, "%s | ", buff);
 			}
-			vfprintf(stdout, fmt, ap);
+			vfprintf(stderr, fmt, ap);
 		}
 		else
 			log_safe(prio + 3, fmt, ap);
-- 
2.15.1
