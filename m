From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 9/9] tests: Add checks for abbreviated DM ioctl output
Date: Wed, 12 Oct 2016 01:39:36 +0300
Message-ID: <20161011223936.GA9597@obsidian>
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
 tests/.gitignore      |    1 +
 tests/Makefile.am     |    2 +
 tests/ioctl_dm-v.c    |    2 +
 tests/ioctl_dm-v.test |   12 ++++
 tests/ioctl_dm.c      |  178 +++++++++++++++++++++++++++++++++++++++----------
 tests/ioctl_dm.test   |    2 +-
 6 files changed, 160 insertions(+), 37 deletions(-)
 create mode 100644 tests/ioctl_dm-v.c
 create mode 100755 tests/ioctl_dm-v.test

diff --git a/tests/.gitignore b/tests/.gitignore
index 9045117..b2c5434 100644
--- a/tests/.gitignore
+++ b/tests/.gitignore
@@ -104,6 +104,7 @@ inet-cmsg
 ioctl
 ioctl_block
 ioctl_dm
+ioctl_dm-v
 ioctl_evdev
 ioctl_evdev-v
 ioctl_mtd
diff --git a/tests/Makefile.am b/tests/Makefile.am
index 2405415..61b6db7 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -164,6 +164,7 @@ check_PROGRAMS = \
 	ioctl \
 	ioctl_block \
 	ioctl_dm \
+	ioctl_dm-v \
 	ioctl_evdev \
 	ioctl_evdev-v \
 	ioctl_mtd \
@@ -513,6 +514,7 @@ DECODER_TESTS = \
 	ioctl.test \
 	ioctl_block.test \
 	ioctl_dm.test \
+	ioctl_dm-v.test \
 	ioctl_evdev.test \
 	ioctl_evdev-v.test \
 	ioctl_mtd.test \
diff --git a/tests/ioctl_dm-v.c b/tests/ioctl_dm-v.c
new file mode 100644
index 0000000..d95058f
--- /dev/null
+++ b/tests/ioctl_dm-v.c
@@ -0,0 +1,2 @@
+#define VERBOSE 1
+#include "ioctl_dm.c"
diff --git a/tests/ioctl_dm-v.test b/tests/ioctl_dm-v.test
new file mode 100755
index 0000000..4f6d64c
--- /dev/null
+++ b/tests/ioctl_dm-v.test
@@ -0,0 +1,12 @@
+#!/bin/sh
+
+# Check abbreviated decoding of DM* ioctls.
+
+. "${srcdir=.}/init.sh"
+
+run_prog > /dev/null
+run_strace -a16 -s9 -veioctl $args > "$EXP"
+check_prog grep
+grep -v '^ioctl([012],' < "$LOG" > "$OUT"
+match_diff "$OUT" "$EXP"
+rm -f "$EXP" "$OUT"
diff --git a/tests/ioctl_dm.c b/tests/ioctl_dm.c
index 0b2c5a7..2fcd430 100644
--- a/tests/ioctl_dm.c
+++ b/tests/ioctl_dm.c
@@ -11,6 +11,10 @@
 # include <sys/ioctl.h>
 # include <linux/dm-ioctl.h>
 
+# ifndef VERBOSE
+#  define VERBOSE 0
+# endif
+
 # define STR32 "AbCdEfGhIjKlMnOpQrStUvWxYz012345"
 
 static const char str129[] = STR32 STR32 STR32 STR32 "6";
@@ -102,6 +106,7 @@ init_dm_target_spec(struct dm_target_spec *ptr, uint32_t id)
 		ptr->target_type[id % (sizeof(ptr->target_type) + 1)] = '\0';
 }
 
+# if VERBOSE
 static void
 print_dm_target_spec(struct dm_target_spec *ptr, uint32_t id)
 {
@@ -112,6 +117,7 @@ print_dm_target_spec(struct dm_target_spec *ptr, uint32_t id)
 	       (int) (id % (sizeof(ptr->target_type) + 1)),
 	       str129 + id % (sizeof(str129) - sizeof(ptr->target_type)));
 }
+# endif /* VERBOSE */
 
 # define ARG_STR(_arg) (_arg), #_arg
 
