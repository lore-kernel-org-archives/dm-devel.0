From: Gi-Oh Kim <gi-oh.kim@profitbricks.com>
Subject: [RFC] multipathd: memory leak from orphan_path()
Date: Fri, 22 Jul 2016 23:20:36 +0200
Message-ID: <CAJX1YtbKqPVE8eQQtcEKJECQ=WhVo6BftqWnNJ7=rq+r+Vd-2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5967364932076728836=="
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
To: dm-devel@redhat.com, hare@suse.de, snitzer@redhat.com, Elmar Gerdes <elmar.gerdes@profitbricks.com>
List-Id: dm-devel.ids

--===============5967364932076728836==
Content-Type: multipart/alternative; boundary=001a11352d40c8141605384003b7

--001a11352d40c8141605384003b7
Content-Type: text/plain; charset=UTF-8

Hello,

I checked the memory consuming of the multipathd and found it consumes too
much memory.
Following is the result I have got from 6 servers.
Longer running multipathd consumes more memory.

# ps -eo user,pid,ppid,rss,size,vsize,pmem,pcpu,time,cmd --sort -rss | grep
multipath
root      2948     1  4376 66764  98572  0.0  0.0 00:00:01 /sbin/multipathd
root      3035     1  8648 71068 102876  0.0  0.1 00:09:11 /sbin/multipathd
root     39004     1 10236 137944 169752  0.0 0.1 03:20:43 /sbin/multipathd
root      3149     1 11976 139792 171600  0.0 0.2 05:37:37 /sbin/multipathd
root      3168     1 13792 76056 107864  0.0  0.3 07:04:41 /sbin/multipathd
root      3135     1 14920 142500 174308  0.0 0.4 08:49:38 /sbin/multipathd


So I did valgrind test with debian 0.4.9 version and I've got following
error.
pp->getuid is initialized by malloc but it is not freed.

==14958== 280 bytes in 4 blocks are definitely lost in loss record 2 of 3
==14958==    at 0x4C28C20: malloc (vg_replace_malloc.c:296)
==14958==    by 0x5702D2E: select_getuid (in /lib/libmultipath.so.0)
==14958==    by 0x56FFA0F: ??? (in /lib/libmultipath.so.0)
==14958==    by 0x5701707: pathinfo (in /lib/libmultipath.so.0)
==14958==    by 0x5701BDE: store_pathinfo (in /lib/libmultipath.so.0)
==14958==    by 0x5701F17: path_discovery (in /lib/libmultipath.so.0)
==14958==    by 0x407916: configure (main.c:1310)
==14958==    by 0x404B60: child (main.c:1623)
==14958==    by 0x404B60: main (main.c:1834)


Finally I've applied following patch.
The valgrind does not complain any more.
I checked the latest source but orphan_path() has no patch like that.
I'd appreciate if you would review my patch and give me any feedback.


------------------------- 8< ------------------
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 6d2d45e..007b5eb 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -84,6 +84,8 @@ orphan_path (struct path * pp, const char *reason)
        pp->mpp = NULL;
        pp->dmstate = PSTATE_UNDEF;
        pp->uid_attribute = NULL;
+    if (pp->getuid)
+        free(pp->getuid);
        pp->getuid = NULL;
        prio_put(&pp->prio);
        checker_put(&pp->checker);

--001a11352d40c8141605384003b7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"font-size:12.8px">Hello,</span><br style=3D=
"font-size:12.8px"><br style=3D"font-size:12.8px"><span style=3D"font-size:=
12.8px">I checked the memory consuming of the multipathd and found it consu=
mes too much memory.</span><br style=3D"font-size:12.8px"><span style=3D"fo=
nt-size:12.8px">Following is the result I have got from 6 servers.</span><b=
r style=3D"font-size:12.8px"><span style=3D"font-size:12.8px">Longer runnin=
g multipathd consumes more memory.</span><br style=3D"font-size:12.8px"><br=
 style=3D"font-size:12.8px"><span style=3D"font-size:12.8px"># ps -eo user,=
pid,ppid,rss,size,vsize,p</span><span style=3D"font-size:12.8px">mem,pcpu,t=
ime,cmd --sort -rss | grep multipath</span><br style=3D"font-size:12.8px"><=
span style=3D"font-size:12.8px">root=C2=A0 =C2=A0 =C2=A0 2948=C2=A0 =C2=A0 =
=C2=A01=C2=A0 4376 66764=C2=A0 98572=C2=A0 0.0=C2=A0 0.0 00:00:01 /sbin/mul=
tipathd</span><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8p=
x">root=C2=A0 =C2=A0 =C2=A0 3035=C2=A0 =C2=A0 =C2=A01=C2=A0 8648 71068 1028=
76=C2=A0 0.0=C2=A0 0.1 00:09:11 /sbin/multipathd</span><br style=3D"font-si=
ze:12.8px"><span style=3D"font-size:12.8px">root=C2=A0 =C2=A0 =C2=A039004=
=C2=A0 =C2=A0 =C2=A01 10236 137944 169752=C2=A0 0.0 0.1 03:20:43 /sbin/mult=
ipathd</span><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8px=
">root=C2=A0 =C2=A0 =C2=A0 3149=C2=A0 =C2=A0 =C2=A01 11976 139792 171600=C2=
=A0 0.0 0.2 05:37:37 /sbin/multipathd</span><br style=3D"font-size:12.8px">=
<span style=3D"font-size:12.8px">root=C2=A0 =C2=A0 =C2=A0 3168=C2=A0 =C2=A0=
 =C2=A01 13792 76056 107864=C2=A0 0.0=C2=A0 0.3 07:04:41 /sbin/multipathd</=
