From: Dragan Stancevic <dragan.stancevic@canonical.com>
Subject: [PATCH 1/1] multipath-tools: fix dm- device filtering
Date: Tue, 5 Jul 2016 15:46:57 -0500
Message-ID: <CAAZtj81O6sRAG7j9DQdbPtTpnAsygPa55FU0_dZJgfyiwHmBEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1710145422047975442=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1710145422047975442==
Content-Type: multipart/alternative; boundary=94eb2c111cbacc87dc0536e98d9f

--94eb2c111cbacc87dc0536e98d9f
Content-Type: text/plain; charset=UTF-8

During "service multipath-tools start" /sbin/multipath is
called on dm- devices that are filtered but due to a condition
conf->dev_type == DEV_DEVNODE in filtering code multipath
binary wasn't dropping out when hitting a dm- device. This
was due to the fact that in this case conf->dev_type is
set to DEV_UEVENT.

This is causing the logs to be filled with following
messages:

multipath: dm-6: failed to get udev uid: Invalid argument
multipath: dm-6: failed to get sysfs uid: Invalid argument
multipath: dm-6: failed to get sgio uid: No such file or directory

This change alows the filtering to happen.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>

Signed-off-by: Dragan Stancevic <dragan.stancevic@canonical.com>
---
 multipath/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipath/main.c b/multipath/main.c
index aadebec..d89298b 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -267,7 +267,8 @@ configure (void)
        /*
         * if we have a blacklisted device parameter, exit early
         */
-       if (dev && conf->dev_type == DEV_DEVNODE &&
+       if (dev && (conf->dev_type == DEV_DEVNODE ||
+                   conf->dev_type == DEV_UEVENT) &&
            conf->cmd != CMD_REMOVE_WWID &&
            (filter_devnode(conf->blist_devnode,
                            conf->elist_devnode, dev) > 0)) {
-- 
2.1.0

--94eb2c111cbacc87dc0536e98d9f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>During &quot;service multipath-tools start&quot; /sbi=
n/multipath is</div><div>called on dm- devices that are filtered but due to=
 a condition</div><div>conf-&gt;dev_type =3D=3D DEV_DEVNODE in filtering co=
de multipath</div><div>binary wasn&#39;t dropping out when hitting a dm- de=
vice. This</div><div>was due to the fact that in this case conf-&gt;dev_typ=
e is</div><div>set to DEV_UEVENT.</div><div><br></div><div>This is causing =
the logs to be filled with following</div><div>messages:</div><div><br></di=
v><div>multipath: dm-6: failed to get udev uid: Invalid argument</div><div>=
multipath: dm-6: failed to get sysfs uid: Invalid argument</div><div>multip=
ath: dm-6: failed to get sgio uid: No such file or directory</div><div><br>=
</div><div>This change alows the filtering to happen.</div><div><br></div><=
div>Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc=
.com">christophe.varoqui@opensvc.com</a>&gt;</div><div>Cc: device-mapper de=
velopment &lt;<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a=
>&gt;</div><div><br></div><div>Signed-off-by: Dragan Stancevic &lt;<a href=
=3D"mailto:dragan.stancevic@canonical.com">dragan.stancevic@canonical.com</=
a>&gt;</div><div>---</div><div>=C2=A0multipath/main.c | 3 ++-=C2=A0</div><d=
iv>=C2=A01 file changed, 2 insertions(+), 1 deletion(-)</div><div><br></div=
><div>diff --git a/multipath/main.c b/multipath/main.c</div><div>index aade=
bec..d89298b 100644</div><div>--- a/multipath/main.c</div><div>+++ b/multip=
ath/main.c</div><div>@@ -267,7 +267,8 @@ configure (void)</div><div>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 /*</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* if we=
 have a blacklisted device parameter, exit early</div><div>=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0*/</div><div>- =C2=A0 =C2=A0 =C2=A0 if (dev &amp;&amp; =
conf-&gt;dev_type =3D=3D DEV_DEVNODE &amp;&amp;</div><div>+ =C2=A0 =C2=A0 =
=C2=A0 if (dev &amp;&amp; (conf-&gt;dev_type =3D=3D DEV_DEVNODE ||</div><di=
v>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt=
;dev_type =3D=3D DEV_UEVENT) &amp;&amp;</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 conf-&gt;cmd !=3D CMD_REMOVE_WWID &amp;&amp;</div><div>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (filter_devnode(conf-&gt;blist_de=
vnode,</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;elist_devnode, dev) &gt;=
 0)) {</div><div>--=C2=A0</div><div>2.1.0</div><div><br></div></div>

--94eb2c111cbacc87dc0536e98d9f--


--===============1710145422047975442==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1710145422047975442==--
