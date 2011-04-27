From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: clear checker message
Date: Wed, 27 Apr 2011 14:52:14 -0500
Message-ID: <20110427195214.GP23657@ether.msp.redhat.com>
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
List-Id: dm-devel.ids

Clear the checker message at the start of get_state, so that stale checker
messages aren't accidentally printed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c  |    5 +++++
 libmultipath/checkers.h  |    1 +
 libmultipath/discovery.c |    1 +
 3 files changed, 7 insertions(+)

Index: multipath-tools-110412/libmultipath/discovery.c
===================================================================
--- multipath-tools-110412.orig/libmultipath/discovery.c
+++ multipath-tools-110412/libmultipath/discovery.c
@@ -848,6 +848,7 @@ get_state (struct path * pp, int daemon)
 			return PATH_UNCHECKED;
 		}
 	}
+	checker_clear_message(c);
 	state = path_offline(pp);
 	if (state != PATH_UP) {
 		condlog(3, "%s: path inaccessible", pp->dev);
Index: multipath-tools-110412/libmultipath/checkers.c
===================================================================
--- multipath-tools-110412.orig/libmultipath/checkers.c
+++ multipath-tools-110412/libmultipath/checkers.c
@@ -183,6 +183,11 @@ char * checker_message (struct checker *
 	return c->message;
 }
 
+void checker_clear_message (struct checker *c)
+{
+	c->message[0] = '\0';
+}
+
 void checker_get (struct checker * dst, char * name)
 {
 	struct checker * src = checker_lookup(name);
Index: multipath-tools-110412/libmultipath/checkers.h
===================================================================
--- multipath-tools-110412.orig/libmultipath/checkers.h
+++ multipath-tools-110412/libmultipath/checkers.h
@@ -114,6 +114,7 @@ int checker_check (struct checker *);
 int checker_selected (struct checker *);
 char * checker_name (struct checker *);
 char * checker_message (struct checker *);
+void checker_clear_message (struct checker *c);
 void checker_get (struct checker *, char *);
 
 #endif /* _CHECKERS_H */
