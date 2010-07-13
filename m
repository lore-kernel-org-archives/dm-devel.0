From: zkabelac@sourceware.org
Subject: dmraid include/dmraid/dmraid.h include/dmraid/ ...
Date: 13 Jul 2010 20:08:59 -0000
Message-ID: <20100713200859.19905.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	zkabelac@sourceware.org	2010-07-13 20:08:58

Modified files:
	include/dmraid : dmraid.h metadata.h misc.h 
	lib/mm         : dbg_malloc.h dbg_malloc.c 

Log message:
	Avoid duplicate redeclaration of functions defined in other exported headers.
	Use const void* for dbg_strdup and dbg_strndup

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/dmraid.h.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/metadata.h.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/misc.h.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/mm/dbg_malloc.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/mm/dbg_malloc.c.diff?cvsroot=dm&r1=1.2&r2=1.3

--- dmraid/include/dmraid/dmraid.h	2009/09/16 11:45:12	1.4
+++ dmraid/include/dmraid/dmraid.h	2010/07/13 20:08:58	1.5
@@ -23,18 +23,11 @@
 #include <dmraid/metadata.h>
 #include <dmraid/reconfig.h>
 #include <dmraid/dmreg.h>
-/*
- * Library init/exit
- */
-extern struct lib_context *libdmraid_init(int argc, char **argv);
-extern void libdmraid_exit(struct lib_context *lc);
 
 /*
  * Retrieve version identifiers.
  */
 extern int dm_version(struct lib_context *lc, char *version, size_t size);
-extern const char *libdmraid_date(struct lib_context *lc);
-extern const char *libdmraid_version(struct lib_context *lc);
 
 /*
  * Dealing with formats.
@@ -44,33 +37,19 @@
 /*
  * Dealing with devices.
  */
-extern unsigned int count_devices(struct lib_context *lc, enum dev_type type);
 extern int discover_devices(struct lib_context *lc, char **devnodes);
-extern void discover_raid_devices(struct lib_context *lc, char **devices);
-extern void discover_partitions(struct lib_context *lc);
-extern int write_dev(struct lib_context *lc, struct raid_dev *rd, int erase);
-
-/*
- * Erase ondisk metadata.
- */
-extern int erase_metadata(struct lib_context *lc);
 
 /*
  * Dealing with RAID sets.
  */
-extern const char *get_set_type(struct lib_context *lc, void *rs);
-extern const char *get_set_name(struct lib_context *lc, void *rs);
-extern int group_set(struct lib_context *lc, char **name);
 extern char *libdmraid_make_table(struct lib_context *lc, struct raid_set *rs);
 
 enum activate_type {
 	A_ACTIVATE,
 	A_DEACTIVATE,
+	A_RELOAD,
 };
 
-extern void process_sets(struct lib_context *lc,
-			 int (*func) (struct lib_context * lc, void *rs,
-				      int arg), int arg, enum set_type type);
 extern int change_set(struct lib_context *lc, enum activate_type what,
 		      void *rs);
 
@@ -83,7 +62,7 @@
 			 const char *who, unsigned int line);
 extern void *_dbg_realloc(void *ptr, size_t size, struct lib_context *lc,
 			  const char *who, unsigned int line);
