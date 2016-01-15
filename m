From: Brian Bunker <brian@purestorage.com>
Subject: getting support for PURE FlashArray into multipath-tools
Date: Thu, 14 Jan 2016 18:53:02 -0800
Message-ID: <CAHZQxyKZzbHLi4xqaqgfvfKqEpxn4HymGy2O4aSFsQ7U4nKDFQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9178255110898507225=="
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

--===============9178255110898507225==
Content-Type: multipart/alternative; boundary=001a1147f5c06d919d05295680b1

--001a1147f5c06d919d05295680b1
Content-Type: text/plain; charset=UTF-8

Hello dm-devel,

How do I go about getting PURE into the list of supported arrays in
multipath? The patch would something like this:

diff -uNr 3/multipath-tools/libmultipath/hwtable.c
4/multipath-tools/libmultipath/hwtable.c
--- 3/multipath-tools/libmultipath/hwtable.c    2016-01-14
17:47:06.000000000 -0800
+++ 4/multipath-tools/libmultipath/hwtable.c    2016-01-14
18:33:45.000000000 -0800
@@ -1166,6 +1166,22 @@
                .prio_name     = PRIO_ALUA,
                .prio_args     = NULL,
        },
+        {
+               .vendor        = "PURE",
+               .product       = "FlashArray",
+               .features      = DEFAULT_FEATURES,
+               .hwhandler     = DEFAULT_HWHANDLER,
+               .selector      = "queue-length 0",
+               .pgpolicy      = MULTIBUS,
+               .pgfailback    = -FAILBACK_IMMEDIATE,
+               .checker_name  = TUR,
+               .fast_io_fail  = 10,
+                .user_friendly_names = USER_FRIENDLY_NAMES_OFF,
+               .prio_name     = DEFAULT_PRIO,
+                .no_path_retry = 0,
+                .dev_loss      = 60,
+               .prio_args     = NULL,
+       },
        /*
         * EOL
         */
diff -uNr 3/multipath-tools/multipath.conf.defaults
4/multipath-tools/multipath.conf.defaults
--- 3/multipath-tools/multipath.conf.defaults   2016-01-14
17:47:06.000000000 -0800
+++ 4/multipath-tools/multipath.conf.defaults   2016-01-14
18:35:50.000000000 -0800
@@ -940,6 +940,17 @@
 #              rr_weight "uniform"
 #              no_path_retry "queue"
 #      }
+#       device {
+#               vendor "PURE"
+#               path_selector "queue-length 0"
+#               path_grouping_policy "multibus"
+#               path_checker "tur"
+#               fast_io_fail_tmo 10
+#               user_friendly_names "no"
+#               no_path_retry 0
+#               features 0
+#               dev_loss_tmo 60
+#       }
 #}
 #multipaths {
 #}

Let me know what is needed to move forward from here.

Thanks,
Brian

-- 
Brian Bunker
PURE Storage, Inc. <http://www.purestorage.com>
brian@purestorage.com

--001a1147f5c06d919d05295680b1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello dm-devel,<div><br></div><div>How do I go about getti=
ng PURE into the list of supported arrays in multipath? The patch would som=
ething like this:</div><div><br></div><div><div>diff -uNr 3/multipath-tools=
/libmultipath/hwtable.c 4/multipath-tools/libmultipath/hwtable.c</div><div>=
--- 3/multipath-tools/libmultipath/hwtable.c =C2=A0 =C2=A02016-01-14 17:47:=
06.000000000 -0800</div><div>+++ 4/multipath-tools/libmultipath/hwtable.c =
=C2=A0 =C2=A02016-01-14 18:33:45.000000000 -0800</div><div>@@ -1166,6 +1166=
,22 @@</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .p=
rio_name =C2=A0 =C2=A0 =3D PRIO_ALUA,</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .prio_args =C2=A0 =C2=A0 =3D NULL,</div><div>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0{</di=
v><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor =C2=A0 =
=C2=A0 =C2=A0 =C2=A0=3D &quot;PURE&quot;,</div><div>+ =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 .product =C2=A0 =C2=A0 =C2=A0 =3D &quot;FlashAr=
ray&quot;,</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .fe=
atures =C2=A0 =C2=A0 =C2=A0=3D DEFAULT_FEATURES,</div><div>+ =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .hwhandler =C2=A0 =C2=A0 =3D DEFAULT_HWH=
ANDLER,</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .selec=
tor =C2=A0 =C2=A0 =C2=A0=3D &quot;queue-length 0&quot;,</div><div>+ =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgpolicy =C2=A0 =C2=A0 =C2=A0=3D=
 MULTIBUS,</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pg=
failback =C2=A0 =C2=A0=3D -FAILBACK_IMMEDIATE,</div><div>+ =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .checker_name =C2=A0=3D TUR,</div><div>+=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .fast_io_fail =C2=A0=3D 1=
0,</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.user=
_friendly_names =3D USER_FRIENDLY_NAMES_OFF,</div><div>+ =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .prio_name =C2=A0 =C2=A0 =3D DEFAULT_PRIO,<=
/div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.no_path=
_retry =3D 0,</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.dev_loss =C2=A0 =C2=A0 =C2=A0=3D 60,</div><div>+ =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .prio_args =C2=A0 =C2=A0 =3D NULL,</div><di=
v>+ =C2=A0 =C2=A0 =C2=A0 }, =C2=A0 =C2=A0 =C2=A0 =C2=A0</div><div>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 /*</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* EOL</=
div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/</div><div>diff -uNr 3/multipa=
th-tools/multipath.conf.defaults 4/multipath-tools/multipath.conf.defaults<=
/div><div>--- 3/multipath-tools/multipath.conf.defaults =C2=A0 2016-01-14 1=
7:47:06.000000000 -0800</div><div>+++ 4/multipath-tools/multipath.conf.defa=
ults =C2=A0 2016-01-14 18:35:50.000000000 -0800</div><div>@@ -940,6 +940,17=
 @@</div><div>=C2=A0# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rr_we=
ight &quot;uniform&quot;</div><div>=C2=A0# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0no_path_retry &quot;queue&quot;</div><div>=C2=A0# =C2=A0 =
=C2=A0 =C2=A0}</div><div>+# =C2=A0 =C2=A0 =C2=A0 device {</div><div>+# =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vendor &quot;PURE&quot;</div>=
<div>+# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 path_selector &quo=
t;queue-length 0&quot;</div><div>+# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 path_grouping_policy &quot;multibus&quot;</div><div>+# =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 path_checker &quot;tur&quot;</div=
><div>+# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fast_io_fail_tmo =
10</div><div>+# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user_frien=
dly_names &quot;no&quot;</div><div>+# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 no_path_retry 0</div><div>+# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 features 0</div><div>+# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 dev_loss_tmo 60</div><div>+# =C2=A0 =C2=A0 =C2=A0 }</div>=
<div>=C2=A0#}</div><div>=C2=A0#multipaths {</div><div>=C2=A0#}</div></div><=
div><br></div><div>Let me know what is needed to move forward from here.</d=
iv><div><br></div><div>Thanks,<br>Brian</div><div><div><br></div>-- <br><di=
v class=3D"gmail_signature"><div>Brian Bunker</div><div><a href=3D"http://w=
ww.purestorage.com" target=3D"_blank">PURE Storage, Inc.</a><br></div><div>=
<a href=3D"mailto:brian@purestorage.com" target=3D"_blank">brian@purestorag=
e.com</a></div></div>
</div></div>

--001a1147f5c06d919d05295680b1--


--===============9178255110898507225==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9178255110898507225==--