@@ -303,9 +309,14 @@ main(void)
 	printf("ioctl(-1, DM_TABLE_LOAD, "
 	       "{version=4.1.2, data_size=%u, data_start=%u, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
-	       "target_count=1, flags=0, {sector_start=16, "
-	       "length=32, target_type=\"tgt\", string=\"tparams\"}}) = "
-	       "-1 EBADF (%m)\n", s.ioc.data_size, s.ioc.data_start);
+	       "target_count=1, flags=0, "
+# if VERBOSE
+	       "{sector_start=16, length=32, target_type=\"tgt\", "
+	       "string=\"tparams\"}"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n", s.ioc.data_size, s.ioc.data_start);
 
 	/* No targets */
 	init_s(dm_arg, sizeof(*dm_arg) - sizeof(dm_arg->data),
@@ -328,8 +339,12 @@ main(void)
 	       "{version=4.1.2, data_size=%zu, data_start=%u, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
 	       "target_count=1234, flags=0, "
-	       "/* misplaced struct dm_target_spec */ ...}) = -1 EBADF (%m)\n",
-	       sizeof(*dm_arg), 0xfffffff8);
+# if VERBOSE
+	       "/* misplaced struct dm_target_spec */ ..."
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n", sizeof(*dm_arg), 0xfffffff8);
 
 	/* Inaccessible pointer */
 	init_s(&dm_arg_open1->ioc, offsetof(struct dm_table_open_test, target1),
@@ -340,11 +355,19 @@ main(void)
 	printf("ioctl(-1, DM_TABLE_LOAD, "
 	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
-	       "target_count=3735936673, flags=0, %p}) = -1 EBADF (%m)\n",
-	       sizeof(*dm_arg_open1),
-	       offsetof(struct dm_table_open_test, target1),
-	       (char *) dm_arg_open1 +
-	       offsetof(struct dm_table_open_test, target1));
+	       "target_count=3735936673, flags=0, "
+# if VERBOSE
+	       "%p"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n", sizeof(*dm_arg_open1),
+	       offsetof(struct dm_table_open_test, target1)
+# if VERBOSE
+	       , (char *) dm_arg_open1 +
+	       offsetof(struct dm_table_open_test, target1)
+# endif /* VERBOSE */
+	       );
 
 	/* Inaccessible string */
 	init_s(&dm_arg_open2->ioc, offsetof(struct dm_table_open_test, param1),
@@ -363,13 +386,18 @@ main(void)
 	       "target_count=2, flags=0, ",
 	       sizeof(*dm_arg_open2),
 	       offsetof(struct dm_table_open_test, target1));
+# if VERBOSE
 	print_dm_target_spec(&dm_arg_open2->target1, 7);
-	errno = saved_errno;
-	printf("%p}, %p}) = -1 EBADF (%m)\n",
+	printf("%p}, %p",
 	       (char *) dm_arg_open2 +
 	       offsetof(struct dm_table_open_test, param1),
 	       (char *) dm_arg_open2 +
 	       offsetof(struct dm_table_open_test, target3));
+# else /* !VERBOSE */
+	printf("...");
+# endif /* VERBOSE */
+	errno = saved_errno;
+	printf("}) = -1 EBADF (%m)\n");
 
 	/* Incorrect next */
 	init_s(&dm_arg_open3->ioc, offsetof(struct dm_table_open_test, target5),
@@ -403,14 +431,19 @@ main(void)
 	       "target_count=4, flags=0, ",
 	       offsetof(struct dm_table_open_test, target5),
 	       offsetof(struct dm_table_open_test, target0));
+# if VERBOSE
 	print_dm_target_spec(&dm_arg_open3->target0, 9);
 	printf("\"\"}, ");
 	print_dm_target_spec(&dm_arg_open3->target1, 15);
 	printf("\"\\377\"}, ");
 	print_dm_target_spec(&dm_arg_open3->target1, 42);
 	errno = saved_errno;
-	printf("\"\\1\\2\"}, /* misplaced struct dm_target_spec */ ...}) = "
-	       "-1 EBADF (%m)\n");
+	printf("\"\\1\\2\"}, /* misplaced struct dm_target_spec */ ...");
+# else /* !VERBOSE */
+	printf("...");
+# endif /* VERBOSE */
+	errno = saved_errno;
+	printf("}) = -1 EBADF (%m)\n");
 
 	#define FILL_DM_TARGET(id, id_next) \
 		do { \
@@ -451,6 +484,7 @@ main(void)
 	       "target_count=3134983661, flags=0, ",
 	       sizeof(*dm_arg_open3),
 	       offsetof(struct dm_table_open_test, target0));
+# if VERBOSE
 	PRINT_DM_TARGET(0);
 	PRINT_DM_TARGET(1);
 	PRINT_DM_TARGET(2);
@@ -460,6 +494,7 @@ main(void)
 	PRINT_DM_TARGET(6);
 	PRINT_DM_TARGET(7);
 	PRINT_DM_TARGET(8);
+# endif /* VERBOSE */
 	errno = saved_errno;
 	printf("...}) = -1 EBADF (%m)\n");
 
@@ -473,7 +508,12 @@ main(void)
 	printf("ioctl(-1, DM_TARGET_MSG, "
 	       "{version=4.1.2, data_size=%u, data_start=%u, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
-	       "{sector=4660, message=\"long targ\"...}}) = -1 EBADF (%m)\n",
+# if VERBOSE
+	       "{sector=4660, message=\"long targ\"...}"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
 	       s.ioc.data_size, s.ioc.data_start);
 
 	/* Invalid data_start */
@@ -484,7 +524,12 @@ main(void)
 	printf("ioctl(-1, DM_TARGET_MSG, "
 	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
-	       "/* misplaced struct dm_target_msg */}) = -1 EBADF (%m)\n",
+# if VERBOSE
+	       "/* misplaced struct dm_target_msg */"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
 	       sizeof(*dm_arg), sizeof(*dm_arg) - sizeof(dm_arg->data));
 
 	/* Invalid data_start */
@@ -494,7 +539,12 @@ main(void)
 	printf("ioctl(-1, DM_TARGET_MSG, "
 	       "{version=4.1.2, data_size=%zu, data_start=%u, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
-	       "/* misplaced struct dm_target_msg */}) = -1 EBADF (%m)\n",
+# if VERBOSE
+	       "/* misplaced struct dm_target_msg */"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
 	       sizeof(*dm_arg), 0xffffffff);
 
 	/* Inaccessible pointer */
@@ -504,10 +554,19 @@ main(void)
 	ioctl(-1, DM_TARGET_MSG, dm_arg);
 	printf("ioctl(-1, DM_TARGET_MSG, "
 	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
-	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, %p}) "
-	       "= -1 EBADF (%m)\n",
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
+# if VERBOSE
+	       "%p"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
 	       sizeof(*dm_arg) + sizeof(struct dm_target_msg),
