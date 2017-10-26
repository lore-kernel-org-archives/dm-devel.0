From: "Zhangyanfei (YF)" <yanfei.zhang@huawei.com>
Subject: dmsetup hangs forever
Date: Thu, 26 Oct 2017 08:07:01 +0000
Message-ID: <97CEEE909D5FE84999281EA4585EB0ED0165DE36@DGGEMA505-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7087099118179626640=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "agk@redhat.com" <agk@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, guijianfeng <guijianfeng@huawei.com>, "Zhangyanfei (YF)" <yanfei.zhang@huawei.com>, Fengtiantian <fengtiantian@huawei.com>, "linux-lvm@redhat.com" <linux-lvm@redhat.com>
List-Id: dm-devel.ids

--===============7087099118179626640==
Content-Language: zh-CN
Content-Type: multipart/alternative;
	boundary="_000_97CEEE909D5FE84999281EA4585EB0ED0165DE36DGGEMA505MBSchi_"

--_000_97CEEE909D5FE84999281EA4585EB0ED0165DE36DGGEMA505MBSchi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello

I find an issue when use  dmsetup in the situation udev event timeout.

Dmsetup use the dm_udev_wait function sync with udev event.When use the dms=
etup generate a new dm-disk, if the raw disk is abnormal(for example ,a ips=
an disk hung IO request), the udevd daemon handle the dm-disk udev event ma=
ybe timeout, and will not notify the dmsetup  by semaphore. And because the=
  dm_udev_wait use the semop to sync with udevd, if udevd event timeout, th=
e dmsetup will hung forever even when the raw disk be recovery.

I wonder if we could use the semtimedop instead semop to add the timeout in=
 function  dm_udev_wait. If the udevd daemon timeout when handle the dm eve=
nt, the dm_udev_wait could timeout too, and the dmsetup could return error.

This is my patch base lvm2-2.02.115-3:

From 6961f824abe8eb15f8328f2f4bd39f4cdbf65d4f Mon Sep 17 00:00:00 2001
From: fengtiantian <fengtiantian@huawei.com<mailto:fengtiantian@huawei.com>=
>
Date: Mon, 23 Oct 2017 19:29:55 +0800
Subject: [PATCH] add timeout when fail to wait udev

---
libdm/libdm-common.c |  7 ++++++-
tools/dmsetup.c      | 20 ++++++++++++++++----
2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/libdm/libdm-common.c b/libdm/libdm-common.c
index bd51645..ede2fea 100644
--- a/libdm/libdm-common.c
+++ b/libdm/libdm-common.c
@@ -59,6 +59,8 @@ union semun
#endif
#endif

