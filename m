From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: two minor multipath tools fixes
Date: Thu, 10 Nov 2005 18:08:32 -0600
Message-ID: <20051111000832.GA9399@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

There was a spot where multipathd's reply length forgot to count the NULL,
and I noticed that the way domap go rewritten, the dry-run option doesn't
print out the maps.

This patch fixes both.

-Ben

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cli_dry_run.patch"

diff -urpN mp-devel/multipath/main.c mp-devel-patched/multipath/main.c
--- mp-devel/multipath/main.c	2005-11-07 12:13:07.000000000 -0600
+++ mp-devel-patched/multipath/main.c	2005-11-10 18:23:46.000000000 -0600
@@ -626,8 +626,10 @@ domap (struct multipath * mpp)
 	/*
 	 * last chance to quit before touching the devmaps
 	 */
-	if (conf->dry_run)
+	if (conf->dry_run) {
+		print_mp(mpp);
 		return 0;
+	}
 
 	switch (mpp->action) {
 	case ACT_NOTHING:
diff -urpN mp-devel/multipathd/cli.c mp-devel-patched/multipathd/cli.c
--- mp-devel/multipathd/cli.c	2005-11-01 18:41:23.000000000 -0600
+++ mp-devel-patched/multipathd/cli.c	2005-11-10 18:23:34.000000000 -0600
@@ -314,7 +314,7 @@ parse_cmd (char * cmd, char ** reply, in
 
 	if (!cmdvec) {
 		*reply = genhelp_handler();
-		*len = strlen(*reply);
+		*len = strlen(*reply) + 1;
 		return 0;
 	}
 

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--n8g4imXOkfNTN/H1--
