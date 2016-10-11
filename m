From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/9] tests: Some additional checks for ioctl_dm test
Date: Wed, 12 Oct 2016 01:39:22 +0300
Message-ID: <20161011223922.GA9227@obsidian>
References: <20161005.192828.566127461630656590.yamato@redhat.com>
Reply-To: strace development list <strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161005.192828.566127461630656590.yamato-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=strace-devel>
List-Post: <mailto:strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

---
 tests/ioctl_dm.c |  505 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 505 insertions(+)

diff --git a/tests/ioctl_dm.c b/tests/ioctl_dm.c
index 24232b7..0b2c5a7 100644
--- a/tests/ioctl_dm.c
+++ b/tests/ioctl_dm.c
@@ -2,13 +2,26 @@
 
 #ifdef HAVE_LINUX_DM_IOCTL_H
 
+# include <errno.h>
 # include <inttypes.h>
+# include <stdbool.h>
 # include <stdio.h>
 # include <stddef.h>
 # include <string.h>
 # include <sys/ioctl.h>
 # include <linux/dm-ioctl.h>
 
+# define STR32 "AbCdEfGhIjKlMnOpQrStUvWxYz012345"
+
+static const char str129[] = STR32 STR32 STR32 STR32 "6";
+
+static const __u64 dts_sector_base = (__u64) 0xdeadca75facef157ULL;
+static const __u64 dts_sector_step = (__u64) 0x100000001ULL;
+static const __u64 dts_length_base = (__u64) 0xbadc0dedda7a1057ULL;
+static const __u64 dts_length_step = (__u64) 0x700000007ULL;
+static const __s32 dts_status_base = (__s32) 3141592653U;
+static const __s32 dts_status_step = 0x1234;
+
 static struct s {
 	struct dm_ioctl ioc;
 	union {
@@ -24,6 +37,43 @@ static struct s {
 	} u;
 } s;
 
+struct dm_table_open_test {
+	struct dm_ioctl ioc;
+	struct dm_target_spec target0;
+	char param0[1];
+	struct dm_target_spec target1;
+	char param1[2];
+	struct dm_target_spec target2;
+	char param2[3];
+	struct dm_target_spec target3;
+	char param3[4];
+	struct dm_target_spec target4;
+	char param4[5];
+	struct dm_target_spec target5;
+	char param5[6];
+	struct dm_target_spec target6;
+	char param6[7];
+	struct dm_target_spec target7;
+	char param7[8];
+	struct dm_target_spec target8;
+	char param8[9];
+	struct dm_target_spec target9;
+	char param9[10];
+};
+
+struct dm_target_msg_test {
+	struct dm_ioctl ioc;
+	struct dm_target_msg msg;
+};
+
+struct args {
+	unsigned int arg;
+	const char *str;
+	bool has_params;
+	bool has_event_nr;
+};
+
+
 static void
 init_s(struct dm_ioctl *s, size_t size, size_t offs)
 {
@@ -38,9 +88,147 @@ init_s(struct dm_ioctl *s, size_t size, size_t offs)
 	strcpy(s->uuid, "uuu");
 }
 
+static void
+init_dm_target_spec(struct dm_target_spec *ptr, uint32_t id)
+{
+	ptr->sector_start = dts_sector_base + dts_sector_step * id;
+	ptr->length       = dts_length_base + dts_length_step * id;
+	ptr->status       = dts_status_base + dts_status_step * id;
+
+	strncpy(ptr->target_type, str129 +
+		id % (sizeof(str129) - sizeof(ptr->target_type)),
+		id % (sizeof(ptr->target_type) + 1));
+	if (id % (sizeof(ptr->target_type) + 1) < sizeof(ptr->target_type))
+		ptr->target_type[id % (sizeof(ptr->target_type) + 1)] = '\0';
+}
+
+static void
+print_dm_target_spec(struct dm_target_spec *ptr, uint32_t id)
+{
+	printf("{sector_start=%" PRI__u64 ", length=%" PRI__u64 ", "
+	       "target_type=\"%.*s\", string=",
+	       dts_sector_base + dts_sector_step * id,
+	       dts_length_base + dts_length_step * id,
+	       (int) (id % (sizeof(ptr->target_type) + 1)),
+	       str129 + id % (sizeof(str129) - sizeof(ptr->target_type)));
+}
+
+# define ARG_STR(_arg) (_arg), #_arg
+
 int
 main(void)
 {
+	/* We can't check these properly for now */
+	static struct args dummy_check_cmds_nodev[] = {
+		{ ARG_STR(DM_REMOVE_ALL),    false },
+		{ ARG_STR(DM_LIST_DEVICES),  true  },
+		{ ARG_STR(DM_LIST_VERSIONS), true  },
+	};
+	static struct args dummy_check_cmds[] = {
+		{ ARG_STR(DM_DEV_CREATE),    false },
+		{ ARG_STR(DM_DEV_REMOVE),    false, true },
+		{ ARG_STR(DM_DEV_STATUS),    false },
+		{ ARG_STR(DM_DEV_WAIT),      true,  true },
+		{ ARG_STR(DM_TABLE_CLEAR),   false },
+		{ ARG_STR(DM_TABLE_DEPS),    true  },
+		{ ARG_STR(DM_TABLE_STATUS),  true  },
+	};
+
+	struct dm_ioctl *dm_arg =
+		tail_alloc(sizeof(*dm_arg) - sizeof(dm_arg->data));
+	struct dm_table_open_test *dm_arg_open1 =
+		tail_alloc(offsetof(struct dm_table_open_test, target1));
+	struct dm_table_open_test *dm_arg_open2 =
+		tail_alloc(offsetof(struct dm_table_open_test, param1));
+	struct dm_table_open_test *dm_arg_open3 =
+		tail_alloc(offsetof(struct dm_table_open_test, target9));
+	struct dm_target_msg_test *dm_arg_msg =
+		tail_alloc(sizeof(*dm_arg_msg));
+
+	int saved_errno;
+	unsigned int i;
+
+
+	/* Incorrect operation */
+	ioctl(-1, _IOW(DM_IOCTL, 0xde, int), dm_arg);
+	printf("ioctl(-1, _IOC(_IOC_WRITE, %#04x, 0xde, %#04zx), %p) = "
+	        "-1 EBADF (%m)\n",
+		DM_IOCTL, sizeof(int), dm_arg);
+
+
+	/* DM_VERSION */
+	/* Incorrect pointer */
+	ioctl(-1, DM_VERSION, dm_arg + 1);
+	printf("ioctl(-1, DM_VERSION, %p) = -1 EBADF (%m)\n", dm_arg + 1);
+
+	/* Incorrect data_size */
+	init_s(dm_arg, 0, 0);
+	ioctl(-1, DM_VERSION, &s);
+	printf("ioctl(-1, DM_VERSION, %p) = -1 EBADF (%m)\n", &s);
+
+	/* Incorrect version */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+	dm_arg->version[0] = 0xbadc0ded;
+	dm_arg->version[1] = 0xbadc0dee;
+	dm_arg->version[2] = 0xbadc0def;
+	ioctl(-1, DM_VERSION, dm_arg);
+	printf("ioctl(-1, DM_VERSION, {version=%u.%u.%u, "
+	       "/* Unsupported device mapper ABI version */ ...}) = "
+	       "-1 EBADF (%m)\n", 0xbadc0ded, 0xbadc0dee, 0xbadc0def);
+
+	/* Incorrect data_size */
+	init_s(dm_arg, 14, 64);
+	ioctl(-1, DM_VERSION, dm_arg);
+	printf("ioctl(-1, DM_VERSION, {version=4.1.2, data_size=14, "
+	       "/* Incorrect data_size */ ...}) = -1 EBADF (%m)\n");
+
+	/* Unterminated name/uuid */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+	strncpy(dm_arg->name, str129, sizeof(dm_arg->name));
+	strncpy(dm_arg->uuid, str129, sizeof(dm_arg->uuid));
+	ioctl(-1, DM_VERSION, dm_arg);
+	printf("ioctl(-1, DM_VERSION, {version=4.1.2, data_size=%zu, "
+	       "dev=makedev(18, 52), name=\"%.127s\", uuid=\"%.128s\", "
+	       "flags=0}) = -1 EBADF (%m)\n",
+	       sizeof(*dm_arg) - sizeof(dm_arg->data), str129, str129);
+
+	/* Normal call */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+	ioctl(-1, DM_VERSION, dm_arg);
+	printf("ioctl(-1, DM_VERSION, "
+	       "{version=4.1.2, data_size=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = "
+	       "-1 EBADF (%m)\n", sizeof(*dm_arg) - sizeof(dm_arg->data));
+
+	/* Zero dev, name, uuid */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+	dm_arg->data_size = 0xfacefeed;
+	dm_arg->dev = 0;
+	dm_arg->name[0] = '\0';
+	dm_arg->uuid[0] = '\0';
+	ioctl(-1, DM_VERSION, dm_arg);
+	printf("ioctl(-1, DM_VERSION, "
+	       "{version=4.1.2, data_size=%u, flags=0}) = "
+	       "-1 EBADF (%m)\n", 0xfacefeed);
+
+	/* Flag */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+	dm_arg->flags = 0xffffffff;
+	ioctl(-1, DM_VERSION, dm_arg);
+	printf("ioctl(-1, DM_VERSION, "
+	       "{version=4.1.2, data_size=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags="
+	       "DM_READONLY_FLAG|DM_SUSPEND_FLAG|DM_EXISTS_FLAG|"
+	       "DM_PERSISTENT_DEV_FLAG|DM_STATUS_TABLE_FLAG|"
+	       "DM_ACTIVE_PRESENT_FLAG|DM_INACTIVE_PRESENT_FLAG|"
+	       "DM_BUFFER_FULL_FLAG|DM_SKIP_BDGET_FLAG|DM_SKIP_LOCKFS_FLAG|"
+	       "DM_NOFLUSH_FLAG|DM_QUERY_INACTIVE_TABLE_FLAG|"
+	       "DM_UEVENT_GENERATED_FLAG|DM_UUID_FLAG|DM_SECURE_DATA_FLAG|"
+	       "DM_DATA_OUT_FLAG|DM_DEFERRED_REMOVE|DM_INTERNAL_SUSPEND_FLAG|"
+	       "0xfff80080}) = -1 EBADF (%m)\n",
+	       sizeof(*dm_arg) - sizeof(dm_arg->data));
+
+	/* Normal call */
 	init_s(&s.ioc, sizeof(s.ioc), 0);
 	ioctl(-1, DM_VERSION, &s);
 	printf("ioctl(-1, DM_VERSION, "
@@ -48,6 +236,61 @@ main(void)
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = "
 	       "-1 EBADF (%m)\n", sizeof(s.ioc));
 
+
+	/* DM_REMOVE_ALL */
+	/* DM_LIST_DEVICES */
+	/* DM_LIST_VERSIONS */
+	for (i = 0; i < ARRAY_SIZE(dummy_check_cmds_nodev); i++) {
+		init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+		ioctl(-1, dummy_check_cmds_nodev[i].arg, dm_arg);
+		printf("ioctl(-1, %s, {version=4.1.2, data_size=%zu%s, "
+		       "flags=0}) = -1 EBADF (%m)\n",
+		       dummy_check_cmds_nodev[i].str,
+		       sizeof(*dm_arg) - sizeof(dm_arg->data),
+		       dummy_check_cmds_nodev[i].has_params ?
+		       ", data_start=0" : "");
+	}
+
+
+	/* DM_DEV_CREATE */
+	/* DM_DEV_REMOVE */
+	/* DM_DEV_STATUS */
+	/* DM_DEV_WAIT */
+	/* DM_TABLE_CLEAR */
+	/* DM_TABLE_DEPS */
+	/* DM_TABLE_STATUS */
+	for (i = 0; i < ARRAY_SIZE(dummy_check_cmds); i++) {
+		init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+		ioctl(-1, dummy_check_cmds[i].arg, dm_arg);
+		printf("ioctl(-1, %s, {version=4.1.2, data_size=%zu%s, "
+		       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\"%s, "
+		       "flags=0}) = -1 EBADF (%m)\n", dummy_check_cmds[i].str,
+		       sizeof(*dm_arg) - sizeof(dm_arg->data),
+		       dummy_check_cmds[i].has_params ? ", data_start=0" : "",
+		       dummy_check_cmds[i].has_event_nr ? ", event_nr=0" : "");
+	}
+
+
+	/* DM_DEV_SUSPEND */
+	init_s(&s.ioc, sizeof(s.ioc), 0);
+	s.ioc.flags = DM_SUSPEND_FLAG;
+	s.ioc.event_nr = 0xbadc0ded;
+	ioctl(-1, DM_DEV_SUSPEND, &s);
+	printf("ioctl(-1, DM_DEV_SUSPEND, "
+	       "{version=4.1.2, data_size=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "flags=DM_SUSPEND_FLAG}) = -1 EBADF (%m)\n", sizeof(s.ioc));
+
+	init_s(&s.ioc, sizeof(s.ioc), 0);
+	s.ioc.event_nr = 0xbadc0ded;
+	ioctl(-1, DM_DEV_SUSPEND, &s);
+	printf("ioctl(-1, DM_DEV_SUSPEND, "
+	       "{version=4.1.2, data_size=%zu, dev=makedev(18, 52), "
+	       "name=\"nnn\", uuid=\"uuu\", event_nr=3134983661, "
+	       "flags=0}) = -1 EBADF (%m)\n", sizeof(s.ioc));
+
+
+	/* DM_TABLE_LOAD */
 	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
 	s.ioc.target_count = 1;
 	s.u.ts.target_spec.sector_start = 0x10;
@@ -64,6 +307,164 @@ main(void)
 	       "length=32, target_type=\"tgt\", string=\"tparams\"}}) = "
 	       "-1 EBADF (%m)\n", s.ioc.data_size, s.ioc.data_start);
 