-extern void *_dbg_strdup(void *ptr, struct lib_context *lc,
+extern void *_dbg_strdup(const void *ptr, struct lib_context *lc,
 			 const char *who, unsigned int line);
 extern void _dbg_free(void *ptr, struct lib_context *lc,
 		      const char *who, unsigned int line);
@@ -99,8 +78,8 @@
 
 extern void *_dbg_malloc(size_t size);
 extern void *_dbg_realloc(void *ptr, size_t size);
-extern void *_dbg_strdup(void *ptr);
-extern void *_dbg_strndup(void *ptr, size_t len);
+extern void *_dbg_strdup(const void *ptr);
+extern void *_dbg_strndup(const void *ptr, size_t len);
 extern void _dbg_free(void *ptr);
 
 #define	dbg_malloc	_dbg_malloc
--- dmraid/include/dmraid/metadata.h	2009/09/16 11:45:12	1.4
+++ dmraid/include/dmraid/metadata.h	2010/07/13 20:08:58	1.5
@@ -234,6 +234,7 @@
 extern unsigned int count_devs(struct lib_context *lc, struct raid_set *rs,
 			       enum count_type type);
 extern void free_raid_set(struct lib_context *lc, struct raid_set *rs);
+extern struct dev_info *find_disk(struct lib_context *lc, const char *dp);
 extern struct raid_set *find_set(struct lib_context *lc,
 				 struct list_head *list, const char *name,
 				 enum find where);
@@ -275,6 +276,9 @@
 extern void file_dev_size(struct lib_context *lc, const char *handler,
 			  struct dev_info *di);
 extern int write_dev(struct lib_context *lc, struct raid_dev *rd, int erase);
+/*
+ * Erase ondisk metadata.
+ */
 extern int erase_metadata(struct lib_context *lc);
 extern int delete_raidsets(struct lib_context *lc);
 extern int lib_perform(struct lib_context *lc, enum action action,
--- dmraid/include/dmraid/misc.h	2010/03/12 11:33:01	1.4
+++ dmraid/include/dmraid/misc.h	2010/07/13 20:08:58	1.5
@@ -13,6 +13,9 @@
 
 #define DM_ASSERT(__cond) do { if (!(__cond)) { printf("ASSERT file:%s line:%d fuction:%s cond: %s\n", __FILE__, __LINE__, __FUNCTION__, #__cond); } } while(0);
 
+/*
+ * Library init/exit
+ */
 extern struct lib_context *libdmraid_init(int argc, char **argv);
 extern void libdmraid_exit(struct lib_context *lc);
 
@@ -20,7 +23,7 @@
 extern void mk_alpha(struct lib_context *lc, char *str, size_t len);
 extern void mk_alphanum(struct lib_context *lc, char *str, size_t len);
 extern char *get_basename(struct lib_context *lc, char *str);
-extern char *get_dirname(struct lib_context *lc, char *str);
+extern char *get_dirname(struct lib_context *lc, const char *str);
 extern char *remove_white_space(struct lib_context *lc, char *str, size_t len);
 extern void remove_tail_space(char *str);
 extern char *remove_delimiter(char *ptr, char c);
--- dmraid/lib/mm/dbg_malloc.h	2008/02/22 16:57:37	1.1
+++ dmraid/lib/mm/dbg_malloc.h	2010/07/13 20:08:58	1.2
@@ -18,9 +18,9 @@
 		  const char *who, unsigned int line);
 void *_dbg_realloc(void *ptr, size_t size, struct lib_context *lc,
 		   const char *who, unsigned int line);
-void *_dbg_strdup(void *ptr, struct lib_context *lc,
+void *_dbg_strdup(const void *ptr, struct lib_context *lc,
 		  const char *who, unsigned int line);
-void *_dbg_strndup(void *ptr, size_t len, struct lib_context *lc,
+void *_dbg_strndup(const void *ptr, size_t len, struct lib_context *lc,
 		   const char *who, unsigned int line);
 void _dbg_free(void *ptr, struct lib_context *lc,
 	       const char *who, unsigned int line);
@@ -36,8 +36,8 @@
 
 void *_dbg_malloc(size_t size);
 void *_dbg_realloc(void *ptr, size_t size);
-void *_dbg_strdup(void *ptr);
-void *_dbg_strndup(void *ptr, size_t len);
+void *_dbg_strdup(const void *ptr);
+void *_dbg_strndup(const void *ptr, size_t len);
 void _dbg_free(void *ptr);
 
 #define	dbg_malloc	_dbg_malloc
--- dmraid/lib/mm/dbg_malloc.c	2008/06/20 21:52:18	1.2
+++ dmraid/lib/mm/dbg_malloc.c	2010/07/13 20:08:58	1.3
@@ -99,7 +99,7 @@
 }
 
 void *
-_dbg_strndup(void *ptr, size_t len)
+_dbg_strndup(const void *ptr, size_t len)
 {
 	char *ret;
 
@@ -112,7 +112,7 @@
 }
 
 void *
-_dbg_strdup(void *ptr)
+_dbg_strdup(const void *ptr)
 {
 	return _dbg_strndup(ptr, strlen(ptr));
 }
