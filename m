From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: [PATCH 1/3][RESEND]multipath-tools: Add mpathpersist
	utility and libmpathpersist library for mpath pr management
Date: Fri, 20 Jan 2012 00:51:04 +0530
Message-ID: <EE2129A8E578DC4E94D643D6C1C1C67D07D9B40A@BTCMVEXC2-PRD.hq.netapp.com>
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
To: dm-devel@redhat.com, christophe.varoqui@free.fr, Mike Snitzer <snitzer@redhat.com>, Fil <lists@internyc.net>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@netapp.com>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>, "Moger,
	Babu" <Babu.Moger@netapp.com>, "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
List-Id: dm-devel.ids

This patch adds new cli utility 'mpathpersist' in multipath-tools for managing pr on mpath device.

Signed-off-by: Vijay Chauhan <Vijay.chauhan@netapp.com>
Reviewed-by: Bob Stankey <Robert.stankey@netapp.com> 
Reviewed-by: Babu Moger <Babu.moger@netapp.com>
Reviewed-by: Yanling Q <Yanling.Q@netapp.com>

---
diff -uprN multipath-tools-orig/libmpathpersist/Makefile multipath-tools/libmpathpersist/Makefile
--- multipath-tools-orig/libmpathpersist/Makefile	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools/libmpathpersist/Makefile	2012-01-17 06:07:41.000000000 -0500
@@ -0,0 +1,49 @@
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
+
+uninstall:
+	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
+	rm $(DESTDIR)$(mandir)/mpath_persistent_reserve_in.3.gz	
+	rm $(DESTDIR)$(mandir)/mpath_persistent_reserve_out.3.gz	
+
+clean:
+	rm -f core *.a *.o 
+	rm -f libmpathpersist.so.0
+	rm -f libmpathpersist.so
+	rm -f mpath_persistent_reserve_in.3.gz mpath_persistent_reserve_out.3.gz
diff -uprN multipath-tools-orig/libmpathpersist/mpath_persist.c multipath-tools/libmpathpersist/mpath_persist.c
--- multipath-tools-orig/libmpathpersist/mpath_persist.c	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools/libmpathpersist/mpath_persist.c	2012-01-12 11:53:01.000000000 -0500
@@ -0,0 +1,880 @@
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
+				if (devt2devname(pp->dev, pp->dev_t)){
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
+
+	vector_foreach_slot (mpp->pg, pgp, j){
+		vector_foreach_slot (pgp->paths, pp, i){
+			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
+				condlog(2, "%s: %s not available. Skip.", mpp->wwid, pp->dev);
+				condlog(3, "%s: status = %d.", mpp->wwid, pp->state);
+				continue;
+			}
+
+			condlog(3, "%s: sending pr in command to %s ", mpp->wwid, pp->dev);
+			ret = mpath_send_prin_activepath(pp->dev, rq_servact, resp, noisy);
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
+		return MPATH_PR_DMMP_ERROR;
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
+int mpath_send_prin_activepath (char * dev, int rq_servact, struct prin_resp * resp, int noisy)
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
+			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
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
+		condlog (3, "%s: ERROR: initiating pr out rollback", mpp->wwid);
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
+
+	vector_foreach_slot (mpp->pg, pgp, j){
+		vector_foreach_slot (pgp->paths, pp, i){
+			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
+				condlog (1, "%s: %s path not up. Skip", mpp->wwid, pp->dev); 
+				continue;
+			}
+
+			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
+			ret = send_prout_activepath(pp->dev, rq_servact, rq_scope, rq_type, 
+					paramp, noisy); 
+			pptemp = pp;
+			return ret ;
+		}
+	}
+	return MPATH_PR_SUCCESS;
+}
+
+int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
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
+	memset(&thread, 0, sizeof(thread));
+	strncpy(param.dev, dev, FILE_NAME_SIZE);
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
+	return (param.status);
+}
+
+int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
+        unsigned int rq_type, struct prout_param_descriptor * paramp, int noisy)
+{
+	int i, j;
+	int num = 0;
+	struct pathgroup *pgp = NULL;
+	struct path *pp = NULL;
+	int active_pathcount = 0;
+	pthread_attr_t attr;
+	int rc, found = 0;;
+	int count = 0;
+	int status = MPATH_PR_SUCCESS;
+	struct prin_resp resp;
+	struct prout_param_descriptor *pamp;
+	struct prin_resp *pr_buff;
+	int length;
+	struct transportid *pptr;	
+
+	if (!mpp)
+		return MPATH_PR_DMMP_ERROR;
+
+	active_pathcount = pathcount (mpp, PATH_UP) + pathcount (mpp, PATH_GHOST);
+
+	struct threadinfo thread[active_pathcount];
+	memset(thread, 0, sizeof(thread));
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
+				condlog (1, "%s: %s path not up.", mpp->wwid, pp->dev);
+				continue;
+			}
+			
+			strncpy(thread[count].param.dev, pp->dev, FILE_NAME_SIZE);
+			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
+			rc = pthread_create (&thread[count].id, &attr, mpath_prout_pthread_fn,
+					(void *) (&thread[count].param));
+			if (rc)
+				condlog (0, "%s: failed to create thread. %d",  mpp->wwid, rc);
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
+	status = mpath_prin_activepath (mpp, MPATH_PRIN_RRES_SA, &resp, noisy);
+	if (status != MPATH_PR_SUCCESS){
+		condlog (0, "%s: pr in read reservation command failed.", mpp->wwid);
+		return MPATH_PR_OTHER;
+	}
+
+	num = resp.prin_descriptor.prin_readresv.additional_length / 8;
+	if (num == 0){
+		condlog (2, "%s: Path holding reservation is released.", mpp->wwid);
+		return MPATH_PR_SUCCESS;	
+	}
+	condlog (2, "%s: Path holding reservation is not avialable.", mpp->wwid);
+
+	pr_buff =  mpath_alloc_prin_response(MPATH_PRIN_RFSTAT_SA);
+	if (!pr_buff){
+		condlog (0, "%s: failed to  alloc pr in response buffer.", mpp->wwid);	
+		return MPATH_PR_OTHER;
+	}
+
+	status = mpath_prin_activepath (mpp, MPATH_PRIN_RFSTAT_SA, pr_buff, noisy);
+
+	if (status != MPATH_PR_SUCCESS){
+		condlog (0,  "%s: pr in read full status command failed.",  mpp->wwid);
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
+		condlog (0, "%s: failed to alloc pr out parameter.", mpp->wwid);
+		goto out1;
+	}
+
+	memset(pamp, 0, length);
+
+	pamp->trnptid_list[0] = (struct transportid *) malloc (sizeof (struct transportid));
+	if (!pamp->trnptid_list[0]){
+		condlog (0, "%s: failed to alloc pr out transportid.", mpp->wwid);
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
+			status = mpath_prout_common (mpp, MPATH_PROUT_REG_SA, 0, rq_type,
+					pamp, noisy);
+
+			pamp->sa_flags = 0;
+			memcpy (pamp->key, pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key, 8);
+			memset (pamp->sa_key, 0, 8);
+			pamp->num_transportid = 0;
+			status = mpath_prout_common (mpp, MPATH_PROUT_REG_SA, 0, rq_type,
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
+		status = mpath_prout_reg(mpp, MPATH_PROUT_REG_SA, rq_scope, rq_type, pamp, noisy);	
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
+	if (!mpp->reservation_key)
+	{
+		/* Nothing to do. Assuming pr mgmt feature is disabled*/
+		condlog(3, "%s: reservation_key not set in multiapth.conf", mpp->alias);
+		return MPATH_PR_SUCCESS;
+	}
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
+		condlog(0,"%s : pr in read keys service action failed Error=%d", mpp->alias, ret);
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
+	prkey = 0;
+	keyp = mpp->reservation_key;
+	for (j = 0; j < 8; ++j) {
+		if (j > 0)
+			prkey <<= 8;
+		prkey |= *keyp;
+		++keyp;
+	}
+	condlog(2, "%s: Multipath  reservation_key: 0x%" PRIx64 " ", mpp->alias, prkey);
+
+	isFound =0;
+	for (i = 0; i < resp->prin_descriptor.prin_readkeys.additional_length/8; i++ )
+	{
+		condlog(2, "%s: PR IN READKEYS[%d]  reservation key:", mpp->alias, i);
+		dumpHex((char *)&resp->prin_descriptor.prin_readkeys.key_list[i*8], 8 , 1);
+
+		if (!memcmp(mpp->reservation_key, &resp->prin_descriptor.prin_readkeys.key_list[i*8], 8))
+		{
+			condlog(2, "%s: reservation key found in pr in readkeys response", mpp->alias);
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
--- multipath-tools-orig/libmpathpersist/mpath_persistent_reserve_in.3	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools/libmpathpersist/mpath_persistent_reserve_in.3	2012-01-12 11:53:01.000000000 -0500
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
--- multipath-tools-orig/libmpathpersist/mpath_persistent_reserve_out.3	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools/libmpathpersist/mpath_persistent_reserve_out.3	2012-01-12 11:53:01.000000000 -0500
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
--- multipath-tools-orig/libmpathpersist/mpath_persist.h	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools/libmpathpersist/mpath_persist.h	2012-01-12 11:53:01.000000000 -0500
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
--- multipath-tools-orig/libmpathpersist/mpathpr.h	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools/libmpathpersist/mpathpr.h	2012-01-12 11:53:01.000000000 -0500
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
+int mpath_send_prin_activepath (char * dev, int rq_servact, struct prin_resp * resp, int noisy);
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
+int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
+        unsigned int rq_type,   struct prout_param_descriptor * paramp, int noisy);
+
+int update_prflag(char * arg1, char * arg2, int noisy);
+void * mpath_alloc_prin_response(int prin_sa);
+int update_map_pr(struct multipath *mpp);
+int devt2devname (char *devname, char *devt);
+
+#endif  
diff -uprN multipath-tools-orig/libmpathpersist/mpath_pr_ioctl.c multipath-tools/libmpathpersist/mpath_pr_ioctl.c
--- multipath-tools-orig/libmpathpersist/mpath_pr_ioctl.c	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools/libmpathpersist/mpath_pr_ioctl.c	2012-01-12 11:53:01.000000000 -0500
@@ -0,0 +1,571 @@
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
--- multipath-tools-orig/libmpathpersist/mpath_pr_ioctl.h	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools/libmpathpersist/mpath_pr_ioctl.h	2012-01-12 11:53:01.000000000 -0500
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
--- multipath-tools-orig/libmpathpersist/mpath_updatepr.c	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools/libmpathpersist/mpath_updatepr.c	2012-01-12 11:53:01.000000000 -0500
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

--