-	       sizeof(*dm_arg), (char *) dm_arg + sizeof(*dm_arg));
+	       sizeof(*dm_arg)
+# if VERBOSE
+	       , (char *) dm_arg + sizeof(*dm_arg)
+# endif /* VERBOSE */
+	       );
 
 	/* Inaccessible string */
 	init_s(&dm_arg_msg->ioc, sizeof(*dm_arg_msg),
@@ -515,29 +574,41 @@ main(void)
 	dm_arg_msg->ioc.data_size = sizeof(*dm_arg_msg) + 1;
 	dm_arg_msg->msg.sector = (__u64) 0xdeadbeeffacef157ULL;
 	ioctl(-1, DM_TARGET_MSG, dm_arg_msg);
+	saved_errno = errno;
 	printf("ioctl(-1, DM_TARGET_MSG, "
 	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
-	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
-	       "{sector=%" PRI__u64 ", message=%p}}) "
-	       "= -1 EBADF (%m)\n",
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, ",
 	       sizeof(*dm_arg_msg) + 1,
-	       offsetof(struct dm_target_msg_test, msg),
+	       offsetof(struct dm_target_msg_test, msg));
+# if VERBOSE
+	printf("{sector=%" PRI__u64 ", message=%p}",
 	       (__u64) 0xdeadbeeffacef157ULL,
 	       (char *) dm_arg_msg +
 	       offsetof(struct dm_target_msg_test, msg.message));
+# else /* !VERBOSE */
+	printf("...");
+# endif /* VERBOSE */
+	errno = saved_errno;
+	printf("}) = -1 EBADF (%m)\n");
 
 	/* Zero-sied string */
 	init_s(&dm_arg_msg->ioc, sizeof(*dm_arg_msg),
 		offsetof(struct dm_target_msg_test, msg));
 	dm_arg_msg->msg.sector = (__u64) 0xdeadbeeffacef157ULL;
 	ioctl(-1, DM_TARGET_MSG, dm_arg_msg);
+	saved_errno = errno;
 	printf("ioctl(-1, DM_TARGET_MSG, "
 	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
-	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
-	       "{sector=%" PRI__u64 ", message=\"\"}}) "
-	       "= -1 EBADF (%m)\n",
-	       sizeof(*dm_arg_msg), offsetof(struct dm_target_msg_test, msg),
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, ",
+	       sizeof(*dm_arg_msg), offsetof(struct dm_target_msg_test, msg));
+# if VERBOSE
+	printf("{sector=%" PRI__u64 ", message=\"\"}",
 	       (__u64) 0xdeadbeeffacef157ULL);
+# else /* !VERBOSE */
+	printf("...");
+# endif /* VERBOSE */
+	errno = saved_errno;
+	printf("}) = -1 EBADF (%m)\n");
 
 
 	/* DM_DEV_SET_GEOMETRY */
@@ -547,7 +618,12 @@ main(void)
 	printf("ioctl(-1, DM_DEV_SET_GEOMETRY, "
 	       "{version=4.1.2, data_size=%u, data_start=%u, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
-	       "string=\"10 20 30 \"...}) = -1 EBADF (%m)\n",
+# if VERBOSE
+	       "string=\"10 20 30 \"..."
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
 	       s.ioc.data_size, s.ioc.data_start);
 
 
@@ -560,9 +636,18 @@ main(void)
 	printf("ioctl(-1, DM_DEV_RENAME, "
 	       "{version=4.1.2, data_size=%zu, data_start=%zu, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", event_nr=0, "
-	       "flags=0, string=%p}) = -1 EBADF (%m)\n",
-	       sizeof(*dm_arg), sizeof(*dm_arg) - sizeof(dm_arg->data),
-	       (char *) dm_arg + sizeof(*dm_arg) - sizeof(dm_arg->data));
+	       "flags=0, "
+# if VERBOSE
+	       "string=%p"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
+	       sizeof(*dm_arg), sizeof(*dm_arg) - sizeof(dm_arg->data)
+# if VERBOSE
+	       , (char *) dm_arg + sizeof(*dm_arg) - sizeof(dm_arg->data)
+# endif /* VERBOSE */
+	       );
 
 	/* Incorrect data_start data */
 	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
