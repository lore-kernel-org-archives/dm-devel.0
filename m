From: devicemapper niko <devicemapper.niko@gmail.com>
Subject: shared snapshot LVM patch compile error
Date: Mon, 14 Mar 2011 20:32:57 +0800
Message-ID: <AANLkTimx6jE0_aHh=pVQp9OgzcX8vFZiYJts-3cn2mwO@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5899063547003196953=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============5899063547003196953==
Content-Type: multipart/alternative; boundary=0015175ca98cf0a00d049e7082a6

--0015175ca98cf0a00d049e7082a6
Content-Type: text/plain; charset=ISO-8859-1

less arguments of lv_info in lvm-shared-merge-dont-delete.patch caused this
error,
origin_only should be 0 ? I didn't look inside the code,so ask you guys

in lvm-shared-merge-dont-delete.patch
Index: LVM2.2.02.73/lib/metadata/lv_manip.c
===================================================================
--- LVM2.2.02.73.orig/lib/metadata/lv_manip.c   2010-09-10
19:15:20.000000000 +0200
+++ LVM2.2.02.73/lib/metadata/lv_manip.c        2010-09-10
19:15:33.000000000 +0200
@@ -2354,6 +2354,38 @@ int lv_remove_with_dependencies(struct c
                struct logical_volume *origin = origin_from_cow(lv);
                /* Remove shared snapshot's virtual snapshots first */
                if (lv_is_multisnap_origin(origin)) {
+                       if (!level) {
+                               int origin_active, merging;
+                               struct lvinfo info;
+                               if (!lv_info(cmd, origin, &info, 0, 0))
{                            -----------------> here
+                                       log_error("Check for existence of
snapshot "
+                                                 "origin '%s' failed.",
origin->name);
+                                       return 0;
+                               }


gcc -c -I. -I../include -DHAVE_CONFIG_H -DDM_IOCTLS -O2 -g -pipe -Wall
-Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector
--param=ssp-buffer-size=4 -m64 -mtune=generic -O2 -g -pipe -Wall
-Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector
--param=ssp-buffer-size=4 -m64 -mtune=generic -fPIC -Wall -Wundef -Wshadow
-Wcast-align -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations
-Wnested-externs -Winline -Wmissing-noreturn -Wformat-security
-Wredundant-decls -O2 -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2
-fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic
-fPIC -Wall -Wundef -Wshadow -Wcast-align -Wwrite-strings
-Wmissing-prototypes -Wmissing-declarations -Wnested-externs -Winline
-Wmissing-noreturn -Wformat-security -Wredundant-decls -O2
locking/no_locking.c -o locking/no_locking.o
gcc -c -I. -I../include -DHAVE_CONFIG_H -DDM_IOCTLS -O2 -g -pipe -Wall
-Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector
--param=ssp-buffer-size=4 -m64 -mtune=generic -O2 -g -pipe -Wall
-Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector
--param=ssp-buffer-size=4 -m64 -mtune=generic -fPIC -Wall -Wundef -Wshadow
-Wcast-align -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations
-Wnested-externs -Winline -Wmissing-noreturn -Wformat-security
-Wredundant-decls -O2 -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2
-fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic
-fPIC -Wall -Wundef -Wshadow -Wcast-align -Wwrite-strings
-Wmissing-prototypes -Wmissing-declarations -Wnested-externs -Winline
-Wmissing-noreturn -Wformat-security -Wredundant-decls -O2 log/log.c -o
log/log.o
gcc -c -I. -I../include -DHAVE_CONFIG_H -DDM_IOCTLS -O2 -g -pipe -Wall
-Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector
--param=ssp-buffer-size=4 -m64 -mtune=generic -O2 -g -pipe -Wall
-Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector
--param=ssp-buffer-size=4 -m64 -mtune=generic -fPIC -Wall -Wundef -Wshadow
-Wcast-align -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations
-Wnested-externs -Winline -Wmissing-noreturn -Wformat-security
-Wredundant-decls -O2 -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2
-fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic
-fPIC -Wall -Wundef -Wshadow -Wcast-align -Wwrite-strings
-Wmissing-prototypes -Wmissing-declarations -Wnested-externs -Winline
-Wmissing-noreturn -Wformat-security -Wredundant-decls -O2
metadata/lv_manip.c -o metadata/lv_manip.o
metadata/lv_manip.c: In function 'lv_remove_with_dependencies':
metadata/lv_manip.c:2360: warning: passing argument 3 of 'lv_info' makes
integer from pointer without a cast
../include/activate.h:80: note: expected 'unsigned int' but argument is of
type 'struct lvinfo *'
metadata/lv_manip.c:2360: error: too few arguments to function 'lv_info'
make[1]: *** [metadata/lv_manip.o] Error 1
make[1]: Leaving directory `/root/rpmbuild/BUILD/LVM2.2.02.72/lib'
make: *** [lib] Error 2
error: Bad exit status from /var/tmp/rpm-tmp.RpT3fj (%build)

--0015175ca98cf0a00d049e7082a6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>less arguments of lv_info in lvm-shared-merge-dont-delete.patch caused=
 this error,</div>
<div>origin_only should be 0 ? I didn&#39;t look inside the code,so ask you=
 guys</div>
<div>=A0</div>
<div>in lvm-shared-merge-dont-delete.patch</div>
<div>Index: LVM2.2.02.73/lib/metadata/lv_manip.c<br>=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>--- LVM2.2.02.73.orig/lib/metadata/lv_man=
ip.c=A0=A0 2010-09-10 19:15:20.000000000 +0200<br>+++ LVM2.2.02.73/lib/meta=
data/lv_manip.c=A0=A0=A0=A0=A0=A0=A0 2010-09-10 19:15:33.000000000 +0200<br=
>
@@ -2354,6 +2354,38 @@ int lv_remove_with_dependencies(struct c<br>=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct logical_volume *origin =3D o=
rigin_from_cow(lv);<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* Rem=
ove shared snapshot&#39;s virtual snapshots first */<br>=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (lv_is_multisnap_origin(origin)) {<br>
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!le=
vel) {<br>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 int origin_active, merging;<br>+=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 struct lvinfo info;<br>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!lv_info(cmd, origin, &amp;i=
nfo, 0, 0)) {=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 -----------------&gt; here<br>
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 log_error(&quot;Check for existe=
nce of snapshot &quot;<br>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 &quot;origin &#39;%s&#39; failed.&quot;, origin-&gt;n=
ame);<br>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;<br>
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 }<br></div>
<div>=A0</div>
<div>=A0</div>
<div>gcc -c -I. -I../include -DHAVE_CONFIG_H -DDM_IOCTLS -O2 -g -pipe -Wall=
 -Wp,-D_FORTIFY_SOURCE=3D2 -fexceptions -fstack-protector --param=3Dssp-buf=
fer-size=3D4 -m64 -mtune=3Dgeneric -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=
=3D2 -fexceptions -fstack-protector --param=3Dssp-buffer-size=3D4 -m64 -mtu=
ne=3Dgeneric -fPIC -Wall -Wundef -Wshadow -Wcast-align -Wwrite-strings -Wmi=
ssing-prototypes -Wmissing-declarations -Wnested-externs -Winline -Wmissing=
-noreturn -Wformat-security -Wredundant-decls -O2 -O2 -g -pipe -Wall -Wp,-D=
_FORTIFY_SOURCE=3D2 -fexceptions -fstack-protector --param=3Dssp-buffer-siz=
e=3D4 -m64 -mtune=3Dgeneric -fPIC -Wall -Wundef -Wshadow -Wcast-align -Wwri=
te-strings -Wmissing-prototypes -Wmissing-declarations -Wnested-externs -Wi=
nline -Wmissing-noreturn -Wformat-security -Wredundant-decls -O2 locking/no=
_locking.c -o locking/no_locking.o<br>
gcc -c -I. -I../include -DHAVE_CONFIG_H -DDM_IOCTLS -O2 -g -pipe -Wall -Wp,=
-D_FORTIFY_SOURCE=3D2 -fexceptions -fstack-protector --param=3Dssp-buffer-s=
ize=3D4 -m64 -mtune=3Dgeneric -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=3D2 =
-fexceptions -fstack-protector --param=3Dssp-buffer-size=3D4 -m64 -mtune=3D=
generic -fPIC -Wall -Wundef -Wshadow -Wcast-align -Wwrite-strings -Wmissing=
-prototypes -Wmissing-declarations -Wnested-externs -Winline -Wmissing-nore=
turn -Wformat-security -Wredundant-decls -O2 -O2 -g -pipe -Wall -Wp,-D_FORT=
IFY_SOURCE=3D2 -fexceptions -fstack-protector --param=3Dssp-buffer-size=3D4=
 -m64 -mtune=3Dgeneric -fPIC -Wall -Wundef -Wshadow -Wcast-align -Wwrite-st=
rings -Wmissing-prototypes -Wmissing-declarations -Wnested-externs -Winline=
 -Wmissing-noreturn -Wformat-security -Wredundant-decls -O2 log/log.c -o lo=
g/log.o<br>
gcc -c -I. -I../include -DHAVE_CONFIG_H -DDM_IOCTLS -O2 -g -pipe -Wall -Wp,=
-D_FORTIFY_SOURCE=3D2 -fexceptions -fstack-protector --param=3Dssp-buffer-s=
ize=3D4 -m64 -mtune=3Dgeneric -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=3D2 =
-fexceptions -fstack-protector --param=3Dssp-buffer-size=3D4 -m64 -mtune=3D=
generic -fPIC -Wall -Wundef -Wshadow -Wcast-align -Wwrite-strings -Wmissing=
-prototypes -Wmissing-declarations -Wnested-externs -Winline -Wmissing-nore=
turn -Wformat-security -Wredundant-decls -O2 -O2 -g -pipe -Wall -Wp,-D_FORT=
IFY_SOURCE=3D2 -fexceptions -fstack-protector --param=3Dssp-buffer-size=3D4=
 -m64 -mtune=3Dgeneric -fPIC -Wall -Wundef -Wshadow -Wcast-align -Wwrite-st=
rings -Wmissing-prototypes -Wmissing-declarations -Wnested-externs -Winline=
 -Wmissing-noreturn -Wformat-security -Wredundant-decls -O2 metadata/lv_man=
ip.c -o metadata/lv_manip.o<br>
metadata/lv_manip.c: In function &#39;lv_remove_with_dependencies&#39;:<br>=
metadata/lv_manip.c:2360: warning: passing argument 3 of &#39;lv_info&#39; =
makes integer from pointer without a cast<br>../include/activate.h:80: note=
: expected &#39;unsigned int&#39; but argument is of type &#39;struct lvinf=
o *&#39;<br>
metadata/lv_manip.c:2360: error: too few arguments to function &#39;lv_info=
&#39;<br>make[1]: *** [metadata/lv_manip.o] Error 1<br>make[1]: Leaving dir=
ectory `/root/rpmbuild/BUILD/LVM2.2.02.72/lib&#39;<br>make: *** [lib] Error=
 2<br>
error: Bad exit status from /var/tmp/rpm-tmp.RpT3fj (%build)<br></div>

--0015175ca98cf0a00d049e7082a6--


--===============5899063547003196953==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5899063547003196953==--
