From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v4 12/12] tree-wide: convert open calls to remove
	spaces to skip_spaces() lib function
Date: Sat,  7 Nov 2009 13:16:20 -0200
Message-ID: <7d5883637aa976b54e944998f635d47a41618a75.1257602781.git.andre.goddard@gmail.com>
References: <cover.1257602781.git.andre.goddard@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1257602781.git.andre.goddard@gmail.com>
In-Reply-To: <cover.1257602781.git.andre.goddard@gmail.com>
References: <cover.1257602781.git.andre.goddard@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com, Michael Holzheu <holzheu@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-f>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
List-Id: dm-devel.ids

Makes use of skip_spaces() defined in lib/string.c for removing leading
spaces from strings all over the tree.

Also, while at it, if we see (*str && isspace(*str)), we can be sure to
remove the first condition (*str) as the second one (isspace(*str)) also
evaluates to 0 whenever *str =3D=3D 0, making it redundant. In other word=
s,
"a char equals zero is never a space".

Signed-off-by: Andr=C3=A9 Goddard Rosa <andre.goddard@gmail.com>
---
 arch/s390/kernel/debug.c              |    3 +-
 arch/um/drivers/mconsole_kern.c       |   16 ++++++--------
 arch/x86/kernel/cpu/mtrr/if.c         |   11 +++------
 drivers/md/dm-table.c                 |    6 +---
 drivers/md/md.c                       |    4 +-
 drivers/parisc/pdc_stable.c           |    9 ++-----
 drivers/platform/x86/thinkpad_acpi.c  |    7 +----
 drivers/pnp/interface.c               |   36 +++++++++------------------=
