From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [RFC] [PATCH] add serial keyword to the weightedpath
	prioritizer
Date: Sun, 31 Jul 2016 21:26:53 +0200
Message-ID: <CABr-Gndh4LLgd=T00GdtwNVrFgL7Te91BwjZ0Dh4uYyDi3c9bA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2115362649058437645=="
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
To: Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2115362649058437645==
Content-Type: multipart/alternative; boundary=001a114109ce58d7fb0538f377ca

--001a114109ce58d7fb0538f377ca
Content-Type: text/plain; charset=UTF-8

Ben, Hannes,

Can you review this patch, adding a new 'serial' keyword to the
weightedpath prioritizer.

I compile-tested it only, as I have no testing environment at hand at the
moment.

I commited it in a separate 'weightedpath-serial' branch for now.

http://git.opensvc.com/?p=multipath-tools/.git;a=commitdiff;h=4dd16d99281104fc3504ad73626894a5c3702fb3

Thanks,
Christophe Varoqui
OpenSVC

---

commit 4dd16d99281104fc3504ad73626894a5c3702fb3
Author: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date:   Sun Jul 31 21:08:14 2016 +0200

    multipath: add serial keyword to the weightedpath prioritizer

    Allow the weightedpath prioritizer to set priority to paths to
    specific serial numbers, expressed as regular expressions.

    Example:

    prio weightedpath
    prio_args "serial .*101 30 .*102 10"

    This feature is most synthetic for cross-site + all-paths-active
    topologies, where servers on a site want to prefer paths to the
    local storage heads.

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 7c556b3..94d6384 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -503,7 +503,7 @@ snprint_path_size (char * buff, size_t len, struct path
* pp)
  return snprint_size(buff, len, pp->size);
 }

