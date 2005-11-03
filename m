From: Lan <transter@gmail.com>
Subject: [PATCH] minor fix for multipathd's multipath hwentry
	setup
Date: Thu, 3 Nov 2005 00:09:34 -0800
Message-ID: <ac71172a0511030009u4b923cffk500154b97ce133f@mail.gmail.com>
Reply-To: tranlan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1189827127=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============1189827127==
Content-Type: multipart/alternative;
	boundary="----=_Part_17988_29295764.1131005374907"

------=_Part_17988_29295764.1131005374907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

It looks like the hwe should be initialized before calling
select_pgfailback, since select_pgfailback could use the mpp->hwe vaule.

--- mp-bleed-1102/multipathd/main.c 2005-11-02 23:24:24.000000000 -0800
+++ mp-bleed-1102-patch/multipathd/main.c 2005-11-01 22:47:47.000000000-080=
0
@@ -394,8 +394,8 @@
goto out;

adopt_paths(vecs, mpp);
- select_pgfailback(mpp);
mpp->hwe =3D extract_hwe_from_path(mpp);
+ select_pgfailback(mpp);
set_no_path_retry(mpp);

return 0;

------=_Part_17988_29295764.1131005374907
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

It looks like the hwe should be initialized before calling
select_pgfailback, since select_pgfailback could use the mpp-&gt;hwe
vaule. <br>
<br>
--- mp-bleed-1102/multipathd/main.c&nbsp;&nbsp;&nbsp;&nbsp; 2005-11-02 23:2=
4:24.000000000 -0800<br>
+++ mp-bleed-1102-patch/multipathd/main.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 2005-11-01 22:47:47.000000000 -0800<br>
@@ -394,8 +394,8 @@<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; goto out;<br>
&nbsp; <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; adopt_paths(vecs, mpp);<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; select_pgfailback(mpp);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mpp-&gt;hwe =3D extract_hwe_from=
_path(mpp);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; select_pgfailback(mpp);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; set_no_path_retry(mpp);<br>
&nbsp; <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<br>
<br>

------=_Part_17988_29295764.1131005374907--


--===============1189827127==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1189827127==--
