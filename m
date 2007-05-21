From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 19/21] [kpartx] Update extended partition handling
Date: Mon, 21 May 2007 11:24:23 +0200
Message-ID: <20070521092423.A7E8FD44CF@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Currently we don't handle extended partitions at all.
This patch implements a proper handling for extended partitions so that we
first create the dm device for the extended partitions and then the logical
partitions as dm devices on top of the device for the extended partition.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/devmapper.c |   29 ++++++++++
 kpartx/devmapper.h |    1 +
 kpartx/dos.c       |    7 +--
 kpartx/kpartx.c    |  153 ++++++++++++++++++++++++++++++++++++++++-----------
 kpartx/kpartx.h    |    3 +
 5 files changed, 156 insertions(+), 37 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 4b228ed..6cbb8eb 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -219,3 +219,32 @@ out:
 	dm_task_destroy(dmt);
 	return uuid;
 }
+
+int
+dm_devn (char * mapname, int *major, int *minor)
+{
+	int r = 1;
+	struct dm_task *dmt;
+	struct dm_info info;
+
+	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
+		return 0;
+
+	if (!dm_task_set_name(dmt, mapname))
+		goto out;
+
+	if (!dm_task_run(dmt))
+		goto out;
+
+	if (!dm_task_get_info(dmt, &info))
+		goto out;
+
+	*major = info.major;
+	*minor = info.minor;
+
+	r = 0;
+out:
+	dm_task_destroy(dmt);
+	return r;
+}
+
diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
index e20e456..ccdbead 100644
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -6,3 +6,4 @@ int dm_map_present (char *);
 char * dm_mapname(int major, int minor);
 dev_t dm_get_first_dep(char *devname);
 char * dm_mapuuid(int major, int minor);
+int dm_devn (char * mapname, int *major, int *minor);
diff --git a/kpartx/dos.c b/kpartx/dos.c
index a707423..1691105 100644
--- a/kpartx/dos.c
+++ b/kpartx/dos.c
@@ -16,7 +16,7 @@ is_extended(int type) {
 }
 
 static int
