From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 35/78] Separate out uevent parsing functions
Date: Mon, 16 Mar 2015 13:36:22 +0100
Message-ID: <1426509425-15978-36-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Move the uevent parsing into separate functions.
No functional change.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/uevent.c | 254 +++++++++++++++++++++++++++-----------------------
 1 file changed, 136 insertions(+), 118 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 9ee3ade..7e41c6f 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -182,6 +182,80 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
 	return 0;
 }
 
+struct uevent *uevent_from_buffer(char *buf, ssize_t buflen)
+{
+	struct uevent *uev;
+	char *buffer;
+	size_t bufpos;
+	int i;
+	char *pos;
+
+	uev = alloc_uevent();
+	if (!uev) {
+		condlog(1, "lost uevent, oom");
+		return NULL;
+	}
+
+	if ((size_t)buflen > sizeof(buf)-1)
+		buflen = sizeof(buf)-1;
+
+	/*
+	 * Copy the shared receive buffer contents to buffer private
+	 * to this uevent so we can immediately reuse the shared buffer.
+	 */
+	memcpy(uev->buffer, buf, HOTPLUG_BUFFER_SIZE + OBJECT_SIZE);
+	buffer = uev->buffer;
+	buffer[buflen] = '\0';
+
+	/* save start of payload */
+	bufpos = strlen(buffer) + 1;
+
+	/* action string */
+	uev->action = buffer;
+	pos = strchr(buffer, '@');
+	if (!pos) {
+		condlog(3, "bad action string '%s'", buffer);
+		FREE(uev);
+		return NULL;
+	}
+	pos[0] = '\0';
+
+	/* sysfs path */
+	uev->devpath = &pos[1];
+
+	/* hotplug events have the environment attached - reconstruct envp[] */
+	for (i = 0; (bufpos < (size_t)buflen) && (i < HOTPLUG_NUM_ENVP-1); i++) {
+		int keylen;
+		char *key;
+
+		key = &buffer[bufpos];
+		keylen = strlen(key);
+		uev->envp[i] = key;
+		/* Filter out sequence number */
+		if (strncmp(key, "SEQNUM=", 7) == 0) {
+			char *eptr;
+
+			uev->seqnum = strtoul(key + 7, &eptr, 10);
+			if (eptr == key + 7)
+				uev->seqnum = -1;
+		}
+		bufpos += keylen + 1;
+	}
+	uev->envp[i] = NULL;
+
+	condlog(3, "uevent %ld '%s' from '%s'", uev->seqnum,
+		uev->action, uev->devpath);
+	uev->kernel = strrchr(uev->devpath, '/');
+	if (uev->kernel)
+		uev->kernel++;
+
+	/* print payload environment */
+	for (i = 0; uev->envp[i] != NULL; i++)
+		condlog(5, "%s", uev->envp[i]);
+
+	return uev;
+}
+
 int failback_listen(void)
 {
 	int sock;
@@ -266,12 +340,9 @@ int failback_listen(void)
 	}
 
 	while (1) {
-		int i;
-		char *pos;
 		size_t bufpos;
 		ssize_t buflen;
 		struct uevent *uev;
-		char *buffer;
 		struct msghdr smsg;
 		struct iovec iov;
 		char cred_msg[CMSG_SPACE(sizeof(struct ucred))];
@@ -324,69 +395,9 @@ int failback_listen(void)
 			buflen = sizeof(buf)-1;
 		}
 
-		uev = alloc_uevent();
-
-		if (!uev) {
-			condlog(1, "lost uevent, oom");
-			continue;
-		}
-
-		if ((size_t)buflen > sizeof(buf)-1)
-			buflen = sizeof(buf)-1;
-
-		/*
-		 * Copy the shared receive buffer contents to buffer private
-		 * to this uevent so we can immediately reuse the shared buffer.
-		 */
-		memcpy(uev->buffer, buf, HOTPLUG_BUFFER_SIZE + OBJECT_SIZE);
-		buffer = uev->buffer;
-		buffer[buflen] = '\0';
-
-		/* save start of payload */
-		bufpos = strlen(buffer) + 1;
-
-		/* action string */
-		uev->action = buffer;
-		pos = strchr(buffer, '@');
-		if (!pos) {
-			condlog(3, "bad action string '%s'", buffer);
+		uev = uevent_from_buffer(buf, buflen);
+		if (!uev)
 			continue;
-		}
-		pos[0] = '\0';
-
-		/* sysfs path */
-		uev->devpath = &pos[1];
-
-		/* hotplug events have the environment attached - reconstruct envp[] */
-		for (i = 0; (bufpos < (size_t)buflen) && (i < HOTPLUG_NUM_ENVP-1); i++) {
-			int keylen;
-			char *key;
-
-			key = &buffer[bufpos];
-			keylen = strlen(key);
-			uev->envp[i] = key;
-			/* Filter out sequence number */
-			if (strncmp(key, "SEQNUM=", 7) == 0) {
-				char *eptr;
-
-				uev->seqnum = strtoul(key + 7, &eptr, 10);
-				if (eptr == key + 7)
-					uev->seqnum = -1;
-			}
-			bufpos += keylen + 1;
-		}
-		uev->envp[i] = NULL;
-
-		condlog(3, "uevent %ld '%s' from '%s'", uev->seqnum,
-			uev->action, uev->devpath);
-		uev->kernel = strrchr(uev->devpath, '/');
-		if (uev->kernel)
-			uev->kernel++;
-
-		/* print payload environment */
-		for (i = 0; uev->envp[i] != NULL; i++)
-			condlog(5, "%s", uev->envp[i]);
-
 		/*
 		 * Queue uevent and poke service pthread.
 		 */
