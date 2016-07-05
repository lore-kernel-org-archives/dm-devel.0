From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 3/4] multipath-tools: Add rbd checker.
Date: Tue,  5 Jul 2016 03:12:32 -0500
Message-ID: <1467706353-16878-4-git-send-email-mchristi@redhat.com>
References: <1467706353-16878-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467706353-16878-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

This checker currently only handles the case where a path is failed
due to it being blacklisted by the ceph cluster. The specific use
case for me is when LIO exports rbd images through multiple LIO
instances.

The problem it handles is when rbd instance1 has the exclusive lock,
but becomes unreachable. Another host in the cluster will take over
and blacklist the instance1. This prevents it from sending stale IO
and corrupting date.

Later, when the host is reachable, we will want to failback to it.
To this, the checker will detect we were blacklisted, unmap the old
image which will make sure old IO is failed, and then remap the image
and unblacklist the host. multipathd will then handle this like a
path being removed and re-added.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 libmultipath/checkers/Makefile |   6 +-
 libmultipath/checkers/rbd.c    | 612 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 617 insertions(+), 1 deletion(-)
 create mode 100644 libmultipath/checkers/rbd.c

diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 4b1a108..1538eb8 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -11,12 +11,16 @@ LIBS= \
 	libcheckdirectio.so \
 	libcheckemc_clariion.so \
 	libcheckhp_sw.so \
-	libcheckrdac.so
+	libcheckrdac.so \
+	libcheckrbd.so
 
 CFLAGS += -I..
 
 all: $(LIBS)
 
+libcheckrbd.so: rbd.o
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lrados -ludev
+
 libcheckdirectio.so: libsg.o directio.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -laio
 
diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
new file mode 100644
index 0000000..071d3f3
--- /dev/null
+++ b/libmultipath/checkers/rbd.c
@@ -0,0 +1,612 @@
+/*
+ * Copyright (c) 2016 Red Hat
+ * Copyright (c) 2004 Christophe Varoqui
+ *
+ * Code based off of tur.c and ceph's krbd.cc
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <pthread.h>
+#include <libudev.h>
+#include <ifaddrs.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <arpa/inet.h>
+
+#include "rados/librados.h"
+
+#include "structs.h"
+#include "checkers.h"
+
+#include "../libmultipath/debug.h"
+#include "../libmultipath/uevent.h"
+
+struct rbd_checker_context;
+typedef int (thread_fn)(struct rbd_checker_context *ct, char *msg);
+
+#define RBD_MSG(msg, fmt, args...) snprintf(msg, CHECKER_MSG_LEN, fmt, ##args);
+
+struct rbd_checker_context {
+	int rbd_bus_id;
+	unsigned int addr_nonce;
+	char *blk_lst_addr;
+	char *config_info;
+	int remapped;
+	int blacklisted;
+
+	rados_t cluster;
+
+	int state;
+	int running;
+	time_t time;
+	thread_fn *fn;
+	pthread_t thread;
+	pthread_mutex_t lock;
+	pthread_cond_t active;
+	pthread_spinlock_t hldr_lock;
+	int holders;
+	char message[CHECKER_MSG_LEN];
+};
+
+int libcheck_init(struct checker * c)
+{
+	struct rbd_checker_context *ct;
+	struct udev_device *block_dev;
+	struct udev_device *bus_dev;
+	struct udev *udev;
+	struct stat sb;
+	const char *block_name, *nonce, *config;
+	char sysfs_path[PATH_SIZE];
+	int ret;
+
+	ct = malloc(sizeof(struct rbd_checker_context));
+	if (!ct)
+		return 1;
+	memset(ct, 0, sizeof(struct rbd_checker_context));
+	ct->holders = 1;
+	pthread_cond_init(&ct->active, NULL);
+	pthread_mutex_init(&ct->lock, NULL);
+	pthread_spin_init(&ct->hldr_lock, PTHREAD_PROCESS_PRIVATE);
+	c->context = ct;
+
+	/*
+	 * The rbd block layer sysfs device is not linked to the rbd bus
+	 * device that we interact with, so figure that out now.
+	 */
+	if (fstat(c->fd, &sb) != 0)
+		goto free_ct;
+
+	udev = udev_new();
+	if (!udev)
+		goto free_ct;
+
+	block_dev = udev_device_new_from_devnum(udev, 'b', sb.st_rdev);
+	if (!block_dev)
+		goto free_udev;
+
+	block_name  = udev_device_get_sysname(block_dev);
+	ret = sscanf(block_name, "rbd%d", &ct->rbd_bus_id);
+
+	udev_device_unref(block_dev);
+	if (ret != 1)
+		goto free_udev;
+
+	snprintf(sysfs_path, sizeof(sysfs_path), "/sys/bus/rbd/devices/%d",
+		 ct->rbd_bus_id);
+	bus_dev = udev_device_new_from_syspath(udev, sysfs_path);
+	if (!bus_dev)
+		goto free_udev;
+
+	nonce = udev_device_get_sysattr_value(bus_dev, "client_addr_nonce");
+	if (!nonce)
+		goto free_dev;
+
+	ret = sscanf(nonce, "%u\n", &ct->addr_nonce);
+	if (ret != 1)
+		goto free_dev;
+
+	config = udev_device_get_sysattr_value(bus_dev, "config_info");
+	if (!config)
+		goto free_dev;
+
+	ct->config_info = strdup(config);
+	if (!ct->config_info)
+		goto free_dev;
+
+	if (rados_create(&ct->cluster, NULL) < 0)
+		goto free_config;
+
+	if (rados_conf_read_file(ct->cluster, NULL) < 0)
+		goto shutdown_rados;
+
+	ret = rados_connect(ct->cluster);
+	if (ret < 0)
+		goto shutdown_rados;
+
+	udev_device_unref(bus_dev);
+	udev_unref(udev);
+
+	return 0;
+
+shutdown_rados:
+	rados_shutdown(ct->cluster);
+free_config:
+	free(ct->config_info);
+free_dev:
+	udev_device_unref(bus_dev);
+free_udev:
+	udev_unref(udev);
+free_ct:
+	free(ct);
+	return 1;
+}
+
+void cleanup_context(struct rbd_checker_context *ct)
+{
+	pthread_mutex_destroy(&ct->lock);
+	pthread_cond_destroy(&ct->active);
+	pthread_spin_destroy(&ct->hldr_lock);
+
+	rados_shutdown(ct->cluster);
+
+	if (ct->blk_lst_addr)
+		free(ct->blk_lst_addr);
+	free(ct->config_info);
+	free(ct);
+}
+
+void libcheck_free(struct checker * c)
+{
+	if (c->context) {
+		struct rbd_checker_context *ct = c->context;
+		int holders;
+		pthread_t thread;
+
+		pthread_spin_lock(&ct->hldr_lock);
+		ct->holders--;
+		holders = ct->holders;
+		thread = ct->thread;
+		pthread_spin_unlock(&ct->hldr_lock);
+		if (holders)
+			pthread_cancel(thread);
+		else
+			cleanup_context(ct);
+		c->context = NULL;
+	}
+}
+
+static int rbd_match_addr(struct in6_addr *inaddr)
+{
+	struct ifaddrs *ifap, *ifa;
+	int ret = 1;
+
+	if (getifaddrs(&ifap))
+		return -EAGAIN;
+
+	for (ifa = ifap; ifa; ifa = ifa->ifa_next) {
+		struct sockaddr_in *s4;
+	        struct sockaddr_in6 *s6;
+
+		if (!ifa->ifa_addr)
+			continue;
+
+		switch (ifa->ifa_addr->sa_family) {
+		case AF_INET:
+			s4 = (struct sockaddr_in *)(ifa->ifa_addr);
+			if (!memcmp(&s4->sin_addr, (struct in_addr *) inaddr,
+				    sizeof(struct in_addr)))
+				goto free_ifap;
+			break;
+		case AF_INET6:
+			s6 = (struct sockaddr_in6 *)(ifa->ifa_addr);
+			if (!memcmp(&s6->sin6_addr, inaddr,
+				    sizeof(struct in6_addr)))
+				goto free_ifap;
+			break;
+		default:
+			continue;
+		}
+	}
+	ret = 0;
+
+free_ifap:
+	freeifaddrs(ifap);
+	return ret;
+}
+
+static int rbd_is_blacklisted(struct rbd_checker_context *ct, char *msg)
+{
+	char *nonce, *addr_tok, *start, *save;
+	char *cmd[2];
+	char *blklist, *stat;
+	size_t blklist_len, stat_len;
+	unsigned int blklisted_nonce;
+	int ret;
+	char *addr;
+	struct in6_addr inaddr;
+
+	cmd[0] = "{\"prefix\": \"osd blacklist ls\"}";
+	cmd[1] = NULL;
+
+	ret = rados_mon_command(ct->cluster, (const char **)cmd, 1, "", 0,
+				&blklist, &blklist_len, &stat, &stat_len);
+	if (ret < 0) {
+		RBD_MSG(msg, "rbd checker failed: mon command failed %d",
+			ret);
+		return ret;
+	}
+
+	if (!blklist || !blklist_len)
+		goto free_bufs;
+
+	/*
+	 * parse list of addrs with the format
+	 * ipv4:port/nonce date time\n
+	 * or
+	 * [ipv6]:port/nonce date time\n
+	 */
+	ret = 0;
+	for (start = blklist; ; start = NULL) {
+		addr_tok = strtok_r(start, "\n", &save);
+		if (!addr_tok || !strlen(addr_tok))
+			break;
+
+		nonce = strchr(addr_tok, '/');
+		if (!nonce || strlen(nonce) < 2) {
+			RBD_MSG(msg, "rbd%d checker failed: invalid blacklist %s",
+				ct->rbd_bus_id, addr_tok);
+			break;
+		}
+		nonce++;
+		blklisted_nonce = atoi(nonce);
+
+		if (blklisted_nonce == ct->addr_nonce) {
+			char *port, *end;
+
+			condlog(3, "rbd%d checker matched nonce %s\n",
+				ct->rbd_bus_id, nonce);
+			addr = addr_tok;
+			if (addr[0] == '[') {
+				addr++;
+				end = strrchr(addr, ']');
+				if (!end) {
+					ret = -EINVAL;
+					break;
+				}
+				*end = '\0';
+				end++;
+
+				port = strchr(end, ':');
+				if (!port) {
+					ret = -EINVAL;
+					break;
+				}
+				*port = '\0';
+
+				ret = inet_pton(AF_INET6, addr,
+						(struct in6_addr *) &inaddr);
+			} else {
+				port = strchr(addr, ':');
+				if (!port) {
+					ret = -EINVAL;
+					break;
+				}
+				*port = '\0';
+
+				ret = inet_pton(AF_INET, addr,
+						(struct in_addr *) &inaddr);
+			}
+
+			if (ret != 1) {
+				break;
+			}
+
+			ret = rbd_match_addr(&inaddr);
+			if (ret == 1) {
+				ct->blk_lst_addr = strdup(addr);
+				if (!ct->blk_lst_addr) {
+					ret = -ENOMEM;
+					break;
+				}
+
+				ct->blacklisted = 1;
+				RBD_MSG(msg, "rbd%d checker: %s/%u is blacklisted",
+					ct->rbd_bus_id, addr, blklisted_nonce);
+			}
+			break;
+		}
+	}
+
+free_bufs:
+	rados_buffer_free(blklist);
+	rados_buffer_free(stat);
+	return ret;
+}
+
+int rbd_check(struct rbd_checker_context *ct, char *msg)
+{
+	if (ct->blacklisted || rbd_is_blacklisted(ct, msg) == 1)
+		return PATH_DOWN;
+
+	RBD_MSG(msg, "rbd checker reports path is up");
+	/*
+	 * Path may have issues, but the ceph cluster is at least
+	 * accepting IO, so we can attempt to do IO.
+	 *
+	 * TODO: in future versions, we can run other tests to
+	 * verify OSDs and networks.
+	 */
+	return PATH_UP;
+}
+
+int safe_write(int fd, const void *buf, size_t count)
+{
+	while (count > 0) {
+		ssize_t r = write(fd, buf, count);
+		if (r < 0) {
+			if (errno == EINTR)
+				continue;
+			return -errno;
+		}
+		count -= r;
+		buf = (char *)buf + r;
+	}
+	return 0;
+}
+
+static int sysfs_write_rbd_bus(const char *which, const char *buf,
+			       size_t buf_len)
+{
+	char sysfs_path[PATH_SIZE];
+	int fd;
+	int r;
+
+	/* we require newer kernels so single_major should alwayws be there */
+	snprintf(sysfs_path, sizeof(sysfs_path),
+		 "/sys/bus/rbd/%s_single_major", which);
+	fd = open(sysfs_path, O_WRONLY);
+	if (fd < 0)
+		return -errno;
+
+	r = safe_write(fd, buf, buf_len);
+	close(fd);
+	return r;
+}
+
+static int sysfs_write_rbd_add(const char *buf, int buf_len)
+{
+	return sysfs_write_rbd_bus("add", buf, buf_len);
+}
+
+static int sysfs_write_rbd_remove(const char *buf, int buf_len)
+{
+	return sysfs_write_rbd_bus("remove", buf, buf_len);
+}
+
+static int rbd_rm_blacklist(struct rbd_checker_context *ct)
+{
+	char *cmd[2];
+	char *stat, *cmd_str;
+	size_t stat_len;
+	int ret;
+
+	ret = asprintf(&cmd_str, "{\"prefix\": \"osd blacklist\", \"blacklistop\": \"rm\", \"addr\": \"%s:0/%u\"}",
+		       ct->blk_lst_addr, ct->addr_nonce);
+	if (ret == -1)
+		return -ENOMEM;
+
+	cmd[0] = cmd_str;
+	cmd[1] = NULL;
+
+	ret = rados_mon_command(ct->cluster, (const char **)cmd, 1, "", 0,
+				NULL, 0, &stat, &stat_len);
+	if (ret < 0) {
+		condlog(1, "rbd%d repair failed to remove blacklist for %s/%u %d",
+			ct->rbd_bus_id, ct->blk_lst_addr, ct->addr_nonce, ret);
+		goto free_cmd;
+	}
+
+	condlog(1, "rbd%d repair rm blacklist for %s/%d",
+	       ct->rbd_bus_id, ct->blk_lst_addr, ct->addr_nonce);
+	free(stat);
+free_cmd:
+	free(cmd_str);
+	return ret;
+}
+
+static int rbd_repair(struct rbd_checker_context *ct, char *msg)
+{
+	char del[17];
+	int ret;
+
+	if (!ct->blacklisted)
+		return PATH_UP;
+
+	if (!ct->remapped) {
+		ret = sysfs_write_rbd_add(ct->config_info,
+					  strlen(ct->config_info) + 1);
+		if (ret) {
+			RBD_MSG(msg, "rbd%d repair failed to remap. Err %d",
+				ct->rbd_bus_id, ret);
+			return PATH_DOWN;
+		}
+	}
+	ct->remapped = 1;
+
+	snprintf(del, sizeof(del), "%d force", ct->rbd_bus_id);
+	ret = sysfs_write_rbd_remove(del, strlen(del) + 1);
+	if (ret) {
+		RBD_MSG(msg, "rbd%d repair failed to clean up. Err %d",
+			ct->rbd_bus_id, ret);
+		return PATH_DOWN;
+	}
+
+	ret = rbd_rm_blacklist(ct);
+	if (ret) {
+		RBD_MSG(msg, "rbd%d repair could not remove blacklist entry. Err %d",
+			ct->rbd_bus_id, ret);
+		return PATH_DOWN;
+	}
+
+	ct->remapped = 0;
+	ct->blacklisted = 0;
+
+	RBD_MSG(msg, "rbd%d has been repaired", ct->rbd_bus_id);
+	return PATH_UP;
+}
+
+#define rbd_thread_cleanup_push(ct) pthread_cleanup_push(cleanup_func, ct)
+#define rbd_thread_cleanup_pop(ct) pthread_cleanup_pop(1)
+
+void cleanup_func(void *data)
+{
+	int holders;
+	struct rbd_checker_context *ct = data;
+	pthread_spin_lock(&ct->hldr_lock);
+	ct->holders--;
+	holders = ct->holders;
+	ct->thread = 0;
+	pthread_spin_unlock(&ct->hldr_lock);
+	if (!holders)
+		cleanup_context(ct);
+}
+
+void *rbd_thread(void *ctx)
+{
+	struct rbd_checker_context *ct = ctx;
+	int state;
+
+	condlog(3, "rbd%d thread starting up", ct->rbd_bus_id);
+
+	ct->message[0] = '\0';
+	/* This thread can be canceled, so setup clean up */
+	rbd_thread_cleanup_push(ct)
+
+	/* checker start up */
+	pthread_mutex_lock(&ct->lock);
+	ct->state = PATH_PENDING;
+	pthread_mutex_unlock(&ct->lock);
+
+	state = ct->fn(ct, ct->message);
+
+	/* checker done */
+	pthread_mutex_lock(&ct->lock);
+	ct->state = state;
+	pthread_mutex_unlock(&ct->lock);
+	pthread_cond_signal(&ct->active);
+
+	condlog(3, "rbd%d thead finished, state %s", ct->rbd_bus_id,
+		checker_state_name(state));
+	rbd_thread_cleanup_pop(ct);
+	return ((void *)0);
+}
+
+static void rbd_timeout(struct timespec *tsp)
+{
+	struct timeval now;
+
+	gettimeofday(&now, NULL);
+	tsp->tv_sec = now.tv_sec;
+	tsp->tv_nsec = now.tv_usec * 1000;
+	tsp->tv_nsec += 1000000; /* 1 millisecond */
+}
+
+static int rbd_exec_fn(struct checker *c, thread_fn *fn)
+{
+	struct rbd_checker_context *ct = c->context;
+	struct timespec tsp;
+	pthread_attr_t attr;
+	int rbd_status, r;
+
+	if (c->sync)
+		return rbd_check(ct, c->message);
+	/*
+	 * Async mode
+	 */
+	r = pthread_mutex_lock(&ct->lock);
+	if (r != 0) {
+		condlog(2, "rbd%d mutex lock failed with %d", ct->rbd_bus_id,
+			r);
+		MSG(c, "rbd%d thread failed to initialize", ct->rbd_bus_id);
+		return PATH_WILD;
+	}
+
+	if (ct->running) {
+		/* Check if checker is still running */
+		if (ct->thread) {
+			condlog(3, "rbd%d thread not finished", ct->rbd_bus_id);
+			rbd_status = PATH_PENDING;
+		} else {
+			/* checker done */
+			ct->running = 0;
+			rbd_status = ct->state;
+			strncpy(c->message, ct->message, CHECKER_MSG_LEN);
+			c->message[CHECKER_MSG_LEN - 1] = '\0';
+		}
+		pthread_mutex_unlock(&ct->lock);
+	} else {
+		/* Start new checker */
+		ct->state = PATH_UNCHECKED;
+		ct->fn = fn;
+		pthread_spin_lock(&ct->hldr_lock);
+		ct->holders++;
+		pthread_spin_unlock(&ct->hldr_lock);
+		setup_thread_attr(&attr, 32 * 1024, 1);
+		r = pthread_create(&ct->thread, &attr, rbd_thread, ct);
+		if (r) {
+			pthread_mutex_unlock(&ct->lock);
+			ct->thread = 0;
+			ct->holders--;
+			condlog(3, "rbd%d failed to start rbd thread, using sync mode",
+				ct->rbd_bus_id);
+			return fn(ct, c->message);
+		}
+		pthread_attr_destroy(&attr);
+		rbd_timeout(&tsp);
+		r = pthread_cond_timedwait(&ct->active, &ct->lock, &tsp);
+		rbd_status = ct->state;
+		strncpy(c->message, ct->message,CHECKER_MSG_LEN);
+		c->message[CHECKER_MSG_LEN -1] = '\0';
+		pthread_mutex_unlock(&ct->lock);
+
+		if (ct->thread &&
+		    (rbd_status == PATH_PENDING || rbd_status == PATH_UNCHECKED)) {
+			condlog(3, "rbd%d thread still running",
+				ct->rbd_bus_id);
+			ct->running = 1;
+			rbd_status = PATH_PENDING;
+		}
+	}
+
+	return rbd_status;
+}
+
+void libcheck_repair(struct checker * c)
+{
+	struct rbd_checker_context *ct = c->context;
+
+	if (!ct || !ct->blacklisted)
+		return;
+	rbd_exec_fn(c, rbd_repair);
+}
+
+int libcheck_check(struct checker * c)
+{
+	struct rbd_checker_context *ct = c->context;
+
+	if (!ct)
+		return PATH_UNCHECKED;
+
+	if (ct->blacklisted)
+		return PATH_DOWN;
+
+	return rbd_exec_fn(c, rbd_check);
+}
-- 
2.5.5
