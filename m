From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: release 0.4.4 ?
Date: Thu, 21 Apr 2005 01:18:02 +0200
Message-ID: <1114039082.24817.184.camel@zezette>
References: <1114006824.24817.108.camel@zezette>
	<20050420201249.GS29071@marowsky-bree.de>
	<1114029597.24817.138.camel@zezette>
	<20050420205139.GU29071@marowsky-bree.de>
	<1114030896.24817.145.camel@zezette>
	<20050420211000.GW29071@marowsky-bree.de>
	<1114033119.24817.161.camel@zezette>
	<20050420215213.GY29071@marowsky-bree.de>
	<1114034685.24817.165.camel@zezette>
	<1114035053.24817.168.camel@zezette>
	<20050420224058.GA29071@marowsky-bree.de>
	<1114037351.24817.176.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1114037351.24817.176.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On jeu, 2005-04-21 at 00:49 +0200, christophe varoqui wrote:
> On jeu, 2005-04-21 at 00:40 +0200, Lars Marowsky-Bree wrote:
> > On 2005-04-21T00:10:52, christophe varoqui <christophe.varoqui@free.fr> wrote:
> > 
> > > In the mean time, you should check why your prio callout always errors
> > > when run from multipathd. One obvious reason would be that the callout
> > > was not copied into the ramfs ...
> > 
> > How can I check that? I don't see any ramfs/shmfs in mount, and
> > multipathd also doesn't log anything about it.
> > 
> "multipathd -v3" will log what files it copies into the ramfs.
> 
> You don't see it in "mount" because its in a private namespace, but you
> should see it listed in /proc/$(pidof multipathd)/mounts ... though it
> won't help you see its content :/
> 
I think I know what happens.

the binvec is constructed from dict.c only, so it works only in presence
of a config file.

Attached patch does :

* move push_callout to config.[ch]
* use it in store_hwe() too

To make you right, I'll push pre18 now ;)

Regards,
cvaroqui

diff -urN multipath-tools-0.4.4-pre17/libmultipath/config.c
multipath-tools-0.4.4-pre18/libmultipath/config.c
--- multipath-tools-0.4.4-pre17/libmultipath/config.c   2005-04-20
12:50:09.000000000 -0700
+++ multipath-tools-0.4.4-pre18/libmultipath/config.c   2005-04-20
16:24:31.951046352 -0700
@@ -14,6 +14,56 @@

 #include "../libcheckers/checkers.h"

+/*
+ * helper function to draw a list of callout binaries found in the
config file
+ */
+extern int
+push_callout(char * callout)
+{
+       int i;
+       char * bin;
+       char * p;
+
+       /*
+        * purge command line arguments
+        */
+       p = callout;
+
+       while (*p != ' ' && *p != '\0')
+               p++;
+
+       if (!conf->binvec)
+               conf->binvec = vector_alloc();
+
+
+       if (!conf->binvec)
+               return 1;
+
+       /*
+        * if this callout is already stored in binvec, don't store it
twice
+        */
+       vector_foreach_slot (conf->binvec, bin, i)
+               if (memcmp(bin, callout, p - callout) == 0)
+                       return 0;
+
+       /*
+        * else, store it
+        */
+       bin = MALLOC((p - callout) + 1);
+
+       if (!bin)
+               return 1;
+
+       strncpy(bin, callout, p - callout);
+
+       if (!vector_alloc_slot(conf->binvec))
+               return 1;
+
+       vector_set_slot(conf->binvec, bin);
+
+       return 0;
+}
+
 struct hwentry *
 find_hwe (vector hwtable, char * vendor, char * product)
 {
@@ -195,10 +245,13 @@
        if (pgp)
                hwe->pgpolicy = pgp;

-       if (getuid)
+       if (getuid) {
                hwe->getuid = set_param_str(getuid);
-       else
+               push_callout(getuid);
+       } else {
                hwe->getuid = set_default(DEFAULT_GETUID);
+               push_callout(DEFAULT_GETUID);
+       }

        if (!hwe->getuid)
                goto out;
@@ -238,17 +291,21 @@
        if (pgp)
                hwe->pgpolicy = pgp;

-       if (getuid)
+       if (getuid) {
                hwe->getuid = set_param_str(getuid);
-       else
+               push_callout(getuid);
+       } else {
                hwe->getuid = set_default(DEFAULT_GETUID);
+               push_callout(DEFAULT_GETUID);
+       }

        if (!hwe->getuid)
                goto out;

-       if (getprio)
+       if (getprio) {
                hwe->getprio = set_param_str(getprio);
-       else
+               push_callout(getprio);
+       } else
                hwe->getprio = NULL;

        if (hwhandler)
@@ -404,3 +461,4 @@
        free_config(conf);
        return 1;
 }
+
diff -urN multipath-tools-0.4.4-pre17/libmultipath/config.h
multipath-tools-0.4.4-pre18/libmultipath/config.h
--- multipath-tools-0.4.4-pre17/libmultipath/config.h   2005-04-18
12:12:39.000000000 -0700
+++ multipath-tools-0.4.4-pre18/libmultipath/config.h   2005-04-20
16:20:27.623189832 -0700
@@ -66,6 +66,8 @@

 struct config * conf;

+extern int push_callout(char * callout);
+
 struct hwentry * find_hwe (vector hwtable, char * vendor, char *
product);
 struct mpentry * find_mpe (char * wwid);
 char * get_mpe_wwid (char * alias);
diff -urN multipath-tools-0.4.4-pre17/libmultipath/dict.h
multipath-tools-0.4.4-pre18/libmultipath/dict.h
--- multipath-tools-0.4.4-pre17/libmultipath/dict.h     2005-03-29
04:19:43.000000000 -0800
+++ multipath-tools-0.4.4-pre18/libmultipath/dict.h     2005-04-20
16:20:40.726197872 -0700
@@ -6,6 +6,5 @@
 #endif

 vector init_keywords(void);
-void push_callout(char * callout);

 #endif /* _DICT_H */
diff -urN multipath-tools-0.4.4-pre17/libmultipath/dict.c
multipath-tools-0.4.4-pre18/libmultipath/dict.c
--- multipath-tools-0.4.4-pre17/libmultipath/dict.c     2005-04-18
09:08:03.000000000 -0700
+++ multipath-tools-0.4.4-pre18/libmultipath/dict.c     2005-04-20
16:28:21.002225280 -0700
@@ -11,56 +11,6 @@
 #include "../libcheckers/checkers.h"

 /*
- * helper function to draw a list of callout binaries found in the
config file
- */
-extern int
-push_callout(char * callout)
-{
-       int i;
-       char * bin;
-       char * p;
-
-       /*
-        * purge command line arguments
-        */
-       p = callout;
-
-       while (*p != ' ' && *p != '\0')
-               p++;
-
-       if (!conf->binvec)
-               conf->binvec = vector_alloc();
-
-
-       if (!conf->binvec)
-               return 1;
-
-       /*
-        * if this callout is already stored in binvec, don't store it
twice
-        */
-       vector_foreach_slot (conf->binvec, bin, i)
-               if (memcmp(bin, callout, p - callout) == 0)
-                       return 0;
-
-       /*
-        * else, store it
-        */
-       bin = MALLOC((p - callout) + 1);
-
-       if (!bin)
-               return 1;
-
-       strncpy(bin, callout, p - callout);
-
-       if (!vector_alloc_slot(conf->binvec))
-               return 1;
-
-       vector_set_slot(conf->binvec, bin);
-
-       return 0;
-}
-
-/*
  * default block handlers
  */
 static int


-- 
christophe varoqui <christophe.varoqui@free.fr>