-static int
+int
 snprint_path_serial (char * buff, size_t len, struct path * pp)
 {
  return snprint_str(buff, len, pp->serial);
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 9306e50..6839fc7 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -112,6 +112,7 @@ int snprint_devices (struct config *, char *, int,
struct vectors *);
 int snprint_hwtable (struct config *, char *, int, vector);
 int snprint_mptable (struct config *, char *, int, vector);
 int snprint_overrides (struct config *, char *, int, struct hwentry *);
+int snprint_path_serial (char *, size_t, struct path *);
 int snprint_host_wwnn (char *, size_t, struct path *);
 int snprint_host_wwpn (char *, size_t, struct path *);
 int snprint_tgt_wwnn (char *, size_t, struct path *);
diff --git a/libmultipath/prioritizers/weightedpath.c
b/libmultipath/prioritizers/weightedpath.c
index e8168fe..e53ab48 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -53,6 +53,16 @@ do { \
 } while(0)

 static int
+build_serial_path(struct path *pp, char *str, int len)
+{
+ char *p = str;
+
+ p += snprint_path_serial(p, str + len - p, pp);
+ CHECK_LEN;
+ return 0;
+}
+
+static int
 build_wwn_path(struct path *pp, char *str, int len)
 {
  char *p = str;
@@ -103,8 +113,13 @@ int prio_path_weight(struct path *pp, char *prio_args)
  pp->sg_id.channel, pp->sg_id.scsi_id, pp->sg_id.lun);
  } else if (!strcmp(regex, DEV_NAME)) {
  strcpy(path, pp->dev);
+ } else if (!strcmp(regex, SERIAL)) {
+ if (build_serial_path(pp, path, FILE_NAME_SIZE) != 0) {
+ FREE(arg);
+ return priority;
+ }
  } else if (!strcmp(regex, WWN)) {
- if (build_wwn_path(pp, path, FILE_NAME_SIZE) != 0) {
+ if (build_serial_path(pp, path, FILE_NAME_SIZE) != 0) {
  FREE(arg);
  return priority;
  }
diff --git a/libmultipath/prioritizers/weightedpath.h
b/libmultipath/prioritizers/weightedpath.h
index 93d8c43..a1b268f 100644
--- a/libmultipath/prioritizers/weightedpath.h
+++ b/libmultipath/prioritizers/weightedpath.h
@@ -4,6 +4,7 @@
 #define PRIO_WEIGHTED_PATH "weightedpath"
 #define HBTL "hbtl"
 #define DEV_NAME "devname"
+#define SERIAL "serial"
 #define WWN "wwn"
 #define DEFAULT_PRIORITY 0

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index ecaef1f..e73e917 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -243,17 +243,25 @@ prioritizers:
 .TP 12
 .I weighted
 Needs a value of the form
-.I "<hbtl|devname|wwn> <regex1> <prio1> <regex2> <prio2> ..."
+.I "<hbtl|devname|serial|wwn> <regex1> <prio1> <regex2> <prio2> ..."
+.RS
+.TP 8
 .I hbtl
 regex can be of SCSI H:B:T:L format  Ex: 1:0:.:. , *:0:0:.
+.TP
 .I devname
 regex can be of device name format  Ex: sda , sd.e
+.TP
+.I serial
+regex can be of serial number format  Ex: .*J1FR.*324  The serial can be
looked up through sysfs or by running multipathd show paths format "%z" Ex:
0395J1FR904324
+.TP
 .I wwn
 regex can be of the form
 .I "host_wwnn:host_wwpn:target_wwnn:target_wwpn"
 these values can be looked up through sysfs or by running
-.I mulitpathd show paths format "%N:%R:%n:%r" Ex:
0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* ,
.*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*
-.TP
+.I multipathd show paths format "%N:%R:%n:%r" Ex:
0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* ,
.*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*
+.RE
+.TP 12
 .I alua
 If
 .I exclusive_pref_bit

--001a114109ce58d7fb0538f377ca
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Ben, Hannes,<div><br></div><div>Can you review this patch,=
 adding a new &#39;serial&#39; keyword to the weightedpath prioritizer.</di=
v><div><br></div><div>I compile-tested it only, as I have no testing enviro=
nment at hand at the moment.</div><div><br></div><div>I commited it in a se=
parate &#39;weightedpath-serial&#39; branch for now.</div><div><br></div><d=
iv><a href=3D"http://git.opensvc.com/?p=3Dmultipath-tools/.git;a=3Dcommitdi=
ff;h=3D4dd16d99281104fc3504ad73626894a5c3702fb3">http://git.opensvc.com/?p=
=3Dmultipath-tools/.git;a=3Dcommitdiff;h=3D4dd16d99281104fc3504ad73626894a5=
c3702fb3</a><br></div><div><br></div><div>Thanks,</div><div>Christophe Varo=
qui</div><div>OpenSVC</div><div><br></div><div>---</div><div><br></div><div=
><div>commit 4dd16d99281104fc3504ad73626894a5c3702fb3</div><div>Author: Chr=
istophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com">chris=
tophe.varoqui@opensvc.com</a>&gt;</div><div>Date: =C2=A0 Sun Jul 31 21:08:1=
4 2016 +0200</div><div><br></div><div>=C2=A0 =C2=A0 multipath: add serial k=
eyword to the weightedpath prioritizer</div><div>=C2=A0 =C2=A0=C2=A0</div><=
div>=C2=A0 =C2=A0 Allow the weightedpath prioritizer to set priority to pat=
hs to</div><div>=C2=A0 =C2=A0 specific serial numbers, expressed as regular=
 expressions.</div><div>=C2=A0 =C2=A0=C2=A0</div><div>=C2=A0 =C2=A0 Example=
:</div><div>=C2=A0 =C2=A0=C2=A0</div><div>=C2=A0 =C2=A0 <span class=3D"gmai=
l-Apple-tab-span" style=3D"white-space:pre">	</span>prio weightedpath</div>=
<div>=C2=A0 =C2=A0 <span class=3D"gmail-Apple-tab-span" style=3D"white-spac=
e:pre">	</span>prio_args &quot;serial .*101 30 .*102 10&quot;</div><div>=C2=
=A0 =C2=A0=C2=A0</div><div>=C2=A0 =C2=A0 This feature is most synthetic for=
 cross-site + all-paths-active</div><div>=C2=A0 =C2=A0 topologies, where se=
rvers on a site want to prefer paths to the</div><div>=C2=A0 =C2=A0 local s=
torage heads.</div><div><br></div><div>diff --git a/libmultipath/print.c b/=
libmultipath/print.c</div><div>index 7c556b3..94d6384 100644</div><div>--- =
a/libmultipath/print.c</div><div>+++ b/libmultipath/print.c</div><div>@@ -5=
03,7 +503,7 @@ snprint_path_size (char * buff, size_t len, struct path * pp=
)</div><div>=C2=A0<span class=3D"gmail-Apple-tab-span" style=3D"white-space=
:pre">	</span>return snprint_size(buff, len, pp-&gt;size);</div><div>=C2=A0=
}</div><div>=C2=A0</div><div>-static int</div><div>+int</div><div>=C2=A0snp=
rint_path_serial (char * buff, size_t len, struct path * pp)</div><div>=C2=
=A0{</div><div>=C2=A0<span class=3D"gmail-Apple-tab-span" style=3D"white-sp=
ace:pre">	</span>return snprint_str(buff, len, pp-&gt;serial);</div><div>di=
ff --git a/libmultipath/print.h b/libmultipath/print.h</div><div>index 9306=
e50..6839fc7 100644</div><div>--- a/libmultipath/print.h</div><div>+++ b/li=
bmultipath/print.h</div><div>@@ -112,6 +112,7 @@ int snprint_devices (struc=
t config *, char *, int, struct vectors *);</div><div>=C2=A0int snprint_hwt=
able (struct config *, char *, int, vector);</div><div>=C2=A0int snprint_mp=
table (struct config *, char *, int, vector);</div><div>=C2=A0int snprint_o=
verrides (struct config *, char *, int, struct hwentry *);</div><div>+int s=
nprint_path_serial (char *, size_t, struct path *);</div><div>=C2=A0int snp=
rint_host_wwnn (char *, size_t, struct path *);</div><div>=C2=A0int snprint=
_host_wwpn (char *, size_t, struct path *);</div><div>=C2=A0int snprint_tgt=
_wwnn (char *, size_t, struct path *);</div><div>diff --git a/libmultipath/=
prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c</div=
><div>index e8168fe..e53ab48 100644</div><div>--- a/libmultipath/prioritize=
rs/weightedpath.c</div><div>+++ b/libmultipath/prioritizers/weightedpath.c<=
/div><div>@@ -53,6 +53,16 @@ do { \</div><div>=C2=A0} while(0)</div><div>=
=C2=A0</div><div>=C2=A0static int</div><div>+build_serial_path(struct path =
*pp, char *str, int len)</div><div>+{</div><div>+<span class=3D"gmail-Apple=
-tab-span" style=3D"white-space:pre">	</span>char *p =3D str;</div><div>+</=
div><div>+<span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">	<=
/span>p +=3D snprint_path_serial(p, str + len - p, pp);</div><div>+<span cl=
ass=3D"gmail-Apple-tab-span" style=3D"white-space:pre">	</span>CHECK_LEN;</=
div><div>+<span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">	<=
/span>return 0;</div><div>+}</div><div>+</div><div>+static int</div><div>=
=C2=A0build_wwn_path(struct path *pp, char *str, int len)</div><div>=C2=A0{=
</div><div>=C2=A0<span class=3D"gmail-Apple-tab-span" style=3D"white-space:=
pre">	</span>char *p =3D str;</div><div>@@ -103,8 +113,13 @@ int prio_path_=
weight(struct path *pp, char *prio_args)</div><div>=C2=A0<span class=3D"gma=
il-Apple-tab-span" style=3D"white-space:pre">			</span>pp-&gt;sg_id.channel=
, pp-&gt;sg_id.scsi_id, pp-&gt;sg_id.lun);</div><div>=C2=A0<span class=3D"g=
mail-Apple-tab-span" style=3D"white-space:pre">	</span>} else if (!strcmp(r=
egex, DEV_NAME)) {</div><div>=C2=A0<span class=3D"gmail-Apple-tab-span" sty=
le=3D"white-space:pre">		</span>strcpy(path, pp-&gt;dev);</div><div>+<span =
class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">	</span>} else if =
(!strcmp(regex, SERIAL)) {</div><div>+<span class=3D"gmail-Apple-tab-span" =
style=3D"white-space:pre">		</span>if (build_serial_path(pp, path, FILE_NAM=
E_SIZE) !=3D 0) {</div><div>+<span class=3D"gmail-Apple-tab-span" style=3D"=
white-space:pre">			</span>FREE(arg);</div><div>+<span class=3D"gmail-Apple=
-tab-span" style=3D"white-space:pre">			</span>return priority;</div><div>+=
<span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">		</span>}</=
div><div>=C2=A0<span class=3D"gmail-Apple-tab-span" style=3D"white-space:pr=
e">	</span>} else if (!strcmp(regex, WWN)) {</div><div>-<span class=3D"gmai=
l-Apple-tab-span" style=3D"white-space:pre">		</span>if (build_wwn_path(pp,=
 path, FILE_NAME_SIZE) !=3D 0) {</div><div>+<span class=3D"gmail-Apple-tab-=
span" style=3D"white-space:pre">		</span>if (build_serial_path(pp, path, FI=
LE_NAME_SIZE) !=3D 0) {</div><div>=C2=A0<span class=3D"gmail-Apple-tab-span=
" style=3D"white-space:pre">			</span>FREE(arg);</div><div>=C2=A0<span clas=
s=3D"gmail-Apple-tab-span" style=3D"white-space:pre">			</span>return prior=
ity;</div><div>=C2=A0<span class=3D"gmail-Apple-tab-span" style=3D"white-sp=
ace:pre">		</span>}</div><div>diff --git a/libmultipath/prioritizers/weight=
edpath.h b/libmultipath/prioritizers/weightedpath.h</div><div>index 93d8c43=
..a1b268f 100644</div><div>--- a/libmultipath/prioritizers/weightedpath.h</=
div><div>+++ b/libmultipath/prioritizers/weightedpath.h</div><div>@@ -4,6 +=
4,7 @@</div><div>=C2=A0#define PRIO_WEIGHTED_PATH &quot;weightedpath&quot;<=
/div><div>=C2=A0#define HBTL &quot;hbtl&quot;</div><div>=C2=A0#define DEV_N=
AME &quot;devname&quot;</div><div>+#define SERIAL &quot;serial&quot;</div><=
div>=C2=A0#define WWN &quot;wwn&quot;</div><div>=C2=A0#define DEFAULT_PRIOR=
ITY 0</div><div>=C2=A0</div><div>diff --git a/multipath/multipath.conf.5 b/=
multipath/multipath.conf.5</div><div>index ecaef1f..e73e917 100644</div><di=
v>--- a/multipath/multipath.conf.5</div><div>+++ b/multipath/multipath.conf=
.5</div><div>@@ -243,17 +243,25 @@ prioritizers:</div><div>=C2=A0.TP 12</di=
v><div>=C2=A0.I weighted</div><div>=C2=A0Needs a value of the form</div><di=
v>-.I &quot;&lt;hbtl|devname|wwn&gt; &lt;regex1&gt; &lt;prio1&gt; &lt;regex=
2&gt; &lt;prio2&gt; ...&quot;</div><div>+.I &quot;&lt;hbtl|devname|serial|w=
wn&gt; &lt;regex1&gt; &lt;prio1&gt; &lt;regex2&gt; &lt;prio2&gt; ...&quot;<=
/div><div>+.RS</div><div>+.TP 8</div><div>=C2=A0.I hbtl</div><div>=C2=A0reg=
ex can be of SCSI H:B:T:L format =C2=A0Ex: 1:0:.:. , *:0:0:.</div><div>+.TP=
</div><div>=C2=A0.I devname</div><div>=C2=A0regex can be of device name for=
mat =C2=A0Ex: sda , sd.e</div><div>+.TP</div><div>+.I serial</div><div>+reg=
ex can be of serial number format =C2=A0Ex: .*J1FR.*324 =C2=A0The serial ca=
n be looked up through sysfs or by running multipathd show paths format &qu=
ot;%z&quot; Ex: 0395J1FR904324</div><div>+.TP</div><div>=C2=A0.I wwn</div><=
div>=C2=A0regex can be of the form</div><div>=C2=A0.I &quot;host_wwnn:host_=
wwpn:target_wwnn:target_wwpn&quot;</div><div>=C2=A0these values can be look=
ed up through sysfs or by running</div><div>-.I mulitpathd show paths forma=
t &quot;%N:%R:%n:%r&quot; Ex: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* ,=
 .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*</div><div>-.TP</div><div>+.=
I multipathd show paths format &quot;%N:%R:%n:%r&quot; Ex: 0x200100e08ba0ae=
a0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.=
*</div><div>+.RE</div><div>+.TP 12</div><div>=C2=A0.I alua</div><div>=C2=A0=
If</div><div>=C2=A0.I exclusive_pref_bit</div></div><div><br></div></div>

--001a114109ce58d7fb0538f377ca--


--===============2115362649058437645==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2115362649058437645==--
