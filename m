From: Dan Williams <dan.j.williams@intel.com>
Subject: [rfc patch] dm2md: activate dmraid arrays with md
Date: Mon, 26 Jan 2009 14:41:25 -0700
Message-ID: <1233006085.7799.8.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, NeilBrown <neilb@suse.de>, Heinz Mauelshagen <heinzm@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, dm-devel <dm-devel@redhat.com>, dm-raid <ataraid-list@redhat.com>
List-Id: dm-devel.ids

Subject: dm2md: activate dmraid arrays with md

From: Dan Williams <dan.j.williams@intel.com>

dm2md parses dmraid/dmsetup table entries and creates md devices with
matching parameters.  For example:

# dmraid -tay
isw_ifgbgihac_vol0: 0 613248 raid45 core 2 128 nosync raid5_la 1 128 4 4232814 /dev/sdb 0 /dev/sdc 0 /dev/sdd 0 /dev/sde 0
# dmraid -tay | dm2md
# ls -l /dev/md/isw_ifgbgihac_vol0
lrwxrwxrwx 1 root root 8 Jan 23 08:53 /dev/md/isw_ifgbgihac_vol0 -> ../md127
# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid10] [raid1] [raid0]
md127 : active (read-only) raid5 sde[3] sdd[2] sdc[1] sdb[0]
      306624 blocks super non-persistent level 5, 64k chunk, algorithm 0 [4/4] [UUUU]

The key difference between this and the upcoming external-metadata
support in mdadm-3.0 is that the metadata-type is set to
'non-persistent' rather than 'external'.  Non-persistent md arrays have
two caveats compared to external-metadata arrays:
1/ The kernel still notifies userspace on metadata events, but it does not
   wait for a response before continuing (this is similar to the current
   dmraid eventing implementation)
2/ Member devices can not be shared between multiple volumes.  This
   could be addressed in the kernel, but as dm2md is meant as a
   transitional tool the fix is to transition to mdadm.

Completing the example with mdadm's external metadata support:  When the
raid5 array is assembled mdmon is launched to manage an Intel container
and process metadata events on behalf of the kernel.

# mdadm -Ebs > mdadm.conf
# mdadm -Asc mdadm.conf
mdadm: Container /dev/md/imsm0 has been assembled with 4 drives
mdadm: Started /dev/md/vol0 with 4 devices
# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid10] [raid1] [raid0]
md_d127 : active (auto-read-only) raid5 sdb[3] sdc[2] sdd[1] sde[0]
      307200 blocks super external:/md127/0 level 5, 64k chunk, algorithm 0 [4/4] [UUUU]

md127 : inactive sde[3](S) sdb[2](S) sdc[1](S) sdd[0](S)
      9028 blocks super external:imsm

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
The goal of dm2md is to address the relative gaps in mdadm and dmraid.
While mdadm now has support for Intel and DDF metadata formats it lacks
the other formats supported by dmraid.  While dmraid has an out of tree
raid5 implementation it is lacking some of the features, and all of the
community's testing that has gone into the md raid5 driver.

dm2md affords dmraid the option to leverage the md raid kernel
infrastructure.  It is a step towards unifying the dmraid and mdraid
efforts.

This code is also available via git at:

	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/mdadm.git dm2md

It has only been lightly tested against a raid10 and raid5 Intel
metadata array, please consider this the initial proof-of-concept.  It
currently accesses /sys/dev/block which requires a kernel >= 2.6.27.

Regards,
Dan

 Makefile |   13 +
 dm2md.c  |  617 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 628 insertions(+), 2 deletions(-)
 create mode 100644 dm2md.c

diff --git a/Makefile b/Makefile
index 7f27aa4..ac746f2 100644
--- a/Makefile
+++ b/Makefile
@@ -91,6 +91,10 @@ MON_OBJS = mdmon.o monitor.o managemon.o util.o mdstat.o sysfs.o config.o \
 	super-ddf.o sha1.o crc32.o msg.o Monitor.o bitmap.o \
 	platform-intel.o probe_roms.o
 
+DM2MD_OBJS = dm2md.o mdopen.o util.o mdstat.o super0.o super1.o super-intel.o \
+	     super-ddf.o sha1.o crc32.o msg.o platform-intel.o probe_roms.o \
+	     sysfs.o config.o sg_io.o dlink.o ReadMe.o mapfile.o Kill.o \
+	     bitmap.o
 
 STATICSRC = pwgr.c
 STATICOBJS = pwgr.o
