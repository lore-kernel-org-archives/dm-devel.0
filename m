From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: User friendly names patch.
Date: Wed, 26 Oct 2005 21:20:08 -0500
Message-ID: <20051027022008.GA5541@phlogiston.msp.redhat.com>
References: <20051021233521.GA32160@phlogiston.msp.redhat.com>
	<1129967524.7313.65.camel@zezette>
	<20051024164902.GB19176@phlogiston.msp.redhat.com>
	<20051025084121.GA17494@free.fr>
	<20051025191749.GL19176@phlogiston.msp.redhat.com>
	<1130269061.13850.26.camel@zezette>
	<20051027021417.GC31187@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051027021417.GC31187@phlogiston.msp.redhat.com>
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


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 26, 2005 at 09:14:18PM -0500, Benjamin Marzinski wrote:
> On Tue, Oct 25, 2005 at 09:37:41PM +0200, Christophe Varoqui wrote:
> > 
> > > How about I make the bindings file location configurable, so that everyone
> > > can be happy with the location? I'll leave the default location where it
> > > is now when I send the patch.  If you would like to change it to someplace in
> > > /etc when you commit it, go ahead.
> > > 
> > Agreed, I guess we can get off with a multipath(8) flag to specify an
> > exotic location in the init{rd,ramfs} and leave the normal location
> > in /var.
> > 
> > I merged the patch as-is today.
> > 
> > Can you craft a patch to move the bindings file locking method from
> > "non-block + retry" to "block + timeout", if it makes sense to you too.
> 
> Sure. Here is the patch. It adds both the -b <bindings_file_path> option to
> the multipath command, and changes the locking method.
> 
> -Ben

It's just one of those weeks.

-Ben
 
> > Regards,
> > cvaroqui
> > 
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bindings.patch"

diff -urpN mp-devel-clean/libmultipath/alias.c mp-devel/libmultipath/alias.c
--- mp-devel-clean/libmultipath/alias.c	2005-10-26 17:53:52.000000000 +0000
+++ mp-devel/libmultipath/alias.c	2005-10-26 21:13:05.000000000 +0000
@@ -7,6 +7,7 @@
 #include <string.h>
 #include <limits.h>
 #include <stdio.h>
+#include <signal.h>
 #include "debug.h"
 #include "uxsock.h"
 #include "alias.h"
@@ -67,35 +68,47 @@ ensure_directories_exist(char *str, mode
 	return 0;
 }
 
+static void
+sigalrm(int sig)
+{
+	/* do nothing */
+}
+
 static int
 lock_bindings_file(int fd)
 {
+	struct sigaction act, oldact;
+	sigset_t set, oldset;
 	struct flock lock;
-	int retrys = BINDINGS_FILE_RETRYS;
+	int err;
 	
 	memset(&lock, 0, sizeof(lock));
 	lock.l_type = F_WRLCK;
 	lock.l_whence = SEEK_SET;
 
-	while (fcntl(fd, F_SETLK, &lock) < 0) {
-		if (errno != EACCES && errno != EAGAIN) {
-			condlog(0, "Cannot lock bindings file : %s",
-				strerror(errno));
-			return -1;
-		} else {
-			condlog(0, "Bindings file is currently locked");
-			if ((retrys--) == 0)
-				return -1;
-		}
-		/* because I'm paranoid */
-		memset(&lock, 0, sizeof(lock));
-		lock.l_type = F_WRLCK;
-		lock.l_whence = SEEK_SET;
-		
-		condlog(0, "retrying");
-		sleep(1);
-	}
-	return 0;
+	act.sa_handler = sigalrm;
+	sigemptyset(&act.sa_mask);
+	act.sa_flags = 0;
+	sigemptyset(&set);
+	sigaddset(&set, SIGALRM);
+	
+	sigaction(SIGALRM, &act, &oldact);
+	sigprocmask(SIG_UNBLOCK, &set, &oldset);
+
+	alarm(BINDINGS_FILE_TIMEOUT);
+	err = fcntl(fd, F_SETLKW, &lock);
+	alarm(0);
+
+	if (err) {
+		if (errno != EINTR) 
+			condlog(0, "Cannot lock bindings file : %s");
+		else
+			condlog(0, "Bindings file is locked. Giving up.");
+	}
+
+	sigprocmask(SIG_SETMASK, &oldset, NULL);
+	sigaction(SIGALRM, &oldact, NULL);
+	return err;
 }
 
 
@@ -245,7 +258,7 @@ allocate_binding(int fd, char *wwid, int
 }		
 
 char *
-get_user_friendly_alias(char *wwid)
+get_user_friendly_alias(char *wwid, char *file)
 {
 	char *alias;
 	int fd, id;
@@ -255,7 +268,7 @@ get_user_friendly_alias(char *wwid)
 		return NULL;
 	}
 
