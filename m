From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 4/6] Fix for parsing multipath.conf files without
	spaces before brackets
Date: Thu, 11 Dec 2008 16:10:27 -0600
Message-ID: <20081211221027.GL1585@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

There's a bug in bug in the multipath.conf code that keeps multipath from
correctly parsing config files where there is no space between a section name
and the opening bracket. For instance

devices {
	device {
		...
	}
}

works but

devices {
	device{
		...
	}
}

doesn't. This patch makes sure that brackets are the recognized as seperate from
the token that they follow, unless they are part of a quoted string.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/parser.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: multipath-tools-081203/libmultipath/parser.c
===================================================================
--- multipath-tools-081203.orig/libmultipath/parser.c
+++ multipath-tools-081203/libmultipath/parser.c
@@ -239,12 +239,20 @@ alloc_strvec(char *string)
 				in_string = 0;
 			else
 				in_string = 1;
+		} else if (!in_string && (*cp == '{' || *cp == '}')) {
+			token = MALLOC(2);
 
+			if (!token)
+				goto out;
+
+			*(token) = *cp;
+			*(token + 1) = '\0';
+			cp++;
 		} else {
 			while ((in_string ||
 				(!isspace((int) *cp) && isascii((int) *cp) &&
-				 *cp != '!' && *cp != '#')) &&
-			       *cp != '\0' && *cp != '"')
+				 *cp != '!' && *cp != '#' && *cp != '{' &&
+				 *cp != '}')) && *cp != '\0' && *cp != '"')
 				cp++;
 			strlen = cp - start;
 			token = MALLOC(strlen + 1);