@@ -105,7 +109,7 @@ ASSEMBLE_SRCS += $(ASSEMBLE_AUTO_SRCS)
 ASSEMBLE_FLAGS += -DMDASSEMBLE_AUTO
 endif
 
-all : mdadm mdmon mdadm.man md.man mdadm.conf.man
+all : mdadm mdmon mdadm.man md.man mdadm.conf.man dm2md
 
 everything: all mdadm.static swap_super test_stripe \
 	mdassemble mdassemble.auto mdassemble.static mdassemble.man \
@@ -139,6 +143,9 @@ mdmon : $(MON_OBJS)
 	$(CC) $(LDFLAGS) -o mdmon $(MON_OBJS) $(LDLIBS)
 msg.o: msg.c msg.h
 
+dm2md : $(DM2MD_OBJS) mdadm.h
+	$(CC) $(LDFLAGS) -o dm2md $(DM2MD_OBJS) $(LDLIBS)
+
 test_stripe : restripe.c mdadm.h
 	$(CC) $(CXFLAGS) $(LDFLAGS) -o test_stripe -DMAIN restripe.c
 
@@ -185,6 +192,7 @@ sha1.o : sha1.c sha1.h md5.h
 install : mdadm mdmon install-man install-udev
 	$(INSTALL) -D $(STRIP) -m 755 mdadm $(DESTDIR)$(BINDIR)/mdadm
 	$(INSTALL) -D $(STRIP) -m 755 mdmon $(DESTDIR)$(BINDIR)/mdmon
+	$(INSTALL) -D $(STRIP) -m 755 dm2md $(DESTDIR)$(BINDIR)/dm2md
 
 install-static : mdadm.static install-man
 	$(INSTALL) -D $(STRIP) -m 755 mdadm.static $(DESTDIR)$(BINDIR)/mdadm
@@ -213,7 +221,8 @@ test: mdadm test_stripe swap_super
 	@echo "Please run 'sh ./test' as root"
 
 clean : 
-	rm -f mdadm mdmon $(OBJS) $(MON_OBJS) $(STATICOBJS) core *.man \
+	rm -f mdadm mdmon $(OBJS) $(MON_OBJS) $(STATICOBJS) $(DM2MD_OBJS) \
+	core *.man dm2md \
 	mdadm.tcc mdadm.uclibc mdadm.static *.orig *.porig *.rej *.alt \
 	mdadm.Os mdadm.O2 \
 	mdassemble mdassemble.static mdassemble.auto mdassemble.uclibc \