-	fd = open_bindings_file(BINDINGS_FILE_NAME);
+	fd = open_bindings_file(file);
 	if (fd < 0)
 		return NULL;
 	id = lookup_binding(fd, wwid, &alias);
diff -urpN mp-devel-clean/libmultipath/alias.h mp-devel/libmultipath/alias.h
--- mp-devel-clean/libmultipath/alias.h	2005-10-26 17:53:52.000000000 +0000
+++ mp-devel/libmultipath/alias.h	2005-10-26 20:20:56.000000000 +0000
@@ -1,5 +1,4 @@
-#define BINDINGS_FILE_NAME "/var/lib/multipath/bindings"
-#define BINDINGS_FILE_RETRYS 3
+#define BINDINGS_FILE_TIMEOUT 3
 #define BINDINGS_FILE_HEADER \
 "# Multipath bindings, Version : 1.0\n" \
 "# NOTE: this file is automatically maintained by the multipath program.\n" \
@@ -10,4 +9,4 @@
 "#\n"
 
 
-char *get_user_friendly_alias(char *wwid);
+char *get_user_friendly_alias(char *wwid, char *bindings_file);
diff -urpN mp-devel-clean/libmultipath/config.c mp-devel/libmultipath/config.c
--- mp-devel-clean/libmultipath/config.c	2005-10-11 00:10:09.000000000 +0000
+++ mp-devel/libmultipath/config.c	2005-10-26 21:27:05.000000000 +0000
@@ -375,6 +375,7 @@ load_config (char * file)
 
 	conf->dev_type = DEV_NONE;
 	conf->minio = 1000;
+	conf->bindings_file = DEFAULT_BINDINGS_FILE;
 
 	/*
 	 * read the config file
diff -urpN mp-devel-clean/libmultipath/config.h mp-devel/libmultipath/config.h
--- mp-devel-clean/libmultipath/config.h	2005-10-26 17:53:52.000000000 +0000
+++ mp-devel/libmultipath/config.h	2005-10-26 20:15:30.000000000 +0000
@@ -68,6 +68,7 @@ struct config {
 	char * default_getprio;
 	char * features;
 	char * default_hwhandler;
+	char * bindings_file;
 
 	vector mptable;
 	vector hwtable;
diff -urpN mp-devel-clean/libmultipath/defaults.h mp-devel/libmultipath/defaults.h
--- mp-devel-clean/libmultipath/defaults.h	2005-07-28 14:51:09.000000000 +0000
+++ mp-devel/libmultipath/defaults.h	2005-10-26 20:20:47.000000000 +0000
@@ -9,5 +9,6 @@
 #define DEFAULT_PIDFILE		"/var/run/multipathd.pid"
 #define DEFAULT_SOCKET		"/var/run/multipathd.sock"
 #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
+#define DEFAULT_BINDINGS_FILE	"/var/lib/multipath/bindings"
 
 char * set_default (char * str);
diff -urpN mp-devel-clean/libmultipath/propsel.c mp-devel/libmultipath/propsel.c
--- mp-devel-clean/libmultipath/propsel.c	2005-10-26 17:53:52.000000000 +0000
+++ mp-devel/libmultipath/propsel.c	2005-10-26 20:23:34.000000000 +0000
@@ -130,7 +130,8 @@ select_alias (struct multipath * mp)
 	else {
 		mp->alias = NULL;
 		if (conf->user_friendly_names)
-			mp->alias = get_user_friendly_alias(mp->wwid);
+			mp->alias = get_user_friendly_alias(mp->wwid,
+					conf->bindings_file);
 		if (mp->alias == NULL)
 			mp->alias = mp->wwid;
 	}
diff -urpN mp-devel-clean/multipath/main.c mp-devel/multipath/main.c
--- mp-devel-clean/multipath/main.c	2005-10-26 17:53:52.000000000 +0000
+++ mp-devel/multipath/main.c	2005-10-26 21:44:20.000000000 +0000
@@ -843,6 +843,7 @@ usage (char * progname)
 		"\t   1\t\t\tprint created devmap names only\n" \
 		"\t   2\t\t\tdefault verbosity\n" \
 		"\t   3\t\t\tprint debug information\n" \
+		"\t-b file\t\tbindings file location\n" \
 		"\t-d\t\tdry run, do not create or update devmaps\n" \
 		"\t-l\t\tshow multipath topology (sysfs and DM info)\n" \
 		"\t-ll\t\tshow multipath topology (maximum info)\n" \
@@ -1076,7 +1077,7 @@ main (int argc, char *argv[])
 	if (load_config(DEFAULT_CONFIGFILE))
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":qdl::Ffi:M:v:p:")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":qdl::Ffi:M:v:p:b:")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -1087,6 +1088,9 @@ main (int argc, char *argv[])
 
 			conf->verbosity = atoi(optarg);
 			break;
+		case 'b':
+			conf->bindings_file = optarg;
+			break;
 		case 'd':
 			conf->dry_run = 1;
 			break;

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--YiEDa0DAkWCtVeE4--