+#define UDEV_SEM_TIMEOUT 300
+
static char _dm_dir[PATH_MAX] =3D DEV_DIR DM_DIR;
static char _sysfs_dir[PATH_MAX] =3D "/sys/";
static char _path0[PATH_MAX];           /* path buffer, safe 4kB on stack *=
/
@@ -2476,6 +2478,9 @@ static int _udev_wait(uint32_t cookie)
{
        int semid;
        struct sembuf sb =3D {0, 0, 0};
+       struct timespec timeout;
+       timeout.tv_sec =3D UDEV_SEM_TIMEOUT;
+       timeout.tv_nsec =3D 0;

        if (!cookie || !dm_udev_get_sync_support())
                return 1;
@@ -2496,7 +2501,7 @@ static int _udev_wait(uint32_t cookie)
                             cookie, semid);

repeat_wait:
-       if (semop(semid, &sb, 1) < 0) {
+       if (semtimedop(semid, &sb, 1,&timeout) < 0) {
                if (errno =3D=3D EINTR)
                        goto repeat_wait;
                else if (errno =3D=3D EIDRM)
diff --git a/tools/dmsetup.c b/tools/dmsetup.c
index 4202dbb..0840031 100644
--- a/tools/dmsetup.c
+++ b/tools/dmsetup.c
@@ -619,6 +619,7 @@ static int _load(CMD_ARGS)
static int _create(CMD_ARGS)
{
        int r =3D 0;
+       int udev_wait_r =3D 1;
        struct dm_task *dmt;
        const char *file =3D NULL;
        uint32_t cookie =3D 0;
@@ -695,18 +696,22 @@ static int _create(CMD_ARGS)

       out:
        if (!_udev_cookie)
-               (void) dm_udev_wait(cookie);
+               udev_wait_r =3D dm_udev_wait(cookie);

        if (r && _switches[VERBOSE_ARG])
                r =3D _display_info(dmt);

        dm_task_destroy(dmt);

+       if(!udev_wait_r)
+               return 0;
+
        return r;
}
static int _do_rename(const char *name, const char *new_name, const char *n=
ew_uuid) {
        int r =3D 0;
+       int udev_wait_r =3D 1;
        struct dm_task *dmt;
        uint32_t cookie =3D 0;
        uint16_t udev_flags =3D 0;
@@ -751,10 +756,13 @@ static int _do_rename(const char *name, const char *n=
ew_name, const char *new_uu

       out:
        if (!_udev_cookie)
-               (void) dm_udev_wait(cookie);
+               udev_wait_r =3D  dm_udev_wait(cookie);

        dm_task_destroy(dmt);

+       if (!udev_wait_r)
+               return 0;
+
        return r;
}

@@ -1267,7 +1275,8 @@ static int _simple(int task, const char *name, uint32=
_t event_nr, int display)
        int udev_wait_flag =3D task =3D=3D DM_DEVICE_RESUME ||
                             task =3D=3D DM_DEVICE_REMOVE;
        int r =3D 0;
-
+       int udev_wait_r =3D 1;
+
        struct dm_task *dmt;

        if (!(dmt =3D dm_task_create(task)))
@@ -1326,13 +1335,16 @@ static int _simple(int task, const char *name, uint=
32_t event_nr, int display)

       out:
        if (!_udev_cookie && udev_wait_flag)
-               (void) dm_udev_wait(cookie);
+               udev_wait_r =3D dm_udev_wait(cookie);

        if (r && display && _switches[VERBOSE_ARG])
                r =3D _display_info(dmt);

        dm_task_destroy(dmt);

+       if(!udev_wait_r)
+               return 0;
+
        return r;
}

--
1.8.3.1


--_000_97CEEE909D5FE84999281EA4585EB0ED0165DE36DGGEMA505MBSchi_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:\5B8B\4F53;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"\@\5B8B\4F53";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Hello<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">I find an issue when u=
se &nbsp;dmsetup in the situation udev event timeout.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Dmsetup use the dm_ude=
v_wait function sync with udev event.When use the dmsetup generate a new dm=
-disk, if the raw disk is abnormal(for example ,a ipsan disk hung IO reques=
t), the udevd daemon handle the dm-disk
 udev event maybe timeout, and will not notify the dmsetup &nbsp;by semapho=
re. And because the &nbsp;dm_udev_wait use the semop to sync with udevd, if=
 udevd event timeout, the dmsetup will hung forever even when the raw disk =
be recovery.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">I wonder if we could u=
se the semtimedop instead semop to add the timeout in function &nbsp;dm_ude=
v_wait. If the udevd daemon timeout when handle the dm event, the dm_udev_w=
ait could timeout too, and the dmsetup could
 return error.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">This is my patch base =
lvm2-2.02.115-3:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">From 6961f824abe8eb15f=
8328f2f4bd39f4cdbf65d4f Mon Sep 17 00:00:00 2001<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">From: fengtiantian &lt=
;<a href=3D"mailto:fengtiantian@huawei.com">fengtiantian@huawei.com</a>&gt;=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Date: Mon, 23 Oct 2017=
 19:29:55 &#43;0800<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Subject: [PATCH] add t=
imeout when fail to wait udev<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">---<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">libdm/libdm-common.c |=
&nbsp; 7 &#43;&#43;&#43;&#43;&#43;&#43;-<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">tools/dmsetup.c&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; | 20 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&=
#43;&#43;&#43;&#43;&#43;&#43;&#43;----<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">2 files changed, 22 in=
sertions(&#43;), 5 deletions(-)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">diff --git a/libdm/lib=
dm-common.c b/libdm/libdm-common.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">index bd51645..ede2fea=
 100644<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">--- a/libdm/libdm-comm=
on.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&#43;&#43; b/libd=
m/libdm-common.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">@@ -59,6 &#43;59,8 @@ =
union semun<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">#endif<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">#endif<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;#define UDEV_SEM_=
TIMEOUT 300<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">static char _dm_dir[PA=
TH_MAX] =3D DEV_DIR DM_DIR;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">static char _sysfs_dir=
[PATH_MAX] =3D &quot;/sys/&quot;;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">static char _path0[PAT=
H_MAX];&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* path=
 buffer, safe 4kB on stack */<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">@@ -2476,6 &#43;2478,9=
 @@ static int _udev_wait(uint32_t cookie)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">{<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; int semid;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; struct sembuf sb =3D {0, 0, 0};<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; struct timespec timeout;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; timeout.tv_sec =3D UDEV_SEM_TIMEOUT;<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; timeout.tv_nsec =3D 0;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; if (!cookie || !dm_udev_get_sync_support())<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return=
 1;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">@@ -2496,7 &#43;2501,7=
 @@ static int _udev_wait(uint32_t cookie)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;coo=