@@ -401,6 +412,62 @@ exit:
 	return 1;
 }
 
+struct uevent *uevent_from_udev_device(struct udev_device *dev)
+{
+	struct uevent *uev;
+	int i = 0;
+	char *pos, *end;
+	struct udev_list_entry *list_entry;
+
+	uev = alloc_uevent();
+	if (!uev) {
+		udev_device_unref(dev);
+		condlog(1, "lost uevent, oom");
+		return NULL;
+	}
+	pos = uev->buffer;
+	end = pos + HOTPLUG_BUFFER_SIZE + OBJECT_SIZE - 1;
+	udev_list_entry_foreach(list_entry, udev_device_get_properties_list_entry(dev)) {
+		const char *name, *value;
+		int bytes;
+
+		name = udev_list_entry_get_name(list_entry);
+		if (!name)
+			name = "(null)";
+		value = udev_list_entry_get_value(list_entry);
+		if (!value)
+			value = "(null)";
+		bytes = snprintf(pos, end - pos, "%s=%s", name, value);
+		if (pos + bytes >= end) {
+			condlog(2, "buffer overflow for uevent");
+			break;
+		}
+		uev->envp[i] = pos;
+		pos += bytes;
+		*pos = '\0';
+		pos++;
+		if (strcmp(name, "DEVPATH") == 0)
+			uev->devpath = uev->envp[i] + 8;
+		if (strcmp(name, "ACTION") == 0)
+			uev->action = uev->envp[i] + 7;
+		i++;
+		if (i == HOTPLUG_NUM_ENVP - 1)
+			break;
+	}
+	uev->udev = dev;
+	uev->envp[i] = NULL;
+
+	condlog(3, "uevent '%s' from '%s'", uev->action, uev->devpath);
+	uev->kernel = strrchr(uev->devpath, '/');
+	if (uev->kernel)
+		uev->kernel++;
+
+	/* print payload environment */
+	for (i = 0; uev->envp[i] != NULL; i++)
+		condlog(5, "%s", uev->envp[i]);
+	return uev;
+}
+
 int uevent_listen(struct udev *udev)
 {
 	int err;
@@ -456,69 +523,20 @@ int uevent_listen(struct udev *udev)
 		goto out;
 	}
 	while (1) {
-		int i = 0;
-		char *pos, *end;
 		struct uevent *uev;
 		struct udev_device *dev;
-                struct udev_list_entry *list_entry;
 
 		dev = udev_monitor_receive_device(monitor);
 		if (!dev) {
 			condlog(0, "failed getting udev device");
 			continue;
 		}
-
-		uev = alloc_uevent();
-		if (!uev) {
-			udev_device_unref(dev);
-			condlog(1, "lost uevent, oom");
+		uev = uevent_from_udev_device(dev);
+		if (!uev)
 			continue;
-		}
-		pos = uev->buffer;
-		end = pos + HOTPLUG_BUFFER_SIZE + OBJECT_SIZE - 1;
-		udev_list_entry_foreach(list_entry, udev_device_get_properties_list_entry(dev)) {
-			const char *name, *value;
-			int bytes;
-
-			name = udev_list_entry_get_name(list_entry);
-			if (!name)
-				name = "(null)";
-			value = udev_list_entry_get_value(list_entry);
-			if (!value)
-				value = "(null)";
-			bytes = snprintf(pos, end - pos, "%s=%s", name,
-					value);
-			if (pos + bytes >= end) {
-				condlog(2, "buffer overflow for uevent");
-				break;
-			}
-			uev->envp[i] = pos;
-			pos += bytes;
-			*pos = '\0';
-			pos++;
-			if (strcmp(name, "DEVPATH") == 0)
-				uev->devpath = uev->envp[i] + 8;
-			if (strcmp(name, "ACTION") == 0)
-				uev->action = uev->envp[i] + 7;
-			i++;
-			if (i == HOTPLUG_NUM_ENVP - 1)
-				break;
-		}
-		uev->udev = dev;
-		uev->envp[i] = NULL;
-
-		condlog(3, "uevent '%s' from '%s'", uev->action, uev->devpath);
-		uev->kernel = strrchr(uev->devpath, '/');
-		if (uev->kernel)
-			uev->kernel++;
-
-		/* print payload environment */
-		for (i = 0; uev->envp[i] != NULL; i++)
-			condlog(5, "%s", uev->envp[i]);
-
 		/*
- 		 * Queue uevent and poke service pthread.
- 		 */
+		 * Queue uevent and poke service pthread.
+		 */
 		pthread_mutex_lock(uevq_lockp);
 		list_add_tail(&uev->node, &uevq);
 		pthread_cond_signal(uev_condp);
-- 
1.8.4.5
