From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: make reservation_key print out
	correctly
Date: Mon, 7 Jan 2013 23:54:07 -0600
Message-ID: <20130108055407.GE19059@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This patch fixes the reservation_key print functions, so they print
it out like it was in the configuration file.  Also, it keeps
cli_getprstatus() from writing over random memory.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c       |   31 +++++++++++++++++++++++++++++--
 multipathd/cli_handlers.c |    2 +-
 2 files changed, 30 insertions(+), 3 deletions(-)

Index: multipath-tools-120821/libmultipath/dict.c
===================================================================
--- multipath-tools-120821.orig/libmultipath/dict.c
+++ multipath-tools-120821/libmultipath/dict.c
@@ -2052,8 +2052,22 @@ snprint_mp_prio_args(char * buff, int le
 static int
 snprint_mp_reservation_key (char * buff, int len, void * data)
 {
+	int i;
+	unsigned char *keyp;
+	uint64_t prkey = 0;
 	struct mpentry * mpe = (struct mpentry *)data;
-	return snprintf(buff, len, "%s" , mpe->reservation_key);
+
+	if (!mpe->reservation_key)
+		return 0;
+	keyp = (unsigned char *)mpe->reservation_key;
+	for (i = 0; i < 8; i++) {
+		if (i > 0)
+			prkey <<= 8;
+		prkey |= *keyp;
+		keyp++;
+	}
+
+	return snprintf(buff, len, "0x%" PRIx64, prkey);
 }
 
 	static int
@@ -2721,7 +2735,20 @@ snprint_def_wwids_file (char * buff, int
 static int
 snprint_def_reservation_key(char * buff, int len, void * data)
 {
-	return snprintf(buff, len, "%s", conf->reservation_key);
+	int i;
+	unsigned char *keyp;
+	uint64_t prkey = 0;
+
+	if (!conf->reservation_key)
+		return 0;
+	keyp = (unsigned char *)conf->reservation_key;
+	for (i = 0; i < 8; i++) {
+		if (i > 0)
+			prkey <<= 8;
+		prkey |= *keyp;
+		keyp++;
+	}
+	return snprintf(buff, len, "0x%" PRIx64, prkey);
 }
 
 static int
Index: multipath-tools-120821/multipathd/cli_handlers.c
===================================================================
--- multipath-tools-120821.orig/multipathd/cli_handlers.c
+++ multipath-tools-120821/multipathd/cli_handlers.c
@@ -947,7 +947,7 @@ cli_getprstatus (void * v, char ** reply
 
 
 	sprintf(*reply,"%d",mpp->prflag);
-	*reply[1]='\0';
+	(*reply)[1]='\0';
 
 
 	condlog(3, "%s: reply = %s", param, *reply);