kie, semid);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">repeat_wait:<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">-&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; if (semop(semid, &amp;sb, 1) &lt; 0) {<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; if (semtimedop(semid, &amp;sb, 1,&amp;timeout) &lt; 0) =
{<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (er=
rno =3D=3D EINTR)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto repeat_wait;<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else i=
f (errno =3D=3D EIDRM)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">diff --git a/tools/dms=
etup.c b/tools/dmsetup.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">index 4202dbb..0840031=
 100644<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">--- a/tools/dmsetup.c<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&#43;&#43; b/tool=
s/dmsetup.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">@@ -619,6 &#43;619,7 @=
@ static int _load(CMD_ARGS)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">static int _create(CMD=
_ARGS)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">{<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; int r =3D 0;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; int udev_wait_r =3D 1;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; struct dm_task *dmt;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; const char *file =3D NULL;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; uint32_t cookie =3D 0;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">@@ -695,18 &#43;696,22=
 @@ static int _create(CMD_ARGS)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; out:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; if (!_udev_cookie)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">-&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (void) dm_u=
dev_wait(cookie);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; udev_wa=
it_r =3D dm_udev_wait(cookie);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; if (r &amp;&amp; _switches[VERBOSE_ARG])<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; r =3D =
_display_info(dmt);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; dm_task_destroy(dmt);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; if(!udev_wait_r)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return =
0;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; return r;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">}<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">static int _do_rename(=
const char *name, const char *new_name, const char *new_uuid) {<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; int r =3D 0;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; int udev_wait_r =3D 1;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; struct dm_task *dmt;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; uint32_t cookie =3D 0;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; uint16_t udev_flags =3D 0;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">@@ -751,10 &#43;756,13=
 @@ static int _do_rename(const char *name, const char *new_name, const cha=
r *new_uu<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; out:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; if (!_udev_cookie)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">-&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (void) dm_u=
dev_wait(cookie);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; udev_wa=
it_r =3D&nbsp; dm_udev_wait(cookie);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; dm_task_destroy(dmt);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; if (!udev_wait_r)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return =
0;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; return r;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">}<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">@@ -1267,7 &#43;1275,8=
 @@ static int _simple(int task, const char *name, uint32_t event_nr, int d=
isplay)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; int udev_wait_flag =3D task =3D=3D DM_DEVICE_RESUME ||=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; tas=
k =3D=3D DM_DEVICE_REMOVE;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; int r =3D 0;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">-<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; int udev_wait_r =3D 1;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; struct dm_task *dmt;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; if (!(dmt =3D dm_task_create(task)))<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">@@ -1326,13 &#43;1335,=
16 @@ static int _simple(int task, const char *name, uint32_t event_nr, int=
 display)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; out:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; if (!_udev_cookie &amp;&amp; udev_wait_flag)<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">-&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (void) dm_u=
dev_wait(cookie);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; udev_wa=
it_r =3D dm_udev_wait(cookie);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; if (r &amp;&amp; display &amp;&amp; _switches[VERBOSE_=
ARG])<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; r =3D =
_display_info(dmt);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; dm_task_destroy(dmt);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; if(!udev_wait_r)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return =
0;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&#43;<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; return r;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">}<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">--<o:p></o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">1.8.3.1<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt"><o:p>&nbsp;</o:p></=
span></p>
</div>
</body>
</html>

--_000_97CEEE909D5FE84999281EA4585EB0ED0165DE36DGGEMA505MBSchi_--


--===============7087099118179626640==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7087099118179626640==--