span><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8px">root=
=C2=A0 =C2=A0 =C2=A0 3135=C2=A0 =C2=A0 =C2=A01 14920 142500 174308=C2=A0 0.=
0 0.4 08:49:38 /sbin/multipathd</span><br style=3D"font-size:12.8px"><br st=
yle=3D"font-size:12.8px"><br style=3D"font-size:12.8px"><span style=3D"font=
-size:12.8px">So I did valgrind test with debian 0.4.9 version and I&#39;ve=
 got following error.</span><br style=3D"font-size:12.8px"><span style=3D"f=
ont-size:12.8px">pp-&gt;getuid is initialized by malloc but it is not freed=
.</span><br style=3D"font-size:12.8px"><br style=3D"font-size:12.8px"><span=
 style=3D"font-size:12.8px">=3D=3D14958=3D=3D 280 bytes in 4 blocks are def=
initely lost in loss record 2 of 3</span><br style=3D"font-size:12.8px"><sp=
an style=3D"font-size:12.8px">=3D=3D14958=3D=3D=C2=A0 =C2=A0 at 0x4C28C20: =
malloc (vg_replace_malloc.c:296)</span><br style=3D"font-size:12.8px"><span=
 style=3D"font-size:12.8px">=3D=3D14958=3D=3D=C2=A0 =C2=A0 by 0x5702D2E: se=
lect_getuid (in /lib/libmultipath.so.0)</span><br style=3D"font-size:12.8px=
"><span style=3D"font-size:12.8px">=3D=3D14958=3D=3D=C2=A0 =C2=A0 by 0x56FF=
A0F: ??? (in /lib/libmultipath.so.0)</span><br style=3D"font-size:12.8px"><=
span style=3D"font-size:12.8px">=3D=3D14958=3D=3D=C2=A0 =C2=A0 by 0x5701707=
: pathinfo (in /lib/libmultipath.so.0)</span><br style=3D"font-size:12.8px"=
><span style=3D"font-size:12.8px">=3D=3D14958=3D=3D=C2=A0 =C2=A0 by 0x5701B=
DE: store_pathinfo (in /lib/libmultipath.so.0)</span><br style=3D"font-size=
:12.8px"><span style=3D"font-size:12.8px">=3D=3D14958=3D=3D=C2=A0 =C2=A0 by=
 0x5701F17: path_discovery (in /lib/libmultipath.so.0)</span><br style=3D"f=
ont-size:12.8px"><span style=3D"font-size:12.8px">=3D=3D14958=3D=3D=C2=A0 =
=C2=A0 by 0x407916: configure (main.c:1310)</span><br style=3D"font-size:12=
.8px"><span style=3D"font-size:12.8px">=3D=3D14958=3D=3D=C2=A0 =C2=A0 by 0x=
404B60: child (main.c:1623)</span><br style=3D"font-size:12.8px"><span styl=
e=3D"font-size:12.8px">=3D=3D14958=3D=3D=C2=A0 =C2=A0 by 0x404B60: main (ma=
in.c:1834)</span><br style=3D"font-size:12.8px"><br style=3D"font-size:12.8=
px"><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8px">Finally=
 I&#39;ve applied following patch.</span><br style=3D"font-size:12.8px"><sp=
an style=3D"font-size:12.8px">The valgrind does not complain any more.</spa=
n><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8px">I checked=
 the latest source but orphan_path() has no patch like that.</span><br styl=
e=3D"font-size:12.8px"><span style=3D"font-size:12.8px">I&#39;d appreciate =
if you would review my patch and give me any feedback.</span><br style=3D"f=
ont-size:12.8px"><br style=3D"font-size:12.8px"><br style=3D"font-size:12.8=
px"><span style=3D"font-size:12.8px">------------------------- 8&lt; ------=
------------</span><br style=3D"font-size:12.8px"><span style=3D"font-size:=
12.8px">diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.=
c</span><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8px">ind=
ex 6d2d45e..007b5eb 100644</span><br style=3D"font-size:12.8px"><span style=
=3D"font-size:12.8px">--- a/libmultipath/structs_vec.c</span><br style=3D"f=
ont-size:12.8px"><span style=3D"font-size:12.8px">+++ b/libmultipath/struct=
s_vec.c</span><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8p=
x">@@ -84,6 +84,8 @@ orphan_path (struct path * pp, const char *reason)</sp=
an><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8px">=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 pp-&gt;mpp =3D NULL;</span><br style=3D"font-size:12.8=
px"><span style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;dms=
tate =3D PSTATE_UNDEF;</span><br style=3D"font-size:12.8px"><span style=3D"=
font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;uid_attribute =3D NULL=
;</span><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8px">+=
=C2=A0 =C2=A0 if (pp-&gt;getuid)</span><br style=3D"font-size:12.8px"><span=
 style=3D"font-size:12.8px">+=C2=A0 =C2=A0 =C2=A0 =C2=A0 free(pp-&gt;getuid=
);</span><br style=3D"font-size:12.8px"><span style=3D"font-size:12.8px">=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;getuid =3D NULL;</span><br style=3D"font=
-size:12.8px"><span style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
prio_put(&amp;pp-&gt;prio);</span><br style=3D"font-size:12.8px"><span styl=
e=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 checker_put(&amp;pp-&gt;=
checker);</span><br>
</div>

--001a11352d40c8141605384003b7--


--===============5967364932076728836==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5967364932076728836==--