-----
 drivers/s390/block/dasd_proc.c        |    5 ++-
 drivers/video/backlight/lcd.c         |    4 +-
 drivers/video/display/display-sysfs.c |    2 +-
 fs/cachefiles/daemon.c                |    8 ++----
 fs/ext4/super.c                       |    7 +----
 kernel/params.c                       |    8 ++----
 lib/argv_split.c                      |   13 ++---------
 lib/dynamic_debug.c                   |    4 +-
 lib/vsprintf.c                        |   15 +++----------
 net/irda/irnet/irnet.h                |    1 +
 net/irda/irnet/irnet_ppp.c            |    8 ++----
 net/netfilter/xt_recent.c             |    3 +-
 sound/pci/hda/hda_hwdep.c             |    7 ++---
 21 files changed, 63 insertions(+), 114 deletions(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index 20f282c..7a0f4a9 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -18,6 +18,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/sysctl.h>
 #include <asm/uaccess.h>
 #include <linux/module.h>
@@ -1183,7 +1184,7 @@ debug_get_uint(char *buf)
 {
 	int rc;
=20
-	for(; isspace(*buf); buf++);
+	buf =3D skip_spaces(buf);
 	rc =3D simple_strtoul(buf, &buf, 10);
 	if(*buf){
 		rc =3D -EINVAL;
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_k=
ern.c
index e14629c..f5d459a 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -6,6 +6,7 @@
=20
 #include <linux/console.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/mm.h>
@@ -131,7 +132,7 @@ void mconsole_proc(struct mc_request *req)
 	char *ptr =3D req->request.data, *buf;
=20
 	ptr +=3D strlen("proc");
-	while (isspace(*ptr)) ptr++;
+	ptr =3D skip_spaces(ptr);
=20
 	proc =3D get_fs_type("proc");
 	if (proc =3D=3D NULL) {
@@ -212,8 +213,7 @@ void mconsole_proc(struct mc_request *req)
 	char *ptr =3D req->request.data;
=20
 	ptr +=3D strlen("proc");
-	while (isspace(*ptr))
-		ptr++;
+	ptr =3D skip_spaces(ptr);
 	snprintf(path, sizeof(path), "/proc/%s", ptr);
=20
 	fd =3D sys_open(path, 0, 0);
@@ -560,8 +560,7 @@ void mconsole_config(struct mc_request *req)
 	int err;
=20
 	ptr +=3D strlen("config");
-	while (isspace(*ptr))
-		ptr++;
+	ptr =3D skip_spaces(ptr);
 	dev =3D mconsole_find_dev(ptr);
 	if (dev =3D=3D NULL) {
 		mconsole_reply(req, "Bad configuration option", 1, 0);
@@ -588,7 +587,7 @@ void mconsole_remove(struct mc_request *req)
 	int err, start, end, n;
=20
 	ptr +=3D strlen("remove");
-	while (isspace(*ptr)) ptr++;
+	ptr =3D skip_spaces(ptr);
 	dev =3D mconsole_find_dev(ptr);
 	if (dev =3D=3D NULL) {
 		mconsole_reply(req, "Bad remove option", 1, 0);
@@ -712,7 +711,7 @@ void mconsole_sysrq(struct mc_request *req)
 	char *ptr =3D req->request.data;
=20
 	ptr +=3D strlen("sysrq");
-	while (isspace(*ptr)) ptr++;
+	ptr =3D skip_spaces(ptr);
=20
 	/*
 	 * With 'b', the system will shut down without a chance to reply,
@@ -757,8 +756,7 @@ void mconsole_stack(struct mc_request *req)
 	 */
=20
 	ptr +=3D strlen("stack");
-	while (isspace(*ptr))
-		ptr++;
+	ptr =3D skip_spaces(ptr);
=20
 	/*
 	 * Should really check for multiple pids or reject bad args here
diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.=
c
index 3c1b12d..e006e56 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -4,6 +4,7 @@
 #include <linux/proc_fs.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/init.h>
=20
 #define LINE_SIZE 80
@@ -133,8 +134,7 @@ mtrr_write(struct file *file, const char __user *buf,=
 size_t len, loff_t * ppos)
 		return -EINVAL;
=20
 	base =3D simple_strtoull(line + 5, &ptr, 0);
-	while (isspace(*ptr))
-		ptr++;
+	ptr =3D skip_spaces(ptr);
=20
 	if (strncmp(ptr, "size=3D", 5))
 		return -EINVAL;
@@ -142,14 +142,11 @@ mtrr_write(struct file *file, const char __user *bu=
f, size_t len, loff_t * ppos)
 	size =3D simple_strtoull(ptr + 5, &ptr, 0);
 	if ((base & 0xfff) || (size & 0xfff))
 		return -EINVAL;
-	while (isspace(*ptr))
-		ptr++;
+	ptr =3D skip_spaces(ptr);
=20
 	if (strncmp(ptr, "type=3D", 5))
 		return -EINVAL;
-	ptr +=3D 5;
-	while (isspace(*ptr))
-		ptr++;
+	ptr =3D skip_spaces(ptr + 5);
=20
 	for (i =3D 0; i < MTRR_NUM_TYPES; ++i) {
 		if (strcmp(ptr, mtrr_strings[i]))
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 1a6cb3c..91976e8 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -12,6 +12,7 @@
 #include <linux/blkdev.h>
 #include <linux/namei.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
@@ -600,11 +601,8 @@ int dm_split_args(int *argc, char ***argvp, char *in=
put)
 		return -ENOMEM;
=20
 	while (1) {
-		start =3D end;
-
 		/* Skip whitespace */
-		while (*start && isspace(*start))
-			start++;
+		start =3D skip_spaces(end);
=20
 		if (!*start)
 			break;	/* success, we hit the end */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 26ba42a..1dcb83c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -39,6 +39,7 @@
 #include <linux/buffer_head.h> /* for invalidate_bdev */
 #include <linux/poll.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/hdreg.h>
 #include <linux/proc_fs.h>
 #include <linux/random.h>
@@ -3225,8 +3226,7 @@ bitmap_store(mddev_t *mddev, const char *buf, size_=
t len)
 		}
 		if (*end && !isspace(*end)) break;
 		bitmap_dirty_bits(mddev->bitmap, chunk, end_chunk);
-		buf =3D end;
-		while (isspace(*buf)) buf++;
+		buf =3D skip_spaces(end);
 	}
 	bitmap_unplug(mddev->bitmap); /* flush the bits to disk */
 out:
diff --git a/drivers/parisc/pdc_stable.c b/drivers/parisc/pdc_stable.c
index 13a64bc..0bc5d47 100644
--- a/drivers/parisc/pdc_stable.c
+++ b/drivers/parisc/pdc_stable.c
@@ -779,12 +779,9 @@ static ssize_t pdcs_auto_write(struct kobject *kobj,
 	read_unlock(&pathentry->rw_lock);
 =09
 	DPRINTK("%s: flags before: 0x%X\n", __func__, flags);
-		=09
-	temp =3D in;
-=09
-	while (*temp && isspace(*temp))
-		temp++;
-=09
+
+	temp =3D skip_spaces(in);
+
 	c =3D *temp++ - '0';
 	if ((c !=3D 0) && (c !=3D 1))
 		goto parse_error;
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/=
thinkpad_acpi.c
index 7e7da18..29dd2dd 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -1006,11 +1006,8 @@ static int parse_strtoul(const char *buf,
 {
 	char *endp;
=20
-	while (*buf && isspace(*buf))
-		buf++;
-	*value =3D simple_strtoul(buf, &endp, 0);
-	while (*endp && isspace(*endp))
-		endp++;
+	*value =3D simple_strtoul(skip_spaces(buf), &endp, 0);
+	endp =3D skip_spaces(endp);
 	if (*endp || *value > max)
 		return -EINVAL;
=20
diff --git a/drivers/pnp/interface.c b/drivers/pnp/interface.c
index c3f1c8e..68b0c04 100644
--- a/drivers/pnp/interface.c
+++ b/drivers/pnp/interface.c
@@ -310,8 +310,7 @@ static ssize_t pnp_set_current_resources(struct devic=
e *dmdev,
 		goto done;
 	}
=20
-	while (isspace(*buf))
-		++buf;
+	buf =3D skip_spaces(buf);
 	if (!strnicmp(buf, "disable", 7)) {
 		retval =3D pnp_disable_dev(dev);
 		goto done;
@@ -353,19 +352,13 @@ static ssize_t pnp_set_current_resources(struct dev=
ice *dmdev,
 		pnp_init_resources(dev);
 		mutex_lock(&pnp_res_mutex);
 		while (1) {
-			while (isspace(*buf))
-				++buf;
+			buf =3D skip_spaces(buf);
 			if (!strnicmp(buf, "io", 2)) {
-				buf +=3D 2;
-				while (isspace(*buf))
-					++buf;
+				buf =3D skip_spaces(buf + 2);
 				start =3D simple_strtoul(buf, &buf, 0);
-				while (isspace(*buf))
-					++buf;
+				buf =3D skip_spaces(buf);
 				if (*buf =3D=3D '-') {
-					buf +=3D 1;
-					while (isspace(*buf))
-						++buf;
+					buf =3D skip_spaces(buf + 1);
 					end =3D simple_strtoul(buf, &buf, 0);
 				} else
 					end =3D start;
@@ -373,16 +366,11 @@ static ssize_t pnp_set_current_resources(struct dev=
ice *dmdev,
 				continue;
 			}
 			if (!strnicmp(buf, "mem", 3)) {
-				buf +=3D 3;
-				while (isspace(*buf))
-					++buf;
+				buf =3D skip_spaces(buf + 3);
 				start =3D simple_strtoul(buf, &buf, 0);
-				while (isspace(*buf))
-					++buf;
+				buf =3D skip_spaces(buf);
 				if (*buf =3D=3D '-') {
-					buf +=3D 1;
-					while (isspace(*buf))
-						++buf;
+					buf =3D skip_spaces(buf + 1);
 					end =3D simple_strtoul(buf, &buf, 0);
 				} else
 					end =3D start;
@@ -390,17 +378,13 @@ static ssize_t pnp_set_current_resources(struct dev=
ice *dmdev,
 				continue;
 			}
 			if (!strnicmp(buf, "irq", 3)) {
-				buf +=3D 3;
-				while (isspace(*buf))
-					++buf;
+				buf =3D skip_spaces(buf + 3);
 				start =3D simple_strtoul(buf, &buf, 0);
 				pnp_add_irq_resource(dev, start, 0);
 				continue;
 			}
 			if (!strnicmp(buf, "dma", 3)) {
-				buf +=3D 3;
-				while (isspace(*buf))
-					++buf;
+				buf =3D skip_spaces(buf + 3);
 				start =3D simple_strtoul(buf, &buf, 0);
 				pnp_add_dma_resource(dev, start, 0);
 				continue;
diff --git a/drivers/s390/block/dasd_proc.c b/drivers/s390/block/dasd_pro=
c.c
index 654daa3..c2d8792 100644
--- a/drivers/s390/block/dasd_proc.c
+++ b/drivers/s390/block/dasd_proc.c
@@ -14,6 +14,7 @@
 #define KMSG_COMPONENT "dasd"
=20
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/seq_file.h>
 #include <linux/vmalloc.h>
 #include <linux/proc_fs.h>
@@ -272,10 +273,10 @@ dasd_statistics_write(struct file *file, const char=
 __user *user_buf,
 	DBF_EVENT(DBF_DEBUG, "/proc/dasd/statictics: '%s'\n", buffer);
=20
 	/* check for valid verbs */
-	for (str =3D buffer; isspace(*str); str++);
+	str =3D skip_spaces(buffer);
 	if (strncmp(str, "set", 3) =3D=3D 0 && isspace(str[3])) {
 		/* 'set xxx' was given */
-		for (str =3D str + 4; isspace(*str); str++);
+		str =3D skip_spaces(str + 4);
 		if (strcmp(str, "on") =3D=3D 0) {
 			/* switch on statistics profiling */
 			dasd_profile_level =3D DASD_PROFILE_ON;
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.=
c
index b644947..3b20cbf 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -101,7 +101,7 @@ static ssize_t lcd_store_power(struct device *dev,
 	int power =3D simple_strtoul(buf, &endp, 0);
 	size_t size =3D endp - buf;
=20
-	if (*endp && isspace(*endp))
+	if (isspace(*endp))
 		size++;
 	if (size !=3D count)
 		return -EINVAL;
@@ -140,7 +140,7 @@ static ssize_t lcd_store_contrast(struct device *dev,
 	int contrast =3D simple_strtoul(buf, &endp, 0);
 	size_t size =3D endp - buf;
=20
-	if (*endp && isspace(*endp))
+	if (isspace(*endp))
 		size++;
 	if (size !=3D count)
 		return -EINVAL;
diff --git a/drivers/video/display/display-sysfs.c b/drivers/video/displa=
y/display-sysfs.c
index 4830b1b..80abbf3 100644
--- a/drivers/video/display/display-sysfs.c
+++ b/drivers/video/display/display-sysfs.c
@@ -67,7 +67,7 @@ static ssize_t display_store_contrast(struct device *de=
v,
 	contrast =3D simple_strtoul(buf, &endp, 0);
 	size =3D endp - buf;
=20
-	if (*endp && isspace(*endp))
+	if (isspace(*endp))
 		size++;
=20
 	if (size !=3D count)
diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index 4618516..af6d9a6 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -21,6 +21,7 @@
 #include <linux/mount.h>
 #include <linux/statfs.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/fs_struct.h>
 #include "internal.h"
=20
@@ -250,15 +251,12 @@ static ssize_t cachefiles_daemon_write(struct file =
*file,
 	/* parse the command */
 	ret =3D -EOPNOTSUPP;
=20
-	for (args =3D data; *args; args++)
-		if (isspace(*args))
-			break;
+	args =3D skip_spaces(data);
 	if (*args) {
 		if (args =3D=3D data)
 			goto error;
 		*args =3D '\0';
-		for (args++; isspace(*args); args++)
-			continue;
+		args =3D skip_spaces(++args);
 	}
=20
 	/* run the appropriate command handler */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 312211e..580766a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2097,11 +2097,8 @@ static int parse_strtoul(const char *buf,
 {
 	char *endp;
=20
-	while (*buf && isspace(*buf))
-		buf++;
-	*value =3D simple_strtoul(buf, &endp, 0);
-	while (*endp && isspace(*endp))
-		endp++;
+	*value =3D simple_strtoul(skip_spaces(buf), &endp, 0);
+	endp =3D skip_spaces(endp);
 	if (*endp || *value > max)
 		return -EINVAL;
=20
diff --git a/kernel/params.c b/kernel/params.c
index d656c27..cf1b691 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
=20
 #if 0
 #define DEBUGP printk
@@ -122,9 +123,7 @@ static char *next_arg(char *args, char **param, char =
**val)
 		next =3D args + i;
=20
 	/* Chew up trailing spaces. */
-	while (isspace(*next))
-		next++;
-	return next;
+	return skip_spaces(next);
 }
=20
 /* Args looks like "foo=3Dbar,bar2 baz=3Dfuz wiz". */
@@ -139,8 +138,7 @@ int parse_args(const char *name,
 	DEBUGP("Parsing ARGS: %s\n", args);
=20
 	/* Chew leading spaces */
-	while (isspace(*args))
-		args++;
+	args =3D skip_spaces(args);
=20
 	while (*args) {
 		int ret;
diff --git a/lib/argv_split.c b/lib/argv_split.c
index 5205a8d..4b1b083 100644
--- a/lib/argv_split.c
+++ b/lib/argv_split.c
@@ -4,17 +4,10 @@
=20
 #include <linux/kernel.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/module.h>
=20
-static const char *skip_sep(const char *cp)
-{
-	while (*cp && isspace(*cp))
-		cp++;
-
-	return cp;
-}
-
 static const char *skip_arg(const char *cp)
 {
 	while (*cp && !isspace(*cp))
@@ -28,7 +21,7 @@ static int count_argc(const char *str)
 	int count =3D 0;
=20
 	while (*str) {
-		str =3D skip_sep(str);
+		str =3D skip_spaces(str);
 		if (*str) {
 			count++;
 			str =3D skip_arg(str);
@@ -82,7 +75,7 @@ char **argv_split(gfp_t gfp, const char *str, int *argc=
p)
 	argvp =3D argv;
=20
 	while (*str) {
-		str =3D skip_sep(str);
+		str =3D skip_spaces(str);
=20
 		if (*str) {
 			const char *p =3D str;
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index e22c148..f935029 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -21,6 +21,7 @@
 #include <linux/list.h>
 #include <linux/sysctl.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/uaccess.h>
 #include <linux/dynamic_debug.h>
 #include <linux/debugfs.h>
@@ -209,8 +210,7 @@ static int ddebug_tokenize(char *buf, char *words[], =
int maxwords)
 		char *end;
=20
 		/* Skip leading whitespace */
-		while (*buf && isspace(*buf))
-			buf++;
+		buf =3D skip_spaces(buf);
 		if (!*buf)
 			break;	/* oh, it was trailing whitespace */
=20
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7ec96a3..06e0311 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1716,13 +1716,6 @@ EXPORT_SYMBOL_GPL(bprintf);
=20
 #endif /* CONFIG_BINARY_PRINTF */
=20
-static noinline const char *skip_space(const char *str)
-{
-	while (isspace(*str))
-		++str;
-	return str;
-}
-
 /**
  * vsscanf - Unformat a buffer into a list of arguments
  * @buf:	input buffer
@@ -1744,8 +1737,8 @@ int vsscanf(const char *buf, const char *fmt, va_li=
st args)
 		 * white space, including none, in the input.
 		 */
 		if (isspace(*fmt)) {
-			fmt =3D skip_space(fmt);
-			str =3D skip_space(str);
+			fmt =3D skip_spaces(++fmt);
+			str =3D skip_spaces(str);
 		}
=20
 		/* anything that is not a conversion must match exactly */
@@ -1815,7 +1808,7 @@ int vsscanf(const char *buf, const char *fmt, va_li=
st args)
 			if (field_width =3D=3D -1)
 				field_width =3D INT_MAX;
 			/* first, skip leading white space in buffer */
-			str =3D skip_space(str);
+			str =3D skip_spaces(str);
=20
 			/* now copy until next white space */
 			while (*str && !isspace(*str) && field_width--)
@@ -1857,7 +1850,7 @@ int vsscanf(const char *buf, const char *fmt, va_li=
st args)
 		/* have some sort of integer conversion.
 		 * first, skip white space in buffer.
 		 */
-		str =3D skip_space(str);
+		str =3D skip_spaces(str);
=20
 		digit =3D *str;
 		if (is_sign && digit =3D=3D '-')
diff --git a/net/irda/irnet/irnet.h b/net/irda/irnet/irnet.h
index b001c36..4300df3 100644
--- a/net/irda/irnet/irnet.h
+++ b/net/irda/irnet/irnet.h
@@ -249,6 +249,7 @@
 #include <linux/poll.h>
 #include <linux/capability.h>
 #include <linux/ctype.h>	/* isspace() */
+#include <linux/string.h>	/* skip_spaces() */
 #include <asm/uaccess.h>
 #include <linux/init.h>
=20
diff --git a/net/irda/irnet/irnet_ppp.c b/net/irda/irnet/irnet_ppp.c
index 7dea882..156020d 100644
--- a/net/irda/irnet/irnet_ppp.c
+++ b/net/irda/irnet/irnet_ppp.c
@@ -76,9 +76,8 @@ irnet_ctrl_write(irnet_socket *	ap,
       /* Look at the next command */
       start =3D next;
=20
-      /* Scrap whitespaces before the command */
-      while(isspace(*start))
-	start++;
+	/* Scrap whitespaces before the command */
+	start =3D skip_spaces(start);
=20
       /* ',' is our command separator */
       next =3D strchr(start, ',');
@@ -133,8 +132,7 @@ irnet_ctrl_write(irnet_socket *	ap,
 	      char *	endp;
=20
 	      /* Scrap whitespaces before the command */
-	      while(isspace(*begp))
-		begp++;
+	      begp =3D skip_spaces(begp);
=20
 	      /* Convert argument to a number (last arg is the base) */
 	      addr =3D simple_strtoul(begp, &endp, 16);
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index eb0ceb8..fc70a49 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -482,8 +482,7 @@ static ssize_t recent_old_proc_write(struct file *fil=
e,
 	if (copy_from_user(buf, input, size))
 		return -EFAULT;
=20
-	while (isspace(*c))
-		c++;
+	c =3D skip_spaces(c);
=20
 	if (size - (c - buf) < 5)
 		return c - buf;
diff --git a/sound/pci/hda/hda_hwdep.c b/sound/pci/hda/hda_hwdep.c
index cc24e67..4e17b43 100644
--- a/sound/pci/hda/hda_hwdep.c
+++ b/sound/pci/hda/hda_hwdep.c
@@ -24,6 +24,7 @@
 #include <linux/compat.h>
 #include <linux/mutex.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/firmware.h>
 #include <sound/core.h>
 #include "hda_codec.h"
@@ -390,8 +391,7 @@ static int parse_hints(struct hda_codec *codec, const=
 char *buf)
 	char *key, *val;
 	struct hda_hint *hint;
=20
-	while (isspace(*buf))
-		buf++;
+	buf =3D skip_spaces(buf);
 	if (!*buf || *buf =3D=3D '#' || *buf =3D=3D '\n')
 		return 0;
 	if (*buf =3D=3D '=3D')
@@ -406,8 +406,7 @@ static int parse_hints(struct hda_codec *codec, const=
 char *buf)
 		return -EINVAL;
 	}
 	*val++ =3D 0;
-	while (isspace(*val))
-		val++;
+	val =3D skip_spaces(val);
 	remove_trail_spaces(key);
 	remove_trail_spaces(val);
 	hint =3D get_hint(codec, key);
--=20
1.6.5.2.153.g6e31f.dirty
