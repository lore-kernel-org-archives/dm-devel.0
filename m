From: =?ISO-8859-2?Q?Mateusz_P=F3=B3rola?= <mateusz.polrola@gmail.com>
Subject: [PATCH] multipathd: Added missing variable declaration
Date: Mon, 9 Dec 2013 21:37:49 +0100
Message-ID: <CAACFEQBRAk=W4ymRuvCYGxuF4K_wZdBw9HH0VgnhU3ThOAa-3A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1378496336816224510=="
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

--===============1378496336816224510==
Content-Type: multipart/alternative; boundary=001a1133458e25878b04ed1ff85b

--001a1133458e25878b04ed1ff85b
Content-Type: text/plain; charset=ISO-8859-1

Declaration of envp variable in child function is missing

---
 multipathd/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 7c0e313..2d6aac8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1609,6 +1609,7 @@ child (void * param)
  struct multipath * mpp;
  int i;
  int rc, pid_rc;
+ char *envp;

  mlockall(MCL_CURRENT | MCL_FUTURE);
  sem_init(&exit_sem, 0, 0);
-- 
1.8.4.2

--001a1133458e25878b04ed1ff85b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>Declaration of envp variable in child funct=
ion is missing</div><div><br></div><div>---</div><div>=A0multipathd/main.c =
| 1 +</div><div>=A01 file changed, 1 insertion(+)</div><div><br></div><div>=
diff --git a/multipathd/main.c b/multipathd/main.c</div>
<div>index 7c0e313..2d6aac8 100644</div><div>--- a/multipathd/main.c</div><=
div>+++ b/multipathd/main.c</div><div>@@ -1609,6 +1609,7 @@ child (void * p=
aram)</div><div>=A0<span class=3D"" style=3D"white-space:pre">	</span>struc=
t multipath * mpp;</div>
<div>=A0<span class=3D"" style=3D"white-space:pre">	</span>int i;</div><div=
>=A0<span class=3D"" style=3D"white-space:pre">	</span>int rc, pid_rc;</div=
><div>+<span class=3D"" style=3D"white-space:pre">	</span>char *envp;</div>=
<div>=A0</div>
<div>=A0<span class=3D"" style=3D"white-space:pre">	</span>mlockall(MCL_CUR=
RENT | MCL_FUTURE);</div><div>=A0<span class=3D"" style=3D"white-space:pre"=
>	</span>sem_init(&amp;exit_sem, 0, 0);</div><div>--=A0</div><div>1.8.4.2</=
div></div>
</div><div><br></div></div>

--001a1133458e25878b04ed1ff85b--


--===============1378496336816224510==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1378496336816224510==--
