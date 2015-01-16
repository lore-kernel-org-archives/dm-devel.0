From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 7/8] multipathd: don't buffer output with systemd
Date: Fri, 16 Jan 2015 14:23:31 -0600
Message-ID: <1421439812-11826-8-git-send-email-bmarzins@redhat.com>
References: <1421439812-11826-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1421439812-11826-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

When stdout isn't hooked up to a tty (like it isn't when you start
multipathd through systemd) the stream is buffered, so messages only
come out in big chunks, or when the program quits. Instead, we should
send the messages out to systemd as we generate them, so that users
know what's happening, and in the event of a crash, they get the most
recent messages.

I realize that there is a performance impact to this.  If people are
against this approach, we could change condlog to print messages above a
certain priority to stderr and messages below that priority to stdout.
If we included a configuration option to change the priority level, then
we could always change it up if we needed to do debugging. However, the
standard level messages are very helpful in quickly diagnosing a number
of problems, so you could make a good argument that we always want
priority 2 messages printed immediately.  And if we intentionally bumped
up the debugging level, we would usually want those messages printed
immediately.  This is exactly what we get with just unbuffering stdout.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f9e3f33..bc21d04 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2011,9 +2011,11 @@ main (int argc, char *argv[])
 		exit(0);
 	}
 
-	if (logsink < 1)
+	if (logsink < 1) {
+		if (!isatty(fileno(stdout)))
+			setbuf(stdout, NULL);
 		err = 0;
-	else
+	} else
 		err = daemonize();
 
 	if (err < 0)
-- 
1.8.3.1
