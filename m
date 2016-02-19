From: Shiva Krishna <Shiva.Krishna@nimblestorage.com>
Subject: [PATCH]multipath-tools: select reservation_key parameter
 before PR handler for first path addition to new map
Date: Fri, 19 Feb 2016 01:49:40 +0000
Message-ID: <D2EBB4B4.75AF%Shiva.Krishna@nimblestorage.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2994094700930614074=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
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

--===============2994094700930614074==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_D2EBB4B475AFShivaKrishnanimblestoragecom_"

--_000_D2EBB4B475AFShivaKrishnanimblestoragecom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On addition of first path, reservation_key parameter is not selected before
handling persistent reservations. This leads multipathd to not perform
registration on the path even when registrations exist on the LUN.

Added code to select "reservation_key" parameter value before calling
PR handler during addition of new path to a new map.

Signed-off-by: ShivaKrishna Merla <shiva.krishna@nimblestorage.com>
---
 libmultipath/configure.c |    5 ++++-
 multipathd/main.c        |    2 ++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 24ad948..2071aa4 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -287,7 +287,10 @@ setup_map (struct multipath * mpp, char * params, int =
params_size)
  select_gid(mpp);
  select_fast_io_fail(mpp);
  select_dev_loss(mpp);
- select_reservation_key(mpp);
+
+ if (!mpp->reservation_key)
+ select_reservation_key(mpp);
+
  select_retain_hwhandler(mpp);
  select_deferred_remove(mpp);
  select_delay_watch_checks(mpp);
diff --git a/multipathd/main.c b/multipathd/main.c
index 04f6d02..bf3423f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -539,6 +539,8 @@ rescan:
  goto fail; /* leave path added to pathvec */
  }

+ /* select configured reservation key */
+ select_reservation_key(mpp);
  /* persistent reseravtion check*/
  mpath_pr_event_handle(pp);
--


--_000_D2EBB4B475AFShivaKrishnanimblestoragecom_
Content-Type: text/html; charset="us-ascii"
Content-ID: <9E0B1475CBE05042B0B0433A9A66964C@nimblestorage.com>
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-lin=
e-break: after-white-space; color: rgb(0, 0, 0); font-size: 14px; font-fami=
ly: Calibri, sans-serif;">
<div>
<div>On addition of first path, reservation_key parameter is not selected b=
efore</div>
<div>handling persistent reservations. This leads multipathd to not perform=
</div>
<div>registration on the path even when registrations exist on the LUN.</di=
v>
<div><br>
</div>
<div>Added code to select &quot;reservation_key&quot; parameter value befor=
e calling</div>
<div>PR handler during addition of new path to a new map.</div>
<div><br>
</div>
<div>Signed-off-by: ShivaKrishna Merla &lt;shiva.krishna@nimblestorage.com&=
gt;</div>
<div>---</div>
<div>&nbsp;libmultipath/configure.c | &nbsp; &nbsp;5 &#43;&#43;&#43;&#43;-<=
/div>
<div>&nbsp;multipathd/main.c &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; &nbsp;2 &#=
43;&#43;</div>
<div>&nbsp;2 files changed, 6 insertions(&#43;), 1 deletions(-)</div>
<div><br>
</div>
<div>diff --git a/libmultipath/configure.c b/libmultipath/configure.c</div>
<div>index 24ad948..2071aa4 100644</div>
<div>--- a/libmultipath/configure.c</div>
<div>&#43;&#43;&#43; b/libmultipath/configure.c</div>
<div>@@ -287,7 &#43;287,10 @@ setup_map (struct multipath * mpp, char * par=
ams, int params_size)</div>
<div>&nbsp;<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span=
>select_gid(mpp);</div>
<div>&nbsp;<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span=
>select_fast_io_fail(mpp);</div>
<div>&nbsp;<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span=
>select_dev_loss(mpp);</div>
<div>-<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>sele=
ct_reservation_key(mpp);</div>
<div>&#43;</div>
<div>&#43;<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>=
if (!mpp-&gt;reservation_key)</div>
<div>&#43;<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>=
select_reservation_key(mpp);</div>
<div>&#43;</div>
<div>&nbsp;<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span=
>select_retain_hwhandler(mpp);</div>
<div>&nbsp;<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span=
>select_deferred_remove(mpp);</div>
<div>&nbsp;<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span=
>select_delay_watch_checks(mpp);</div>
<div>diff --git a/multipathd/main.c b/multipathd/main.c</div>
<div>index 04f6d02..bf3423f 100644</div>
<div>--- a/multipathd/main.c</div>
<div>&#43;&#43;&#43; b/multipathd/main.c</div>
<div>@@ -539,6 &#43;539,8 @@ rescan:</div>
<div>&nbsp;<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span=
>goto fail; /* leave path added to pathvec */</div>
<div>&nbsp;<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span=
>}</div>
<div>&nbsp;</div>
<div>&#43;<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>=
/* select configured reservation key */</div>
<div>&#43;<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span>=
select_reservation_key(mpp);</div>
<div>&nbsp;<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span=
>/* persistent reseravtion check*/</div>
<div>&nbsp;<span class=3D"Apple-tab-span" style=3D"white-space:pre"> </span=
>mpath_pr_event_handle(pp);</div>
<div>--</div>
</div>
<div><br>
</div>
</body>
</html>

--_000_D2EBB4B475AFShivaKrishnanimblestoragecom_--


--===============2994094700930614074==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2994094700930614074==--
