From: Werner Koch <wk@gnupg.org>
Subject: [PATCH] dmsetup: improve message command
Date: Fri, 26 Feb 2016 12:42:33 +0100
Message-ID: <87y4a7wvdi.fsf@wheatstone.g10code.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=Syria-cypherpunk-Elvis-Hugo-Chavez-AMEMB-Majic-Geraldton-CDMA-COSCO="
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

--=Syria-cypherpunk-Elvis-Hugo-Chavez-AMEMB-Majic-Geraldton-CDMA-COSCO=

Hi!

I am playing with a new crypto container format and propose to enhance
"dmsetup message" to accept the actual message from stdin instead of
taking it only from the command line.  This is useful to set a key and
similar to how "dmsetup create" is reading the table from stdin.

Patch attached.


Shalom-Salam,

   Werner

-- 
Die Gedanken sind frei.  Ausnahmen regelt ein Bundesgesetz.

--=Syria-cypherpunk-Elvis-Hugo-Chavez-AMEMB-Majic-Geraldton-CDMA-COSCO=
Content-Type: text/x-diff
Content-Disposition: inline;
	filename=0001-dmsetup-command-message-may-now-read-the-message-fro.patch

From ae2b5739007b0829c3a142d0d5e782b3b7fe3028 Mon Sep 17 00:00:00 2001
From: Werner Koch <wk@gnupg.org>
Date: Fri, 19 Feb 2016 21:47:45 +0100
Subject: [PATCH] dmsetup: command message may now read the message from stdin.

When "dmsetup messsage" is used to set an encryption key it is better
to read that from stdin so that the key does not show up in ps or the
shell history.  Thus instead of an error message when the third arg is
missing, it is now taken from stdin.  stdin is also switched to
unbuffered mode so that sensitive data should not end up in stdio
buffers.  A new wipememory macro (taken from GnuPG) is used to
securely erase the message from memory.

Signed-off-by: Werner Koch <wk@gnupg.org>
---
 man/dmsetup.8.in |  5 +++--
 tools/dmsetup.c  | 68 ++++++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 54 insertions(+), 19 deletions(-)

diff --git a/man/dmsetup.8.in b/man/dmsetup.8.in
index f92dbe5..c9c886a 100644
--- a/man/dmsetup.8.in
+++ b/man/dmsetup.8.in
@@ -127,7 +127,7 @@ dmsetup \(em low level logical volume management
 .  BR message
 .  IR device_name
 .  IR sector
-.  IR message
+.  RI [ message ]
 ..
 .CMD_MESSAGE
 .
@@ -714,7 +714,8 @@ reactivating it with proper mangling mode used (see also \fB\-\-manglename\fP).
 .HP
 .CMD_MESSAGE
 .br
-Send message to target. If sector not needed use 0.
+Send message to target. If sector not needed use 0.  If the message
+argument is not given, the first line read from stdin is used.
 .
 .HP
 .CMD_MKNODES
diff --git a/tools/dmsetup.c b/tools/dmsetup.c
index 4db6004..8e988f0 100644
--- a/tools/dmsetup.c
+++ b/tools/dmsetup.c
@@ -105,6 +105,15 @@ extern char *optarg;
 
 #define err(msg, x...) fprintf(stderr, msg "\n", ##x)
 
+/* To avoid that a compiler optimizes memset calls away, this macro
+ * should be used securely clear memory. */
+#define wipememory(_ptr,_len) do { \
+              volatile char *_vptr=(volatile char *)(_ptr); \
+              size_t _vlen=(_len); \
+              while(_vlen) { *_vptr=0; _vptr++; _vlen--; } \
+                  } while(0)
+
+
 /* program_id used for dmstats-managed statistics regions */
 #define DM_STATS_PROGRAM_ID "dmstats"
 
@@ -1234,25 +1243,50 @@ static int _message(CMD_ARGS)
 	argc--;
 	argv++;
 
-	if (argc <= 0)
-		err("No message supplied.\n");
-
-	for (i = 0; i < argc; i++)
-		sz += strlen(argv[i]) + 1;
-
-	if (!(str = dm_zalloc(sz))) {
-		err("message string allocation failed");
-		goto out;
-	}
-
-	for (i = 0; i < argc; i++) {
-		if (i)
-			strcat(str, " ");
-		strcat(str, argv[i]);
-	}
+	if (argc <= 0) {
+		/* Read messsage from stdin (one line).  */
+                size_t len = LINE_SIZE;
+
+                /* Try avoiding storing potential sensitive data in a
+                 * stdio buffer.  */
+                if (setvbuf (stdin, NULL, _IONBF, BUFSIZ)) {
+                        err("Failed to switch stdin to unbuffered mode.");
+                        goto out;
+                }
+
+                if (!(str = dm_malloc(len))) {
+                        err("Failed to malloc line buffer.");
+                        goto out;
+                }
+
+                if (!fgets(str, (int) len, stdin)) {
+                        err("Error reading line from stdin.");
+                        dm_free(str);
+                        goto out;
+                }
+                len = strlen (str);
+                if (len && str[len-1]=='\n')
+                        str[--len] = 0;
+
+        } else {
+                for (i = 0; i < argc; i++)
+                        sz += strlen(argv[i]) + 1;
+
+                if (!(str = dm_zalloc(sz))) {
+                        err("message string allocation failed");
+                        goto out;
+                }
+
+                for (i = 0; i < argc; i++) {
+                        if (i)
+                                strcat(str, " ");
+                        strcat(str, argv[i]);
+                }
+        }
 
 	i = dm_task_set_message(dmt, str);
 
+        wipememory (str, strlen(str));
 	dm_free(str);
 
 	if (!i)
@@ -5132,7 +5166,7 @@ static struct command _dmsetup_commands[] = {
 	{"reload", "<device> [<table>|<table_file>]", 0, 2, 0, 0, _load},
 	{"wipe_table", "[-f|--force] [--noflush] [--nolockfs] <device>", 1, -1, 1, 0, _error_device},
 	{"rename", "<device> [--setuuid] <new_name_or_uuid>", 1, 2, 0, 0, _rename},
-	{"message", "<device> <sector> <message>", 2, -1, 0, 0, _message},
+	{"message", "<device> <sector> [<message>]", 2, -1, 0, 0, _message},
 	{"ls", "[--target <target_type>] [--exec <command>] [-o <options>] [--tree]", 0, 0, 0, 0, _ls},
 	{"info", "[<device>]", 0, -1, 1, 0, _info},
 	{"deps", "[-o <options>] [<device>]", 0, -1, 1, 0, _deps},
-- 
2.1.4


--=Syria-cypherpunk-Elvis-Hugo-Chavez-AMEMB-Majic-Geraldton-CDMA-COSCO=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=Syria-cypherpunk-Elvis-Hugo-Chavez-AMEMB-Majic-Geraldton-CDMA-COSCO=--
