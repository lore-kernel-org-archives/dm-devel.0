From: bmarzins@sourceware.org
Subject: multipath-tools multipath/Makefile multipathd/ ...
Date: 6 May 2009 17:26:47 -0000
Message-ID: <20090506172647.3636.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2009-05-06 17:26:45

Modified files:
	multipath      : Makefile 
	multipathd     : cli.c main.c uxclnt.c 

Log message:
	Fix for bz #484711
	Make failed commands to multipathd -k"cmd" return exit code 1

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.1&r2=1.17.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.3&r2=1.5.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.20&r2=1.69.2.21
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/uxclnt.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.7&r2=1.7.2.1

--- multipath-tools/multipath/Makefile	2009/05/05 22:02:31	1.17.2.1
+++ multipath-tools/multipath/Makefile	2009/05/06 17:26:43	1.17.2.2
@@ -42,7 +42,7 @@
 	install -d $(DESTDIR)$(mandir)
 	install -m 644 $(EXEC).8 $(DESTDIR)$(mandir)
 	install -d $(DESTDIR)$(man5dir)
-	install -m 644 $(EXEC).5 $(DESTDIR)$(man5dir)
+	install -m 644 $(EXEC).conf.5 $(DESTDIR)$(man5dir)
 	@if [ ! -e $(DESTDIR)/etc/multipath.conf ]; then \
 		install -m 644 multipath.conf.redhat  $(DESTDIR)/etc/multipath.conf; \
 	fi
--- multipath-tools/multipathd/cli.c	2008/09/19 03:27:08	1.5.2.3
+++ multipath-tools/multipathd/cli.c	2009/05/06 17:26:44	1.5.2.4
@@ -311,6 +311,7 @@
 		return NULL;
 
 	p = reply;
+	p += sprintf(p, "fail\n");
 	p += sprintf(p, VERSION_STRING);
 	p += sprintf(p, "CLI commands reference:\n");
 
--- multipath-tools/multipathd/main.c	2009/04/27 21:19:41	1.69.2.20
+++ multipath-tools/multipathd/main.c	2009/05/06 17:26:45	1.69.2.21
@@ -1756,8 +1756,8 @@
 			conf->verbosity = atoi(optarg);
 			break;
 		case 'k':
-			uxclnt(optarg);
-			exit(0);
+			err = uxclnt(optarg);
+			exit(err);
 		default:
 			;
 		}
--- multipath-tools/multipathd/uxclnt.c	2006/06/06 18:32:44	1.7
+++ multipath-tools/multipathd/uxclnt.c	2009/05/06 17:26:45	1.7.2.1
@@ -51,16 +51,21 @@
 	}
 }
 
-static void process_req(int fd, char * inbuf)
+static int process_req(int fd, char * inbuf)
 {
 	char *reply;
 	size_t len;
+	int ret = 0;
 
 	send_packet(fd, inbuf, strlen(inbuf) + 1);
 	recv_packet(fd, &reply, &len);
 
+	if (strncmp(reply, "fail\n", 5) == 0)
+		ret = 1;
 	printf("%s", reply);
 	FREE(reply);
+
+	return ret;
 }
 	
 /*
@@ -69,6 +74,7 @@
 int uxclnt(char * inbuf)
 {
 	int fd;
+	int r = 0;
 
 	fd = ux_socket_connect(DEFAULT_SOCKET);
 	if (fd == -1) {
@@ -77,9 +83,9 @@
 	}
 
 	if (inbuf)
-		process_req(fd, inbuf);
+		r = process_req(fd, inbuf);
 	else
 		process(fd);
 	
-	return 0;
+	return r;
 }
