From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: multipath: change the DEFAULT_MINIO for the request
 based multipath
Date: Tue, 01 Feb 2011 10:00:09 +0100
Message-ID: <1296550809.6483.132.camel@zezette>
References: <4D37E513.3070506@suse.de> <20110120160726.GA23529@redhat.com>
	<4D392FBD.5080207@ce.jp.nec.com> <1295599627.23625.16.camel@zezette>
	<20110121141204.GE30411@redhat.com> <1295621193.23625.37.camel@zezette>
	<20110121173930.GB20278@us.ibm.com> <4D3E9020.6010009@ce.jp.nec.com>
	<20110126022307.GA512@us.ibm.com> <1296518031.6483.106.camel@zezette>
	<20110201081303.GA31174@us.ibm.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110201081303.GA31174@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On mar., 2011-02-01 at 00:13 -0800, Malahal Naineni wrote:
> >Christophe Varoqui [christophe.varoqui@gmail.com] wrote:
> 
> >+dm_drv_get_rq (void)
> >+{
> >+	unsigned int minv_dmrq[3] = {1, 1, 0};
> >+	unsigned int *v;
> >+
> >+	v = zalloc(3);
> >+	if (!v)
> >+		return 0;
> >+
> >+	if (dm_drv_version(v, TGT_MPATH)) {
> >+		/* in doubt return least capable */
> >+		return 0;
> >+	}
> 
> Looks like the 'v' is NOT freed. Local stack allocation looks much
> cleaner, why not do that? You missed the same thing at other places, so
> I imagine you started with the on stack local structure but changed
> later???
> 
Sure, fixed.

> >+static int
> >+dm_drvprereq (char * str)
> >+{
> >+	unsigned int minv[3] = {1, 0, 3};
> >+	unsigned int *v;
> >+
> >+	v = zalloc(3);
> >+	if (!v)
> >+		return 0;
> >+
> >+	if (dm_drv_version(v, str)) {
> >+		/* in doubt return not capable */
> >+		return 1;
> >+	}
> 
> Missed freeing 'v'. Also, this function taking the target driver name as
> 'str' doesn't make sense as the minimum version is hard coded internally
> to this function. Take no arguments and pass 'TGT_MPATH' while calling
> dm_drv_version.
> 
Indeed. Fixed.

> > static int
> >+def_minio_rq_handler(vector strvec)
> >+{
> >+	char * buff;
> >+
> >+	buff = set_value(strvec);
> >+
> >+	if (!buff)
> >+		return 1;
> >+
> >+	conf->minio_rq = atoi(buff);
> >+	FREE(buff);
> >+
> >+	return 0;
> >+}
> 
> I was thinking why introduce minio and minio_rq in the
> /etc/multipath.conf file. By default we ship empty /etc/multipath.conf
> file. If the admin wants to override the default, he knows if he is
> going to use the BIO or REQUEST based multipath. So here is my approach
> to avoid introducing another similar looking config keyword:
> 
That's because there are /etc/multipath.conf in the wild right now,
created with non rq capable kernels. rr_min_io meant something then. It
seems not fair to change the meaning of that tunable upon upgrade.
People do cut-and-paste from old docs (corp or googled) and from peers
systems ... this approach minimize the risk of killing the perf by
accident. And I don't see downsides.


--
commit 035ea75c47302fc95d5742e854971f951419ec81
Author: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date:   Tue Feb 1 09:53:20 2011 +0100

    Fix Malahal Naineni commit 2b68b83 review highlights
    
    1/ use local stack allocation in dm_drv_get_rq() and dm_drv_prereq()
    
    2/ don't pass argument to dm_drv_prereq() as it's dm-multipath
specific
    
    Also rename dm_drvprereq() to dm_drv_prereq() and dm_libprereq() to
    dm_lib_prereq() for consistency with dm_drv_get_rq() naming.

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index e34c41d..50cdf98 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -79,7 +79,7 @@ dm_init(void) {
 )
 
 static int
-dm_libprereq (void)
+dm_lib_prereq (void)
 {
        char version[64];
        int v[3];
@@ -143,11 +143,8 @@ int
 dm_drv_get_rq (void)
 {
        unsigned int minv_dmrq[3] = {1, 1, 0};
-       unsigned int *v;
-
-       v = zalloc(3);
-       if (!v)
-               return 0;
+       unsigned int version[3] = {0, 0, 0};
+        unsigned int * v = version;
 
        if (dm_drv_version(v, TGT_MPATH)) {
                /* in doubt return least capable */
@@ -165,16 +162,13 @@ dm_drv_get_rq (void)
 }
 
 static int
-dm_drvprereq (char * str)
+dm_drv_prereq (void)
 {
        unsigned int minv[3] = {1, 0, 3};
-       unsigned int *v;
+       unsigned int version[3] = {0, 0, 0};
+        unsigned int * v = version;
 
-       v = zalloc(3);
-       if (!v)
-               return 0;
-
-       if (dm_drv_version(v, str)) {
+       if (dm_drv_version(v, TGT_MPATH)) {
                /* in doubt return not capable */
                return 1;
        }
@@ -194,9 +188,9 @@ dm_drvprereq (char * str)
 extern int
 dm_prereq (void)
 {
-       if (dm_libprereq())
+       if (dm_lib_prereq())
                return 1;
-       return dm_drvprereq(TGT_MPATH);
+       return dm_drv_prereq();
 }
 
 static int



-- 
Christophe Varoqui <christophe.varoqui@opensvc.com>
OpenSVC