+	/* No targets */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data),
+		sizeof(*dm_arg) - sizeof(dm_arg->data));
+	dm_arg->data_size = sizeof(*dm_arg);
+	dm_arg->target_count = 0;
+	ioctl(-1, DM_TABLE_LOAD, dm_arg);
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=0, flags=0}) = -1 EBADF (%m)\n", sizeof(*dm_arg),
+	       sizeof(*dm_arg) - sizeof(dm_arg->data));
+
+	/* Invalid data_start */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0xfffffff8);
+	dm_arg->data_size = sizeof(*dm_arg);
+	dm_arg->target_count = 1234;
+	ioctl(-1, DM_TABLE_LOAD, dm_arg);
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, data_size=%zu, data_start=%u, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=1234, flags=0, "
+	       "/* misplaced struct dm_target_spec */ ...}) = -1 EBADF (%m)\n",
+	       sizeof(*dm_arg), 0xfffffff8);
+
+	/* Inaccessible pointer */
+	init_s(&dm_arg_open1->ioc, offsetof(struct dm_table_open_test, target1),
+	       offsetof(struct dm_table_open_test, target1));
+	dm_arg_open1->ioc.data_size = sizeof(*dm_arg_open1);
+	dm_arg_open1->ioc.target_count = 0xdeaddea1;
+	ioctl(-1, DM_TABLE_LOAD, dm_arg_open1);
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=3735936673, flags=0, %p}) = -1 EBADF (%m)\n",
+	       sizeof(*dm_arg_open1),
+	       offsetof(struct dm_table_open_test, target1),
+	       (char *) dm_arg_open1 +
+	       offsetof(struct dm_table_open_test, target1));
+
+	/* Inaccessible string */
+	init_s(&dm_arg_open2->ioc, offsetof(struct dm_table_open_test, param1),
+	       offsetof(struct dm_table_open_test, target1));
+	dm_arg_open2->ioc.data_size = sizeof(*dm_arg_open2);
+	dm_arg_open2->ioc.target_count = 2;
+	init_dm_target_spec(&dm_arg_open2->target1, 7);
+	dm_arg_open2->target1.next =
+		offsetof(struct dm_table_open_test, target3) -
+		offsetof(struct dm_table_open_test, target1);
+	ioctl(-1, DM_TABLE_LOAD, dm_arg_open2);
+	saved_errno = errno;
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=2, flags=0, ",
+	       sizeof(*dm_arg_open2),
+	       offsetof(struct dm_table_open_test, target1));
+	print_dm_target_spec(&dm_arg_open2->target1, 7);
+	errno = saved_errno;
+	printf("%p}, %p}) = -1 EBADF (%m)\n",
+	       (char *) dm_arg_open2 +
+	       offsetof(struct dm_table_open_test, param1),
+	       (char *) dm_arg_open2 +
+	       offsetof(struct dm_table_open_test, target3));
+
+	/* Incorrect next */
+	init_s(&dm_arg_open3->ioc, offsetof(struct dm_table_open_test, target5),
+	       offsetof(struct dm_table_open_test, target0));
+	dm_arg_open3->ioc.target_count = 4;
+
+	init_dm_target_spec(&dm_arg_open3->target0, 9);
+	dm_arg_open3->target0.next =
+		offsetof(struct dm_table_open_test, target1) -
+		offsetof(struct dm_table_open_test, target0);
+	dm_arg_open3->param0[0] = '\0';
+
+	init_dm_target_spec(&dm_arg_open3->target1, 15);
+	dm_arg_open3->target1.next =
+		offsetof(struct dm_table_open_test, target3) -
+		offsetof(struct dm_table_open_test, target1);
+	dm_arg_open3->param1[0] = '\377';
+	dm_arg_open3->param1[1] = '\0';
+
+	init_dm_target_spec(&dm_arg_open3->target3, 42);
+	dm_arg_open3->target3.next = 0xdeadbeef;
+	dm_arg_open3->param3[0] = '\1';
+	dm_arg_open3->param3[1] = '\2';
+	dm_arg_open3->param1[2] = '\0';
+
+	ioctl(-1, DM_TABLE_LOAD, dm_arg_open3);
+	saved_errno = errno;
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=4, flags=0, ",
+	       offsetof(struct dm_table_open_test, target5),
+	       offsetof(struct dm_table_open_test, target0));
+	print_dm_target_spec(&dm_arg_open3->target0, 9);
+	printf("\"\"}, ");
+	print_dm_target_spec(&dm_arg_open3->target1, 15);
+	printf("\"\\377\"}, ");
+	print_dm_target_spec(&dm_arg_open3->target1, 42);
+	errno = saved_errno;
+	printf("\"\\1\\2\"}, /* misplaced struct dm_target_spec */ ...}) = "
+	       "-1 EBADF (%m)\n");
+
+	#define FILL_DM_TARGET(id, id_next) \
+		do { \
+			init_dm_target_spec(&dm_arg_open3->target##id, id); \
+			dm_arg_open3->target##id.next = \
+				offsetof(struct dm_table_open_test, \
+					target##id_next) - \
+				offsetof(struct dm_table_open_test, \
+					target##id); \
+			strncpy(dm_arg_open3->param##id, str129 + id * 2, id); \
+			dm_arg_open3->param##id[id] = '\0'; \
+		} while (0)
+	#define PRINT_DM_TARGET(id) \
+		do { \
+			print_dm_target_spec(&dm_arg_open3->target##id, id); \
+			printf("\"%.*s\"}, ", id, str129 + id * 2); \
+		} while (0)
+
+	/* max_strlen limit */
+	init_s(&dm_arg_open3->ioc, offsetof(struct dm_table_open_test, target9),
+	       offsetof(struct dm_table_open_test, target0));
+	dm_arg_open3->ioc.data_size = sizeof(*dm_arg_open3);
+	dm_arg_open3->ioc.target_count = 0xbadc0ded;
+	FILL_DM_TARGET(0, 1);
+	FILL_DM_TARGET(1, 2);
+	FILL_DM_TARGET(2, 3);
+	FILL_DM_TARGET(3, 4);
+	FILL_DM_TARGET(4, 5);
+	FILL_DM_TARGET(5, 6);
+	FILL_DM_TARGET(6, 7);
+	FILL_DM_TARGET(7, 8);
+	FILL_DM_TARGET(8, 9);
+	ioctl(-1, DM_TABLE_LOAD, dm_arg_open3);
+	saved_errno = errno;
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=3134983661, flags=0, ",
+	       sizeof(*dm_arg_open3),
+	       offsetof(struct dm_table_open_test, target0));
+	PRINT_DM_TARGET(0);
+	PRINT_DM_TARGET(1);
+	PRINT_DM_TARGET(2);
+	PRINT_DM_TARGET(3);
+	PRINT_DM_TARGET(4);
+	PRINT_DM_TARGET(5);
+	PRINT_DM_TARGET(6);
+	PRINT_DM_TARGET(7);
+	PRINT_DM_TARGET(8);
+	errno = saved_errno;
+	printf("...}) = -1 EBADF (%m)\n");
+
+
+	/* DM_TARGET_MSG */
 	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
 	s.u.tm.target_msg.sector = 0x1234;
 	strcpy(s.u.string + offsetof(struct dm_target_msg, message),
@@ -75,6 +476,71 @@ main(void)
 	       "{sector=4660, message=\"long targ\"...}}) = -1 EBADF (%m)\n",
 	       s.ioc.data_size, s.ioc.data_start);
 
+	/* Invalid data_start */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data),
+		sizeof(*dm_arg) - sizeof(dm_arg->data));
+	dm_arg->data_size = sizeof(*dm_arg);
+	ioctl(-1, DM_TARGET_MSG, dm_arg);
+	printf("ioctl(-1, DM_TARGET_MSG, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
+	       "/* misplaced struct dm_target_msg */}) = -1 EBADF (%m)\n",
+	       sizeof(*dm_arg), sizeof(*dm_arg) - sizeof(dm_arg->data));
+
+	/* Invalid data_start */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0xffffffff);
+	dm_arg->data_size = sizeof(*dm_arg);
+	ioctl(-1, DM_TARGET_MSG, dm_arg);
+	printf("ioctl(-1, DM_TARGET_MSG, "
+	       "{version=4.1.2, data_size=%zu, data_start=%u, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
+	       "/* misplaced struct dm_target_msg */}) = -1 EBADF (%m)\n",
+	       sizeof(*dm_arg), 0xffffffff);
+
+	/* Inaccessible pointer */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data), 0);
+	dm_arg->data_size = sizeof(*dm_arg) + sizeof(struct dm_target_msg);
+	dm_arg->data_start = sizeof(*dm_arg);
+	ioctl(-1, DM_TARGET_MSG, dm_arg);
+	printf("ioctl(-1, DM_TARGET_MSG, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, %p}) "
+	       "= -1 EBADF (%m)\n",
+	       sizeof(*dm_arg) + sizeof(struct dm_target_msg),
+	       sizeof(*dm_arg), (char *) dm_arg + sizeof(*dm_arg));
+
+	/* Inaccessible string */
+	init_s(&dm_arg_msg->ioc, sizeof(*dm_arg_msg),
+		offsetof(struct dm_target_msg_test, msg));
+	dm_arg_msg->ioc.data_size = sizeof(*dm_arg_msg) + 1;
+	dm_arg_msg->msg.sector = (__u64) 0xdeadbeeffacef157ULL;
+	ioctl(-1, DM_TARGET_MSG, dm_arg_msg);
+	printf("ioctl(-1, DM_TARGET_MSG, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
+	       "{sector=%" PRI__u64 ", message=%p}}) "
+	       "= -1 EBADF (%m)\n",
+	       sizeof(*dm_arg_msg) + 1,
+	       offsetof(struct dm_target_msg_test, msg),
+	       (__u64) 0xdeadbeeffacef157ULL,
+	       (char *) dm_arg_msg +
+	       offsetof(struct dm_target_msg_test, msg.message));
+
+	/* Zero-sied string */
+	init_s(&dm_arg_msg->ioc, sizeof(*dm_arg_msg),
+		offsetof(struct dm_target_msg_test, msg));
+	dm_arg_msg->msg.sector = (__u64) 0xdeadbeeffacef157ULL;
+	ioctl(-1, DM_TARGET_MSG, dm_arg_msg);
+	printf("ioctl(-1, DM_TARGET_MSG, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
+	       "{sector=%" PRI__u64 ", message=\"\"}}) "
+	       "= -1 EBADF (%m)\n",
+	       sizeof(*dm_arg_msg), offsetof(struct dm_target_msg_test, msg),
+	       (__u64) 0xdeadbeeffacef157ULL);
+
+
+	/* DM_DEV_SET_GEOMETRY */
 	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
 	strcpy(s.u.string, "10 20 30 40");
 	ioctl(-1, DM_DEV_SET_GEOMETRY, &s);
