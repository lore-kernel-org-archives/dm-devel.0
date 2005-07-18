From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: tiny bug
Date: Mon, 18 Jul 2005 16:53:05 -0500
Message-ID: <20050718215304.GE24376@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

mulitpathd was crashing when I entered an empty line at the CLI prompt, because
the output buffer from get_word was being checked to see if it was NULL, but
get_word never explicitly sets the buffer to NULL if there is no word.

The patch fixes this.

-Ben

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="get_word.patch"

diff -urpN mp-devel/libmultipath/util.c mp-devel-patched/libmultipath/util.c
--- mp-devel/libmultipath/util.c	2005-06-20 18:00:23.000000000 -0500
+++ mp-devel-patched/libmultipath/util.c	2005-07-18 14:28:18.332453696 -0500
@@ -59,6 +59,8 @@ get_word (char * sentence, char ** word)
 	int len;
 	int skip = 0;
 	
+	if (word)
+		*word = NULL;	
 	while (*sentence ==  ' ') {
 		sentence++;
 		skip++;

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--2fHTh5uZTiUOsy+g--
