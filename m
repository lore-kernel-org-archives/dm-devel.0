From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 4/5] multipath: add alternate reservation_key
	method
Date: Fri, 15 Sep 2017 17:25:35 -0500
Message-ID: <1505514336-27839-6-git-send-email-bmarzins@redhat.com>
References: <1505514336-27839-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1505514336-27839-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The scsi persistent reservation API doesn't force devices to implement
any method to display the mapping from a reservation key to an I_T Nexus
(the READ_FULL_STATUS action is an optional later addition, and a number
of devices don't support it). To allow multipathd to determine the
correct reservation key for a device without support from the device
itself, it uses the reservation_key configuration option. Unfortunately,
using this option forces the multipath configuration to be updated
whenever a new scsi registration key is used.  This isn't acceptable to
some users, who want a static configuration file.

This patch provides an alternate method of setting the reservation_key
for the multipath device. The reservation_key configuration option now
also accepts the keyword "file". If this is used, multpath will look in
the new prkeys file (by default "/etc/multipath/prkeys") for a line with
the device wwid and it's associated reservation_key. Where a device's
reservation key comes from is tracked by the prkey_source variable,
which is set and read through the reservation_key dict.c functions.

There are also new multipathd commands to get, set, and unset the
mappings in the prkesy file. Currently,

"multipathd map $map setprkey key $key" sets the mapping
"multipathd map $map unsetprkey" unsets the mapping
"multipathd map $map getprkey" gets the current reservation_key for a
multipath device.

There is some lack of symmetry here where you are allowed to set and
unset mappings even for devices that aren't configured to use the prkeys
file, but you will only get the mapping from the prkeys file for devices
that are configured to use it. Otherwise you will get the mapping from
multipath.conf. In other words, setprkey and unsetprkey return success
but don't do anything useful unless a device is configured with

reservation_key file

but getprkey will return the device's current reservation_key regardless
of where the key came from.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/Makefile     |   2 +-
 libmultipath/config.c     |   6 +-
 libmultipath/config.h     |   7 +-
 libmultipath/defaults.h   |   1 +
 libmultipath/dict.c       |  62 ++++++++++++++---
 libmultipath/dict.h       |   4 +-
 libmultipath/prkey.c      | 166 ++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/prkey.h      |  19 ++++++
 libmultipath/propsel.c    |  31 +++++++--
 libmultipath/structs.h    |   9 ++-
 multipathd/cli.c          |   8 +++
 multipathd/cli.h          |   8 +++
 multipathd/cli_handlers.c |  82 +++++++++++++++++++++++
 multipathd/cli_handlers.h |   3 +
 multipathd/main.c         |   3 +
 15 files changed, 391 insertions(+), 20 deletions(-)
 create mode 100644 libmultipath/prkey.c
 create mode 100644 libmultipath/prkey.h

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index b3244fc..928bc25 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -42,7 +42,7 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	pgpolicies.o debug.o defaults.o uevent.o time-util.o \
 	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
 	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
-	lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o
+	lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o prkey.o
 
 all: $(LIBS)
 
diff --git a/libmultipath/config.c b/libmultipath/config.c
index dba4bc4..ea2359a 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -515,6 +515,9 @@ free_config (struct config * conf)
 	if (conf->wwids_file)
 		FREE(conf->wwids_file);
 
+	if (conf->prkeys_file)
+		FREE(conf->prkeys_file);
+
 	if (conf->prio_name)
 		FREE(conf->prio_name);
 
@@ -603,6 +606,7 @@ load_config (char * file)
 	get_sys_max_fds(&conf->max_fds);
 	conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
 	conf->wwids_file = set_default(DEFAULT_WWIDS_FILE);
+	conf->prkeys_file = set_default(DEFAULT_PRKEYS_FILE);
 	conf->multipath_dir = set_default(DEFAULT_MULTIPATHDIR);
 	conf->attribute_flags = 0;
 	conf->reassign_maps = DEFAULT_REASSIGN_MAPS;
@@ -728,7 +732,7 @@ load_config (char * file)
 		conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
 
 	if (!conf->multipath_dir || !conf->bindings_file ||
-	    !conf->wwids_file)
+	    !conf->wwids_file || !conf->prkeys_file)
 		goto out;
 
 	return conf;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index d1ca7d3..5ea852f 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -92,7 +92,8 @@ struct mpentry {
 
 	char * prio_name;
 	char * prio_args;
-	struct be64  reservation_key;
+	int prkey_source;
+	struct be64 reservation_key;
 	int pgpolicy;
 	int pgfailback;
 	int rr_weight;
@@ -179,13 +180,15 @@ struct config {
 	char * hwhandler;
 	char * bindings_file;
 	char * wwids_file;
+	char * prkeys_file;
 	char * prio_name;
 	char * prio_args;
 	char * checker_name;
 	char * alias_prefix;
 	char * partition_delim;
 	char * config_dir;
-	struct be64  reservation_key;
+	int prkey_source;
+	struct be64 reservation_key;
 
 	vector keywords;
 	vector mptable;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index db2b756..740ccf4 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -50,6 +50,7 @@
 #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
 #define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
 #define DEFAULT_WWIDS_FILE	"/etc/multipath/wwids"
+#define DEFAULT_PRKEYS_FILE    "/etc/multipath/prkeys"
 #define DEFAULT_CONFIG_DIR	"/etc/multipath/conf.d"
 
 char * set_default (char * str);
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 50d618c..36cccc9 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -368,6 +368,9 @@ declare_def_snprint(bindings_file, print_str)
 declare_def_handler(wwids_file, set_str)
 declare_def_snprint(wwids_file, print_str)
 
+declare_def_handler(prkeys_file, set_str)
+declare_def_snprint(prkeys_file, print_str)
+
 declare_def_handler(retain_hwhandler, set_yes_no_undef)
 declare_def_snprint_defint(retain_hwhandler, print_yes_no_undef, YNU_NO)
 declare_ovr_handler(retain_hwhandler, set_yes_no_undef)
@@ -960,9 +963,8 @@ snprint_def_log_checker_err (struct config *conf, char * buff, int len, void * d
 }
 
 static int
-set_reservation_key(vector strvec, void *ptr)
+set_reservation_key(vector strvec, struct be64 *be64_ptr, int *source_ptr)
 {
-	struct be64 *be64_ptr = (struct be64 *)ptr;
 	char *buff;
 	uint64_t prkey;
 
@@ -970,27 +972,66 @@ set_reservation_key(vector strvec, void *ptr)
 	if (!buff)
 		return 1;
 
+	if (strcmp(buff, "file") == 0) {
+		*source_ptr = PRKEY_SOURCE_FILE;
+		put_be64(*be64_ptr, 0);
+		FREE(buff);
+		return 0;
+	}
+
 	if (parse_prkey(buff, &prkey) != 0) {
 		FREE(buff);
 		return 1;
 	}
-
+	*source_ptr = PRKEY_SOURCE_CONF;
 	put_be64(*be64_ptr, prkey);
 	FREE(buff);
 	return 0;
 }
 
 int
-print_reservation_key(char * buff, int len, void * ptr)
+print_reservation_key(char * buff, int len, struct be64 key, int source)
+{
+	if (source == PRKEY_SOURCE_NONE)
+		return 0;
+	if (source == PRKEY_SOURCE_FILE)
+		return snprintf(buff, len, "file");
+	return snprintf(buff, len, "0x%" PRIx64, get_be64(key));
+}
+
+static int
+def_reservation_key_handler(struct config *conf, vector strvec)
+{
+	return set_reservation_key(strvec, &conf->reservation_key,
+				   &conf->prkey_source);
+}
+
+static int
+snprint_def_reservation_key (struct config *conf, char * buff, int len,
+			     void * data)
+{
+	return print_reservation_key(buff, len, conf->reservation_key,
+				     conf->prkey_source);
+}
+
+static int
+mp_reservation_key_handler(struct config *conf, vector strvec)
 {
-	struct be64 *be64_ptr = (struct be64 *)ptr;
-	return snprintf(buff, len, "0x%" PRIx64, get_be64(*be64_ptr));
+	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);
+	if (!mpe)
+		return 1;
+	return set_reservation_key(strvec, &mpe->reservation_key,
+				   &mpe->prkey_source);
 }
 
-declare_def_handler(reservation_key, set_reservation_key)
-declare_def_snprint(reservation_key, print_reservation_key)
-declare_mp_handler(reservation_key, set_reservation_key)
-declare_mp_snprint(reservation_key, print_reservation_key)
+static int
+snprint_mp_reservation_key (struct config *conf, char * buff, int len,
+			     void * data)
+{
+	struct mpentry * mpe = (struct mpentry *)data;
+	return print_reservation_key(buff, len, mpe->reservation_key,
+				     mpe->prkey_source);
+}
 
 static int
 set_off_int_undef(vector strvec, void *ptr)
@@ -1389,6 +1430,7 @@ init_keywords(vector keywords)
 	install_keyword("dev_loss_tmo", &def_dev_loss_handler, &snprint_def_dev_loss);
 	install_keyword("bindings_file", &def_bindings_file_handler, &snprint_def_bindings_file);
 	install_keyword("wwids_file", &def_wwids_file_handler, &snprint_def_wwids_file);
+	install_keyword("prkeys_file", &def_prkeys_file_handler, &snprint_def_prkeys_file);
 	install_keyword("log_checker_err", &def_log_checker_err_handler, &snprint_def_log_checker_err);
 	install_keyword("reservation_key", &def_reservation_key_handler, &snprint_def_reservation_key);
 	install_keyword("retain_attached_hw_handler", &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler);
diff --git a/libmultipath/dict.h b/libmultipath/dict.h
index 2d6097d..0442227 100644
--- a/libmultipath/dict.h
+++ b/libmultipath/dict.h
@@ -5,6 +5,8 @@
 #include "vector.h"
 #endif
 
+#include "byteorder.h"
+
 void init_keywords(vector keywords);
 int get_sys_max_fds(int *);
 int print_rr_weight (char * buff, int len, void *ptr);
@@ -13,6 +15,6 @@ int print_pgpolicy(char * buff, int len, void *ptr);
 int print_no_path_retry(char * buff, int len, void *ptr);
 int print_fast_io_fail(char * buff, int len, void *ptr);
 int print_dev_loss(char * buff, int len, void *ptr);
-int print_reservation_key(char * buff, int len, void * ptr);
+int print_reservation_key(char * buff, int len, struct be64 key, int source);
 int print_off_int_undef(char * buff, int len, void *ptr);
 #endif /* _DICT_H */
diff --git a/libmultipath/prkey.c b/libmultipath/prkey.c
new file mode 100644
index 0000000..89b90ed
--- /dev/null
+++ b/libmultipath/prkey.c
@@ -0,0 +1,166 @@
+#include "structs.h"
+#include "file.h"
+#include "debug.h"
+#include "config.h"
+#include "util.h"
+#include "propsel.h"
+#include "prkey.h"
+#include <sys/types.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <string.h>
+#include <inttypes.h>
+#include <errno.h>
+
+#define PRKEY_READ 0
+#define PRKEY_WRITE 1
+
+static int do_prkey(int fd, char *wwid, char *keystr, int cmd)
+{
+	char buf[4097];
+	char *ptr;
+	off_t start = 0;
+	int bytes;
+
+	while (1) {
+		if (lseek(fd, start, SEEK_SET) < 0) {
+			condlog(0, "prkey file read lseek failed : %s",
+				strerror(errno));
+			return 1;
+		}
+		bytes = read(fd, buf, 4096);
+		if (bytes < 0) {
+			if (errno == EINTR || errno == EAGAIN)
+				continue;
+			condlog(0, "failed to read from prkey file : %s",
+				strerror(errno));
+			return 1;
+		}
+		if (!bytes) {
+			ptr = NULL;
+			break;
+		}
+		buf[bytes] = '\0';
+		ptr = strstr(buf, wwid);
+		while (ptr) {
+			if (ptr == buf || *(ptr - 1) != ' ' ||
+			    *(ptr + strlen(wwid)) != '\n')
+				ptr = strstr(ptr + strlen(wwid), wwid);
+			else
+				break;
+		}
+		if (ptr) {
+			condlog(3, "found prkey for '%s'", wwid);
+			ptr[strlen(wwid)] = '\0';
+			if (ptr - PRKEY_SIZE < buf ||
+			    (ptr - PRKEY_SIZE != buf &&
+			     *(ptr - PRKEY_SIZE - 1) != '\n')) {
+				condlog(0, "malformed prkey file line for wwid: '%s'", ptr);
+				return 1;
+			}
+			ptr = ptr - PRKEY_SIZE;
+			break;
+		}
+		ptr = strrchr(buf, '\n');
+		if (ptr == NULL) {
+			condlog(4, "couldn't file newline, assuming end of file");
+			break;
+		}
+		start = start + (ptr - buf) + 1;
+	}
+	if (cmd == PRKEY_READ) {
+		if (!ptr || *ptr == '#')
+			return 1;
+		memcpy(keystr, ptr, PRKEY_SIZE - 1);
+		keystr[PRKEY_SIZE - 1] = '\0';
+		return 0;
+	}
+	if (!ptr && !keystr)
+		return 0;
+	if (ptr) {
+		if (lseek(fd, start + (ptr - buf), SEEK_SET) < 0) {
+			condlog(0, "prkey write lseek failed : %s",
+				strerror(errno));
+			return 1;
+		}
+	}
+	if (!keystr) {
+		if (safe_write(fd, "#", 1) < 0) {
+			condlog(0, "failed to write to prkey file : %s",
+				strerror(errno));
+			return 1;
+		}
+		return 0;
+	}
+	if (!ptr) {
+		if (lseek(fd, 0, SEEK_END) < 0) {
+			condlog(0, "prkey write lseek failed : %s",
+				strerror(errno));
+			return 1;
+		}
+	}
+	bytes = sprintf(buf, "%s %s\n", keystr, wwid);
+	if (safe_write(fd, buf, bytes) < 0) {
+		condlog(0, "failed to write to prkey file: %s",
+			strerror(errno));
+		return 1;
+	}
+	return 0;
+}
+
+int get_prkey(struct config *conf, struct multipath *mpp, uint64_t *prkey)
+{
+	int fd;
+	int unused;
+	int ret = 1;
+	char keystr[PRKEY_SIZE];
+
+	if (!strlen(mpp->wwid))
+		goto out;
+
+	fd = open_file(conf->prkeys_file, &unused, PRKEYS_FILE_HEADER);
+	if (fd < 0)
+		goto out;
+	ret = do_prkey(fd, mpp->wwid, keystr, PRKEY_READ);
+	if (ret)
+		goto out_file;
+	ret = !!parse_prkey(keystr, prkey);
+out_file:
+	close(fd);
+out:
+	return ret;
+}
+
+int set_prkey(struct config *conf, struct multipath *mpp, uint64_t prkey)
+{
+	int fd;
+	int can_write = 1;
+	int ret = 1;
+	char keystr[PRKEY_SIZE];
+
+	if (!strlen(mpp->wwid))
+		goto out;
+
+	fd = open_file(conf->prkeys_file, &can_write, PRKEYS_FILE_HEADER);
+	if (fd < 0)
+		goto out;
+	if (!can_write) {
+		condlog(0, "cannot set prkey, prkeys file is read-only");
+		goto out_file;
+	}
+	if (prkey) {
+		snprintf(keystr, PRKEY_SIZE, "0x%016" PRIx64, prkey);
+		keystr[PRKEY_SIZE - 1] = '\0';
+		ret = do_prkey(fd, mpp->wwid, keystr, PRKEY_WRITE);
+	}
+	else
+		ret = do_prkey(fd, mpp->wwid, NULL, PRKEY_WRITE);
+	if (ret == 0)
+		select_reservation_key(conf, mpp);
+	if (get_be64(mpp->reservation_key) != prkey)
+		ret = 1;
+out_file:
+	close(fd);
+out:
+	return ret;
+}
diff --git a/libmultipath/prkey.h b/libmultipath/prkey.h
new file mode 100644
index 0000000..4028e70
--- /dev/null
+++ b/libmultipath/prkey.h
@@ -0,0 +1,19 @@
+#ifndef _PRKEY_H
+#define _PRKEY_H
+
+#include "structs.h"
+#include <inttypes.h>
+
+#define PRKEYS_FILE_HEADER \
+"# Multipath persistent reservation keys, Version : 1.0\n" \
+"# NOTE: this file is automatically maintained by the multipathd program.\n" \
+"# You should not need to edit this file in normal circumstances.\n" \
+"#\n" \
+"# Format:\n" \
+"# prkey wwid\n" \
+"#\n"
+
+int set_prkey(struct config *conf, struct multipath *mpp, uint64_t prkey);
+int get_prkey(struct config *conf, struct multipath *mpp, uint64_t *prkey);
+
+#endif /* _PRKEY_H */
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 429e039..5eee5ba 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -20,6 +20,7 @@
 #include "dict.h"
 #include "util.h"
 #include "prioritizers/alua_rtpg.h"
+#include "prkey.h"
 #include <inttypes.h>
 
 pgpolicyfn *pgpolicies[] = {
@@ -82,6 +83,16 @@ do_attr_set(var, mp->mpe, shift, "(setting: multipath.conf multipaths section)")
 #define set_attr_conf(var, shift)					\
 do_attr_set(var, conf, shift, "(setting: multipath.conf defaults/devices section)")
 
+#define do_prkey_set(src, msg)						\
+do {									\
+	if (src && src->prkey_source != PRKEY_SOURCE_NONE) {		\
+		mp->prkey_source = src->prkey_source;			\
+		mp->reservation_key = src->reservation_key;		\
+		origin = msg;						\
+		goto out;						\
+	}								\
+} while (0)
+
 int select_mode(struct config *conf, struct multipath *mp)
 {
 	char *origin;
@@ -610,14 +621,26 @@ out:
 int select_reservation_key(struct config *conf, struct multipath *mp)
 {
 	char *origin, buff[PRKEY_SIZE];
+	char *from_file = "";
+	uint64_t prkey = 0;
 
-	mp_set_mpe(reservation_key._v);
-	mp_set_conf(reservation_key._v);
+	do_prkey_set(mp->mpe, "(setting: multipath.conf multipaths section)");
+	do_prkey_set(conf, "(setting: multipath.conf defaults/devices section)");
 	put_be64(mp->reservation_key, 0);
+	mp->prkey_source = PRKEY_SOURCE_NONE;
 	return 0;
 out:
-	print_reservation_key(buff, PRKEY_SIZE, &mp->reservation_key);
-	condlog(3, "%s: reservation_key = %s %s", mp->alias, buff, origin);
+	if (mp->prkey_source == PRKEY_SOURCE_FILE) {
+		from_file = " (from prkeys file)";
+		if (get_prkey(conf, mp, &prkey) != 0)
+			put_be64(mp->reservation_key, 0);
+		else
+			put_be64(mp->reservation_key, prkey);
+	}
+	print_reservation_key(buff, PRKEY_SIZE, mp->reservation_key,
+			      mp->prkey_source);
+	condlog(3, "%s: reservation_key = %s %s%s", mp->alias, buff, origin,
+		from_file);
 	return 0;
 }
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index b4c0bd6..f06824a 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -174,6 +174,12 @@ enum initialized_states {
 	INIT_OK,
 };
 
+enum prkey_sources {
+	PRKEY_SOURCE_NONE,
+	PRKEY_SOURCE_CONF,
+	PRKEY_SOURCE_FILE,
+};
+
 struct sg_id {
 	int host_no;
 	int channel;
@@ -309,7 +315,8 @@ struct multipath {
 	void * mpcontext;
 
 	/* persistent management data*/
-	struct be64  reservation_key;
+	int prkey_source;
+	struct be64 reservation_key;
 	unsigned char prflag;
 };
 
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 32d4976..deb72cb 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -208,6 +208,11 @@ load_keys (void)
 	r += add_key(keys, "unsetprstatus", UNSETPRSTATUS, 0);
 	r += add_key(keys, "format", FMT, 1);
 	r += add_key(keys, "json", JSON, 0);
+	r += add_key(keys, "getprkey", GETPRKEY, 0);
+	r += add_key(keys, "setprkey", SETPRKEY, 0);
+	r += add_key(keys, "unsetprkey", UNSETPRKEY, 0);
+	r += add_key(keys, "key", KEY, 1);
+
 
 	if (r) {
 		free_keys(keys);
@@ -571,6 +576,9 @@ cli_init (void) {
 	add_handler(GETPRSTATUS+MAP, NULL);
 	add_handler(SETPRSTATUS+MAP, NULL);
 	add_handler(UNSETPRSTATUS+MAP, NULL);
+	add_handler(GETPRKEY+MAP, NULL);
+	add_handler(SETPRKEY+MAP+KEY, NULL);
+	add_handler(UNSETPRKEY+MAP, NULL);
 	add_handler(FORCEQ+DAEMON, NULL);
 	add_handler(RESTOREQ+DAEMON, NULL);
 
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 92cb41b..d289167 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -37,6 +37,10 @@ enum {
 	__UNSETPRSTATUS,
 	__FMT,
 	__JSON,
+	__GETPRKEY,
+	__SETPRKEY,
+	__UNSETPRKEY,
+	__KEY,
 };
 
 #define LIST		(1 << __LIST)
@@ -76,6 +80,10 @@ enum {
 #define UNSETPRSTATUS	(1ULL << __UNSETPRSTATUS)
 #define FMT		(1ULL << __FMT)
 #define JSON		(1ULL << __JSON)
+#define GETPRKEY	(1ULL << __GETPRKEY)
+#define SETPRKEY	(1ULL << __SETPRKEY)
+#define UNSETPRKEY	(1ULL << __UNSETPRKEY)
+#define KEY		(1ULL << __KEY)
 
 #define INITIAL_REPLY_LEN	1200
 
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index b4a95e3..05d139b 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -21,6 +21,7 @@
 #include <errno.h>
 #include <libudev.h>
 #include "util.h"
+#include "prkey.h"
 
 #include "main.h"
 #include "cli.h"
@@ -1390,3 +1391,84 @@ cli_unsetprstatus(void * v, char ** reply, int * len, void * data)
 
 	return 0;
 }
+
+int
+cli_getprkey(void * v, char ** reply, int * len, void * data)
+{
+	struct multipath * mpp;
+	struct vectors * vecs = (struct vectors *)data;
+	char *mapname = get_keyparam(v, MAP);
+
+	mapname = convert_dev(mapname, 0);
+	condlog(3, "%s: get persistent reservation key (operator)", mapname);
+	mpp = find_mp_by_str(vecs->mpvec, mapname);
+
+	if (!mpp)
+		return 1;
+
+	*reply = malloc(20);
+
+	if (!get_be64(mpp->reservation_key)) {
+		sprintf(*reply, "none\n");
+		*len = strlen(*reply) + 1;
+		return 0;
+	}
+	snprintf(*reply, 20, "0x%" PRIx64 "\n",
+		 get_be64(mpp->reservation_key));
+	(*reply)[19] = '\0';
+	*len = strlen(*reply) + 1;
+	return 0;
+}
+
+int
+cli_unsetprkey(void * v, char ** reply, int * len, void * data)
+{
+	struct multipath * mpp;
+	struct vectors * vecs = (struct vectors *)data;
+	char *mapname = get_keyparam(v, MAP);
+	int ret;
+	struct config *conf;
+
+	mapname = convert_dev(mapname, 0);
+	condlog(3, "%s: unset persistent reservation key (operator)", mapname);
+	mpp = find_mp_by_str(vecs->mpvec, mapname);
+
+	if (!mpp)
+		return 1;
+
+	conf = get_multipath_config();
+	ret = set_prkey(conf, mpp, 0);
+	put_multipath_config(conf);
+
+	return ret;
+}
+
+int
+cli_setprkey(void * v, char ** reply, int * len, void * data)
+{
+	struct multipath * mpp;
+	struct vectors * vecs = (struct vectors *)data;
+	char *mapname = get_keyparam(v, MAP);
+	char *keyparam = get_keyparam(v, KEY);
+	uint64_t prkey;
+	int ret;
+	struct config *conf;
+
+	mapname = convert_dev(mapname, 0);
+	condlog(3, "%s: set persistent reservation key (operator)", mapname);
+	mpp = find_mp_by_str(vecs->mpvec, mapname);
+
+	if (!mpp)
+		return 1;
+
+	if (parse_prkey(keyparam, &prkey) != 0) {
+		condlog(0, "%s: invalid prkey : '%s'", mapname, keyparam);
+		return 1;
+	}
+
+	conf = get_multipath_config();
+	ret = set_prkey(conf, mpp, prkey);
+	put_multipath_config(conf);
+
+	return ret;
+}
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index f4d02cc..78a3a43 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -45,3 +45,6 @@ int cli_reassign (void * v, char ** reply, int * len, void * data);
 int cli_getprstatus(void * v, char ** reply, int * len, void * data);
 int cli_setprstatus(void * v, char ** reply, int * len, void * data);
 int cli_unsetprstatus(void * v, char ** reply, int * len, void * data);
+int cli_getprkey(void * v, char ** reply, int * len, void * data);
+int cli_setprkey(void * v, char ** reply, int * len, void * data);
+int cli_unsetprkey(void * v, char ** reply, int * len, void * data);
diff --git a/multipathd/main.c b/multipathd/main.c
index 16c5e0c..33db6a4 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1249,6 +1249,9 @@ uxlsnrloop (void * ap)
 	set_handler_callback(UNSETPRSTATUS+MAP, cli_unsetprstatus);
 	set_handler_callback(FORCEQ+DAEMON, cli_force_no_daemon_q);
 	set_handler_callback(RESTOREQ+DAEMON, cli_restore_no_daemon_q);
+	set_handler_callback(GETPRKEY+MAP, cli_getprkey);
+	set_handler_callback(SETPRKEY+MAP+KEY, cli_setprkey);
+	set_handler_callback(UNSETPRKEY+MAP, cli_unsetprkey);
 
 	umask(077);
 	uxsock_listen(&uxsock_trigger, ap);
-- 
2.7.4
