From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: delete trailing white spaces
Date: Sun, 10 Jul 2016 01:42:44 +0200
Message-ID: <1468107764-4086-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/dasd.c             | 2 +-
 kpartx/efi.h              | 4 ++--
 kpartx/lopart.c           | 4 ++--
 libmultipath/discovery.c  | 2 +-
 libmultipath/structs.h    | 4 ++--
 mpathpersist/Makefile     | 4 ++--
 mpathpersist/main.c       | 2 +-
 multipathd/cli_handlers.c | 4 ++--
 multipathd/main.c         | 2 +-
 9 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index 5342184..046a08b 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -112,7 +112,7 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 		 * major/minor into an openable device file, so we have
 		 * to create one for ourselves.
 		 */
-		
+
 		sprintf(pathname, "/dev/.kpartx-node-%u-%u",
 			(unsigned int)major(dev), (unsigned int)minor(dev));
 		if ((fd_dasd = open(pathname, O_RDONLY)) == -1) {
diff --git a/kpartx/efi.h b/kpartx/efi.h
index c66508e..af5660a 100644
--- a/kpartx/efi.h
+++ b/kpartx/efi.h
@@ -1,8 +1,8 @@
 /*
   efi.[ch] - Manipulates EFI variables as exported in /proc/efi/vars
- 
+
   Copyright (C) 2001 Dell Computer Corporation <Matt_Domsch@dell.com>
- 
+
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation; either version 2 of the License, or
diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index b35cbf4..4e0911f 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -76,9 +76,9 @@ is_loop_device (const char *device)
 	loopmajor = 0;
 
 	if ((procdev = fopen(PROC_DEVICES, "r")) != NULL) {
-		
+
 		while (fgets (line, sizeof(line), procdev)) {
-			
+
 			if ((cp = strstr (line, " loop\n")) != NULL) {
 				*cp='\0';
 				loopmajor=atoi(line);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 9fcede7..866a2ef 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1714,7 +1714,7 @@ pathinfo (struct path *pp, struct config *conf, int mask)
 			get_prio(pp);
 		}
 	}
-	
+
 	if ((mask & DI_ALL) == DI_ALL)
 		pp->initialized = INIT_OK;
 	return PATHINFO_OK;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index ab7dc25..9f216df 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -272,7 +272,7 @@ struct multipath {
 
 	/* checkers shared data */
 	void * mpcontext;
-	
+
 	/* persistent management data*/
 	unsigned char * reservation_key;
 	unsigned char prflag;
@@ -328,7 +328,7 @@ struct multipath * find_mp_by_alias (vector mp, char * alias);
 struct multipath * find_mp_by_wwid (vector mp, char * wwid);
 struct multipath * find_mp_by_str (vector mp, char * wwid);
 struct multipath * find_mp_by_minor (vector mp, int minor);
-	
+
 struct path * find_path_by_devt (vector pathvec, char * devt);
 struct path * find_path_by_dev (vector pathvec, char * dev);
 struct path * first_path (struct multipath * mpp);
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index df81372..a458c4d 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -14,13 +14,13 @@ all: $(EXEC)
 $(EXEC): $(OBJS)
 	$(CC) -g $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
-	
+
 install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
 	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
-	
+
 clean:
 	$(RM) *.o $(EXEC)
 	$(RM) mpathpersist.8.gz
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 5fb831e..953def5 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -423,7 +423,7 @@ int main (int argc, char * argv[])
 		struct prout_param_descriptor *paramp;
 
 		paramp= malloc(sizeof(struct prout_param_descriptor) + (sizeof(struct transportid *)*(MPATH_MX_TIDS )));
-		
+
 		memset(paramp, 0, sizeof(struct prout_param_descriptor) + (sizeof(struct transportid *)*(MPATH_MX_TIDS)));
 
 		for (j = 7; j >= 0; --j) {
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 2a54cba..9d97bac 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -127,7 +127,7 @@ show_maps_topology (char ** r, int * len, struct vectors * vecs)
 	char * reply;
 	unsigned int maxlen = INITIAL_REPLY_LEN;
 	int again = 1;
- 
+
 	get_path_layout(vecs->pathvec, 0);
 	reply = MALLOC(maxlen);
 
@@ -338,7 +338,7 @@ cli_list_map_topology (void * v, char ** reply, int * len, void * data)
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
-	
+
 	param = convert_dev(param, 0);
 	get_path_layout(vecs->pathvec, 0);
 	mpp = find_mp_by_str(vecs->mpvec, param);
diff --git a/multipathd/main.c b/multipathd/main.c
index c129298..754a855 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1520,7 +1520,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 			} else if (ret == PATHINFO_SKIPPED) {
 				put_multipath_config(conf);
 				return -1;
-			} 
+			}
 			put_multipath_config(conf);
 		}
 		return 0;
-- 
2.7.4
