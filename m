From: mwilck@suse.com
Subject: [PATCH 17/35] libmultipath: remove uevent listener
	failback
Date: Thu,  9 Jul 2020 12:16:02 +0200
Message-ID: <20200709101620.6786-18-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

TL;DR: this code is obsolete.

The failback code uses the udev 'RUN+="socket:"' technique, which
has been deprecated since udev 178 and removed since udev 183,
in 2012. The corresponding udev rule in multipath-tools has been removed
in ad067ac ("multipath: do not install rules file"), in 0.5.0 (2013).
Since that time, the failback code has been non-functional and basically
unmaintained.

While there's yet another fallback to the netlink socket, this 2nd fallback
would only be used if the socket(AF_LOCAL, ...) call failed, which would be
very unlikely. Even with the AF_LOCAL failback removed, leaving this 2nd
fallback in place doesn't make sense because it's just a reimplementation
of udev_monitor_new_from_netlink(); it's hard to imagine a case where the
latter would fail but our code would succeed.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 245 +-----------------------------------------
 libmultipath/uevent.h |   4 -
 2 files changed, 2 insertions(+), 247 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index e0d13b1..6a3f8bd 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -450,243 +450,6 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
 	return 0;
 }
 
-struct uevent *uevent_from_buffer(char *buf, ssize_t buflen)
-{
-	struct uevent *uev;
-	char *buffer;
-	size_t bufpos;
-	int i;
-	char *pos;
-
-	uev = alloc_uevent();
-	if (!uev) {
-		condlog(1, "lost uevent, oom");
-		return NULL;
-	}
-
-	if ((size_t)buflen > sizeof(buf)-1)
-		buflen = sizeof(buf)-1;
-
-	/*
-	 * Copy the shared receive buffer contents to buffer private
-	 * to this uevent so we can immediately reuse the shared buffer.
-	 */
-	memcpy(uev->buffer, buf, HOTPLUG_BUFFER_SIZE + OBJECT_SIZE);
-	buffer = uev->buffer;
-	buffer[buflen] = '\0';
-
-	/* save start of payload */
-	bufpos = strlen(buffer) + 1;
-
-	/* action string */
-	uev->action = buffer;
-	pos = strchr(buffer, '@');
-	if (!pos) {
-		condlog(3, "bad action string '%s'", buffer);
-		FREE(uev);
-		return NULL;
-	}
-	pos[0] = '\0';
-
-	/* sysfs path */
-	uev->devpath = &pos[1];
-
-	/* hotplug events have the environment attached - reconstruct envp[] */
-	for (i = 0; (bufpos < (size_t)buflen) && (i < HOTPLUG_NUM_ENVP-1); i++) {
-		int keylen;
-		char *key;
-
-		key = &buffer[bufpos];
-		keylen = strlen(key);
-		uev->envp[i] = key;
-		/* Filter out sequence number */
-		if (strncmp(key, "SEQNUM=", 7) == 0) {
-			char *eptr;
-
-			uev->seqnum = strtoul(key + 7, &eptr, 10);
-			if (eptr == key + 7)
-				uev->seqnum = -1;
-		}
-		bufpos += keylen + 1;
-	}
-	uev->envp[i] = NULL;
-
-	condlog(3, "uevent %ld '%s' from '%s'", uev->seqnum,
-		uev->action, uev->devpath);
-	uev->kernel = strrchr(uev->devpath, '/');
-	if (uev->kernel)
-		uev->kernel++;
-
-	/* print payload environment */
-	for (i = 0; uev->envp[i] != NULL; i++)
-		condlog(5, "%s", uev->envp[i]);
-
-	return uev;
-}
-
-int failback_listen(void)
-{
-	int sock;
-	struct sockaddr_nl snl;
-	struct sockaddr_un sun;
-	socklen_t addrlen;
-	int retval;
-	int rcvbufsz = 128*1024;
-	int rcvsz = 0;
-	int rcvszsz = sizeof(rcvsz);
-	unsigned int *prcvszsz = (unsigned int *)&rcvszsz;
-	const int feature_on = 1;
-	/*
-	 * First check whether we have a udev socket
-	 */
-	memset(&sun, 0x00, sizeof(struct sockaddr_un));
-	sun.sun_family = AF_LOCAL;
-	strcpy(&sun.sun_path[1], "/org/kernel/dm/multipath_event");
-	addrlen = offsetof(struct sockaddr_un, sun_path) + strlen(sun.sun_path+1) + 1;
-
-	sock = socket(AF_LOCAL, SOCK_DGRAM, 0);
-	if (sock >= 0) {
-
-		condlog(3, "reading events from udev socket.");
-
-		/* the bind takes care of ensuring only one copy running */
-		retval = bind(sock, (struct sockaddr *) &sun, addrlen);
-		if (retval < 0) {
-			condlog(0, "bind failed, exit");
-			goto exit;
-		}
-
-		/* enable receiving of the sender credentials */
-		retval = setsockopt(sock, SOL_SOCKET, SO_PASSCRED,
-				    &feature_on, sizeof(feature_on));
-		if (retval < 0) {
-			condlog(0, "failed to enable credential passing, exit");
-			goto exit;
-		}
-
-	} else {
-		/* Fallback to read kernel netlink events */
-		memset(&snl, 0x00, sizeof(struct sockaddr_nl));
-		snl.nl_family = AF_NETLINK;
-		snl.nl_pid = getpid();
-		snl.nl_groups = 0x01;
-
-		sock = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_KOBJECT_UEVENT);
-		if (sock == -1) {
-			condlog(0, "error getting socket, exit");
-			return 1;
-		}
-
-		condlog(3, "reading events from kernel.");
-
-		/*
-		 * try to avoid dropping uevents, even so, this is not a guarantee,
-		 * but it does help to change the netlink uevent socket's
-		 * receive buffer threshold from the default value of 106,496 to
-		 * the maximum value of 262,142.
-		 */
-		retval = setsockopt(sock, SOL_SOCKET, SO_RCVBUF, &rcvbufsz,
-				    sizeof(rcvbufsz));
-
-		if (retval < 0) {
-			condlog(0, "error setting receive buffer size for socket, exit");
-			exit(1);
-		}
-		retval = getsockopt(sock, SOL_SOCKET, SO_RCVBUF, &rcvsz, prcvszsz);
-		if (retval < 0) {
-			condlog(0, "error setting receive buffer size for socket, exit");
-			exit(1);
-		}
-		condlog(3, "receive buffer size for socket is %u.", rcvsz);
-
-		/* enable receiving of the sender credentials */
-		if (setsockopt(sock, SOL_SOCKET, SO_PASSCRED,
-			       &feature_on, sizeof(feature_on)) < 0) {
-			condlog(0, "error on enabling credential passing for socket");
-			exit(1);
-		}
-
-		retval = bind(sock, (struct sockaddr *) &snl,
-			      sizeof(struct sockaddr_nl));
-		if (retval < 0) {
-			condlog(0, "bind failed, exit");
-			goto exit;
-		}
-	}
-
-	while (1) {
-		size_t bufpos;
-		ssize_t buflen;
-		struct uevent *uev;
-		struct msghdr smsg;
-		struct iovec iov;
-		char cred_msg[CMSG_SPACE(sizeof(struct ucred))];
-		struct cmsghdr *cmsg;
-		struct ucred *cred;
-		static char buf[HOTPLUG_BUFFER_SIZE + OBJECT_SIZE];
-
-		memset(buf, 0x00, sizeof(buf));
-		iov.iov_base = &buf;
-		iov.iov_len = sizeof(buf);
-		memset (&smsg, 0x00, sizeof(struct msghdr));
-		smsg.msg_iov = &iov;
-		smsg.msg_iovlen = 1;
-		smsg.msg_control = cred_msg;
-		smsg.msg_controllen = sizeof(cred_msg);
-
-		buflen = recvmsg(sock, &smsg, 0);
-		if (buflen < 0) {
-			if (errno != EINTR)
-				condlog(0, "error receiving message, errno %d", errno);
-			continue;
-		}
-
-		cmsg = CMSG_FIRSTHDR(&smsg);
-		if (cmsg == NULL || cmsg->cmsg_type != SCM_CREDENTIALS) {
-			condlog(3, "no sender credentials received, message ignored");
-			continue;
-		}
-
-		cred = (struct ucred *)CMSG_DATA(cmsg);
-		if (cred->uid != 0) {
-			condlog(3, "sender uid=%d, message ignored", cred->uid);
-			continue;
-		}
-
-		/* skip header */
-		bufpos = strlen(buf) + 1;
-		if (bufpos < sizeof("a@/d") || bufpos >= sizeof(buf)) {
-			condlog(3, "invalid message length");
-			continue;
-		}
-
-		/* check message header */
-		if (strstr(buf, "@/") == NULL) {
-			condlog(3, "unrecognized message header");
-			continue;
-		}
-		if ((size_t)buflen > sizeof(buf)-1) {
-			condlog(2, "buffer overflow for received uevent");
-			buflen = sizeof(buf)-1;
-		}
-
-		uev = uevent_from_buffer(buf, buflen);
-		if (!uev)
-			continue;
-		/*
-		 * Queue uevent and poke service pthread.
-		 */
-		pthread_mutex_lock(uevq_lockp);
-		list_add_tail(&uev->node, &uevq);
-		pthread_cond_signal(uev_condp);
-		pthread_mutex_unlock(uevq_lockp);
-	}
-
-exit:
-	close(sock);
-	return 1;
-}
-
 struct uevent *uevent_from_udev_device(struct udev_device *dev)
 {
 	struct uevent *uev;
@@ -786,7 +549,6 @@ int uevent_listen(struct udev *udev)
 	struct udev_monitor *monitor = NULL;
 	int fd, socket_flags, events;
 	struct timeval start_time;
-	int need_failback = 1;
 	int timeout = 30;
 	LIST_HEAD(uevlisten_tmp);
 
@@ -806,7 +568,7 @@ int uevent_listen(struct udev *udev)
 	monitor = udev_monitor_new_from_netlink(udev, "udev");
 	if (!monitor) {
 		condlog(2, "failed to create udev monitor");
-		goto failback;
+		goto out_udev;
 	}
 	pthread_cleanup_push(monitor_cleanup, monitor);
 #ifdef LIBUDEV_API_RECVBUF
@@ -891,12 +653,9 @@ int uevent_listen(struct udev *udev)
 		gettimeofday(&start_time, NULL);
 		timeout = 30;
 	}
-	need_failback = 0;
 out:
 	pthread_cleanup_pop(1);
-failback:
-	if (need_failback)
-		err = failback_listen();
+out_udev:
 	pthread_cleanup_pop(1);
 	return err;
 }
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 0aa8675..4956bfc 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -9,10 +9,6 @@
 #define HOTPLUG_NUM_ENVP		32
 #define OBJECT_SIZE			512
 
-#ifndef NETLINK_KOBJECT_UEVENT
-#define NETLINK_KOBJECT_UEVENT		15
-#endif
-
 struct udev;
 
 struct uevent {
-- 
2.26.2