@@ -571,7 +656,13 @@ main(void)
 	printf("ioctl(-1, DM_DEV_RENAME, "
 	       "{version=4.1.2, data_size=%u, data_start=3735928559, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", event_nr=0, "
-	       "flags=0, /* misplaced string */}) = -1 EBADF (%m)\n",
+	       "flags=0, "
+# if VERBOSE
+	       "/* misplaced string */"
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
 	       s.ioc.data_size);
 
 	/* Strange but still valid data_start */
@@ -582,7 +673,13 @@ main(void)
 	printf("ioctl(-1, DM_DEV_RENAME, "
 	       "{version=4.1.2, data_size=%u, data_start=%zu, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", event_nr=0, "
-	       "flags=0, string=\"nn\"}) = -1 EBADF (%m)\n",
+	       "flags=0, "
+# if VERBOSE
+	       "string=\"nn\""
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
 	       s.ioc.data_size,
 	       offsetof(struct dm_ioctl, name) + 1);
 
@@ -593,7 +690,13 @@ main(void)
 	printf("ioctl(-1, DM_DEV_RENAME, "
 	       "{version=4.1.2, data_size=%u, data_start=%u, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", event_nr=0, "
-	       "flags=0, string=\"new long \"...}) = -1 EBADF (%m)\n",
+	       "flags=0, "
+# if VERBOSE
+	       "string=\"new long \"..."
+# else /* !VERBOSE */
+	       "..."
+# endif /* VERBOSE */
+	       "}) = -1 EBADF (%m)\n",
 	       s.ioc.data_size, s.ioc.data_start);
 
 
@@ -605,8 +708,11 @@ main(void)
 	       "{version=4.1.2, data_size=%u, data_start=%u, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
 	       "target_count=4294967295, flags=0, "
+# if VERBOSE
 	       "{sector_start=0, length=0, target_type=\"\", string=\"\"}, "
-	       "/* misplaced struct dm_target_spec */ ...}) = -1 EBADF (%m)\n",
+	       "/* misplaced struct dm_target_spec */ "
+# endif /* VERBOSE */
+	       "...}) = -1 EBADF (%m)\n",
 	       s.ioc.data_size, s.ioc.data_start);
 
 	puts("+++ exited with 0 +++");
diff --git a/tests/ioctl_dm.test b/tests/ioctl_dm.test
index 78866d3..6485205 100755
--- a/tests/ioctl_dm.test
+++ b/tests/ioctl_dm.test
@@ -5,7 +5,7 @@
 . "${srcdir=.}/init.sh"
 
 run_prog > /dev/null
-run_strace -a16 -s9 -veioctl $args > "$EXP"
+run_strace -a16 -s9 -eioctl $args > "$EXP"
 check_prog grep
 grep -v '^ioctl([012],' < "$LOG" > "$OUT"
 match_diff "$OUT" "$EXP"
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
