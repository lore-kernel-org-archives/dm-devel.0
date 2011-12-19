From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: [RFC][PATCH 1/3] persistent management feature for
	multipath-tools
Date: Mon, 19 Dec 2011 22:04:35 +0530
Message-ID: <EE2129A8E578DC4E94D643D6C1C1C67D078966D0@BTCMVEXC2-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@free.fr
Cc: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>, "Dachepalli,
	Sudhir" <Sudhir.Dachepalli@netapp.com>, "Moger,
	Babu" <Babu.Moger@netapp.com>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>
List-Id: dm-devel.ids

This patch adds new cli utility 'mpathpersist' in multipath-tools for mpath persistent management. 
 
Signed-off-by: Vijay Chauhan <Vijay.chauhan@netapp.com>
Reviewed-by: Bob Stankey <Robert.stankey@netapp.com> 
Reviewed-by: Babu Moger <Babu.moger@netapp.com>
Reviewed-by: Yanling Q <Yanling.Q@netapp.com>
---
diff -uprN multipath-tools-orig/libmpathpersist/Makefile multipath-tools/libmpathpersist/Makefile
--- multipath-tools-orig/libmpathpersist/Makefile	1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools/libmpathpersist/Makefile	2011-12-20 00:15:04.000000000 +0530
@@ -0,0 +1,51 @@
+# Makefile
+#
+BUILD = glibc
+include ../Makefile.inc
+
+INSTALL_PROGRAM = install
+
+SONAME=0
+DEVLIB = libmpathpersist.so
+LIBS = $(DEVLIB).$(SONAME)
+
+
+CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) 
+LIBDEPS +=  -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath -lsysfs
+
+OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o 
+
+all: $(LIBS)
+
+
+$(LIBS): 
+	$(CC) -Wall -fPIC -c $(CFLAGS) *.c 
+	$(CC)  -shared $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
+	ln -s $(LIBS) $(DEVLIB)
+	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz	
+	$(GZIP) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz	
+
+install: $(LIBS)
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
+	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
+	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(syslibdir)
+	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(man3dir)
+	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)/usr/include/
+	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)/usr/share/doc/mpathpersist/
+	ln -sf $(DESTDIR)$(syslibdir)/$(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
+	install -m 644 mpath_persistent_reserve_in.3.gz $(DESTDIR)$(man3dir)	
+	install -m 644 mpath_persistent_reserve_out.3.gz $(DESTDIR)$(man3dir)	
+	install -m 644 mpath_persist.h $(DESTDIR)/usr/include/
+	install -m 644 README $(DESTDIR)/usr/share/doc/mpathpersist/
+
+uninstall:
+	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
+	rm $(DESTDIR)$(mandir)/mpath_persistent_reserve_in.3.gz	
+	rm $(DESTDIR)$(mandir)/mpath_persistent_reserve_out.3.gz	
+	rm $(DESTDIR)/usr/share/doc/mpathpersist/README
+
+clean:
+	rm -f core *.a *.o 
+	rm -f libmpathpersist.so.0
+	rm -f libmpathpersist.so
+	rm -f mpath_persistent_reserve_in.3.gz mpath_persistent_reserve_out.3.gz
diff -uprN multipath-tools-orig/libmpathpersist/mpath_persist.c multipath-tools/libmpathpersist/mpath_persist.c
--- multipath-tools-orig/libmpathpersist/mpath_persist.c	1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools/libmpathpersist/mpath_persist.c	2011-12-20 00:15:04.000000000 +0530
@@ -0,0 +1,897 @@
+#include "mpath_persist.h"
+#include <libdevmapper.h>
+#include <defaults.h>
+#include <sys/stat.h>
+#include <linux/kdev_t.h>
+#include <fcntl.h>
+#include <vector.h>
+#include <checkers.h>
+#include <structs.h>
+#include <structs_vec.h>
+
+#include <prio.h>
+#include <unistd.h>
+#include <devmapper.h>
+#include <debug.h>
+#include <config.h>
+#include <switchgroup.h>
+#include <discovery.h>
+#include <dmparser.h>
+#include <ctype.h>
+#include <propsel.h>
+#include <sysfs.h>
+
+#include "mpathpr.h"
+#include "mpath_pr_ioctl.h"
+
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#define __STDC_FORMAT_MACROS 1
+
+
+int
+mpath_lib_init (void)
+{
+	if (load_config(DEFAULT_CONFIGFILE)){
+		condlog(0, "Failed to initialize multipath config.");
+		return 1;
+	}
+
+	if (sysfs_init(conf->sysfs_dir, FILE_NAME_SIZE)){
+		condlog(0, "Failed. mpathpersist needs sysfs mounted");
+		exit(1);
+	}
+	return 0;
+}
+
+int
+mpath_lib_exit (void)
+{
+	dm_lib_release();
+	dm_lib_exit();
+	cleanup_prio();
+	cleanup_checkers();
+	free_config(conf);
+	conf = NULL;
+	return 0;
+}
+
+static int
+updatepaths (struct multipath * mpp)
+{
+	int i, j;
+	struct pathgroup * pgp;
+	struct path * pp;
+
+	if (!mpp->pg)
+		return 0;
+
+	vector_foreach_slot (mpp->pg, pgp, i){
+		if (!pgp->paths)
+			continue;
+
+		vector_foreach_slot (pgp->paths, pp, j){
+			if (!strlen(pp->dev)){
+				if (devt2devname(pp->dev, FILE_NAME_SIZE,
+							pp->dev_t)){
+					/*
+					 * path is not in sysfs anymore
+					 */
+					pp->state = PATH_DOWN;
+					continue;
+				}
+				pp->mpp = mpp;
+				pathinfo(pp, conf->hwtable, DI_ALL);
+				continue;
+			}
+			pp->mpp = mpp;
+			if (pp->state == PATH_UNCHECKED ||
+					pp->state == PATH_WILD)
+				pathinfo(pp, conf->hwtable, DI_CHECKER);
+
+			if (pp->priority == PRIO_UNDEF)
+				pathinfo(pp, conf->hwtable, DI_PRIO);
+		}
+	}
+	return 0;
+}
+
+int 
+mpath_prin_activepath (struct multipath *mpp, int rq_servact,
+	struct prin_resp * resp, int noisy)
+{
+	int i,j, ret;
+	struct pathgroup *pgp = NULL;
+	struct path *pp = NULL;
+	char dev[FILE_NAME_SIZE];
+
+	vector_foreach_slot (mpp->pg, pgp, j){
+		vector_foreach_slot (pgp->paths, pp, i){
+			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
+				condlog(2, "%s: %s not available. Skip.", mpp->wwid, dev);
+				condlog(3, "%s: status = %d.", mpp->wwid, pp->state);
+				continue;
+			}
+
+			condlog(3, "%s: sending PR IN command to %s ", mpp->wwid, dev);
+			ret = mpath_send_prin_activePath(pp->dev, rq_servact, resp, noisy);
+			return ret ;
+		}
+	}
+	return MPATH_PR_DMMP_ERROR;	
+}
+
+int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp *resp, int noisy, int verbose)
+{
+	struct stat info;
+	vector curmp = NULL;
+	vector pathvec = NULL;
+	char * alias;
+	struct multipath * mpp;
+	int map_present;
+	int major, minor;
+	int ret;
+
+	conf->verbosity = verbose;
+
+	if (fstat( fd, &info) != 0){
+		condlog(0, "stat error %d", fd);
+		return MPATH_PR_FILE_ERROR;
+	} 
+	if(!S_ISBLK(info.st_mode)){
+		condlog(0, "Failed to get major:minor. fd = %d", fd);
+		return MPATH_PR_FILE_ERROR;
+	}
+
+	major = (int)MAJOR(info.st_rdev);
+	minor = (int)MINOR(info.st_rdev);	
+	condlog(4, "Device %d:%d:  ", major, minor);
+
+	/* get alias from major:minor*/
+	alias = dm_mapname(major, minor);
+	if (!alias){
+		condlog(0, "%d:%d failed to get device alias.", major, minor);
+		return MPATH_PR_DMMP_ERROR;
+	}
+
+	condlog(3, "alias = %s", alias);
+	map_present = dm_map_present(alias);
+	if (map_present && dm_type(alias, TGT_MPATH) <= 0){
+		condlog( 0, "%s: not a multipath device.", alias);
+		ret = MPATH_PR_DMMP_ERROR;
+		goto out;
+	}
+
+	/*
+	 * allocate core vectors to store paths and multipaths
+	 */
+	curmp = vector_alloc ();
+	pathvec = vector_alloc ();
+
+	if (!curmp || !pathvec){
+		condlog (0, "%s: vector allocation failed.", alias);
+		ret = MPATH_PR_DMMP_ERROR;
+		goto out;
+	}
+
+	/* get info of all paths from the dm device	*/
+	if (get_mpvec (curmp, pathvec, alias)){
+		condlog(0, "%s: failed to get device info.", alias);
+		ret = MPATH_PR_DMMP_ERROR;
+		goto out1;
+	}
+
+	mpp = find_mp_by_alias(curmp, alias);
+	if (!mpp){
+		condlog(0, "%s: devmap not registered.", alias);
+		ret = MPATH_PR_DMMP_ERROR;
+		goto out1;
+	}
+
+	ret = mpath_prin_activepath(mpp, rq_servact, resp, noisy);
+
+out1:
+	free_multipathvec(curmp, KEEP_PATHS);
+	free_pathvec(pathvec, FREE_PATHS);	
+out:
+	FREE(alias);
+	return ret; 						
+}
+
+int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
+		unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy, int verbose)
+{
+
+	struct stat info;
+
+	vector curmp = NULL;
+	vector pathvec = NULL;
+
+	char * alias;
+	struct multipath * mpp;
+	int map_present;
+	int major, minor;
+	int ret;
+	int j;
+	unsigned char *keyp;
+	uint64_t prkey;		
+
+	conf->verbosity = verbose;
+
+	if (fstat( fd, &info) != 0){
+		condlog(0, "stat error fd=%d", fd);
+		return MPATH_PR_FILE_ERROR;
+	}
+
+	if(!S_ISBLK(info.st_mode)){
+		condlog(3, "Failed to get major:minor. fd=%d", fd);
+		return MPATH_PR_FILE_ERROR;	
+	}	
+
+	major = (int)MAJOR(info.st_rdev);
+	minor = (int)MINOR(info.st_rdev);
+	condlog(4, "Device  %d:%d", major, minor);
+
+	/* get WWN of the device from major:minor*/
+	alias = dm_mapname(major, minor);
+	if (!alias){
+		ret = MPATH_PR_DMMP_ERROR;
+		goto out;
+	}
+
+	condlog(3, "alias = %s", alias);
+	map_present = dm_map_present(alias);
+
+	if (map_present && dm_type(alias, TGT_MPATH) <= 0){
+		condlog(3, "%s: not a multipath device.", alias);
+		ret = MPATH_PR_DMMP_ERROR;
+		goto out;
+	}
+
+	/*
+	 * allocate core vectors to store paths and multipaths
+	 */
+	curmp = vector_alloc ();
+	pathvec = vector_alloc ();
+
+	 if (!curmp || !pathvec){
+                condlog (0, "%s: vector allocation failed.", alias);
+                ret = MPATH_PR_DMMP_ERROR;
+                goto out;
+        }
+
+	/* get info of all paths from the dm device     */
+	if (get_mpvec(curmp, pathvec, alias)){
+		condlog(0, "%s: failed to get device info.", alias);
+		ret = MPATH_PR_DMMP_ERROR;
+		goto out;
+	}
+
+	mpp = find_mp_by_alias(curmp, alias);
+
+	if (!mpp) {
+		condlog(0, "%s: devmap not registered.", alias);
+		ret = MPATH_PR_DMMP_ERROR;
+		goto out1;
+	}
+
+	select_reservation_key(mpp);
+
+	switch(rq_servact)
+	{
+		case MPATH_PROUT_REG_SA: 
+		case MPATH_PROUT_REG_IGN_SA:  
+			ret= mpath_prout_reg(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
+			break;
+		case MPATH_PROUT_RES_SA :  
+		case MPATH_PROUT_PREE_SA :  
+		case MPATH_PROUT_PREE_AB_SA :  
+		case MPATH_PROUT_CLEAR_SA:  
+			ret = mpath_prout_common(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
+			break;
+		case MPATH_PROUT_REL_SA:
+			ret = mpath_prout_rel(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
+			break;
+		default:
+			ret = MPATH_PR_OTHER;
+			goto out1;
+	}
+
+	if ((ret == MPATH_PR_SUCCESS) && ((rq_servact == MPATH_PROUT_REG_SA) ||
+				(rq_servact ==  MPATH_PROUT_REG_IGN_SA)))
+	{
+		keyp=paramp->sa_key;
+		prkey = 0;
+		for (j = 0; j < 8; ++j) {
+			if (j > 0)
+				prkey <<= 8;
+			prkey |= *keyp;
+			++keyp;
+		}
+		if (prkey == 0)
+			update_prflag(alias, "unset", noisy);
+		else
+			update_prflag(alias, "set", noisy);
+	} else {
+		if ((ret == MPATH_PR_SUCCESS) && ((rq_servact == MPATH_PROUT_CLEAR_SA) || 
+					(rq_servact == MPATH_PROUT_PREE_AB_SA ))){
+			update_prflag(alias, "unset", noisy);
+		}
+	}
+out1:
+	free_multipathvec(curmp, KEEP_PATHS);
+	free_pathvec(pathvec, FREE_PATHS);
+
+out:
+	FREE(alias);
+	return ret; 
+}
+
+int
+get_mpvec (vector curmp, vector pathvec, char * refwwid)
+{
+	int i;
+	struct multipath *mpp;
+	char params[PARAMS_SIZE], status[PARAMS_SIZE];
+
+	if (dm_get_maps (curmp)){
+		return 1;
+	}
+
+	vector_foreach_slot (curmp, mpp, i){
+		/*
+		 * discard out of scope maps
+		 */
+		if (mpp->alias && refwwid && strncmp (mpp->alias, refwwid, WWID_SIZE)){
+			free_multipath (mpp, KEEP_PATHS);
+			vector_del_slot (curmp, i);
+			i--;
+			continue;
+		}
+
+		dm_get_map(mpp->alias, &mpp->size, params);
+		condlog(3, "params = %s", params);
+		dm_get_status(mpp->alias, status);
+                condlog(3, "status = %s", status);
+		disassemble_map (pathvec, params, mpp);
+		
+		/*
+		 * disassemble_map() can add new paths to pathvec.
+		 * If not in "fast list mode", we need to fetch information
+		 * about them
+		 */
+		updatepaths(mpp);
+		mpp->bestpg = select_path_group (mpp);
+		disassemble_status (status, mpp);
+
+	}
+	return MPATH_PR_SUCCESS ;
+}
+
+void * mpath_prin_pthread_fn (void *p)
+{
+	int ret;
+	struct prin_param * pparam = (struct prin_param *)p;
+
+	ret = prin_do_scsi_ioctl(pparam->dev, pparam->rq_servact, pparam->resp,  pparam->noisy);
+	pparam->status = ret;	
+	pthread_exit(NULL);	
+}
+
+int mpath_send_prin_activePath (char * dev, int rq_servact, struct prin_resp * resp, int noisy)
+{
+
+	struct prin_param param;
+	int rc;
+
+	param.rq_servact = rq_servact; 
+	param.resp = resp;
+	param.noisy = noisy;
+	param.status = MPATH_PR_OTHER;
+
+	rc = prin_do_scsi_ioctl(dev, rq_servact, resp,  noisy);
+	
+	return (rc);
+}
+
+int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
+	unsigned int rq_type, struct prout_param_descriptor * paramp, int noisy)
+{
+
+	int i, j;
+	struct pathgroup *pgp = NULL;
+	struct path *pp = NULL;
+	int rollback = 0;
+	int active_pathcount=0;	
+	int rc;
+	int count=0;
+	int status = MPATH_PR_SUCCESS;
+	uint64_t sa_key;	
+
+	if (!mpp)
+		return MPATH_PR_DMMP_ERROR; 
+
+	active_pathcount = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
+
+	if (active_pathcount == 0) {
+		condlog (0, "%s: no path available", mpp->wwid);
+		return MPATH_PR_DMMP_ERROR;
+	}
+
+	if ( paramp->sa_flags & MPATH_F_ALL_TG_PT_MASK ) {
+		condlog (1, "Warning: ALL_TG_PT is set. Configuration not supported");
+	}
+
+	struct threadinfo thread[active_pathcount];
+
+	memset(thread, 0, sizeof(thread));
+
+	/* init thread parameter */
+	for (i =0; i< active_pathcount; i++){
+		thread[i].param.rq_servact = rq_servact;
+		thread[i].param.rq_scope = rq_scope;
+		thread[i].param.rq_type = rq_type;
+		thread[i].param.paramp = paramp;
+		thread[i].param.noisy = noisy;
+		thread[i].param.status = -1;
+
+		condlog (3, "THRED ID [%d] INFO]", i);
+		condlog (3, "rq_servact=%d ", thread[i].param.rq_servact);
+		condlog (3, "rq_scope=%d ", thread[i].param.rq_scope); 
+		condlog (3, "rq_type=%d ", thread[i].param.rq_type);  
+		condlog (3, "rkey="); 
+		condlog (3, "paramp->sa_flags =%02x ", thread[i].param.paramp->sa_flags); 
+		condlog (3, "noisy=%d ", thread[i].param.noisy); 
+		condlog (3, "status=%d ", thread[i].param.status); 
+	}
+
+	pthread_attr_t attr;
+	pthread_attr_init(&attr);
+	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
+
+	vector_foreach_slot (mpp->pg, pgp, j){
+		vector_foreach_slot (pgp->paths, pp, i){
+			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
+				condlog (1, "%s: %s path not up. Skip.", mpp->wwid, pp->dev);
+				continue;
+			}
+			strncpy(thread[count].param.dev, pp->dev, FILE_NAME_SIZE);
+
+			if (count && (thread[count].param.paramp->sa_flags & MPATH_F_SPEC_I_PT_MASK)){
+				/*
+				 * Clearing SPEC_I_PT as transportids are already registered by now.
+				 */
+				thread[count].param.paramp->sa_flags &= (~MPATH_F_SPEC_I_PT_MASK);
+			}
+
+			condlog (3, "%s: sending PR OUT command to %s", mpp->wwid, pp->dev);
+
+			rc = pthread_create(&thread[count].id, &attr, mpath_prout_pthread_fn, (void *)(&thread[count].param));
+			if (rc){
+				condlog (0, "%s: failed to create thread %d", mpp->wwid, rc);
+			}
+			count = count +1;
+		}
+	}
+	for( i=0; i < active_pathcount ; i++){
+		rc = pthread_join(thread[i].id, NULL);
+		if (rc){
+			condlog (0, "%s: Thread[%d] failed to join thread %d", mpp->wwid, i, rc);
+		}
+		if (!rollback && (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)){
+			rollback = 1;
+			sa_key = 0;
+			for (i = 0; i < 8; ++i){
+				if (i > 0)
+					sa_key <<= 8;
+				sa_key |= paramp->sa_key[i];
+			}
+			status = MPATH_PR_RESERV_CONFLICT ;
+		}
+		if (!rollback && (status == MPATH_PR_SUCCESS)){
+			status = thread[i].param.status;
+		}
+	}
+	if (rollback && ((rq_servact == MPATH_PROUT_REG_SA) && sa_key != 0 )){
+		condlog (3, "%s: ERROR: initiating PR OUT rollback", mpp->wwid);
+		for( i=0 ; i < active_pathcount ; i++){
+			if((thread[i].param.status == MPATH_PR_SUCCESS) &&
+					((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
+				memcpy(&thread[i].param.paramp->key, &thread[i].param.paramp->sa_key, 8);
+				memset(&thread[i].param.paramp->sa_key, 0, 8);
+				thread[i].param.status = MPATH_PR_SUCCESS;
+				rc = pthread_create(&thread[i].id, &attr, mpath_prout_pthread_fn, 
+						(void *)(&thread[count].param));
+				if (rc){
+					condlog (0, "%s: failed to create thread for rollback. %d",  mpp->wwid, rc);
+				}
+			}
+		}
+		for(i=0; i < active_pathcount ; i++){
+			rc = pthread_join(thread[i].id, NULL);
+			if (rc){
+				condlog (3, "%s: failed to join thread while rolling back %d",
+						mpp->wwid, i);
+			}
+		}
+	}
+
+	pthread_attr_destroy(&attr);
+	return (status);
+}
+
+void * mpath_prout_pthread_fn(void *p)
+{
+	int ret;
+	struct prout_param * param = (struct prout_param *)p;
+
+	ret = prout_do_scsi_ioctl( param->dev,param->rq_servact, param->rq_scope,
+			param->rq_type, param->paramp, param->noisy);
+	param->status = ret;
+	pthread_exit(NULL);
+}
+
+int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope,
+        unsigned int rq_type, struct prout_param_descriptor* paramp, int noisy)
+{
+	int i,j, ret;
+	struct pathgroup *pgp = NULL;
+	struct path *pp = NULL;
+	struct path *pptemp = NULL;
+	char dev[FILE_NAME_SIZE];
+
+	vector_foreach_slot (mpp->pg, pgp, j){
+		vector_foreach_slot (pgp->paths, pp, i){
+			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
+				condlog (1, "%s: %s path not up. Skip", mpp->wwid, dev); 
+				continue;
+			}
+
+			condlog (3, "%s: sending prout command to %s", mpp->wwid, dev);
+			ret = send_prout_activePath(pp->dev, rq_servact, rq_scope, rq_type, 
+					paramp, noisy); 
+			pptemp = pp;
+			return ret ;
+		}
+	}
+	return MPATH_PR_SUCCESS;
+}
+
+int send_prout_activePath(char * dev, int rq_servact, int rq_scope,
+	unsigned int rq_type, struct prout_param_descriptor * paramp, int noisy)
+{
+	struct prout_param param;
+	param.rq_servact = rq_servact;
+	param.rq_scope  = rq_scope;
+	param.rq_type   = rq_type;
+	param.paramp    = paramp;
+	param.noisy = noisy;
+	param.status = -1;
+
+	pthread_t thread;
+	pthread_attr_t attr;
+	int rc;
+
+	/* Initialize and set thread joinable attribute */
+	pthread_attr_init(&attr);
+	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
+
+	rc = pthread_create(&thread, &attr, mpath_prout_pthread_fn, (void *)(&param));
+	if (rc){
+		condlog (3, "%s: failed to create thread %d", dev, rc);
+		exit(-1);
+	}
+	/* Free attribute and wait for the other threads */
+	pthread_attr_destroy(&attr);
+	rc = pthread_join(thread, NULL);
+
+	return (rc);
+}
+
+int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
+        unsigned int rq_type, struct prout_param_descriptor * paramp, int noisy)
+{
+	int i, j, k;
+	int num = 0;
+	struct pathgroup *pgp = NULL;
+	struct path *pp = NULL;
+	char dev[FILE_NAME_SIZE];
+	int active_pathcount = 0;
+	pthread_attr_t attr;
+	int rc, found = 0;;
+	int count = 0;
+	int status = MPATH_PR_SUCCESS;
+	struct prin_resp resp;
+	struct prout_param_descriptor *pamp;
+	struct prin_resp *pr_buff;
+	int result = 0, length;
+	struct transportid *pptr;	
+
+	if (!mpp)
+		return MPATH_PR_DMMP_ERROR;
+
+	active_pathcount = pathcount (mpp, PATH_UP) + pathcount (mpp, PATH_GHOST);
+
+	struct threadinfo thread[active_pathcount];
+
+	for (i = 0; i < active_pathcount; i++){
+		thread[i].param.rq_servact = rq_servact;
+		thread[i].param.rq_scope = rq_scope;
+		thread[i].param.rq_type = rq_type;
+		thread[i].param.paramp = paramp;
+		thread[i].param.noisy = noisy;
+		thread[i].param.status = -1;
+
+		condlog (3, " path count = %d", i);
+		condlog (3, "rq_servact=%d ", thread[i].param.rq_servact);
+		condlog (3, "rq_scope=%d ", thread[i].param.rq_scope);
+		condlog (3, "rq_type=%d ", thread[i].param.rq_type);
+		for (k = 0; k < 8; k++)
+			printf ("paramp=%02x ", thread[i].param.paramp->key[k]);
+		for (k = 0; k < 8; k++)
+			printf ("paramp=%02x ", thread[i].param.paramp->sa_key[k]);
+
+		condlog (3, "paramp->sa_flags =%02x ",
+				thread[i].param.paramp->sa_flags);
+		condlog (3, "noisy=%d ", thread[i].param.noisy);
+		condlog (3, "status=%d ", thread[i].param.status);
+	}
+
+	pthread_attr_init (&attr);
+	pthread_attr_setdetachstate (&attr, PTHREAD_CREATE_JOINABLE);
+
+	vector_foreach_slot (mpp->pg, pgp, j){
+		vector_foreach_slot (pgp->paths, pp, i){
+			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
+				condlog (1, "%s: %s path not up.", mpp->wwid, dev);
+				continue;
+			}
+			
+			strncpy(thread[count].param.dev, pp->dev, FILE_NAME_SIZE);
+
+			condlog (3, "%s: sending prout command to %s", mpp->wwid, dev);
+
+			rc = pthread_create (&thread[count].id, &attr, mpath_prout_pthread_fn,
+					(void *) (&thread[count].param));
+			if (rc){
+				condlog (0, "%s: failed to create thread. %d",  mpp->wwid, rc);
+			}
+			count = count + 1;
+		}
+	}
+	pthread_attr_destroy (&attr);
+	for (i = 0; i < active_pathcount; i++){
+		rc = pthread_join (thread[i].id, NULL);
+		if (rc){
+			condlog (1, "%s: failed to join thread.  %d",  mpp->wwid,  rc);
+		}
+	}
+
+	for (i = 0; i < active_pathcount; i++){
+		/*  check thread status here and return the status */
+
+		if (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)
+			status = MPATH_PR_RESERV_CONFLICT;
+		else if (status == MPATH_PR_SUCCESS
+				&& thread[i].param.status != MPATH_PR_RESERV_CONFLICT)
+			status = thread[i].param.status;
+	}
+
+	result = mpath_prin_activepath (mpp, MPATH_PRIN_RRES_SA, &resp, noisy);
+	if (result != MPATH_PR_SUCCESS){
+		condlog (0, "%s: prin read reservation command failed.", mpp->wwid);
+		return MPATH_PR_OTHER;
+	}
+
+	num = resp.prin_descriptor.prin_readresv.additional_length / 8;
+	if (num == 0){
+		return MPATH_PR_SUCCESS;	
+	}
+	condlog (3, "%s: Path holding reservation is not avialable.", mpp->wwid);
+
+	pr_buff =  mpath_alloc_prin_response(MPATH_PRIN_RFSTAT_SA);
+	if (!pr_buff){
+		condlog (0, "%s: failed to  alloc prin response buffer.", mpp->wwid);	
+		return MPATH_PR_OTHER;
+	}
+
+	result =
+		mpath_prin_activepath (mpp, MPATH_PRIN_RFSTAT_SA, pr_buff, noisy);
+
+	if (result != MPATH_PR_SUCCESS){
+		condlog (0,  "%s: prin read full status command failed.",  mpp->wwid);
+		goto out;
+	}
+
+	num = pr_buff->prin_descriptor.prin_readfd.number_of_descriptor;
+	if (0 == num){
+		goto out;
+	}
+	length = sizeof (struct prout_param_descriptor) + (sizeof (struct transportid *));
+
+	pamp = (struct prout_param_descriptor *)malloc (length);
+	if (!pamp){
+		condlog (0, "%s: failed to alloc prout parameter.", mpp->wwid);
+		goto out1;
+	}
+
+	memset(pamp, 0, length);
+
+	pamp->trnptid_list[0] = (struct transportid *) malloc (sizeof (struct transportid));
+	if (!pamp->trnptid_list[0]){
+		condlog (0, "%s: failed to alloc prout transportid.", mpp->wwid);
+		goto out1;
+	}
+
+	if (mpp->reservation_key ){
+		memcpy (pamp->key, mpp->reservation_key, 8);
+		condlog (3, "%s: reservation key set.", mpp->wwid);
+	}
+
+	mpath_prout_common (mpp, MPATH_PROUT_CLEAR_SA, rq_scope, rq_type, pamp,
+			noisy);
+
+	pamp->num_transportid = 1;
+	pptr=pamp->trnptid_list[0];
+
+	for (i = 0; i < num; i++){
+		if (mpp->reservation_key && 
+			memcmp(pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key,
+			mpp->reservation_key, 8)){	
+			/*register with tarnsport id*/
+			memset(pamp, 0, length);
+			pamp->trnptid_list[0] = pptr;
+			memset (pamp->trnptid_list[0], 0, sizeof (struct transportid));
+			memcpy (pamp->sa_key,
+					pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key, 8);
+			pamp->sa_flags = MPATH_F_SPEC_I_PT_MASK;
+			pamp->num_transportid = 1;
+
+			memcpy (pamp->trnptid_list[0],
+					&pr_buff->prin_descriptor.prin_readfd.descriptors[i]->trnptid,
+					sizeof (struct transportid));
+			result = mpath_prout_common (mpp, MPATH_PROUT_REG_SA, 0, rq_type,
+					pamp, noisy);
+
+			pamp->sa_flags = 0;
+			memcpy (pamp->key, pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key, 8);
+			memset (pamp->sa_key, 0, 8);
+			pamp->num_transportid = 0;
+			result = mpath_prout_common (mpp, MPATH_PROUT_REG_SA, 0, rq_type,
+					pamp, noisy);
+		}
+		else
+		{
+			if (mpp->reservation_key)
+				found = 1;
+		}
+
+
+	}
+
+	if (found){
+		memset (pamp, 0, length);
+		memcpy (pamp->sa_key, mpp->reservation_key, 8);
+		memset (pamp->key, 0, 8);
+		mpath_prout_reg(mpp, MPATH_PROUT_REG_SA, rq_scope, rq_type, pamp, noisy);	
+	}
+
+
+	free(pptr);
+out1:
+	free (pamp);
+out:
+	free (pr_buff);
+	return (status);
+}
+
+void * mpath_alloc_prin_response(int prin_sa)
+{
+	void * ptr = NULL;
+	int size=0;
+	switch (prin_sa)
+	{
+		case MPATH_PRIN_RKEY_SA:
+			size = sizeof(struct prin_readdescr);
+			ptr = malloc(size);
+			memset(ptr, 0, size);
+			break;
+		case MPATH_PRIN_RRES_SA:
+			size = sizeof(struct prin_resvdescr);
+			ptr = malloc(size);
+			memset(ptr, 0, size);
+			break;
+		case MPATH_PRIN_RCAP_SA:
+			size=sizeof(struct prin_capdescr);
+			ptr = malloc(size);
+			memset(ptr, 0, size);
+			break;
+		case MPATH_PRIN_RFSTAT_SA:
+			size = sizeof(struct print_fulldescr_list) + 
+				sizeof(struct prin_fulldescr *)*MPATH_MX_TIDS;
+			ptr = malloc(size);
+			memset(ptr, 0, size);
+			break;
+	}
+	return ptr;
+}
+
+int update_map_pr(struct multipath *mpp)
+{
+	int noisy=0;
+	struct prin_resp *resp;
+	int i,j, ret, isFound;
+	unsigned char *keyp;
+	uint64_t prkey;
+
+	resp = mpath_alloc_prin_response(MPATH_PRIN_RKEY_SA);
+	if (!resp)
+	{
+		condlog(0,"%s : failed to alloc resp in update_map_pr", mpp->alias);
+		return MPATH_PR_OTHER;
+	}
+	ret = mpath_prin_activepath(mpp, MPATH_PRIN_RKEY_SA, resp, noisy);
+
+	if (ret != MPATH_PR_SUCCESS )
+	{
+		condlog(0,"%s : PR IN Read keys Service Action Failed Error=%d", mpp->alias, ret);
+		free(resp);
+		return  ret;
+	}
+
+	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
+	{
+		condlog(0,"%s: No key found. Device may not be registered. ", mpp->alias);
+		free(resp);
+		return MPATH_PR_SUCCESS;
+	}
+
+	if (mpp->reservation_key)
+	{
+		prkey = 0;
+		keyp = mpp->reservation_key;
+		for (j = 0; j < 8; ++j) {
+			if (j > 0)
+				prkey <<= 8;
+			prkey |= *keyp;
+			++keyp;
+		}
+		condlog(2, "%s: Multipath  reservation_key: 0x%" PRIx64 " ", mpp->alias, prkey);
+	}
+	else
+	{
+		condlog(1, "%s: reservation_key not set in multiapth.conf", mpp->alias);
+		free(resp);
+		return MPATH_PR_DMMP_ERROR;
+	}
+
+	isFound =0;
+
+	for (i = 0; i < resp->prin_descriptor.prin_readkeys.additional_length/8; i++ )
+	{
+		condlog(2, "%s: PR IN READKEYS[%d]  reservation key:", mpp->alias, i);
+		dumpHex((char *)&resp->prin_descriptor.prin_readkeys.key_list[i*8], 8 , 1);
+
+		if (!memcmp(mpp->reservation_key, &resp->prin_descriptor.prin_readkeys.key_list[i*8], 8))
+		{
+
+			condlog(2, "%s: reservation key found in prin readkeys response", mpp->alias);
+			isFound =1;
+		}
+	}
+
+	if (isFound)
+	{
+		mpp->prflag = 1;
+		condlog(2, "%s: prflag flag set.", mpp->alias );
+	}
+
+	free(resp);
+	return MPATH_PR_SUCCESS;
+}
+
+
+
diff -uprN multipath-tools-orig/libmpathpersist/mpath_persistent_reserve_in.3 multipath-tools/libmpathpersist/mpath_persistent_reserve_in.3
--- multipath-tools-orig/libmpathpersist/mpath_persistent_reserve_in.3	1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools/libmpathpersist/mpath_persistent_reserve_in.3	2011-12-20 00:15:04.000000000 +0530
@@ -0,0 +1,80 @@
+.\"
+.TH MPATH_PERSISTENT_RESERVE_IN 3  2011-04-08 "Linux Manpage" 
+.SH NAME
+mpath_persistent_reserve_in
+.SH SYNOPSIS
+.B #include <mpath_persist.h>
+.sp
+.BI "int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp *resp, int noisy, int verbose)"
+.sp
+.SH DESCRIPTION
+The function in the
+.BR mpath_persistent_reserve_in ()
+sends PRIN command to the DM device and gets the response.
+.br
+.BI Parameters:
+.br
+.I fd
+.B The file descriptor of a multipath device. Input argument.
+.br
+.I rq_servact
+.B PRIN command service action. Input argument
+.br
+.I resp
+.B The response from PRIN service action. The caller should manage the memory allocation of this structure
+.br
+.I noisy
+.B Turn on debugging trace: Input argument. 0->Disable, 1->Enable
+.br
+.I verbose
+.B Set verbosity level. Input argument. value:[0-3]. 0->Crits and Errors, 1->Warnings, 2->Info, 3->Debug
+.br
+
+.SH "RETURNS"
+.I MPATH_PR_SUCCESS
+.B if PR command successful
+.br
+.I MPATH_PR_SYNTAX_ERROR        
+.B if  syntax error or invalid parameter
+.br
+.I MPATH_PR_SENSE_NOT_READY     
+.B  if command fails with [sk,asc,ascq: 0x2,*,*]
+.br
+.I MPATH_PR_SENSE_MEDIUM_ERROR
+.B  if command fails with [sk,asc,ascq: 0x3,*,*]
+.br
+.I MPATH_PR_SENSE_HARDWARE_ERROR
+.B  if command fails with [sk,asc,ascq: 0x4,*,*]
+.br
+.I MPATH_PR_SENSE_INVALID_OP
+.B  if command fails with [sk,asc,ascq: 0x5,0x20,0x0]
+.br
+.I MPATH_PR_ILLEGAL_REQ
+.B  if command fails with [sk,asc,ascq: 0x5,*,*]
+.br
+.I MPATH_PR_SENSE_UNIT_ATTENTION
+.B  if command fails with [sk,asc,ascq: 0x6,*,*]
+.br
+.I MPATH_PR_SENSE_ABORTED_COMMAND
+.B  if command fails with [sk,asc,ascq: 0xb,*,*]
+.br
+.I MPATH_PR_NO_SENSE
+.B  if command fails with [sk,asc,ascq: 0x0,*,*]
+.br
+.I MPATH_PR_SENSE_MALFORMED  
+.B if command fails with SCSI command malformed
+.br
+.I MPATH_PR_FILE_ERROR
+.B if command fails while accessing file (device node) problems(e.g. not found)
+.br
+.I MPATH_PR_DMMP_ERROR
+.B if Device Mapper related error.(e.g Error in getting dm info) 
+.br
+.I MPATH_PR_OTHER
+.B if other error/warning has occurred(e.g transport or driver error)
+.br
+
+
+.SH "SEE ALSO"
+.I  mpath_persistent_reserve_out      mpathpersist     /usr/share/doc/mpathpersist/README
+.br
diff -uprN multipath-tools-orig/libmpathpersist/mpath_persistent_reserve_out.3 multipath-tools/libmpathpersist/mpath_persistent_reserve_out.3
--- multipath-tools-orig/libmpathpersist/mpath_persistent_reserve_out.3	1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools/libmpathpersist/mpath_persistent_reserve_out.3	2011-12-20 00:15:04.000000000 +0530
@@ -0,0 +1,92 @@
+.\"
+.TH MPATH_PERSISTENT_RESERVE_OUT 3  2011-04-08 "Linux Manpage" 
+.SH NAME
+mpath_persistent_reserve_out
+.SH SYNOPSIS
+.B #include <mpath_persist.h>
+.sp
+.BI "int mpath_persistent_reserve_out (int fd, int rq_servact, struct prin_resp *resp, int noisy, int verbose)"
+.sp
+.SH DESCRIPTION
+The function in the
+.BR mpath_persistent_reserve_out ()
+sends PR OUT command to the DM device and gets the response.
+.br
+.BI Parameters:
+.br
+.I fd 
+.B The file descriptor of a multipath device. Input argument.
+.br
+.I rq_servact
+.B PROUT command service action. Input argument
+.br
+.I rq_scope
+.B Persistent reservation scope. The value should be always LU_SCOPE (0h).
+.br
+.I rq_type
+.B Persistent reservation type. The valid values of persistent reservation types are
+      5h (Write exclusive - registrants only)
+      8h (Exclusive access - registrants only)
+      7h (Write exclusive - All registrants)
+      8h (Exclusive access - All registrants).
+.br
+.I paramp
+.B PROUT command parameter data. The paramp is a struct which describes PROUT parameter list. Caller should manage the memory allocation of this structure.
+.br
+.I noisy
+.B Turn on debugging trace: Input argument. 0->Disable, 1->Enable.
+.br
+.I verbose
+.B Set verbosity level. Input argument. value: 0 to 3. 0->Crits and Errors, 1->Warnings, 2->Info, 3->Debug
+
+.SH "RETURNS"
+.I MPATH_PR_SUCCESS
+.B if PR command successful else returns any one of the status mentioned below
+.br
+.I MPATH_PR_SYNTAX_ERROR        
+.B if  syntax error or invalid parameter
+.br
+.I MPATH_PR_SENSE_NOT_READY     
+.B  if command fails with [sk,asc,ascq: 0x2,*,*]
+.br
+.I MPATH_PR_SENSE_MEDIUM_ERROR
+.B  if command fails with [sk,asc,ascq: 0x3,*,*]
+.br
+.I MPATH_PR_SENSE_HARDWARE_ERROR
+.B  if command fails with [sk,asc,ascq: 0x4,*,*]
+.br
+.I MPATH_PR_SENSE_INVALID_OP
+.B  if command fails with [sk,asc,ascq: 0x5,0x20,0x0]
+.br
+.I MPATH_PR_ILLEGAL_REQ
+.B  if command fails with [sk,asc,ascq: 0x5,*,*]
+.br
+.I MPATH_PR_SENSE_UNIT_ATTENTION
+.B  if command fails with [sk,asc,ascq: 0x6,*,*]
+.br
+.I MPATH_PR_SENSE_ABORTED_COMMAND
+.B  if command fails with [sk,asc,ascq: 0xb,*,*]
+.br
+.I MPATH_PR_NO_SENSE
+.B  if command fails with [sk,asc,ascq: 0x0,*,*]
+.br
+.I MPATH_PR_SENSE_MALFORMED  
+.B if command fails with SCSI command malformed
+.br
+.I MPATH_PR_RESERV_CONFLICT
+.B if command fails with reservation conflict
+.br
+.I MPATH_PR_FILE_ERROR
+.B if command fails while accessing file (device node) problems(e.g. not found)
+.br
+.I MPATH_PR_DMMP_ERROR
+.B if Device Mapper related error.(e.g Error in getting dm info) 
+.br
+.I MPATH_PR_OTHER
+.B if other error/warning has occurred(e.g transport or driver error)
+.br
+
+
+.SH "SEE ALSO"
+.I  mpath_persistent_reserve_in		mpathpersist     /usr/share/doc/mpathpersist/README
+.br
diff -uprN multipath-tools-orig/libmpathpersist/mpath_persist.h multipath-tools/libmpathpersist/mpath_persist.h
--- multipath-tools-orig/libmpathpersist/mpath_persist.h	1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools/libmpathpersist/mpath_persist.h	2011-12-20 00:15:04.000000000 +0530
@@ -0,0 +1,241 @@
+/* version - 1.0 */
+
+#ifndef MPATH_PERSIST_LIB_H
+#define MPATH_PERSIST_LIB_H
+
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#include <inttypes.h>
+
+#define MPATH_MAX_PARAM_LEN	8192
+
+#define MPATH_MX_TIDS 		32	  /* Max number of transport ids"*/
+#define MPATH_MX_TID_LEN	256	  /* Max lenght of transport id */
+
+/* PRIN Service Actions */
+#define MPATH_PRIN_RKEY_SA	0x00	   /* READ KEYS SA*/
+#define MPATH_PRIN_RRES_SA	0x01	   /* READ RESERVATION  SA*/
+#define MPATH_PRIN_RCAP_SA	0x02	   /* REPORT CAPABILITIES SA*/
+#define MPATH_PRIN_RFSTAT_SA	0x03	   /* READ FULL STATUS SA*/
+
+/* PROUT Service Actions */
+#define MPATH_PROUT_REG_SA	0x00	    /* REGISTER SA */
+#define MPATH_PROUT_RES_SA	0x01	    /* RESERVE SA*/
+#define MPATH_PROUT_REL_SA	0x02	    /* RELEASE SA*/
+#define MPATH_PROUT_CLEAR_SA	0x03	    /* CLEAR SA*/
+#define MPATH_PROUT_PREE_SA	0x04	    /* PREEMPT SA*/
+#define MPATH_PROUT_PREE_AB_SA	0x05	    /* PREEMPT AND ABORT SA*/
+#define MPATH_PROUT_REG_IGN_SA	0x06	    /* REGISTER AND IGNORE EXISTING KEY SA*/
+#define MPATH_PROUT_REG_MOV_SA	0x07	    /* REGISTER AND MOVE SA*/
+
+#define MPATH_LU_SCOPE		0x00	    /* LU_SCOPE */
+
+/* Persistent reservations type */
+#define MPATH_PRTPE_WE	 	0x01	    /* Write Exclusive */
+#define MPATH_PRTPE_EA 		0x03	    /* Exclusive Access*/
+#define MPATH_PRTPE_WE_RO 	0x05	    /* WriteExclusive Registrants Only */
+#define MPATH_PRTPE_EA_RO 	0x06	    /* Exclusive Access. Registrants Only*/
+#define MPATH_PRTPE_WE_AR	0x07	    /* Write Exclusive. All Registrants*/
+#define MPATH_PRTPE_EA_AR 	0x08	    /* Exclusive Access. All Registrants */
+
+
+/* PR RETURN_STATUS */
+#define MPATH_PR_SUCCESS 		0
+#define MPATH_PR_SYNTAX_ERROR		1   /*  syntax error or invalid parameter */
+					    /* status for check condition */
+#define MPATH_PR_SENSE_NOT_READY 	2   /*	[sk,asc,ascq: 0x2,*,*] */
+#define MPATH_PR_SENSE_MEDIUM_ERROR	3   /*	[sk,asc,ascq: 0x3,*,*] */
+#define MPATH_PR_SENSE_HARDWARE_ERROR	4   /*	[sk,asc,ascq: 0x4,*,*] */
+#define MPATH_PR_ILLEGAL_REQ 		5   /*	[sk,asc,ascq: 0x5,*,*]*/
+#define MPATH_PR_SENSE_UNIT_ATTENTION	6   /*	[sk,asc,ascq: 0x6,*,*] */
+#define MPATH_PR_SENSE_INVALID_OP	7   /* 	[sk,asc,ascq: 0x5,0x20,0x0]*/
+#define MPATH_PR_SENSE_ABORTED_COMMAND  8   /*  [sk,asc,ascq: 0xb,*,*] */
+#define MPATH_PR_NO_SENSE		9   /*	[sk,asc,ascq: 0x0,*,*] */
+
+#define MPATH_PR_SENSE_MALFORMED	10  /* Response to SCSI command malformed */
+#define MPATH_PR_RESERV_CONFLICT	11  /* Reservation conflict on the device */
+#define MPATH_PR_FILE_ERROR		12  /* file (device node) problems(e.g. not found)*/
+#define MPATH_PR_DMMP_ERROR		13  /* DMMP related error.(e.g Error in getting dm info */
+#define MPATH_PR_OTHER			14  /*other error/warning has occurred(transport
+					      or driver error) */
+
+/* PR MASK */
+#define MPATH_F_APTPL_MASK		0x01	/* APTPL MASK*/
+#define MPATH_F_ALL_TG_PT_MASK		0x04	/* ALL_TG_PT MASK*/
+#define MPATH_F_SPEC_I_PT_MASK		0x08	/* SPEC_I_PT MASK*/
+#define MPATH_PR_TYPE_MASK 		0x0f	/* TYPE MASK*/
+#define MPATH_PR_SCOPE_MASK		0xf0	/* SCOPE MASK*/
+
+/*Transport ID PROTOCOL IDENTIFIER values */
+#define MPATH_PROTOCOL_ID_FC		0x00
+#define MPATH_PROTOCOL_ID_ISCSI		0x05
+#define MPATH_PROTOCOL_ID_SAS		0x06
+
+
+/*Transport ID FORMATE CODE */
+#define MPATH_WWUI_DEVICE_NAME		0x00	/* World wide unique initiator device name */
+#define MPATH_WWUI_PORT_IDENTIFIER	0x40	/* World wide unique initiator port identifier	*/
+
+
+
+
+struct prin_readdescr
+{
+	uint32_t prgeneration;
+	uint32_t additional_length;	/* The value should be either 0 or divisible by 8.
+					   0 indicates no registered reservation key. */
+	uint8_t	 key_list[MPATH_MAX_PARAM_LEN];
+};
+
+struct prin_resvdescr
+{
+	uint32_t prgeneration;
+	uint32_t additional_length;	/* The value should be either 0 or 10h. 0 indicates
+					   there is no reservation held. 10h indicates the
+					   key[8] and scope_type have valid values */
+	uint8_t  key[8];
+	uint32_t _obsolete;
+	uint8_t  _reserved;
+	uint8_t  scope_type;            /* Use PR SCOPE AND TYPE MASK specified above */
+	uint16_t _obsolete1;
+};
+
+struct prin_capdescr
+{
+	uint16_t length;
+	uint8_t  flags[2];
+	uint16_t pr_type_mask;
+	uint16_t _reserved;
+};
+
+struct transportid
+{
+	uint8_t format_code;
+	uint8_t protocol_id;
+	union {
+		uint8_t n_port_name[8];	/* FC transport*/
+		uint8_t sas_address[8];	/* SAS transport */
+		uint8_t iscsi_name[256]; /* ISCSI  transport */
+	};
+};
+
+struct prin_fulldescr
+{
+	uint8_t key[8];
+	uint8_t flag; 			/* All_tg_pt and reservation holder */
+	uint8_t scope_type;		/* Use PR SCOPE AND TYPE MASK specified above.
+					   Meaningful only for reservation holder */
+	uint16_t rtpi;
+	struct transportid trnptid;
+};
+
+struct print_fulldescr_list
+{
+	uint32_t prgeneration;
+	uint32_t number_of_descriptor;
+	uint8_t private_buffer[MPATH_MAX_PARAM_LEN]; /*Private buffer for list storage*/
+	struct prin_fulldescr *descriptors[];
+};
+
+struct prin_resp
+{
+	union
+	{
+		struct prin_readdescr prin_readkeys; /* for PRIN read keys SA*/
+		struct prin_resvdescr prin_readresv; /* for PRIN read reservation SA*/
+		struct prin_capdescr  prin_readcap;  /* for PRIN Report Capabilities SA*/
+		struct print_fulldescr_list prin_readfd;   /* for PRIN read full status SA*/
+	}prin_descriptor;
+};
+
+struct prout_param_descriptor { 	/* PROUT parameter descriptor */
+	uint8_t	 key[8];
+	uint8_t	 sa_key[8];
+	uint32_t _obsolete;
+	uint8_t	 sa_flags;
+	uint8_t _reserved;
+	uint16_t _obsolete1;
+	uint8_t  private_buffer[MPATH_MAX_PARAM_LEN]; /*private buffer for list storage*/
+	uint32_t num_transportid;	/* Number of Transport ID listed in trnptid_list[]*/
+	struct transportid *trnptid_list[];
+};
+
+
+/* Function declarations */
+
+/*
+ * DESCRIPTION :
+ *	Initialize device mapper multipath configuration. This function must be invoked first
+ *	before performing reservation management functions.
+ * RESTRICTIONS:
+ *
+ * RETURNS: 0->Success, 1->Failed.
+ */
+extern int mpath_lib_init (void );
+
+
+/*
+ * DESCRIPTION :
+ *	Release device mapper multipath configuration. This function must be invoked after
+ *	performing reservation management functions.
+ * RESTRICTIONS:
+ *
+ * RETURNS: 0->Success, 1->Failed.
+ */
+extern int mpath_lib_exit (void );
+
+
+/*
+ * DESCRIPTION :
+ * This function sends PRIN command to the DM device and get the response.
+ *
+ * @fd:	The file descriptor of a multipath device. Input argument.
+ * @rq_servact: PRIN command service action. Input argument
+ * @resp: The response from PRIN service action. The resp is a struct specified below. The caller should
+ * 	manage the memory allocation of this struct
+ * @noisy: Turn on debugging trace: Input argument. 0->Disable, 1->Enable
+ * @verbose: Set verbosity level. Input argument. value:[0-3]. 0->disabled, 3->Max verbose
+ *
+ * RESTRICTIONS:
+ *
+ * RETURNS: MPATH_PR_SUCCESS if PR command successful else returns any of the PR status (specified
+ *	 above).
+ *
+ */
+extern int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp *resp,
+		int noisy, int verbose);
+
+/*
+ * DESCRIPTION :
+ * This function sends PROUT command to the DM device and get the response.
+ *
+ * @fd: The file descriptor of a multipath device. Input argument.
+ * @rq_servact: PROUT command service action. Input argument
+ * @rq_scope: Persistent reservation scope. The value should be always LU_SCOPE (0h).
+ * @rq_type: Persistent reservation type. The valid values of persistent reservation types are
+ *	5h (Write exclusive - registrants only)
+ *	8h (Exclusive access - registrants only)
+ *	7h (Write exclusive - All registrants)
+ *	8h (Exclusive access - All registrants).
+ * @paramp: PROUT command parameter data. The paramp is a struct which describes PROUT
+ * 	    parameter list. The caller should manage the memory allocation of this struct.
+ * @noisy: Turn on debugging trace: Input argument.0->Disable, 1->Enable.
+ * @verbose: Set verbosity level. Input argument. value:0 to 3. 0->disabled, 3->Max verbose
+ *
+ * RESTRICTIONS:
+ *
+ * RETURNS: MPATH_PR_SUCCESS if PR command successful else returns any of the status specified
+ *       above in RETURN_STATUS.
+ */
+extern int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
+		unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy,
+		int verbose);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif  /*MPATH_PERSIST_LIB_H*/
diff -uprN multipath-tools-orig/libmpathpersist/mpathpr.h multipath-tools/libmpathpersist/mpathpr.h
--- multipath-tools-orig/libmpathpersist/mpathpr.h	1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools/libmpathpersist/mpathpr.h	2011-12-20 00:15:04.000000000 +0530
@@ -0,0 +1,55 @@
+#ifndef MPATHPR_H
+#define MPATHPR_H
+
+struct prin_param {
+	char dev[FILE_NAME_SIZE];
+        int rq_servact;
+        struct prin_resp *resp;
+        int noisy;
+        int status;
+};
+
+struct prout_param {
+	char dev[FILE_NAME_SIZE];
+        int rq_servact;
+        int rq_scope;
+        unsigned int rq_type;
+        struct prout_param_descriptor  *paramp;
+        int noisy;
+        int status;
+};
+
+struct threadinfo {
+        int status;
+        pthread_t id;
+        struct prout_param param;
+};
+
+
+struct config * conf;
+
+
+int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp * resp, int noisy);
+int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
+                unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
+void * _mpath_pr_update (void *arg);
+int mpath_send_prin_activePath (char * dev, int rq_servact, struct prin_resp * resp, int noisy);
+int get_mpvec (vector curmp, vector pathvec, char * refwwid);
+void * mpath_prout_pthread_fn(void *p);
+void dumpHex(const char* , int len, int no_ascii);
+
+int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
+        unsigned int rq_type,  struct prout_param_descriptor * paramp, int noisy);
+int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope,
+        unsigned int rq_type,  struct prout_param_descriptor * paramp, int noisy);
+int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
+        unsigned int rq_type,  struct prout_param_descriptor * paramp, int noisy);
+int send_prout_activePath(char * dev, int rq_servact, int rq_scope,
+        unsigned int rq_type,   struct prout_param_descriptor * paramp, int noisy);
+
+int update_prflag(char * arg1, char * arg2, int noisy);
+void * mpath_alloc_prin_response(int prin_sa);
+int update_map_pr(struct multipath *mpp);
+int devt2devname (char *devname, int devname_len, char *devt);
+
+#endif  
diff -uprN multipath-tools-orig/libmpathpersist/mpath_pr_ioctl.c multipath-tools/libmpathpersist/mpath_pr_ioctl.c
--- multipath-tools-orig/libmpathpersist/mpath_pr_ioctl.c	1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools/libmpathpersist/mpath_pr_ioctl.c	2011-12-20 00:15:04.000000000 +0530
@@ -0,0 +1,572 @@
+#include <stdio.h>
+#include <stdlib.h>
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <scsi/sg.h>
+#include <scsi/scsi.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+#include "mpath_pr_ioctl.h" 
+#include <mpath_persist.h> 
+
+#include <debug.h>
+
+#define FILE_NAME_SIZE          256
+
+#define TIMEOUT 2000
+#define MAXRETRY 5
+
+int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp *resp, int noisy);
+void mpath_format_readkeys(struct prin_resp *pr_buff, int len , int noisy);
+void mpath_format_readfullstatus(struct prin_resp *pr_buff, int len, int noisy);
+int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr, SenseData_t Sensedata, int noisy);
+void dumpHex(const char* str, int len, int no_ascii);
+int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
+                unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
+uint32_t  format_transportids(struct prout_param_descriptor *paramp);
+void mpath_reverse_uint32_byteorder(uint32_t *num);
+void mpath_reverse_uint16_byteorder(uint16_t *num);
+void decode_transport_id(struct prin_fulldescr *fdesc, unsigned char * p, int length);
+int get_prin_length(int rq_servact);
+int mpath_isLittleEndian(void);
+
+
+int prout_do_scsi_ioctl(char * dev, int rq_servact, int rq_scope,
+                unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy)
+{
+
+	int status, paramlen = 24, ret = 0;
+	uint32_t translen=0;
+	int retry = MAXRETRY;
+	SenseData_t Sensedata;
+	struct sg_io_hdr io_hdr;
+	char devname[FILE_NAME_SIZE];
+	int fd = -1;
+
+	snprintf(devname, FILE_NAME_SIZE, "/dev/%s",dev);
+	fd = open(devname, O_WRONLY);
+	if(fd < 0){
+		condlog (1, "%s: unable to open device.", dev);
+		return MPATH_PR_FILE_ERROR;
+	}
+
+	unsigned char cdb[MPATH_PROUT_CMDLEN] =
+	{MPATH_PROUT_CMD, 0, 0, 0, 0, 0, 0, 0, 0, 0};
+
+
+	if (paramp->sa_flags & MPATH_F_SPEC_I_PT_MASK)
+	{
+		translen = format_transportids(paramp);
+		paramlen = 24 + translen;
+	}	
+	else
+		paramlen = 24;
+
+	condlog(3, "%s: parameter length =%d", dev, paramlen);
+	if ( rq_servact > 0)
+		cdb[1] = (unsigned char)(rq_servact & 0x1f);
+	cdb[2] = (((rq_scope & 0xf) << 4) | (rq_type & 0xf));
+	cdb[7] = (unsigned char)((paramlen >> 8) & 0xff);
+	cdb[8] = (unsigned char)(paramlen & 0xff);
+
+retry :
+	condlog(3, "%s: rq_servact = %d", dev, rq_servact); 
+	condlog(3, "%s: rq_scope = %d ", dev, rq_scope);
+	condlog(3, "%s: rq_type = %d ", dev, rq_type);
+	condlog(3, "%s: paramlen = %d", dev, paramlen);
+
+	if (noisy)
+	{
+		condlog(3, "%s: Persistent Reservation OUT parameter:", dev);
+		dumpHex((const char *)paramp, paramlen,1);
+	}
+
+	memset(&Sensedata, 0, sizeof(SenseData_t));
+	memset(&io_hdr,0 , sizeof( struct sg_io_hdr));
+	io_hdr.interface_id = 'S';
+	io_hdr.cmd_len = MPATH_PROUT_CMDLEN;
+	io_hdr.cmdp = cdb;
+	io_hdr.sbp = (void *)&Sensedata;
+	io_hdr.mx_sb_len = sizeof (SenseData_t);
+	io_hdr.timeout = TIMEOUT;
+
+	if (paramlen > 0) {
+		io_hdr.dxferp = (void *)paramp;
+		io_hdr.dxfer_len = paramlen;
+		io_hdr.dxfer_direction = SG_DXFER_TO_DEV ;
+	}
+	else {
+		io_hdr.dxfer_direction = SG_DXFER_NONE;
+	}
+	ret = ioctl(fd, SG_IO, &io_hdr);
+	if (ret < 0)
+	{
+		condlog(0, "%s: ioctl failed %d", dev, ret);
+		close(fd);
+		return ret;
+	}
+
+	condlog(2, "%s: Duration=%u (ms)", dev, io_hdr.duration);
+
+	status = mpath_translate_response(dev, io_hdr, Sensedata, noisy);
+	condlog(3, "%s: status = %d", dev, status);
+
+	if (status == MPATH_PR_SENSE_UNIT_ATTENTION && (retry > 0))
+	{
+		--retry;
+		condlog(2, "%s: retrying for Unit Attention. Remaining retries = %d", 
+			dev, retry);
+		goto retry;
+	}
+
+	if (((status == MPATH_PR_SENSE_NOT_READY )&& (Sensedata.ASC == 0x04)&&
+				(Sensedata.ASCQ == 0x07))&& (retry > 0))
+	{
+		usleep(1000);
+		--retry;
+		condlog(2, "%s: retrying for sense 02/04/07."
+			" Remaining retries = %d", dev, retry);
+		goto retry;
+	}
+
+	close(fd);	
+	return status;
+}
+
+uint32_t  format_transportids(struct prout_param_descriptor *paramp)
+{
+	int i = 0, len;	
+	uint32_t buff_offset = 4;
+	memset(paramp->private_buffer, 0, MPATH_MAX_PARAM_LEN);
+	for (i=0; i < paramp->num_transportid; i++ )
+	{
+		paramp->private_buffer[buff_offset] = (uint8_t)((paramp->trnptid_list[i]->format_code & 0xff)|
+							(paramp->trnptid_list[i]->protocol_id & 0xff));
+		buff_offset += 1;
+		switch(paramp->trnptid_list[i]->protocol_id)
+		{
+			case MPATH_PROTOCOL_ID_FC:
+				buff_offset += 7;
+				memcpy(&paramp->private_buffer[buff_offset], &paramp->trnptid_list[i]->n_port_name, 8);
+				buff_offset +=8 ;
+				buff_offset +=8 ;
+				break;
+			case MPATH_PROTOCOL_ID_SAS:
+				buff_offset += 3;
+				memcpy(&paramp->private_buffer[buff_offset], &paramp->trnptid_list[i]->sas_address, 8);
+				buff_offset += 12;
+				break;
+			case MPATH_PROTOCOL_ID_ISCSI:
+				buff_offset += 1;
+				len = (paramp->trnptid_list[i]->iscsi_name[1] & 0xff)+2;	
+				memcpy(&paramp->private_buffer[buff_offset], &paramp->trnptid_list[i]->iscsi_name,len);
+				buff_offset += len ; 
+				break;
+		}
+
+	}
+	buff_offset -= 4; 
+	paramp->private_buffer[0] = (unsigned char)((buff_offset >> 24) & 0xff);
+	paramp->private_buffer[1] = (unsigned char)((buff_offset >> 16) & 0xff);
+	paramp->private_buffer[2] = (unsigned char)((buff_offset >> 8) & 0xff);
+	paramp->private_buffer[3] = (unsigned char)(buff_offset & 0xff);
+	buff_offset += 4; 
+	return buff_offset;	
+}
+
+void mpath_format_readkeys( struct prin_resp *pr_buff, int len, int noisy)
+{
+        mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.prgeneration);
+        mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.additional_length);
+}
+
+void mpath_format_readresv(struct prin_resp *pr_buff, int len, int noisy)
+{
+
+        mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.prgeneration);
+        mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.additional_length);
+
+        return;
+}
+
+void mpath_format_reportcapabilities(struct prin_resp *pr_buff, int len, int noisy)
+{
+        mpath_reverse_uint16_byteorder(&pr_buff->prin_descriptor.prin_readcap.length);
+        mpath_reverse_uint16_byteorder(&pr_buff->prin_descriptor.prin_readcap.pr_type_mask);
+
+        return;
+}
+
+void mpath_format_readfullstatus(struct prin_resp *pr_buff, int len, int noisy)
+{
+	int num, k, tid_len_len=0;
+	uint32_t fdesc_count=0;
+	unsigned char *p;
+	char  *ppbuff;
+	uint32_t additional_length;
+
+
+	mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readfd.prgeneration);
+	mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readfd.number_of_descriptor);
+
+	if (0 == pr_buff->prin_descriptor.prin_readfd.number_of_descriptor)
+	{
+		return ;
+	}
+
+
+	if (pr_buff->prin_descriptor.prin_readfd.number_of_descriptor == 0)
+	{
+		condlog(2, "No registration or resrvation found.");
+		return;
+	}
+
+	additional_length = pr_buff->prin_descriptor.prin_readfd.number_of_descriptor;
+
+	char tempbuff[MPATH_MAX_PARAM_LEN];
+	struct prin_fulldescr fdesc;
+	memset(&fdesc, 0, sizeof(struct prin_fulldescr));
+
+	memcpy( tempbuff, pr_buff->prin_descriptor.prin_readfd.private_buffer,MPATH_MAX_PARAM_LEN );
+	memset(&pr_buff->prin_descriptor.prin_readfd.private_buffer, 0, MPATH_MAX_PARAM_LEN);
+
+	p =(unsigned char *)tempbuff;
+	ppbuff = (char *)pr_buff->prin_descriptor.prin_readfd.private_buffer;
+
+	for (k = 0; k < additional_length; k += num, p += num) {
+		memcpy(&fdesc.key, p, 8 );
+		fdesc.flag = p[12];
+		fdesc.scope_type =  p[13];
+		fdesc.rtpi = ((p[18] << 8) | p[19]);
+
+		tid_len_len = ((p[20] << 24) | (p[21] << 16) |
+				(p[22] << 8) | p[23]);
+
+		if (tid_len_len > 0)
+			decode_transport_id( &fdesc, &p[24], tid_len_len);
+
+		num = 24 + tid_len_len;
+		memcpy(ppbuff, &fdesc, sizeof(struct prin_fulldescr));
+		pr_buff->prin_descriptor.prin_readfd.descriptors[fdesc_count]= (struct prin_fulldescr *)ppbuff;
+		ppbuff += sizeof(struct prin_fulldescr);
+		++fdesc_count;
+	}
+
+	pr_buff->prin_descriptor.prin_readfd.number_of_descriptor = fdesc_count;
+
+	return;
+}
+
+void
+decode_transport_id(struct prin_fulldescr *fdesc, unsigned char * p, int length)
+{
+	int num, k;
+	int jump;
+	for (k = 0, jump = 24; k < length; k += jump, p += jump) {
+		fdesc->trnptid.format_code = ((p[0] >> 6) & 0x3);
+		fdesc->trnptid.protocol_id = (p[0] & 0xf);
+		switch (fdesc->trnptid.protocol_id) {
+			case MPATH_PROTOCOL_ID_FC:
+				memcpy(&fdesc->trnptid.n_port_name, &p[8], 8);
+				jump = 24;
+				break;
+			case MPATH_PROTOCOL_ID_ISCSI:
+				num = ((p[2] << 8) | p[3]);
+				memcpy(&fdesc->trnptid.iscsi_name, &p[4], num);
+				jump = (((num + 4) < 24) ? 24 : num + 4);
+				break;
+			case MPATH_PROTOCOL_ID_SAS:
+				memcpy(&fdesc->trnptid.sas_address, &p[4], 8);
+				jump = 24;
+				break;
+			default:
+				jump = 24;
+				break;
+		}
+	}
+}
+
+int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp * resp, int noisy)
+{
+
+	int ret, status, got, fd;
+	int mx_resp_len;
+	SenseData_t Sensedata;
+	int retry = MAXRETRY;
+	struct sg_io_hdr io_hdr;
+	char devname[FILE_NAME_SIZE];
+	unsigned char cdb[MPATH_PRIN_CMDLEN] =
+	{MPATH_PRIN_CMD, 0, 0, 0, 0, 0, 0, 0, 0, 0};
+
+	snprintf(devname, FILE_NAME_SIZE, "/dev/%s",dev);
+        fd = open(devname, O_WRONLY);
+        if(fd < 0){
+        	condlog(0, "%s: Unable to open device ", dev);
+		return MPATH_PR_FILE_ERROR;
+         }
+
+	mx_resp_len =  sizeof(struct prin_readdescr);
+	cdb[1] = (unsigned char)(rq_servact & 0x1f);
+	cdb[7] = (unsigned char)((mx_resp_len >> 8) & 0xff);
+	cdb[8] = (unsigned char)(mx_resp_len & 0xff);
+
+retry :
+	memset(&Sensedata, 0, sizeof(SenseData_t));
+	memset(&io_hdr,0 , sizeof( struct sg_io_hdr));
+
+	io_hdr.interface_id = 'S';
+	io_hdr.cmd_len = MPATH_PRIN_CMDLEN;
+	io_hdr.mx_sb_len = sizeof (SenseData_t);
+	io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+	io_hdr.cmdp = cdb;
+	io_hdr.sbp = (void *)&Sensedata;
+	io_hdr.timeout = TIMEOUT;
+
+	mx_resp_len = get_prin_length(rq_servact);
+
+
+	io_hdr.dxfer_len = mx_resp_len;
+	io_hdr.dxferp = (void *)resp;
+
+	ret =ioctl(fd, SG_IO, &io_hdr);
+	if (ret < 0){
+		condlog(0, "%s: IOCTL failed %d", dev, ret);
+		status = MPATH_PR_OTHER;
+		goto out;
+	}
+
+	got = mx_resp_len - io_hdr.resid;
+
+	condlog(2, "%s: duration = %u (ms)", dev, io_hdr.duration);
+
+	status = mpath_translate_response(dev, io_hdr, Sensedata, noisy);
+
+	if (status == MPATH_PR_SENSE_UNIT_ATTENTION && (retry > 0))
+	{
+		--retry;
+		condlog(2, "%s: retrying for Unit Attention. Remaining retries = %d", dev, retry);
+		goto retry;
+	}
+
+	if (((status == MPATH_PR_SENSE_NOT_READY )&& (Sensedata.ASC == 0x04)&&
+				(Sensedata.ASCQ == 0x07))&& (retry > 0))
+	{
+		usleep(1000);
+		--retry;
+		condlog(2, "%s: retrying for 02/04/07. Remaining retries = %d", dev, retry);
+		goto retry;
+	}
+
+	if (status != MPATH_PR_SUCCESS)
+		goto out;
+
+	if (noisy)
+		dumpHex((const char *)resp, got , 1);
+
+
+	switch (rq_servact)
+	{
+		case MPATH_PRIN_RKEY_SA :
+			mpath_format_readkeys(resp, got, noisy);
+			break;
+		case MPATH_PRIN_RRES_SA :
+			mpath_format_readresv(resp, got, noisy);
+			break;
+		case MPATH_PRIN_RCAP_SA :
+			mpath_format_reportcapabilities(resp, got, noisy);
+			break;
+		case MPATH_PRIN_RFSTAT_SA :
+			mpath_format_readfullstatus(resp, got, noisy);
+	}
+
+out:
+	close(fd);
+	return status;
+}
+
+int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr, SenseData_t Sensedata, int noisy)
+{
+	condlog(3, "%s: status driver:%02x host:%02x scsi:%02x", dev, 
+			io_hdr.driver_status, io_hdr.host_status ,io_hdr.status);
+	io_hdr.status &= 0x7e;
+	if ((0 == io_hdr.status) && (0 == io_hdr.host_status) &&
+			(0 == io_hdr.driver_status))
+	{
+		return MPATH_PR_SUCCESS;
+	}
+
+	switch(io_hdr.status)
+	{
+		case SAM_STAT_GOOD:
+			break;
+		case SAM_STAT_CHECK_CONDITION:
+			condlog(2, "%s: Sense_Key=%02x, ASC=%02x ASCQ=%02x", dev,
+					Sensedata.Sense_Key, Sensedata.ASC, Sensedata.ASCQ);
+			switch(Sensedata.Sense_Key)
+			{
+				case NO_SENSE:
+					return MPATH_PR_NO_SENSE;
+				case RECOVERED_ERROR:
+					return MPATH_PR_SUCCESS;
+				case NOT_READY:
+					return MPATH_PR_SENSE_NOT_READY;
+				case MEDIUM_ERROR:
+					return MPATH_PR_SENSE_MEDIUM_ERROR;
+				case BLANK_CHECK:
+					return MPATH_PR_OTHER;
+				case HARDWARE_ERROR:
+					return MPATH_PR_SENSE_HARDWARE_ERROR;
+				case ILLEGAL_REQUEST:
+					return MPATH_PR_ILLEGAL_REQ;
+				case UNIT_ATTENTION:
+					return MPATH_PR_SENSE_UNIT_ATTENTION;
+				case DATA_PROTECT:
+				case COPY_ABORTED:
+					return MPATH_PR_OTHER;
+				case ABORTED_COMMAND:
+					return MPATH_PR_SENSE_ABORTED_COMMAND;
+
+				default :
+					return MPATH_PR_OTHER;
+			}
+		case SAM_STAT_RESERVATION_CONFLICT:
+			return MPATH_PR_RESERV_CONFLICT;
+
+		default :
+			return  MPATH_PR_OTHER;
+	}
+
+	switch(io_hdr.host_status)
+	{
+		case DID_OK :
+			break;
+		default :
+			return MPATH_PR_OTHER;
+	}
+	switch(io_hdr.driver_status)
+	{
+		case DRIVER_OK:
+			break;
+		default :
+			return MPATH_PR_OTHER;
+	}
+	return MPATH_PR_SUCCESS;
+}
+
+int mpath_isLittleEndian()
+{
+	int num = 1;
+	if(*(char *)&num == 1)
+	{
+		condlog(2, "Little-Endian");
+	}
+	else
+	{
+		condlog(2, "Big-Endian");
+	}
+	return 0;
+}
+
+void mpath_reverse_uint16_byteorder(uint16_t *num)
+{
+	uint16_t byte0, byte1;
+
+	byte0 = (*num & 0x000000FF) >>  0 ;
+	byte1 = (*num & 0x0000FF00) >>  8 ;
+
+	*num = ((byte0 << 8) | (byte1 << 0));
+}
+
+void mpath_reverse_uint32_byteorder(uint32_t *num)
+{
+	uint32_t byte0, byte1, byte2, byte3;
+
+	byte0 = (*num & 0x000000FF) >>  0 ;
+	byte1 = (*num & 0x0000FF00) >>  8 ;
+	byte2 = (*num & 0x00FF0000) >> 16 ;
+	byte3 = (*num & 0xFF000000) >> 24 ;
+
+	*num = ((byte0 << 24) | (byte1 << 16) | (byte2 << 8) | (byte3 << 0));
+}
+
+void mpath_reverse_8bytes_order(char * var)
+{
+	char byte[8];
+
+	int i;
+	for(i=0 ; i < 8 ; i++ )
+	{
+		byte[i] = var[i];
+	}
+	for(i=0 ; i < 8 ; i++ )
+	{
+		var[7 - i] = byte[i];
+	}
+}
+
+void
+dumpHex(const char* str, int len, int log)
+{
+	const char * p = str;
+	const char * formatstr;
+	unsigned char c;
+	char buff[82];
+	const int bpstart = 5;
+	int bpos = bpstart;
+	int  k;
+
+	if (len <= 0)
+		return;
+	formatstr = (0 == log) ? "%.76s\n" : "%.56s\n";
+	memset(buff, ' ', 80);
+	buff[80] = '\0';
+	for (k = 0; k < len; k++) {
+		c = *p++;
+		bpos += 3;
+		if (bpos == (bpstart + (9 * 3)))
+			bpos++;
+		sprintf(&buff[bpos], "%.2x", (int)(unsigned char)c);
+		buff[bpos + 2] = ' ';
+		if ((k > 0) && (0 == ((k + 1) % 16))) {
+			if (log)
+				condlog(0, "%.76s" , buff);
+			else
+				printf("%.76s" , buff);
+			bpos = bpstart;
+			memset(buff, ' ', 80);
+		}
+	}
+	if (bpos > bpstart) {
+		buff[bpos + 2] = '\0';
+		if (log)
+			condlog(0, "%s", buff);
+		else
+			printf("%s\n" , buff);
+	}
+	return;
+}
+
+int get_prin_length(int rq_servact)
+{
+        int mx_resp_len;
+        switch (rq_servact)
+        {
+                case MPATH_PRIN_RKEY_SA:
+                        mx_resp_len =  sizeof(struct prin_readdescr);
+                        break;
+                case MPATH_PRIN_RRES_SA :
+                        mx_resp_len =  sizeof(struct prin_resvdescr);
+                        break;
+                case MPATH_PRIN_RCAP_SA :
+                        mx_resp_len = sizeof(struct prin_capdescr);
+                        break;
+                case MPATH_PRIN_RFSTAT_SA:
+                        mx_resp_len = sizeof(struct print_fulldescr_list) + sizeof(struct prin_fulldescr *)*32;
+                        break;
+        }
+        return mx_resp_len;
+}
diff -uprN multipath-tools-orig/libmpathpersist/mpath_pr_ioctl.h multipath-tools/libmpathpersist/mpath_pr_ioctl.h
--- multipath-tools-orig/libmpathpersist/mpath_pr_ioctl.h	1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools/libmpathpersist/mpath_pr_ioctl.h	2011-12-20 00:15:04.000000000 +0530
@@ -0,0 +1,111 @@
+#define MPATH_XFER_HOST_DEV              0   /*data transfer from initiator to target */
+#define MPATH_XFER_DEV_HOST              1   /*data transfer from target to initiator */
+#define MPATH_XFER_NONE                  2   /*no data transfer */
+#define MPATH_XFER_UNKNOWN               3   /*data transfer direction is unknown */
+
+#if 0
+static const char * pr_type_strs[] = {
+    "obsolete [0]",
+    "Write Exclusive",
+    "obsolete [2]",
+    "Exclusive Access",
+    "obsolete [4]",
+    "Write Exclusive, registrants only",
+    "Exclusive Access, registrants only",
+    "Write Exclusive, all registrants",
+    "Exclusive Access, all registrants",
+    "obsolete [9]", "obsolete [0xa]", "obsolete [0xb]", "obsolete [0xc]",
+    "obsolete [0xd]", "obsolete [0xe]", "obsolete [0xf]",
+};
+#endif
+
+typedef unsigned int     LWORD;     /* unsigned numeric, bit patterns */
+typedef unsigned char    BYTE;      /* unsigned numeric, bit patterns */
+
+typedef struct SenseData
+{
+    BYTE        Error_Code;
+    BYTE        Segment_Number; /* not applicable to DAC */
+    BYTE        Sense_Key;
+    BYTE        Information[ 4 ];
+    BYTE        Additional_Len;
+    LWORD       Command_Specific_Info;
+    BYTE        ASC;
+    BYTE        ASCQ;
+    BYTE        Field_Replaceable_Unit;
+    BYTE        Sense_Key_Specific_Info[ 3 ];
+    BYTE        Recovery_Action[ 2 ];
+    BYTE        Total_Errors;
+    BYTE        Total_Retries;
+    BYTE        ASC_Stack_1;
+    BYTE        ASCQ_Stack_1;
+    BYTE        ASC_Stack_2;
+    BYTE        ASCQ_Stack_2;
+    BYTE        Additional_FRU_Info[ 8 ];
+    BYTE        Error_Specific_Info[ 3 ];
+    BYTE        Error_Detection_Point[ 4 ];
+    BYTE        Original_CDB[10];
+    BYTE        Host_ID;
+    BYTE        Host_Descriptor[ 2 ];
+    BYTE        Serial_Number[ 16 ];
+    BYTE        Array_SW_Revision[ 4 ];
+    BYTE        Data_Xfer_Operation;
+    BYTE        LUN_Number;
+    BYTE        LUN_Status;
+    BYTE        Drive_ID;
+    BYTE        Xfer_Start_Drive_ID;
+    BYTE        Drive_SW_Revision[ 4 ];
+    BYTE        Drive_Product_ID[ 16 ];
+    BYTE        PowerUp_Status[ 2 ];
+    BYTE        RAID_Level;
+    BYTE        Drive_Sense_ID[ 2 ];
+    BYTE        Drive_Sense_Data[ 32 ];
+    BYTE        Reserved2[24];
+} SenseData_t;
+
+#define MPATH_PRIN_CMD 0x5e
+#define MPATH_PRIN_CMDLEN 10
+#define MPATH_PROUT_CMD 0x5f
+#define MPATH_PROUT_CMDLEN 10
+
+#define  DID_OK	0x00
+/*
+ *  Status codes
+ */
+#define SAM_STAT_GOOD            0x00
+#define SAM_STAT_CHECK_CONDITION 0x02
+#define SAM_STAT_CONDITION_MET   0x04
+#define SAM_STAT_BUSY            0x08
+#define SAM_STAT_INTERMEDIATE    0x10
+#define SAM_STAT_INTERMEDIATE_CONDITION_MET 0x14
+#define SAM_STAT_RESERVATION_CONFLICT 0x18
+#define SAM_STAT_COMMAND_TERMINATED 0x22        /* obsolete in SAM-3 */
+#define SAM_STAT_TASK_SET_FULL   0x28
+#define SAM_STAT_ACA_ACTIVE      0x30
+#define SAM_STAT_TASK_ABORTED    0x40
+
+#define STATUS_MASK          0x3e
+
+/*
+ *  SENSE KEYS
+ */
+
+#define NO_SENSE            0x00
+#define RECOVERED_ERROR     0x01
+#define NOT_READY           0x02
+#define MEDIUM_ERROR        0x03
+#define HARDWARE_ERROR      0x04
+#define ILLEGAL_REQUEST     0x05
+#define UNIT_ATTENTION      0x06
+#define DATA_PROTECT        0x07
+#define BLANK_CHECK         0x08
+#define COPY_ABORTED        0x0a
+#define ABORTED_COMMAND     0x0b
+#define VOLUME_OVERFLOW     0x0d
+#define MISCOMPARE          0x0e
+
+
+/* Driver status */
+#define DRIVER_OK 0x00
+
+
diff -uprN multipath-tools-orig/libmpathpersist/mpath_updatepr.c multipath-tools/libmpathpersist/mpath_updatepr.c
--- multipath-tools-orig/libmpathpersist/mpath_updatepr.c	1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools/libmpathpersist/mpath_updatepr.c	2011-12-20 00:15:04.000000000 +0530
@@ -0,0 +1,50 @@
+#include<stdio.h>
+#include<unistd.h>
+#include <errno.h>
+
+#include <stdlib.h>
+#include <stdarg.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <sys/poll.h>
+#include <errno.h>
+#include <debug.h>
+#include "memory.h"
+#include "../libmultipath/uxsock.h"
+
+unsigned long mem_allocated;    /* Total memory used in Bytes */
+
+int update_prflag(char * arg1, char * arg2, int noisy)
+{
+	int fd;
+	char str[64];
+	char *reply;
+	size_t len;
+	int ret = 0;
+
+	fd = ux_socket_connect("/var/run/multipathd.sock");
+	if (fd == -1) {
+		condlog (0, "ux socket connect error");
+		return 1 ;
+	}
+
+	snprintf(str,sizeof(str),"map %s %s", arg1, arg2);
+	condlog (2, "%s: pr flag message=%s", arg1, str);
+	send_packet(fd, str, strlen(str) + 1);
+	recv_packet(fd, &reply, &len);
+
+	condlog (2, "%s: message=%s reply=%s", arg1, str, reply);
+	if (!reply || strncmp(reply,"ok", 2) == 0)
+		ret = -1;
+	else if (strncmp(reply, "fail", 4) == 0)
+		ret = -2;
+	else{
+		ret = atoi(reply);
+	}
+
+	free(reply);
+	return ret;
+}
diff -uprN multipath-tools-orig/libmpathpersist/README multipath-tools/libmpathpersist/README
--- multipath-tools-orig/libmpathpersist/README	1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools/libmpathpersist/README	2011-12-20 00:15:04.000000000 +0530
@@ -0,0 +1,212 @@
+Updated: 06/27/2011                           
+================================================================
+
+Contents
+================================================================
+1. OS Support
+2. Installation Instructions
+   2.1 Requirements and assumptions 
+   2.2 Installation of rpms 
+   2.3 mpathpersist library and device mapper multipath tools  post-Installation
+3. mpathpersist library  usages
+4. mpath_persist Header file
+5. mpathpersist Utility
+6. Restrictions
+7. Reference 
+8. GPL License
+
+1. OS Support
+	mpathpersist library  and utility is supported on following Linux distributions:
+		RHEL5 Update 6 (x86)
+		RHEL5 Update 6 (x86_64)
+
+2. Installation Instructions:
+   2.1. Requirements and assumptions 
+	Requirements and assumptions before mpathpersist library and device mapper multipath 
+	tools package installation:
+	a. It's assumed that the host system on which mpathpersist library and device mapper 
+		multipath tool are being installed has supported configuration for device mapper multipath.    
+	b. User must have root privilege while installing rpms.
+	c. Ensure multipathd daemon is not running. multipathd daemon can be stopped with following instruction: 
+		# /etc/init.d/multipathd stop
+   2.2 Installation of rpms 
+	a. Install mpathpersist library
+		# rpm -Uvh libmpathpersist-<version>.<arch>.rpm
+	b.   Install kpartx rpm 
+		#  rpm -Uvh kpartx-<version>.<arch>.rpm
+	c. Install 
+		# rpm -Uvh device-mapper-multipath-<version>.<arch>.rpm 
+
+   2.3 mpathpersist library and device mapper multipath tools  post-Installation
+	a. Restart multipathd daemon 
+		# /etc/init.d/multipathd start
+
+3. mpathpersist library  usages
+	mpathpersist library provides four APIs for managing persistent reservation on device mapper multipath 
+	device. libmpathpersist.so is a link pointing to libmpathpersist.so.X [X is a library version].  
+	mpathpersist  Library  APIs.
+
+	a. int mpath_lib_init (void )
+	DESCRIPTION :
+	Initialize device mapper multipath configuration. This function must be	invoked first before performing 
+	reservation management functions.
+
+	RETURNS: 
+	0->Success, 1->Failed	
+	Note: mpath_lib_init function must be called at the start of the usage of PR management APIs (such as 
+	mpath_persistent_reserve_in or mpath_persistent_reserve_out). This function is responsible for initializing 
+	config table. (Any dynamic allocation done by mpath_lib_init function will be de-allocated only by mpath_lib_exit API).
+
+		
+	b.	int mpath_lib_exit (void )
+	DESCRIPTION:
+	Release device mapper multipath configuration. This function must be invoked after performing 
+	reservation management functions.
+
+	RETURNS: 
+	0->Success, 1->Failed.
+
+	Note: mpath_lib_exit function must be called at the end of the usage of PR management APIs (such as 
+	mpath_persistent_reserve_in or mpath_persistent_reserve_out). This function is responsible for freeing
+	up the dynamic allocation made by mpath_lib_init function.
+
+	c. int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp *resp, int noisy, int verbose)
+	DESCRIPTION:
+	The function in the mpath_persistent_reserve_in() sends PRIN command to the DM device and gets the response.
+
+	PARAMETERS:
+	fd - The file descriptor of a multipath device. Input argument.
+	rq_servact  -  PRIN command service action. Input argument
+	resp - The response from PRIN service action. The caller should manage the memory allocation of this structure
+	noisy - Turn on debugging trace: Input argument. 0->Disable, 1->Enable
+        verbose -  Set verbosity level. Input argument. value:[0-3]. 0->Crits and Errors, 1->Warnings, 2->Info, 3->Debug
+
+	RETURNS
+        MPATH_PR_SUCCESS if PR command successful
+        MPATH_PR_SYNTAX_ERROR if syntax error or invalid parameter
+        MPATH_PR_SENSE_NOT_READY if command fails with [sk,asc,ascq: 0x2,*,*]
+        MPATH_PR_SENSE_MEDIUM_ERROR if command fails with [sk,asc,ascq: 0x3,*,*]
+        MPATH_PR_SENSE_HARDWARE_ERROR if command fails with [sk,asc,ascq: 0x4,*,*]
+        MPATH_PR_SENSE_INVALID_OP if command fails with [sk,asc,ascq: 0x5,0x20,0x0]
+        MPATH_PR_ILLEGAL_REQ if command fails with [sk,asc,ascq: 0x5,*,*]
+        MPATH_PR_SENSE_UNIT_ATTENTION if command fails with [sk,asc,ascq: 0x6,*,*]
+        MPATH_PR_SENSE_ABORTED_COMMAND if command fails with [sk,asc,ascq: 0xb,*,*]
+        MPATH_PR_NO_SENSE if command fails with [sk,asc,ascq: 0x0,*,*]
+        MPATH_PR_SENSE_MALFORMED if command fails with SCSI command malformed
+        MPATH_PR_FILE_ERROR if command fails while accessing file (device node) problems(e.g. not found)
+        MPATH_PR_DMMP_ERROR if Device Mapper related error.(e.g Error in getting dm info)
+        MPATH_PR_OTHER if other error/warning has occurred(e.g transport or driver error)
+ 
+	d. int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope, unsigned int rq_type, 
+	   	struct rout_param_descriptor *paramp, int noisy, int verbose)
+	DESCRIPTION
+	The function in the mpath_persistent_reserve_out() sends PR OUT command to the DM device and gets the response.
+	PARAMETERS:
+	fd - The file descriptor of a multipath device. Input argument.
+	rq_servact  - PROUT command service action. Input argument
+	rq_scope - Persistent reservation scope. The value should be always LU_SCOPE (0h).
+	rq_type - Persistent reservation type. The valid values of persistent reservation types are
+             5h (Write exclusive - registrants only)
+             8h (Exclusive access - registrants only)
+             7h (Write exclusive - All registrants)
+             8h (Exclusive access - All registrants).
+	paramp - PROUT  command  parameter  data.  The paramp is a struct which describes PROUT parameter list. Caller should 
+		 manage the memory  allocation of this structure. noisy Turn on debugging trace: Input argument. 0->Disable, 1->Enable. 
+	verbose - Set verbosity level. Input argument. value: 0 to 3. 0->Crits and Errors, 1->Warnings, 2->Info, 3->Debug
+
+
+4. mpath_persist Header file
+
+	Macro definitions
+	-------------------
+	#define MPATH_MX_TIDS           32        /* Max number of transport ids*/
+	#define MPATH_MX_TID_LEN        256       /* Max lenght of transport id */
+
+	Maximum 32 transport ids can be passed as parameter for persistent reserve out command. Length of each 
+	transport id should not exceed 256 bytes. FC, ISCSI and SAS are the only supported transport protocols.
+	Transport id for the respective transport protocol (i.e n_port_name[8], sas_address[8], iscsi_name[256]) 
+	should be well formated as defined in SCSI Primary Commands . 3[T10.org]. 
+
+	struct transportid
+	{
+	        uint8_t format_code;
+	        uint8_t protocol_id;
+	        union {
+	                uint8_t n_port_name[8]; /* FC transport*/
+	                uint8_t sas_address[8]; /* SAS transport */
+        	        uint8_t iscsi_name[256]; /* ISCSI  transport */
+        	};
+	};
+
+
+	PROUT parameter descriptor:
+	struct prout_param_descriptor {        
+	        uint8_t  key[8];
+	        uint8_t  sa_key[8];
+	        uint32_t _obsolete;
+	        uint8_t  sa_flags;
+	        uint8_t _reserved;
+	        uint16_t _obsolete1;
+	        uint8_t  private_buffer[MPATH_MAX_PARAM_LEN]; /*private buffer for list storage*/
+	        uint32_t num_transportid;       /* Number of Transport ID listed in trnptid_list[]*/
+	        struct transportid *trnptid_list[];
+	};
+
+	Example: Total length of memory allocation for struct prout_param_descriptor should be calculated 
+	as following : 
+	sizeof(struct prout_param_descriptor) + (sizeof(struct transportid *)*(MPATH_MX_TIDS ))
+	[here MPATH_MX_TIDS is the max number of transport ids]
+
+
+	Note : Application using libmpathpersist needs to carefully allocate the prout parameter descriptor
+	while using transport descriptor ( if the user needs to mention transport id) as the flexible array 
+	structure memeber. 
+
+
+	Note: Number of transport ids allocated  must be also mentioned in num_transportid structure memeber.
+
+
+5. mpathpersist utility usages example:
+	PROUT Register service action: 
+	# mpathpersist --out --register --param-sark=123abc --prout-type=5 /dev/mapper/mpath9
+
+	PROUT Reserve service action
+	# mpathpersist --out --reserve --param-rk=123abc --prout-type=5	/dev/mapper/mpath9
+
+	PROUT Release service action
+	# mpathpersist --out --release --param-rk=123abc --prout-type=5 /dev/mapper/mpath9
+
+	PROUT Unregister service action
+	# mpathpersist --out --register --param-rk=123abc --prout-type=5 /dev/mapper/mpath9
+
+	PROUT clear service action
+	mpathpersist --out --clear --param-rk=123abc --prout-type=5 /dev/mapper/mpath9
+
+	PROUT Preempt and abort service action
+	# mpathpersist --out --preempt-abort --param-rk=123abc --paramsark=789def --prout-type=5 /dev/mapper/mpath9
+
+	PROUT Preempt
+	# mpathpersist --out --preempt-abort --param-rk=0 --paramsark=789def --prout-type=5 /dev/mapper/mpath9
+
+	PRIN read key
+	# mpathpersist -i -k /dev/mapper/mpath9
+
+	PRIN PRIN  read reservation
+	# mpathpersist -i -r /dev/mapper/mpath9
+
+
+6. Restrictions
+	- Physical paths should not be used for persistent management.
+	- Reservation key provided to mpathpersist utility/libmpathpersist should match with key mentioned in
+	  multipath.conf.
+	- Supported on RHEL5 Update 6. 
+	- ALL_TG_PT flag is set to 0 for PROUT command.
+
+7. Reference 
+	- man page 
+		a. mpath_persistent_reserve_in
+		b. mpath_persistent_reserve_out
+		c. mpathpersist
+	
+8. GPL License
+	mpathpersist library and utility  carry GPL License.
diff -uprN multipath-tools-orig/mpathpersist/main.c multipath-tools/mpathpersist/main.c
--- multipath-tools-orig/mpathpersist/main.c	1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools/mpathpersist/main.c	2011-12-20 00:27:13.000000000 +0530
@@ -0,0 +1,808 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <checkers.h>
+#include <vector.h>
+#include <structs.h>
+#include <getopt.h>
+#include <mpath_persist.h>
+#include "main.h"
+#include <pthread.h>
+#include <ctype.h>
+#include <string.h>
+
+static const char * pr_type_strs[] = {
+	"obsolete [0]",
+	"Write Exclusive",
+	"obsolete [2]",
+	"Exclusive Access",
+	"obsolete [4]",
+	"Write Exclusive, registrants only",
+	"Exclusive Access, registrants only",
+	"Write Exclusive, all registrants",
+	"Exclusive Access, all registrants",
+	"obsolete [9]", "obsolete [0xa]", "obsolete [0xb]", "obsolete [0xc]",
+	"obsolete [0xd]", "obsolete [0xe]", "obsolete [0xf]",
+};
+
+int get_transportids_length(unsigned char * transportid_arr, int max_transportid, int num_transportids);
+void mpath_print_buf_readcap(struct prin_resp *pr_buff); 
+void mpath_print_buf_readfullstat(struct prin_resp *pr_buff);
+void mpath_print_buf_readresv(struct prin_resp *pr_buff);
+void mpath_print_buf_readkeys(struct prin_resp *pr_buff);
+void dumpHex(const char* str, int len, int no_ascii);
+void * mpath_alloc_prin_response(int prin_sa);	
+void mpath_print_transport_id(struct prin_fulldescr *fdesc);
+int construct_transportid(const char * inp, struct transportid transid[], int num_transportids);
+
+int logsink;
+
+int main (int argc, char * argv[])
+{
+	int fd, c, res;
+	const char *device_name = NULL;
+	int num_prin_sa = 0;
+	int num_prout_sa = 0;
+	int num_prout_param = 0;
+	int prin_flag = 0;
+	int prout_flag = 0;
+	int ret = 0;
+	int hex = 0;
+	uint64_t param_sark = 0;
+	unsigned int prout_type = 0;
+	int param_alltgpt = 0;
+	int param_aptpl = 0;
+	uint64_t param_rk = 0;
+	unsigned int param_rtp = 0;
+	int num_transportids = 0;
+	struct transportid transportids[MPATH_MX_TIDS];
+	int prout = 1;
+	int prin = 1;
+	int prin_sa = -1;
+	int prout_sa = -1;
+	int verbose = 0;
+	int loglevel = 0;
+	int noisy = 0;
+	int num_transport =0;
+	void *resp = NULL;
+	struct transportid * tmp; 
+
+	if (optind == argc)
+	{
+
+		fprintf (stderr, "No parameter used\n");
+		usage ();
+		exit (1);
+	}
+
+	if (getuid () != 0)
+	{
+		fprintf (stderr, "need to be root\n");
+		exit (1);
+	}
+
+
+	mpath_lib_init();
+	memset(transportids,0,MPATH_MX_TIDS);
+
+	while (1)
+	{
+		int option_index = 0;
+
+		c = getopt_long (argc, argv, "v:Cd:hHioZK:S:PAT:skrGILcRX:",
+				long_options, &option_index);
+		if (c == -1)
+			break;
+
+		switch (c)
+		{
+			case 'v':
+				if (1 != sscanf (optarg, "%d", &loglevel))
+				{
+					fprintf (stderr, "bad argument to '--verbose'\n");
+					return MPATH_PR_SYNTAX_ERROR;
+				}
+				break;
+
+			case 'C':
+				prout_sa = MPATH_PROUT_CLEAR_SA;
+				++num_prout_sa;
+				break;
+
+			case 'd':
+				device_name = optarg;
+				break;
+
+			case 'h':
+				usage ();
+				return 0;
+
+			case 'H':
+				hex=1;
+				break;
+
+			case 'i':
+				prin_flag = 1;
+				break;
+
+			case 'o':
+				prout_flag = 1;
+				break;
+
+			case 'Z':
+				param_aptpl = 1;
+				++num_prout_param;
+				break;
+			case 'K':
+				if (1 != sscanf (optarg, "%" SCNx64 "", &param_rk))
+				{
+					fprintf (stderr, "bad argument to '--param-rk'\n");
+					return MPATH_PR_SYNTAX_ERROR;
+				}
+				++num_prout_param;
+				break;
+
+			case 'S':
+				if (1 != sscanf (optarg, "%" SCNx64 "", &param_sark))
+				{
+					fprintf (stderr, "bad argument to '--param-sark'\n");
+					return MPATH_PR_SYNTAX_ERROR;
+				}
+				++num_prout_param;
+				break;
+
+			case 'P':
+				prout_sa = MPATH_PROUT_PREE_SA;
+				++num_prout_sa;
+				break;
+
+			case 'A':
+				prout_sa = MPATH_PROUT_PREE_AB_SA;
+				++num_prout_sa;
+				break;
+
+			case 'T':
+				if (1 != sscanf (optarg, "%x", &prout_type))
+				{
+					fprintf (stderr, "bad argument to '--prout-type'\n");
+					return MPATH_PR_SYNTAX_ERROR;
+				}
+				++num_prout_param;
+				break;
+
+			case 's':
+				prin_sa = MPATH_PRIN_RFSTAT_SA;
+				++num_prin_sa;
+				break;
+
+			case 'k':
+				prin_sa = MPATH_PRIN_RKEY_SA;
+				++num_prin_sa;
+				break;
+
+			case 'r':
+				prin_sa = MPATH_PRIN_RRES_SA;
+				++num_prin_sa;
+				break;
+
+			case 'G':
+				prout_sa = MPATH_PROUT_REG_SA;
+				++num_prout_sa;
+				break;
+
+			case 'I':
+				prout_sa = MPATH_PROUT_REG_IGN_SA;
+				++num_prout_sa;
+				break;
+
+			case 'L':
+				prout_sa = MPATH_PROUT_REL_SA;
+				++num_prout_sa;
+				break;
+
+			case 'c':
+				prin_sa = MPATH_PRIN_RCAP_SA;
+				++num_prin_sa;
+				break;
+
+			case 'R':
+				prout_sa = MPATH_PROUT_RES_SA;
+				++num_prout_sa;
+				break;
+
+			case 'X':
+				if (0 != construct_transportid(optarg, transportids, num_transport)) {
+					fprintf(stderr, "bad argument to '--transport-id'\n");
+					return MPATH_PR_SYNTAX_ERROR;
+				}
+
+				++num_transport;
+				break;
+
+			default:
+				fprintf(stderr, "unrecognised switch " "code 0x%x ??\n", c);	
+				usage ();
+				ret = MPATH_PR_SYNTAX_ERROR;
+				goto out;
+		}
+	}
+
+	if (optind < argc)
+	{
+
+		if (NULL == device_name)
+		{
+			device_name = argv[optind];
+			++optind;
+		}
+		if (optind < argc)
+		{
+			for (; optind < argc; ++optind)
+				fprintf (stderr, "Unexpected extra argument: %s\n", argv[optind]);
+			usage ();
+			ret = MPATH_PR_SYNTAX_ERROR;
+			goto out;
+		}
+	}
+
+	/* set verbosity */
+	noisy = (loglevel >= 3) ? 1: 0;
+	verbose	= (loglevel >= 3)? 3: loglevel;
+
+	if ((prout_flag + prin_flag) == 0)
+	{
+		fprintf (stderr, "choose either '--in' or '--out' \n");
+		usage ();
+		ret = MPATH_PR_SYNTAX_ERROR;
+		goto out;
+	}
+	if ((prout_flag + prin_flag) > 1)
+	{
+		fprintf (stderr, "choose either '--in' or '--out' \n");
+		usage ();
+		ret = MPATH_PR_SYNTAX_ERROR;
+		goto out;
+	}
+	else if (prout_flag)
+	{				/* syntax check on PROUT arguments */
+		prin = 0;
+		if ((1 != num_prout_sa) || (0 != num_prin_sa))
+		{
+			fprintf (stderr, " For Persistent Reserve Out only one "
+					"appropriate\n service action must be "
+					"chosen \n");
+			ret = MPATH_PR_SYNTAX_ERROR;
+			goto out;
+		}
+	}
+	else if (prin_flag)
+	{				/* syntax check on PRIN arguments */
+		prout = 0;
+		if (num_prout_sa > 0)
+		{
+			fprintf (stderr, " When a service action for Persistent "
+					"Reserve Out is chosen the\n"
+					" '--out' option must be given \n");
+			ret = MPATH_PR_SYNTAX_ERROR;
+			goto out;
+		}
+		if (0 == num_prin_sa)
+		{
+			fprintf (stderr,
+					" No service action given for Persistent Reserve IN\n");
+			usage();
+			ret = MPATH_PR_SYNTAX_ERROR;
+		}
+		else if (num_prin_sa > 1)
+		{
+			fprintf (stderr, " Too many service actions given; choose "
+					"one only\n");
+			usage();
+			ret = MPATH_PR_SYNTAX_ERROR;
+		}
+	}
+	else
+	{
+		usage ();
+		ret = MPATH_PR_SYNTAX_ERROR;
+		goto out;
+	}
+
+	if ((param_rtp) && (MPATH_PROUT_REG_MOV_SA != prout_sa))
+	{
+		fprintf (stderr, " --relative-target-port"
+				" only useful with --register-move\n");
+		usage ();
+		ret = MPATH_PR_SYNTAX_ERROR;
+		goto out;
+	}
+
+	if (((MPATH_PROUT_RES_SA == prout_sa) ||
+				(MPATH_PROUT_REL_SA == prout_sa) ||
+				(MPATH_PROUT_PREE_SA == prout_sa) ||
+				(MPATH_PROUT_PREE_AB_SA == prout_sa)) &&
+			(0 == prout_type)) {
+		fprintf(stderr, "Warning: --prout-type probably needs to be "
+				"given\n");
+	}
+	if ((verbose > 2) && num_transportids)
+	{
+		fprintf (stderr, "number of tranport-ids decoded from "
+				"command line : %d\n", num_transportids);
+	}
+
+	if (device_name == NULL)
+	{
+		fprintf (stderr, "No device name given \n");
+		usage ();
+		ret = MPATH_PR_SYNTAX_ERROR;
+		goto out;
+	}
+
+	/* open device */
+	if ((fd = open (device_name, O_WRONLY)) < 0)
+	{
+		fprintf (stderr, "%s: error opening file (rw) fd=%d\n",
+				device_name, fd);
+		ret = MPATH_PR_FILE_ERROR;
+		goto out;
+	}
+
+
+	if (prin)
+	{
+		resp = mpath_alloc_prin_response(prin_sa);
+		if (!resp)
+		{
+			fprintf (stderr, "failed to allocate PRIN response buffer\n");
+			ret = MPATH_PR_OTHER;
+			goto out;
+		}
+
+		ret = mpath_persistent_reserve_in (fd, prin_sa, resp, noisy, verbose);
+		if (ret != MPATH_PR_SUCCESS )
+		{
+			fprintf (stderr, "Persistent Reserve IN command failed\n");
+			goto out;	
+		}
+
+		switch(prin_sa)
+		{			
+			case MPATH_PRIN_RKEY_SA: 
+				mpath_print_buf_readkeys(resp);		
+				break;
+			case MPATH_PRIN_RRES_SA: 
+				mpath_print_buf_readresv(resp);
+				break;
+			case MPATH_PRIN_RCAP_SA:
+				mpath_print_buf_readcap(resp);		
+				break;
+			case MPATH_PRIN_RFSTAT_SA:
+				mpath_print_buf_readfullstat(resp);		
+				break;
+		}
+		free(resp);
+	}
+	else if (prout)
+	{
+		int j; 
+		int t_arr_len=0;
+		struct prout_param_descriptor *paramp;
+		t_arr_len = MPATH_MX_TID_LEN * num_transport;
+
+		paramp= malloc(sizeof(struct prout_param_descriptor) + (sizeof(struct transportid *)*(MPATH_MX_TIDS )));
+		
+		memset(paramp, 0, sizeof(struct prout_param_descriptor) + (sizeof(struct transportid *)*(MPATH_MX_TIDS)));
+
+		for (j = 7; j >= 0; --j) {
+			paramp->key[j] = (param_rk & 0xff);
+			param_rk >>= 8;
+		}
+
+		for (j = 7; j >= 0; --j) {
+			paramp->sa_key[j] = (param_sark & 0xff);
+			param_sark >>= 8;
+		}
+
+		if (param_alltgpt)
+			paramp->sa_flags |= 0x4;
+		if (param_aptpl)
+			paramp->sa_flags |= 0x1;
+
+		if (num_transport) 
+		{
+			paramp->sa_flags |= MPATH_F_SPEC_I_PT_MASK;
+			paramp->num_transportid = num_transport;
+			for (j = 0 ; j < num_transport; j++)
+			{
+				paramp->trnptid_list[j] = (struct transportid *)malloc(sizeof(struct transportid));
+				memcpy(paramp->trnptid_list[j], &transportids[j],sizeof(struct transportid));
+			}
+		}
+
+		/* PROUT commands other than 'register and move' */
+		ret = mpath_persistent_reserve_out (fd, prout_sa, 0, prout_type,
+				paramp, noisy, verbose);
+		for (j = 0 ; j < num_transport; j++)
+		{
+			tmp = paramp->trnptid_list[j];
+			free(tmp);
+		}
+		free(paramp);
+	}
+
+	if (ret != MPATH_PR_SUCCESS)
+	{
+		switch(ret)
+		{
+			case MPATH_PR_SENSE_UNIT_ATTENTION:
+				printf("persistent reserve out: scsi status: Unit Attention\n");
+				break;
+			case MPATH_PR_RESERV_CONFLICT:
+				printf("persistent reserve out: scsi status: Reservation Conflict\n");
+				break;
+		}
+		printf("PR out: command failed\n");
+	}
+
+	res = close (fd);
+	if (res < 0)
+	{
+		mpath_lib_exit();
+		return MPATH_PR_FILE_ERROR;
+	}
+
+out :
+	mpath_lib_exit();
+
+	return (ret >= 0) ? ret : MPATH_PR_OTHER;
+}
+
+int
+get_transportids_length(unsigned char * transportid_arr, int max_transportid, int num_transportids)
+{
+	int compact_len = 0;
+	unsigned char * ucp = transportid_arr;
+	int k, off, protocol_id, len;
+	for (k = 0, off = 0; ((k < num_transportids) && (k < max_transportid));
+			++k, off += MPATH_MX_TID_LEN) {
+		protocol_id = ucp[off] & 0xf;
+		if (5 == protocol_id) {
+			len = (ucp[off + 2] << 8) + ucp[off + 3] + 4;
+			if (len < 24)
+				len = 24;
+			if (off > compact_len)
+				memmove(ucp + compact_len, ucp + off, len);
+			compact_len += len;
+
+		} else {
+			if (off > compact_len)
+				memmove(ucp + compact_len, ucp + off, 24);
+			compact_len += 24;
+		}
+	}
+
+	return compact_len;
+}
+
+void mpath_print_buf_readkeys( struct prin_resp *pr_buff)
+{
+	int i,j,k, num;
+	unsigned char *keyp;
+	uint64_t prkey;
+	printf("  PR generation=0x%x, ", pr_buff->prin_descriptor.prin_readkeys.prgeneration);
+
+	num = pr_buff->prin_descriptor.prin_readkeys.additional_length / 8;
+	if (0 == num) {
+		printf("	0 registered reservation key.\n");
+		return;
+	}
+	else if (1 == num)
+		printf("	1 registered reservation key follows:\n");
+	else
+		printf("	%d registered reservation keys follow:\n", num);
+
+
+	keyp = (unsigned char *)&pr_buff->prin_descriptor.prin_readkeys.key_list[0];
+	for (i = 0; i < num ; i++)
+	{
+		prkey = 0;
+		for (j = 0; j < 8; ++j) {
+
+			if (j > 0)
+				prkey <<= 8;
+			prkey |= keyp[j];
+		}
+		printf("    0x%" PRIx64 "\n", prkey);
+		k=8*i+j;
+		keyp = (unsigned char *)&pr_buff->prin_descriptor.prin_readkeys.key_list[k];
+	}
+}
+
+void mpath_print_buf_readresv( struct prin_resp *pr_buff)
+{
+	int j, num, scope=0, type=0;
+	unsigned char *keyp;
+	uint64_t prkey;	
+
+	num = pr_buff->prin_descriptor.prin_readresv.additional_length / 8;
+	if (0 == num)
+	{
+		printf("  PR generation=0x%x, there is NO reservation held \n", pr_buff->prin_descriptor.prin_readresv.prgeneration);
+		return ;
+	}
+	else
+		printf("  PR generation=0x%x, Reservation follows:\n", pr_buff->prin_descriptor.prin_readresv.prgeneration);
+	keyp = (unsigned  char *)&pr_buff->prin_descriptor.prin_readkeys.key_list[0]; 
+	prkey = 0;
+	for (j = 0; j < 8; ++j) {
+		if (j > 0)
+			prkey <<= 8;
+		prkey |= keyp[j];
+	}
+
+	printf("   Key = 0x%" PRIx64 "\n", prkey);
+
+	scope = (pr_buff->prin_descriptor.prin_readresv.scope_type >> 4) &  0x0f;
+	type = pr_buff->prin_descriptor.prin_readresv.scope_type & 0x0f;
+
+	if (scope == 0)	
+		printf("  scope = LU_SCOPE, type = %s", pr_type_strs[type]);
+	else
+		printf("  scope = %d, type = %s", scope, pr_type_strs[type]);
+
+	printf("\n");
+
+}
+
+void mpath_print_buf_readcap( struct prin_resp *pr_buff)
+{
+	if ( pr_buff->prin_descriptor.prin_readcap.length <= 2 ) {
+		fprintf(stderr, "Unexpected response for PRIN Report "
+				"Capabilities\n");
+		return; //MALFORMED;
+	}
+
+	printf("Report capabilities response:\n");
+
+	printf("  Compatible Reservation Handling(CRH): %d\n", !!(pr_buff->prin_descriptor.prin_readcap.flags[0] & 0x10));
+	printf("  Specify Initiator Ports Capable(SIP_C): %d\n",!!(pr_buff->prin_descriptor.prin_readcap.flags[0] & 0x8));
+	printf("  All Target Ports Capable(ATP_C): %d\n",!!(pr_buff->prin_descriptor.prin_readcap.flags[0] & 0x4 ));
+	printf("  Persist Through Power Loss Capable(PTPL_C): %d\n",!!(pr_buff->prin_descriptor.prin_readcap.flags[0]));
+	printf("  Type Mask Valid(TMV): %d\n", !!(pr_buff->prin_descriptor.prin_readcap.flags[1] & 0x80));
+	printf("  Allow Commands: %d\n", !!(( pr_buff->prin_descriptor.prin_readcap.flags[1] >> 4) & 0x7));
+	printf("  Persist Through Power Loss Active(PTPL_A): %d\n",
+			!!(pr_buff->prin_descriptor.prin_readcap.flags[1] & 0x1));
+
+	if(pr_buff->prin_descriptor.prin_readcap.flags[1] & 0x80)
+	{
+		printf("    Support indicated in Type mask:\n");
+
+		printf("      %s: %d\n", pr_type_strs[7], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x80);
+		printf("      %s: %d\n", pr_type_strs[6], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x40);
+		printf("      %s: %d\n", pr_type_strs[5], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x20);
+		printf("      %s: %d\n", pr_type_strs[3], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x8);
+		printf("      %s: %d\n", pr_type_strs[1], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x2);
+		printf("      %s: %d\n", pr_type_strs[8], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x100);
+	}
+}
+
+void mpath_print_buf_readfullstat( struct prin_resp *pr_buff)
+{
+
+	int i,j, num;
+	uint64_t  prkey;
+	uint16_t  rel_pt_addr;
+	unsigned char * keyp;
+
+	num = pr_buff->prin_descriptor.prin_readfd.number_of_descriptor;	
+	if (0 == num)
+	{
+		printf("  PR generation=0x%x \n", pr_buff->prin_descriptor.prin_readfd.prgeneration);
+		return ;
+	}
+	else
+		printf("  PR generation=0x%x \n", pr_buff->prin_descriptor.prin_readfd.prgeneration);
+
+	for (i = 0 ; i < num; i++)
+	{
+		keyp = (unsigned  char *)&pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key;
+
+		prkey = 0;
+		for (j = 0; j < 8; ++j) {
+			if (j > 0)
+				prkey <<= 8;
+			prkey |= *keyp;
+			++keyp;
+		}
+		printf("   Key = 0x%" PRIx64 "\n", prkey);
+
+		if (pr_buff->prin_descriptor.prin_readfd.descriptors[i]->flag & 0x02)	
+			printf("      All target ports bit set\n");
+		else {
+			printf("      All target ports bit clear\n");
+
+			rel_pt_addr = pr_buff->prin_descriptor.prin_readfd.descriptors[i]->rtpi;
+			printf("      Relative port address: 0x%x\n",
+					rel_pt_addr);
+		}
+
+		if (pr_buff->prin_descriptor.prin_readfd.descriptors[i]->flag & 0x1) {
+			printf("      << Reservation holder >>\n");
+			j = ((pr_buff->prin_descriptor.prin_readfd.descriptors[i]->scope_type>> 4) & 0xf);
+			if (0 == j)
+				printf("      scope: LU_SCOPE, ");
+			else
+				printf("      scope: %d ", j);
+			j = (pr_buff->prin_descriptor.prin_readfd.descriptors[i]->scope_type & 0xf);
+			printf(" type: %s\n", pr_type_strs[j]);
+		} else
+			printf("      not reservation holder\n");
+		mpath_print_transport_id(pr_buff->prin_descriptor.prin_readfd.descriptors[i]);
+	}
+}
+
+static void usage()
+{
+	fprintf(stderr,
+			"Usage: mpathpersist [OPTIONS] [DEVICE]\n"
+			" Options:\n"
+			"    --verbose|-v level         verbosity level\n"
+			"                   0           Critical messages\n"
+			"                   1           Error messages\n"
+			"                   2           Warning messages\n"
+			"                   3           Informational messages\n"
+			"                   4           Informational messages with trace enabled\n"
+			"    --clear|-C                 PR Out: Clear\n"
+			"    --device=DEVICE|-d DEVICE  query or change DEVICE\n"
+			"    --help|-h                  output this usage message\n"
+			"    --hex|-H                   output response in hex\n"
+			"    --in|-i                    request PR In command \n"
+			"    --out|-o                   request PR Out command\n"
+			"    --param-aptpl|-Z           PR Out parameter 'APTPL'\n"
+			"    --read-keys|-k             PR In: Read Keys\n"
+			"    --param-sark=SARK|-S SARK  PR Out parameter service "
+			"action\n"
+			"                               reservation key (SARK is in "
+			"hex)\n"
+			"    --preempt|-P               PR Out: Preempt\n"
+			"    --preempt-abort|-A         PR Out: Preempt and Abort\n"
+			"    --prout-type=TYPE|-T TYPE  PR Out command type\n"
+			"    --read-status|-s           PR In: Read Full Status\n"
+			"    --read-keys|-k             PR In: Read Keys\n"
+			"    --read-reservation|-r      PR In: Read Reservation\n"
+			"    --register|-G              PR Out: Register\n"
+			"    --register-ignore|-I       PR Out: Register and Ignore\n"
+			"    --release|-L               PR Out: Release\n"
+			"    --report-capabilities|-c   PR In: Report Capabilities\n"
+			"    --reserve|-R               PR Out: Reserve\n"
+			"    --transport-id=TIDS|-X TIDS  TransportIDs can be mentioned \n"
+			"                               in several forms\n"
+			" Examples:\n"
+			"     mpathpersist --out --register --param-sark=123abc --prout-type=5 /dev/mapper/mpath9\n"
+			"     mpathpersist -i -k /dev/mapper/mpath9\n"	);
+}
+
+void
+mpath_print_transport_id(struct prin_fulldescr *fdesc)
+{
+	switch (fdesc->trnptid.protocol_id) {
+		case MPATH_PROTOCOL_ID_FC:
+			printf("   FCP-2 ");
+			if (0 != fdesc->trnptid.format_code)
+				printf(" [Unexpected format code: %d]\n", 
+						fdesc->trnptid.format_code);
+			dumpHex((const char *)fdesc->trnptid.n_port_name, 8, 0);
+			break;
+		case MPATH_PROTOCOL_ID_ISCSI:
+			printf("   iSCSI ");
+			if (0 == fdesc->trnptid.format_code) {
+				printf("name: %.*s\n", (int)sizeof(fdesc->trnptid.iscsi_name),
+					fdesc->trnptid.iscsi_name);
+			}else if (1 == fdesc->trnptid.format_code){
+				printf("world wide unique port id: %.*s\n",
+						(int)sizeof(fdesc->trnptid.iscsi_name),
+						fdesc->trnptid.iscsi_name);
+			}else {
+				printf("  [Unexpected format code: %d]\n", fdesc->trnptid.format_code);
+				dumpHex((const char *)fdesc->trnptid.iscsi_name,
+					 (int)sizeof(fdesc->trnptid.iscsi_name), 0);
+			}
+			break;
+		case MPATH_PROTOCOL_ID_SAS:
+			printf("   SAS ");
+			 if (0 != fdesc->trnptid.format_code)
+                                printf(" [Unexpected format code: %d]\n",
+                                                fdesc->trnptid.format_code);
+                        dumpHex((const char *)fdesc->trnptid.sas_address, 8, 0);
+			break;
+		default:
+			return;
+	}
+}
+
+int
+construct_transportid(const char * lcp, struct transportid transid[], int num_transportids)
+{
+	unsigned char * tidp;
+	int k = 0;
+	int j, n, b, c, len, alen;
+	const char * ecp;
+	const char * isip;
+
+	if ((0 == memcmp("fcp,", lcp, 4)) ||
+			(0 == memcmp("FCP,", lcp, 4))) {
+		lcp += 4;
+		k = strspn(lcp, "0123456789aAbBcCdDeEfF");
+
+		len = strlen(lcp);
+		if (len != k) {
+			fprintf(stderr, "badly formed symbolic FCP TransportID: %s\n",
+					lcp);
+			return 1;
+		}
+		transid[num_transportids].format_code = MPATH_PROTOCOL_ID_FC;
+		transid[num_transportids].protocol_id = MPATH_WWUI_DEVICE_NAME;
+		for (k = 0, j = 0, b = 0; k < 16; ++k) {
+			c = lcp[k];
+			if (isdigit(c))
+				n = c - 0x30;
+			else if (isupper(c))
+				n = c - 0x37;
+			else
+				n = c - 0x57;
+			if (k & 1) {
+				transid[num_transportids].n_port_name[j] = b | n;
+				++j;
+			} else
+				b = n << 4;
+		}
+		goto my_cont_b;
+	}
+	if ((0 == memcmp("sas,", lcp, 4)) || (0 == memcmp("SAS,", lcp, 4))) {
+		lcp += 4;
+		k = strspn(lcp, "0123456789aAbBcCdDeEfF");
+		len =strlen(lcp);
+		if (len != k) {
+			fprintf(stderr, "badly formed symbolic SAS TransportID: %s\n",
+					lcp);
+			return 1;
+		}
+		transid[num_transportids].format_code = MPATH_PROTOCOL_ID_SAS;
+		transid[num_transportids].protocol_id = MPATH_WWUI_DEVICE_NAME;
+		memcpy(&transid[num_transportids].sas_address, lcp, 8);
+
+		goto my_cont_b;
+	}
+	if (0 == memcmp("iqn.", lcp, 4)) {
+		ecp = strpbrk(lcp, " \t");
+		isip = strstr(lcp, ",i,0x");
+		if (ecp && (isip > ecp))
+			isip = NULL;
+		len = ecp ? (ecp - lcp) : (int)strlen(lcp);
+		memset(&tidp, 0, 24);
+		transid[num_transportids].format_code = (isip ? MPATH_WWUI_PORT_IDENTIFIER:MPATH_WWUI_DEVICE_NAME);
+		transid[num_transportids].protocol_id = MPATH_PROTOCOL_ID_ISCSI;
+		alen = len + 1; /* at least one trailing null */
+		if (alen < 20)
+			alen = 20;
+		else if (0 != (alen % 4))
+			alen = ((alen / 4) + 1) * 4;
+		if (alen > 241) { /* sam5r02.pdf A.2 (Annex) */
+			fprintf(stderr, "iSCSI name too long, alen=%d\n", alen);
+			return 0;
+		}
+		transid[num_transportids].iscsi_name[1] = alen & 0xff;
+		memcpy(&transid[num_transportids].iscsi_name[2], lcp, len);
+		goto my_cont_b;
+	}
+my_cont_b:
+	if (k >= MPATH_MAX_PARAM_LEN) {
+		fprintf(stderr, "build_transportid: array length exceeded\n");
+		return 1;
+	}
+	return 0;
+}
+
diff -uprN multipath-tools-orig/mpathpersist/main.h multipath-tools/mpathpersist/main.h
--- multipath-tools-orig/mpathpersist/main.h	1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools/mpathpersist/main.h	2011-12-20 00:15:04.000000000 +0530
@@ -0,0 +1,28 @@
+static struct option long_options[] = {
+	{"verbose", 1, 0, 'v'},
+	{"clear", 0, 0, 'C'},
+	{"device", 1, 0, 'd'},
+	{"help", 0, 0, 'h'},
+	{"hex", 0, 0, 'H'},
+	{"in", 0, 0, 'i'},
+	{"out", 0, 0, 'o'},
+	{"param-aptpl", 0, 0, 'Z'},
+	{"param-rk", 1, 0, 'K'},
+	{"param-sark", 1, 0, 'S'},
+	{"preempt", 0, 0, 'P'},
+	{"preempt-abort", 0, 0, 'A'},
+	{"prout-type", 1, 0, 'T'},
+	{"read-full-status", 0, 0, 's'},
+	{"read-keys", 0, 0, 'k'},
+	{"read-reservation", 0, 0, 'r'},
+	{"register", 0, 0, 'G'},
+	{"register-ignore", 0, 0, 'I'},
+	{"release", 0, 0, 'L'},
+	{"report-capabilities", 0, 0, 'c'},		
+	{"reserve", 0, 0, 'R'},
+	{"transport-id", 1, 0, 'X'},
+	{0, 0, 0, 0}
+};
+
+static void usage(void);
+
diff -uprN multipath-tools-orig/mpathpersist/Makefile multipath-tools/mpathpersist/Makefile
--- multipath-tools-orig/mpathpersist/Makefile	1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools/mpathpersist/Makefile	2011-12-20 00:15:04.000000000 +0530
@@ -0,0 +1,30 @@
+# Makefile
+#
+include ../Makefile.inc
+
+OBJS = main.o 
+
+CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) 
+LDFLAGS += -lpthread -ldevmapper -lsysfs -L$(mpathpersistdir) -lmpathpersist -L$(multipathdir) -lmultipath 
+
+EXEC = mpathpersist
+
+all: $(EXEC)
+
+$(EXEC): $(OBJS)
+	$(CC) -g $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS)
+	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
+	
+install:
+	install -d $(DESTDIR)$(bindir)
+	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/
+	install -d $(DESTDIR)$(mandir)
+	install -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
+	
+clean:
+	rm -f *.o $(EXEC)
+	rm -f mpathpersist.8.gz
+
+uninstall:
+	rm $(DESTDIR)$(bindir)/$(EXEC)
+	rm $(DESTDIR)$(mandir)/$(EXEC).8.gz
diff -uprN multipath-tools-orig/mpathpersist/mpathpersist.8 multipath-tools/mpathpersist/mpathpersist.8
--- multipath-tools-orig/mpathpersist/mpathpersist.8	1970-01-01 05:30:00.000000000 +0530
+++ multipath-tools/mpathpersist/mpathpersist.8	2011-12-20 00:15:04.000000000 +0530
@@ -0,0 +1,96 @@
+.\" DO NOT MODIFY THIS FILE!  It was generated by help2man 1.39.2.
+.TH MPATHPERSIST  "8" "April 2011" "mpathpersist" "User Commands"
+.SH NAME
+mpathpersist
+.SH SYNOPSIS
+.B mpathpersist
+[\fIOPTIONS\fR] [\fIDEVICE\fR]
+.SH DESCRIPTION
+.IP
+Options:
+.TP
+\fB\-\-verbose\fR|\-v level
+verbosity level
+.TP
+0
+Critical and error messages
+.TP
+1
+Warning messages
+.TP
+2
+Informational messages
+.TP
+3
+Informational messages with trace enabled
+.TP
+\fB\-\-clear\fR|\-C
+PR Out: Clear
+.TP
+\fB\-\-device\fR=\fIDEVICE\fR|\-d DEVICE
+query or change DEVICE
+.TP
+\fB\-\-help\fR|\-h
+output this usage message
+.TP
+\fB\-\-hex\fR|\-H
+output response in hex
+.TP
+\fB\-\-in\fR|\-i
+request PR In command
+.TP
+\fB\-\-out\fR|\-o
+request PR Out command
+.TP
+\fB\-\-param\-aptpl\fR|\-Z
+PR Out parameter 'APTPL'
+.TP
+\fB\-\-read\-keys\fR|\-k
+PR In: Read Keys
+.TP
+\fB\-\-param\-sark\fR=\fISARK\fR|\-S SARK
+PR Out parameter service action
+reservation key (SARK is in hex)
+.TP
+\fB\-\-preempt\fR|\-P
+PR Out: Preempt
+.TP
+\fB\-\-preempt\-abort\fR|\-A
+PR Out: Preempt and Abort
+.TP
+\fB\-\-prout\-type\fR=\fITYPE\fR|\-T TYPE
+PR Out command type
+.TP
+\fB\-\-read\-status\fR|\-s
+PR In: Read Full Status
+.TP
+\fB\-\-read\-keys\fR|\-k
+PR In: Read Keys
+.TP
+\fB\-\-read\-reservation\fR|\-r
+PR In: Read Reservation
+.TP
+\fB\-\-register\fR|\-G
+PR Out: Register
+.TP
+\fB\-\-register\-ignore\fR|\-I
+PR Out: Register and Ignore
+.TP
+\fB\-\-release\fR|\-L
+PR Out: Release
+.TP
+\fB\-\-report\-capabilities\fR|\-c
+PR In: Report Capabilities
+.TP
+\fB\-\-reserve\fR|\-R
+PR Out: Reserve
+.TP
+\fB\-\-transport\-id\fR=\fITIDS\fR|\-X TIDS
+TransportIDs can be mentioned
+in several forms
+.IP
+Examples:
+.IP
+mpathpersist \fB\-\-out\fR \fB\-\-register\fR \fB\-\-param\-sark\fR=\fI123abc\fR \fB\-\-prout\-type\fR=\fI5\fR /dev/mapper/mpath9
+mpathpersist \fB\-i\fR \fB\-k\fR /dev/mapper/mpath9
+.PP
--