@@ -84,6 +550,43 @@ main(void)
 	       "string=\"10 20 30 \"...}) = -1 EBADF (%m)\n",
 	       s.ioc.data_size, s.ioc.data_start);
 
+
+	/* DM_DEV_RENAME */
+	/* Inaccessible data */
+	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data),
+		sizeof(*dm_arg) - sizeof(dm_arg->data));
+	dm_arg->data_size = sizeof(*dm_arg);
+	ioctl(-1, DM_DEV_RENAME, dm_arg);
+	printf("ioctl(-1, DM_DEV_RENAME, "
+	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", event_nr=0, "
+	       "flags=0, string=%p}) = -1 EBADF (%m)\n",
+	       sizeof(*dm_arg), sizeof(*dm_arg) - sizeof(dm_arg->data),
+	       (char *) dm_arg + sizeof(*dm_arg) - sizeof(dm_arg->data));
+
+	/* Incorrect data_start data */
+	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
+	s.ioc.data_start = 0xdeadbeef;
+	ioctl(-1, DM_DEV_RENAME, &s);
+	printf("ioctl(-1, DM_DEV_RENAME, "
+	       "{version=4.1.2, data_size=%u, data_start=3735928559, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", event_nr=0, "
+	       "flags=0, /* misplaced string */}) = -1 EBADF (%m)\n",
+	       s.ioc.data_size);
+
+	/* Strange but still valid data_start */
+	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
+	/* Curiously, this is a valid structure */
+	s.ioc.data_start = offsetof(struct dm_ioctl, name) + 1;
+	ioctl(-1, DM_DEV_RENAME, &s);
+	printf("ioctl(-1, DM_DEV_RENAME, "
+	       "{version=4.1.2, data_size=%u, data_start=%zu, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", event_nr=0, "
+	       "flags=0, string=\"nn\"}) = -1 EBADF (%m)\n",
+	       s.ioc.data_size,
+	       offsetof(struct dm_ioctl, name) + 1);
+
+	/* Correct data */
 	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
 	strcpy(s.u.string, "new long name");
 	ioctl(-1, DM_DEV_RENAME, &s);
@@ -93,6 +596,8 @@ main(void)
 	       "flags=0, string=\"new long \"...}) = -1 EBADF (%m)\n",
 	       s.ioc.data_size, s.ioc.data_start);
 
+
+	/* DM_TABLE_LOAD */
 	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
 	s.ioc.target_count = -1U;
 	ioctl(-1, DM_TABLE_LOAD, &s);
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
