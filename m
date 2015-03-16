From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/78] multipathd: set correct PID when running
	in debug mode
Date: Mon, 16 Mar 2015 13:35:59 +0100
Message-ID: <1426509425-15978-13-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When running in debug mode the PID is not set, causing
the PID in the pidfile to always be set to '0'.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 4f02211..3e22ad1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2056,6 +2056,7 @@ main (int argc, char *argv[])
 		if (!isatty(fileno(stdout)))
 			setbuf(stdout, NULL);
 		err = 0;
+		daemon_pid = getpid();
 	} else
 		err = daemonize();
 
-- 
1.8.4.5