-read_extended_partition(int fd, struct partition *ep,
+read_extended_partition(int fd, struct partition *ep, int en,
 			struct slice *sp, int ns)
 {
 	struct partition p;
@@ -53,6 +53,7 @@ read_extended_partition(int fd, struct p
 			if (n < ns) {
 				sp[n].start = here + le32_to_cpu(p.start_sect);
 				sp[n].size = le32_to_cpu(p.nr_sects);
+				sp[n].container = en + 1;
 				n++;
 			} else {
 				fprintf(stderr,
@@ -97,9 +98,7 @@ read_dos_pt(int fd, struct slice all, st
 			break;
 		}
 		if (is_extended(p.sys_type)) {
-			n += read_extended_partition(fd, &p, sp+n, ns-n);
-			/* hide the extended partition itself */
-			sp[i].size = 0;
+			n += read_extended_partition(fd, &p, i, sp+n, ns-n);
 		}
 	}
 	return n;
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index b406b95..48169f1 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -115,7 +115,7 @@ strip_slash (char * device)
 	char * p = device;
 
 	while (*(p++) != 0x0) {
-		
+
 		if (*p == '/')
 			*p = '!';
 	}
@@ -125,9 +125,9 @@ static int
 find_devname_offset (char * device)
 {
 	char *p, *q = NULL;
-	
+
 	p = device;
-	
+
 	while (*p++)
 		if (*p == '/')
 			q = p;
@@ -182,7 +182,7 @@ get_hotplug_device(void)
 
 int
 main(int argc, char **argv){
-        int fd, i, j, k, n, op, off, arg;
+	int fd, i, j, k, m, n, op, off, arg, c, d;
 	struct slice all;
 	struct pt *ptp;
 	enum action what = LIST;
@@ -205,7 +205,7 @@ main(int argc, char **argv){
 	type = device = diskdevice = NULL;
 	memset(&all, 0, sizeof(all));
 	memset(&partname, 0, sizeof(partname));
-	
+
 	/* Check whether hotplug mode. */
 	progname = strrchr(argv[0], '/');
 
@@ -291,7 +291,7 @@ main(int argc, char **argv){
 
 		if (!loopdev && what == DELETE)
 			exit (0);
-				
+
 		if (!loopdev) {
 			loopdev = find_unused_loop_device();
 
@@ -308,7 +308,7 @@ main(int argc, char **argv){
 		memset(delim, 0, DELIM_SIZE);
 		set_delimiter(device, delim);
 	}
-	
+
 	off = find_devname_offset(device);
 
 	if (!loopdev) {
@@ -320,7 +320,7 @@ main(int argc, char **argv){
 
 	if (!uuid)
 		uuid = device + off;
-		
+
 	if (!mapname)
 		mapname = device + off;
 
@@ -339,7 +339,7 @@ main(int argc, char **argv){
 
 		if (type && strcmp(type, ptp->type))
 			continue;
-		
+
 		/* here we get partitions */
 		n = ptp->fn(fd, all, slices, SIZE(slices));
 
@@ -353,30 +353,47 @@ main(int argc, char **argv){
 		else
 			continue;
 
-		/*
-		 * test for overlap, as in the case of an extended partition
-		 * zero their size to avoid mapping
-		 */
-		for (j=0; j<n; j++) {
-			for (k=j+1; k<n; k++) {
-				if (slices[k].start > slices[j].start &&
-				    slices[k].start < slices[j].start +
-				    slices[j].size)
-					slices[j].size = 0;
-			}
-		}
-
 		switch(what) {
 		case LIST:
-			for (j = 0; j < n; j++) {
+			for (j = 0, c = 0, m = 0; j < n; j++) {
 				if (slices[j].size == 0)
 					continue;
+				if (slices[j].container > 0) {
+					c++;
+					continue;
+				}
+
+				slices[j].minor = m++;
 
 				printf("%s%s%d : 0 %lu %s %lu\n",
-					mapname, delim, j+1,
-					(unsigned long) slices[j].size, device,
-				        (unsigned long) slices[j].start);
+				       mapname, delim, j+1,
+				       (unsigned long) slices[j].size, device,
+				       (unsigned long) slices[j].start);
+			}
+			/* Loop to resolve contained slices */
+			d = c;
+			while (c) {
+				for (j = 0; j < n; j++) {
+					if (slices[j].size == 0)
+						continue;
+					if (slices[j].minor > 0)
+						continue;
+					if (slices[j].container == 0)
+						continue;
+					slices[j].minor = m++;
+
+					printf("%s%s%d : 0 %lu /dev/dm-%d %lu\n",
+					       mapname, delim, j+1,
+					       (unsigned long) slices[j].size,
+					       slices[j].minor,
+					       (unsigned long) slices[j].start);
+					c--;
+				}
+				/* Terminate loop if nothing more to resolve */
+				if (d == c)
+					break;
 			}
+
 			break;
 
 		case DELETE:
@@ -401,7 +418,7 @@ main(int argc, char **argv){
 			if (S_ISREG (buf.st_mode)) {
 				if (del_loop(device)) {
 					if (verbose)
-				    		printf("can't del loop : %s\n",
+						printf("can't del loop : %s\n",
 							device);
 					exit(1);
 				}
@@ -410,17 +427,23 @@ main(int argc, char **argv){
 			break;
 
 		case ADD:
-			for (j=0; j<n; j++) {
+			for (j=0, c = 0; j<n; j++) {
 				if (slices[j].size == 0)
 					continue;
 
+				/* Skip all contained slices */
+				if (slices[j].container > 0) {
+					c++;
+					continue;
+				}
+
 				if (safe_sprintf(partname, "%s%s%d",
 					     mapname, delim, j+1)) {
 					fprintf(stderr, "partname too small\n");
 					exit(1);
 				}
 				strip_slash(partname);
-				
+
 				if (safe_sprintf(params, "%s %lu", device,
 					     (unsigned long)slices[j].start)) {
 					fprintf(stderr, "params too small\n");
@@ -437,10 +460,74 @@ main(int argc, char **argv){
 					dm_simplecmd(DM_DEVICE_RESUME,
 							partname);
 
+				dm_devn(partname, &slices[j].major,
+					&slices[j].minor);
+
 				if (verbose)
-					printf("add map %s : 0 %lu %s %s\n",
-						partname, slices[j].size,
-						DM_TARGET, params);
+					printf("add map %s (%d:%d): 0 %lu %s %s\n",
+					       partname, slices[j].major,
+					       slices[j].minor, slices[j].size,
+					       DM_TARGET, params);
+			}
+			/* Loop to resolve contained slices */
+			d = c;
+			while (c) {
+				for (j = 0; j < n; j++) {
+					int k = slices[j].container - 1;
+
+					if (slices[j].size == 0)
+						continue;
+
+					/* Skip all existing slices */
+					if (slices[j].minor > 0)
+						continue;
+
+					/* Skip all simple slices */
+					if (k < 0)
+						continue;
+
+					/* Check container slice */
+					if (slices[k].size == 0)
+						fprintf(stderr, "Invalid slice %d\n",
+							k);
+
+					if (safe_sprintf(partname, "%s%s%d",
+							 mapname, delim, j+1)) {
+						fprintf(stderr, "partname too small\n");
+						exit(1);
+					}
+					strip_slash(partname);
+
+					if (safe_sprintf(params, "%d:%d %lu",
+							 slices[k].major,
+							 slices[k].minor,
+							 (unsigned long)slices[j].start)) {
+						fprintf(stderr, "params too small\n");
+						exit(1);
+					}
+
+					op = (dm_map_present(partname) ?
+					      DM_DEVICE_RELOAD : DM_DEVICE_CREATE);
+
+					dm_addmap(op, partname, DM_TARGET, params,
+						  slices[j].size, uuid, j+1);
+
+					if (op == DM_DEVICE_RELOAD)
+						dm_simplecmd(DM_DEVICE_RESUME,
+							     partname);
+
+					dm_devn(partname, &slices[j].major,
+						&slices[j].minor);
+
+					if (verbose)
+						printf("add map %s : 0 %lu %s %s\n",
+						       partname, slices[j].size,
+						       DM_TARGET, params);
+					c--;
+				}
+				/* Terminate loop */
+				if (d == c)
+					break;
 			}
 			break;
 
@@ -516,7 +603,7 @@ getblock (int fd, unsigned int secnr) {
 	bp->next = blockhead;
 	blockhead = bp;
 	bp->block = (char *) xmalloc(READ_SIZE);
-	
+
 	if (read(fd, bp->block, READ_SIZE) != READ_SIZE) {
 		fprintf(stderr, "read error, sector %d\n", secnr);
 		bp->block = NULL;
diff --git a/kpartx/kpartx.h b/kpartx/kpartx.h
index 6a715de..b49c543 100644
--- a/kpartx/kpartx.h
+++ b/kpartx/kpartx.h
@@ -22,6 +22,9 @@
 struct slice {
 	unsigned long start;
 	unsigned long size;
+	int container;
+	int major;
+	int minor;
 };
 
 typedef int (ptreader)(int fd, struct slice all, struct slice *sp, int ns);
-- 
1.4.3.4
