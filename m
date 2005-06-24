From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: multipath uxsock patch
Date: Thu, 23 Jun 2005 23:04:01 -0500
Message-ID: <20050624040401.GB14793@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
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


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I was playing around with the CLI, and having some issues. Occasionally commands
wouldn't work, which was because multipathd was using string functions on
strings that weren't NULL terminated. Also, if you just typed in junk for the
name of the map to remove, it would always remove dm-0, because atoi returned 0.
I fixed those, added some moron-proofing checks, and made multipathd reply
"fail" if the command failed.

Here's the patch

-Ben

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="uxsock.patch"

diff -urN mp-devel-clean/multipathd/main.c mp-devel-patched/multipathd/main.c
--- mp-devel-clean/multipathd/main.c	2005-06-23 18:41:47.000000000 -0500
+++ mp-devel-patched/multipathd/main.c	2005-06-23 22:49:06.000000000 -0500
@@ -222,29 +222,36 @@
 	return 1;
 }
 
-static void
+static int
 switch_to_pathgroup (char * str)
 {
-	char * mapname;
-	char * buff;
+	int ret = 1;
+	int pg;
+	char * mapname = NULL;
+	char * buff = NULL;
 	char * p;
 
 	p = str;
 	p += get_word(p, &mapname);
 
 	if (!mapname)
-		return;
+		return 1;
 
 	p += get_word(p, &buff);
 
 	if (!buff)
 		goto out;
 
-	dm_switchgroup(mapname, atoi(buff));
-	FREE(buff);
+	if (sscanf(buff, "%d", &pg) != 1)
+		goto out;
+
+	ret = !dm_switchgroup(mapname, pg);
 out:
-	FREE(mapname);
-	return;
+	if (buff)
+		FREE(buff);
+	if (mapname)
+		FREE(mapname);
+	return ret;
 }
 	
 static void
@@ -560,13 +567,15 @@
 	int minor;
 	struct multipath * mpp;
 
-	minor = atoi(devname + 3);
+	if (sscanf(devname, "dm-%d", &minor) != 1)
+		return 1;
 	mpp = find_mp_by_minor(allpaths->mpvec, minor);
 
-	if (mpp)
+	if (mpp) {
 		remove_map(mpp, allpaths);
-
-	return 0;
+		return 0;
+	}
+	return 1;
 }
 
 static int
@@ -578,7 +587,7 @@
 
 	if (pp) {
 		condlog(3, "%s: already in pathvec");
-		return 0;
+		return 1;
 	}
 	condlog(2, "add %s path checker", devname);
 	pp = store_pathinfo(allpaths->pathvec, conf->hwtable,
@@ -608,7 +617,7 @@
 
 	if (!pp) {
 		condlog(3, "%s: not in pathvec");
-		return 0;
+		return 1;
 	}
 	condlog(2, "remove %s path checker", devname);
 	i = find_slot(allpaths->pathvec, (void *)pp);
@@ -657,7 +666,7 @@
 
 		c += sprintf(c, "\n");
 	}
-
+	reply[MAX_REPLY_LEN - 1] = 0;
 	return reply;
 }
 
@@ -698,13 +707,14 @@
 
 		c += sprintf(c, "\n");
 	}
-
+	reply[MAX_REPLY_LEN - 1] = 0;
 	return reply;
 }
 
 char *
 uxsock_trigger (char * str, void * trigger_data)
 {
+	int err;
 	struct paths * allpaths;
 	char * reply = NULL;
 
@@ -712,29 +722,42 @@
 
 	lock(allpaths->lock);
 
-	if (*str == 'l' && *(str + 1) == 'p')
+	if (strlen(str) < 2)
+		err = 1;
+
+	else if (*str == 'l' && *(str + 1) == 'p')
 		reply = show_paths(allpaths);
 
 	else if (*str == 'l' && *(str + 1) == 'm')
 		reply = show_maps(allpaths);
 
+	else if (strlen(str) < 4)
+		err = 1;
+
 	else if (*str == 'r' && *(str + 1) == 'p')
-		uev_remove_path(str + 3, allpaths);
+		err = uev_remove_path(str + 3, allpaths);
 
 	else if (*str == 'a' && *(str + 1) == 'p')
-		uev_add_path(str + 3, allpaths);
+		err = uev_add_path(str + 3, allpaths);
 
 	else if (*str == 'r' && *(str + 1) == 'm')
-		uev_remove_map(str + 3, allpaths);
+		err = uev_remove_map(str + 3, allpaths);
 
 	else if (*str == 'a' && *(str + 1) == 'm')
-		uev_add_map(str + 3, allpaths);
+		err = uev_add_map(str + 3, allpaths);
 
 	else if (*str == 's' && *(str + 1) == 'g')
-		switch_to_pathgroup(str + 3);
+		err = switch_to_pathgroup(str + 3);
 
-	if (!reply)
-		asprintf(&reply, "ok\n");
+	else
+		err = 1;
+
+	if (!reply) {
+		if (err)
+			asprintf(&reply, "fail\n");
+		else
+			asprintf(&reply, "ok\n");
+	}
 
 	unlock(allpaths->lock);
 
diff -urN mp-devel-clean/multipathd/uxclnt.c mp-devel-patched/multipathd/uxclnt.c
--- mp-devel-clean/multipathd/uxclnt.c	2005-06-20 18:00:23.000000000 -0500
+++ mp-devel-patched/multipathd/uxclnt.c	2005-06-23 21:32:19.000000000 -0500
@@ -22,12 +22,12 @@
 	char *reply;
 
 	while (line = readline("multipathd> ")) {
-		size_t len = strlen(line);
+		size_t len;
 
-		if (send_packet(fd, line, strlen(line)) != 0) break;
+		if (send_packet(fd, line, strlen(line)+1) != 0) break;
 		if (recv_packet(fd, &reply, &len) != 0) break;
 
-		printf("%*.*s\n", (int)len, (int)len, reply);
+		printf("%s\n", reply);
 
 		if (line && *line)
 			add_history(line);
@@ -42,10 +42,10 @@
 	char *reply;
 	size_t len;
 
-	send_packet(fd, inbuf, strlen(inbuf));
+	send_packet(fd, inbuf, strlen(inbuf)+1);
 	recv_packet(fd, &reply, &len);
 
-	printf("%*.*s\n", (int)len, (int)len, reply);
+	printf("%s\n", reply);
 	free(reply);
 }
 	
diff -urN mp-devel-clean/multipathd/uxlsnr.c mp-devel-patched/multipathd/uxlsnr.c
--- mp-devel-clean/multipathd/uxlsnr.c	2005-06-20 18:00:23.000000000 -0500
+++ mp-devel-patched/multipathd/uxlsnr.c	2005-06-23 21:30:05.000000000 -0500
@@ -120,14 +120,14 @@
 				if (recv_packet(c->fd, &inbuf, &len) != 0) {
 					dead_client(c);
 				} else {
-					condlog(4, "Got request [%*.*s]",
-						(int)len, (int)len, inbuf);
+					inbuf[len - 1] = 0;
+					condlog(4, "Got request [%s]", inbuf);
 					reply = uxsock_trigger(inbuf,
 							trigger_data);
 
 					if (reply) {
 						if (send_packet(c->fd, reply,
-							strlen(reply)) != 0) {
+							strlen(reply)+1) != 0) {
 							dead_client(c);
 						}
 						FREE(reply);

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--M9NhX3UHpAaciwkO--
