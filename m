From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: [PATCH 0/1] multipathd: deterministic io throughput in
 multipath
Date: Mon, 6 Feb 2017 06:11:12 +0000
Message-ID: <a1ff9b2e91c34eccb038367f07b0781f@HQ1WP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6282553372467452115=="
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
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6282553372467452115==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_a1ff9b2e91c34eccb038367f07b0781fHQ1WPEXMB12corpbrocadec_"

--_000_a1ff9b2e91c34eccb038367f07b0781fHQ1WPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"

This patch adds three configuration parameters, "san_path_err_threshold",
"san_path_err_recovery_time" and "san_path_err_forget_rate".
multipathd will watch paths and check how many times a path has been
failed due to errors.If the number of failures on a particular path is
greater then the san_path_err_threshold then the path will not  reinstante
till san_path_err_recovery_time.These path failures should occur within a
san_path_err_forget_rate checks, if not we will consider the path is good enough
to reinstantate.If it is the only available path, it will immediately be
reintegrated.

This helps us to place the path in failed state if we hit lot of errors on a particular path
due to network /target issues and allow the admin to rectify the errors on a path.


M Muneendra Kumar (1):
  multipathd: deterministic io throughput in multipath

 libmultipath/config.c      |  6 ++++
 libmultipath/config.h      |  9 +++++
 libmultipath/configure.c   |  3 ++
 libmultipath/defaults.h    |  3 +-
 libmultipath/dict.c        | 86 ++++++++++++++++++++++++++++++++--------------
 libmultipath/dict.h        |  3 +-
 libmultipath/propsel.c     | 48 ++++++++++++++++++++++++--
 libmultipath/propsel.h     |  3 ++
 libmultipath/structs.h     | 14 +++++---
 multipath/multipath.conf.5 | 57 ++++++++++++++++++++++++++++++
 multipathd/main.c          | 83 ++++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 281 insertions(+), 34 deletions(-)

--
1.8.3.1



--_000_a1ff9b2e91c34eccb038367f07b0781fHQ1WPEXMB12corpbrocadec_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
<!-- converted from rtf -->
<style><!-- .EmailQuote { margin-left: 1pt; padding-left: 4pt; border-left:=
 #800000 2px solid; } --></style>
</head>
<body>
<font face=3D"Courier New" size=3D"2"><span style=3D"font-size:10pt;">
<div>This patch adds three configuration parameters, &quot;san_path_err_thr=
eshold&quot;,</div>
<div>&quot;san_path_err_recovery_time&quot; and &quot;san_path_err_forget_r=
ate&quot;.</div>
<div>multipathd will watch paths and check how many times a path has been</=
div>
<div>failed due to errors.If the number of failures on a particular path is=
</div>
<div>greater then the san_path_err_threshold then the path will not&nbsp; r=
einstante</div>
<div>till san_path_err_recovery_time.These path failures should occur withi=
n a</div>
<div>san_path_err_forget_rate checks, if not we will consider the path is g=
ood enough</div>
<div>to reinstantate.If it is the only available path, it will immediately =
be</div>
<div>reintegrated.</div>
<div>&nbsp;</div>
<div>This helps us to place the path in failed state if we hit lot of error=
s on a particular path </div>
<div>due to network /target issues and allow the admin to rectify the error=
s on a path.</div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<div>M Muneendra Kumar (1):</div>
<div>&nbsp; multipathd: deterministic io throughput in multipath</div>
<div>&nbsp;</div>
<div> libmultipath/config.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; 6 &#43;&#=
43;&#43;&#43;</div>
<div> libmultipath/config.h&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; 9 &#43;&#=
43;&#43;&#43;&#43;</div>
<div> libmultipath/configure.c&nbsp;&nbsp; |&nbsp; 3 &#43;&#43;</div>
<div> libmultipath/defaults.h&nbsp;&nbsp;&nbsp; |&nbsp; 3 &#43;-</div>
<div> libmultipath/dict.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 86 &#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;--------------</div>
<div> libmultipath/dict.h&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;=
 3 &#43;-</div>
<div> libmultipath/propsel.c&nbsp;&nbsp;&nbsp;&nbsp; | 48 &#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;--</div>
<div> libmultipath/propsel.h&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; 3 &#43;&#43;</=
div>
<div> libmultipath/structs.h&nbsp;&nbsp;&nbsp;&nbsp; | 14 &#43;&#43;&#43;&#=
43;&#43;---</div>
<div> multipath/multipath.conf.5 | 57 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;</div>
<div> multipathd/main.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; | 83 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;</div>
<div> 11 files changed, 281 insertions(&#43;), 34 deletions(-)</div>
<div>&nbsp;</div>
<div>-- </div>
<div>1.8.3.1</div>
<div><font face=3D"Calibri" size=3D"2"><span style=3D"font-size:11pt;">&nbs=
p;</span></font></div>
<div><font face=3D"Calibri" size=3D"2"><span style=3D"font-size:11pt;">&nbs=
p;</span></font></div>
</span></font>
</body>
</html>

--_000_a1ff9b2e91c34eccb038367f07b0781fHQ1WPEXMB12corpbrocadec_--


--===============6282553372467452115==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6282553372467452115==--