diff --git a/dm2md.c b/dm2md.c
new file mode 100644
index 0000000..5fba0e4
--- /dev/null
+++ b/dm2md.c
@@ -0,0 +1,617 @@
+/*
+ * dm2md - Activate dmraid tables with md
+ *
+ * Copyright (C) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+#define HAVE_STDINT_H 1
+#include "mdadm.h"
+#include "sha1.h"
+#include <stdio.h>
+#include <errno.h>
+#include <ctype.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+enum dm_target_type {
+	DMRAID45 = 0,
+	DMRAID1,
+	DMRAID0,
+};
+
+static const char *dm_targets[] = {
+	"raid45",
+	"mirror",
+	"striped",
+};
+
+static const int dm_target_cnt = sizeof(dm_targets) / sizeof(char *);
+
+struct member {
+	char *name;
+	char *offset;
+	unsigned long start_offset;
+	int major;
+	int minor;
+};
+
+struct dm2md_info {
+	char *name;
+	int level;
+	int dosync;
+	int layout;
+	int chunk_size;
+	int raid_disks;
+	unsigned long long component_size;
+	struct member *inf;
+};
+
+static struct member *parse_members(int num_members)
+{
+	struct member *m = calloc(num_members, sizeof(*m));
+	int i;
+	int rc;
+	struct stat st;
+	char *end;
+	char *tok;
+	char *last_off;
+	
+	if (!m) {
+		fprintf(stderr, "dm2md: failed to allocate %d members\n",
+			num_members);
+		return NULL;
+	}
+
+	for (i = 0; i < num_members * 2; i++) {
+		tok = strtok(NULL, " ");
+		if (!tok)
+			break;
+		if (i & 1)
+			m[i/2].offset = tok;
+		else
+			m[i/2].name = tok;
+	}
+	if (i < num_members * 2) {
+		fprintf(stderr, "dm2md: failed to parse member %d\n", i/2);
+		free(m);
+		return NULL;
+	}
+
+	/* all members should be valid block devices */
+	for (i = 0; i < num_members; i++) {
+		rc = stat(m[i].name, &st);
+		if (rc < 0) {
+			char *nm;
+
+			/* initial stat failed, but check to see if
+			 * /dev/mapper/ devices are available under
+			 * /dev/md/
+			 */
+			if (strncmp(m[i].name, "/dev/mapper/",
+			    strlen("/dev/mapper/")) != 0)
+				break;
+			nm = m[i].name + strlen("/dev/mapper/");
+			sprintf(m[i].name, "/dev/md/%s", nm);
+			i--;
+			continue; /* retry */
+		}
+		if (!S_ISBLK(st.st_mode))
+			break;
+		m[i].major = major(st.st_rdev);
+		m[i].minor = minor(st.st_rdev);
+	}
+	if (i < num_members) {
+		if (rc == 0)
+			fprintf(stderr, "dm2md: \'%s\' not a block device\n", m[i].name);
+		else
+			fprintf(stderr, "dm2md: \'%s\' stat failed\n", m[i].name);
+		free(m);
+		return NULL;
+	}
+
+	/* the last start offset may end in \n, chop it off */
+	last_off = m[num_members - 1].offset;
+	i = strlen(last_off);
+	if (last_off[i - 1] == '\n')
+		last_off[i - 1] = '\0';
+
+	/* convert and check start offsets */
+	for (i = 0; i < num_members; i++) {
+		m[i].start_offset = strtoul(m[i].offset, &end, 10);
+		if (end == m[i].offset || *end != '\0')
+			break;
+	}
+	if (i < num_members) {
+		fprintf(stderr, "dm2md: invalid start offset for member%d \'%s\'\n",
+			i, m[i].offset);
+		free(m);
+		return NULL;
+	}
+
+	return m;
+}
+
+static int dm2md_raid5_layout(char *layout)
+{
+	if (strcmp(layout, "raid5_la") == 0)
+		return ALGORITHM_LEFT_ASYMMETRIC;
+	else if (strcmp(layout, "raid5_ra") == 0)
+		return ALGORITHM_RIGHT_ASYMMETRIC;
+	else if (strcmp(layout, "raid5_ls") == 0)
+		return ALGORITHM_LEFT_SYMMETRIC;
+	else if (strcmp(layout, "raid5_rs") == 0)
+		return ALGORITHM_RIGHT_SYMMETRIC;
+	else
+		return -1;
+}
+
+static void uuid_from_dm(struct dm2md_info *d2m, int uuid[4])
+{
+	char buf[20];
+	struct sha1_ctx ctx;
+
+	sha1_init_ctx(&ctx);
+	sha1_process_bytes(d2m->name, strlen(d2m->name), &ctx);
+	sha1_finish_ctx(&ctx, buf);
+	memcpy(uuid, buf, 4*4);
+}
+
+static int assemble(struct dm2md_info *d2m)
+{
+	int mdfd;
+	char buf[100];
+	char path[30];
+	char chosen_name[500];
+	struct mdinfo mdi;
+	struct mdinfo *sra;
+	int uuid[4];
+	int i;
+	int rc = 0;
+	unsigned long long resync_start = d2m->dosync ? 0 : ~0ULL;
+	struct map_ent *map = NULL;
+
+	sprintf(buf, "/dev/md/%s", d2m->name);
+
+	map_lock(&map);
+	mdfd = create_mddev(buf, d2m->name, 3, LOCAL, chosen_name);
+	if (mdfd < 0) {
+		fprintf(stderr, "dm2md: failed to open %s (%s)\n",
+			buf, strerror(errno));
+		free(d2m->inf);
+		map_unlock(&map);
+		return 1;
+	}
+	uuid_from_dm(d2m, uuid);
+	map_update(&map, fd2devnum(mdfd), "none", uuid, chosen_name);
+	map_unlock(&map);
+
+	sra = sysfs_read(mdfd, fd2devnum(mdfd), GET_VERSION);
+	rc |= sysfs_set_num(sra, NULL, "chunk_size", d2m->chunk_size);
+	rc |= sysfs_set_num(sra, NULL, "layout", d2m->layout);
+	sprintf(buf, "raid%d", d2m->level);
+	rc |= sysfs_set_str(sra, NULL, "level", buf);
+	rc |= sysfs_set_str(sra, NULL, "metadata_version", "none");
+	rc |= sysfs_set_num(sra, NULL, "raid_disks", d2m->raid_disks);
+	rc |= sysfs_set_num(sra, NULL, "component_size", d2m->component_size/2);
+	if (d2m->level > 0)
+		rc |= sysfs_set_num(sra, NULL, "resync_start", resync_start);
+
+	for (i = 0; i < d2m->raid_disks; i++) {
+		struct member *m = &d2m->inf[i];
+		int rv;
+		char *nm;
+
+		sprintf(buf, "%d:%d", m->major, m->minor);
+		rc |= sysfs_set_str(sra, NULL, "new_dev", buf);
+		sprintf(path, "/sys/dev/block/%d:%d",
+			m->major, m->minor);
+		rv = readlink(path, buf, sizeof(buf) - 1);
+		if (rv <= 0) {
+			rc |= -1;
+			break;
+		}
+		buf[rv] = '\0';
+		nm = strrchr(buf, '/');
+		if (!nm) {
+			rc |= -1;
+			break;
+		}
+		nm++;
+		sprintf(mdi.sys_name, "dev-%s", nm);
+		rc |= sysfs_set_num(sra, &mdi, "offset", m->start_offset);
+		rc |= sysfs_set_num(sra, &mdi, "slot", i);
+		rc |= sysfs_set_num(sra, &mdi, "size", (d2m->component_size+1)/2);
+	}
+	if (rc || sysfs_set_str(sra, NULL, "array_state", "readonly")) {
+		fprintf(stderr, "dm2md: failed to start array\n");
+		rc = 1;
+	} else {
+		wait_for(chosen_name);
+		rc = 0;
+	}
+	sysfs_free(sra);
+	free(d2m->inf);
+	close(mdfd);
+
+	return rc;
+}
+
+static int dmraid0(char *name, unsigned long long array_size)
+{
+	char *tok;
+	int i;
+	char *num;
+	char *end;
+	char *bps;
+	unsigned long blocks_per_strip;
+	unsigned long num_members;
+	struct member *dev_info;
+	struct dm2md_info d2m;
+
+	for (i = 0; i < 2; i++) {
+		tok = strtok(NULL, " ");	
+		if (!tok)
+			break;
+		if (i == 0)
+			num = tok;
+		else if (i == 1)
+			bps = tok;
+	}
+	if (i < 2) {
+		fprintf(stderr, "dm2md: %s failed to retrieve field %d\n",
+			__func__, i+4);
+		return 1;
+	}
+	blocks_per_strip = strtoul(bps, &end, 10);
+	if (bps == end || *end != '\0') {
+		fprintf(stderr, "dm2md: %s invalid blocks per strip \'%s\'\n",
+			__func__, bps);
+		return 1;
+	}
+	num_members = strtoul(num, &end, 10);
+	if (num == end || *end != '\0') {
+		fprintf(stderr, "dm2md: %s invalid number of members \'%s\'\n",
+			__func__, num);
+		return 1;
+	}
+
+	dev_info = parse_members(num_members);
+	if (!dev_info)
+		return 1;
+
+	do {
+		d2m.name = name;
+		d2m.level = 0;
+		d2m.layout = 0;
+		d2m.chunk_size = (blocks_per_strip / 2) * 1024;
+		if (d2m.chunk_size != (blocks_per_strip / 2) * 1024)
+			break;
+		d2m.raid_disks = num_members;
+		if (d2m.raid_disks != num_members)
+			break;
+		d2m.component_size = array_size / num_members;
+		d2m.inf = dev_info;
+
+		return assemble(&d2m);
+	} while (0);
+
+	fprintf(stderr, "dm2md: %s conversion error chunk: %lu disks: %lu\n",
+		__func__, (blocks_per_strip / 2) * 1024, num_members);
+	free(dev_info);
+
+	return 1;
+}
+
+static int dmraid1(char *name, unsigned long long array_size)
+{
+	char *tok;
+	int i;
+	char *log;
+	unsigned long log_region_size;
+	char *sync;
+	char *num;
+	char *end;
+	unsigned long num_members;
+	struct member *dev_info;
+	struct dm2md_info d2m;
+
+	for (i = 0; i < 5; i++) {
+		tok = strtok(NULL, " ");	
+		if (!tok)
+			break;
+		if (i == 0 && strcmp(tok, "core") != 0)
+			break;
+		else if (i == 1 && strcmp(tok, "2") != 0)
+			break;
+		else if (i == 2)
+			log = tok;
+		else if (i == 3)
+			sync = tok;
+		else if (i == 4)
+			num = tok;
+	}
+	if (i < 5) {
+		fprintf(stderr, "dm2md: %s failed to retrieve field %d\n",
+			__func__, i+4);
+		return 1;
+	}
+	log_region_size = strtoul(log, &end, 10);
+	if (log == end || *end != '\0') {
+		fprintf(stderr, "dm2md: %s invalid log region size \'%s\'\n",
+			__func__, log);
+		return 1;
+	}
+	if (strcmp(sync, "sync") != 0 && strcmp(sync, "nosync") != 0) {
+		fprintf(stderr, "dm2md: %s invalid sync field \'%s\'\n",
+			__func__, sync);
+		return 1;
+	}
+	num_members = strtoul(num, &end, 10);
+	if (num == end || *end != '\0') {
+		fprintf(stderr, "dm2md: %s invalid number of members \'%s\'\n",
+			__func__, num);
+		return 1;
+	}
+
+	dev_info = parse_members(num_members);
+	if (!dev_info)
+		return 1;
+
+	do {
+		d2m.name = name;
+		d2m.level = 1;
+		d2m.layout = 0;
+		d2m.dosync = strcmp(sync, "sync") == 0;
+		d2m.chunk_size = 65536;
+		d2m.raid_disks = num_members;
+		if (d2m.raid_disks != num_members)
+			break;
+		d2m.component_size = array_size;
+		d2m.inf = dev_info;
+
+		return assemble(&d2m);
+	} while (0);
+
+	fprintf(stderr, "dm2md: %s conversion error disks: %lu\n",
+		__func__, num_members);
+	free(dev_info);
+
+	return 1;
+}
+
+
+/* sample line and fields:
+ * isw_iageiijgf_Volume0: 0 41943552 raid45 core 2 8192
+ * 	nosync raid5_la 1 128 4 4232814
+ * 	/dev/sdb 0 /dev/sdc 0 /dev/sdd 0 /dev/sde 0
+ * device name: 0 array_size target core 2 log_region_size
+ * 	(no)sync raid5_[l|r][a|s] 1 blocks_per_strip num_members failed_disk_number
+ * 	(member start_offset)[num_members]
+ */
+static int dmraid45(char *name, unsigned long long array_size)
+{
+	char *log;
+	unsigned long log_region_size;
+	char *sync;
+	char *layout;
+	char *bps;
+	unsigned long blocks_per_strip;
+	char *num;
+	unsigned long num_members;
+	char *failed;
+	unsigned long failed_info;
+	char *tok;
+	int i;
+	char *end;
+	struct member *dev_info;
+	struct dm2md_info d2m;
+
+	for (i = 0; i < 9; i++) {
+		tok = strtok(NULL, " ");	
+		if (!tok)
+			break;
+		if (i == 0 && strcmp(tok, "core") != 0)
+			break;
+		else if (i == 1 && strcmp(tok, "2") != 0)
+			break;
+		else if (i == 2)
+			log = tok;
+		else if (i == 3)
+			sync = tok;
+		else if (i == 4)
+			layout = tok;
+		else if (i == 5 && strcmp(tok, "1") != 0)
+			break;
+		else if (i == 6)
+			bps = tok;
+		else if (i == 7)
+			num = tok;
+		else if (i == 8)
+			failed = tok;
+	}
+	if (i < 9) {
+		fprintf(stderr, "dm2md: %s failed to retrieve field %d\n",
+			__func__, i+4);
+		return 1;
+	}
+
+	log_region_size = strtoul(log, &end, 10);
+	if (log == end || *end != '\0') {
+		fprintf(stderr, "dm2md: %s invalid log region size \'%s\'\n",
+			__func__, log);
+		return 1;
+	}
+	if (strcmp(sync, "sync") != 0 && strcmp(sync, "nosync") != 0) {
+		fprintf(stderr, "dm2md: %s invalid sync field \'%s\'\n",
+			__func__, sync);
+		return 1;
+	}
+	if (strcmp(layout, "raid5_la") != 0 &&
+	    strcmp(layout, "raid5_ra") != 0 &&
+	    strcmp(layout, "raid5_ls") != 0 &&
+	    strcmp(layout, "raid5_rs") != 0) {
+		fprintf(stderr, "dm2md: %s invalid layout field \'%s\'\n",
+			__func__, layout);
+		return 1;
+	}
+	blocks_per_strip = strtoul(bps, &end, 10);
+	if (bps == end || *end != '\0') {
+		fprintf(stderr, "dm2md: %s invalid blocks per strip \'%s\'\n",
+			__func__, bps);
+		return 1;
+	}
+	num_members = strtoul(num, &end, 10);
+	if (num == end || *end != '\0') {
+		fprintf(stderr, "dm2md: %s invalid number of members \'%s\'\n",
+			__func__, num);
+		return 1;
+	}
+	failed_info = strtoul(failed, &end, 10);
+	if (failed == end || *end != '\0') {
+		fprintf(stderr, "dm2md: %s invalid failed info \'%s\'\n",
+			__func__, failed);
+		return 1;
+	}
+
+	dev_info = parse_members(num_members);
+	if (!dev_info)
+		return 1;
+
+	do {
+		d2m.name = name;
+		d2m.level = 5;
+		d2m.layout = dm2md_raid5_layout(layout);
+		d2m.dosync = strcmp(sync, "sync") == 0;
+		if (d2m.layout < 0)
+			break;
+		d2m.chunk_size = (blocks_per_strip / 2) * 1024;
+		if (d2m.chunk_size != (blocks_per_strip / 2) * 1024)
+			break;
+		d2m.raid_disks = num_members;
+		if (d2m.raid_disks != num_members)
+			break;
+		d2m.component_size = array_size / (num_members - 1);
+		d2m.inf = dev_info;
+
+		return assemble(&d2m);
+	} while (0);
+
+	fprintf(stderr, "dm2md: %s conversion error layout: %s chunk: %lu disks: %lu\n",
+		__func__, layout, (blocks_per_strip / 2) * 1024, num_members);
+	free(dev_info);
+
+	return 1;
+}
+
+static int handle_table_ent(char *line)
+{
+	char *name;
+	char *size;
+	unsigned long long array_size;
+	char *type;
+	char *tok;
+	char *end;
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		tok = strtok(i ? NULL : line, " ");
+		if (!tok)
+			break;
+		if (i == 0)
+			name = tok;
+		else if (i == 1 && *tok != '0')
+			break;
+		else if (i == 2)
+			size = tok;
+		else if (i == 3)
+			type = tok;
+	}
+	if (i < 4) {
+		fprintf(stderr, "dm2md: failed to determine dmraid type\n");
+		return 1;
+	}
+
+	if (name[strlen(name) - 1] != ':') {
+		fprintf(stderr, "dm2md: invalid name field \'%s\'\n", name);
+		return 1;
+	}
+	name[strlen(name) - 1] = '\0';
+
+	array_size = strtoull(size, &end, 10);
+	if (end == size || *end != '\0') {
+		fprintf(stderr, "dm2md: invalid size \'%s\'\n", size);
+		return 1;
+	}
+	
+	for (i = 0; i < dm_target_cnt; i++)
+		if (strcmp(type, dm_targets[i]) == 0)
+			switch (i) {
+			case DMRAID45:
+				return dmraid45(name, array_size);
+			case DMRAID1:
+				return dmraid1(name, array_size);
+			case DMRAID0:
+				return dmraid0(name, array_size);
+			default:
+				/* can't happen */
+				return 1;
+			}
+
+	fprintf(stderr, "dm2md: \'%s\' not a valid dmraid type\n", type);
+
+	return 1;
+}
+
+int main(int argc, char *argv[])
+{
+	char *line = NULL;
+	FILE *table;
+	int rc;
+	size_t n;
+
+	if (argc == 1)
+		table = stdin;
+	else if (argc == 2) {
+		table = fopen(argv[1], "r");
+		if (!table) {
+			fprintf(stderr, "dm2md: failed to open %s (%s)\n",
+				argv[1], strerror(errno));
+			return 1;
+		}
+	} else {
+		fprintf(stderr, "usage: dmraid -tay | dm2md\n");
+		fprintf(stderr, "   - or -\n");
+		fprintf(stderr, "usage: dm2md <dmraid_table>\n");
+		return 1;
+	}
+
+	while (getline(&line, &n, table) > 0) {
+		if (line[0] != '#')
+			rc = handle_table_ent(line);
+		else
+			rc = 0;
+		if (line) {
+			free(line);
+			line = NULL;
+		}
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+


