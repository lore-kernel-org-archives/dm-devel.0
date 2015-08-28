From: Satyajit Deshmukh <satyajit.s.deshmukh@gmail.com>
Subject: Unnecessary scanning of all SCSI devices in
 mpath_persistent_reserve_in/out command, sent to a specific mpath device,
Date: Fri, 28 Aug 2015 00:49:58 -0700
Message-ID: <CAO6eWML_u5H4jyMxv=mjCDLxPj_jSMz20zk7acFwAC8SeJ315w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=089e0112d0b899f329051e5a546d
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

--089e0112d0b899f329051e5a546d
Content-Type: multipart/alternative; boundary=089e0112d0b899f325051e5a546b

--089e0112d0b899f325051e5a546b
Content-Type: text/plain; charset=UTF-8

Hello,

This is related to an issue raised by Richard Sharpe recently.
https://www.redhat.com/archives/dm-devel/2015-August/msg00154.html

The RPM that was used-
http://vault.centos.org/6.6/updates/Source/SPackages/device-mapper-multipath-0.4.9-80.el6_6.3.src.rpm

*Problem:*
From reading the source code, I understand that 2 APIs defined in
libmpathpersist/mpath_persist.c do a system-wide scan of all SCSI devices
by sending asynchronous IO (io_submit calls) to test if SCSI device path is
good:



*extern int mpath_persistent_reserve_in (int fd, int rq_servact, struct
prin_resp *resp, int noisy, int verbose);extern int
mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy,
int verbose);*

So, to get a persistent reservation on a single /dev/mapper/mpathx device
on a system having 400 SCSI devices, current code does 400 reads of 4K
each.(512 bytes of 8 sectors), leading to huge delays.

*Root cause of the system wide device scan:*
The system-wide scan is triggered by setting the DI_CHECKER bit in the
flags argument to a path_discovery() API:










* if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER)) {    ret =
MPATH_PR_DMMP_ERROR;    goto out1;  }  /* get info of all paths from the dm
device */  if (get_mpvec (curmp, pathvec, alias)){    condlog(0, "%s:
failed to get device info.", alias);    ret = MPATH_PR_DMMP_ERROR;    goto
out1;  }  *

I believe the DI_CHECKER bit in path_discovery() API is not needed.
This is because the path status checking is already done on the specific
mpath device in the get_mpvec API.

The get_mpvec() gets the required struct multipath *mpp, and then invokes
pathinfo(pp, conf->hwtable, DI_CHECKER) for each path in the multipath dev.
And this checks state of each path for the multipath device.

* if (mask & DI_CHECKER) {    pp->chkrstate = pp->state = get_state(pp, 0);*

*Possible solution:*
I have a patch ready that simply removes the DI_CHECKER bit from the
path_discovery() calls inside mpath_persistent_reserve_in() and
mpath_persistent_reserve_out(). Attached the patch.
I have tested out the following PRIN and PROUT commands and don't see any
errors.
mpathpersist -i -k /dev/mapper/mpathig
mpathpersist -i -r /dev/mapper/mpathig
mpathpersist --out --register --param-rk=0A041D3d /dev/mapper/mpathig
mpathpersist --out --register --param-sark=0A041D3d /dev/mapper/mpathig
mpathpersist --out --reserve --param-rk=0A041D3D --prout-type=5 --verbose=3
/dev/mapper/mpathig

Request someone to review the patch, suggest changes and guide me in fixing
this issue.

Thanks,
Satyajit

--089e0112d0b899f325051e5a546b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<br><br>This is related to an issue raised by Richar=
d Sharpe recently.<br><a href=3D"https://www.redhat.com/archives/dm-devel/2=
015-August/msg00154.html">https://www.redhat.com/archives/dm-devel/2015-Aug=
ust/msg00154.html</a><br><br>The RPM that was used-<br><a href=3D"http://va=
ult.centos.org/6.6/updates/Source/SPackages/device-mapper-multipath-0.4.9-8=
0.el6_6.3.src.rpm">http://vault.centos.org/6.6/updates/Source/SPackages/dev=
ice-mapper-multipath-0.4.9-80.el6_6.3.src.rpm</a><br><br><b>Problem:</b><br=
From reading the source code, I understand that 2 APIs defined in libmpath=
persist/mpath_persist.c do a system-wide scan of all SCSI devices by sendin=
g asynchronous IO (io_submit calls) to test if SCSI device path is good:<br=
><i>extern int mpath_persistent_reserve_in (int fd, int rq_servact, struct =
prin_resp *resp, int noisy, int verbose);<br>extern int mpath_persistent_re=
serve_out ( int fd, int rq_servact, int rq_scope,<br>=C2=A0 =C2=A0 unsigned=
 int rq_type, struct prout_param_descriptor *paramp, int noisy,<br>=C2=A0 =
=C2=A0 int verbose);</i><br><br>So, to get a persistent reservation on a si=
ngle /dev/mapper/mpathx device on a system having 400 SCSI devices, current=
 code does 400 reads of 4K each.(512 bytes of 8 sectors), leading to huge d=
elays.<br><br><b>Root cause of the system wide device scan:</b><br>The syst=
em-wide scan is triggered by setting the DI_CHECKER bit in the flags argume=
nt to a path_discovery() API:<br>=C2=A0<i> if (path_discovery(pathvec, conf=
, DI_SYSFS | DI_CHECKER)) {<br>=C2=A0 =C2=A0 ret =3D MPATH_PR_DMMP_ERROR;<b=
r>=C2=A0 =C2=A0 goto out1;<br>=C2=A0 }<br><br>=C2=A0 /* get info of all pat=
hs from the dm device */<br>=C2=A0 if (get_mpvec (curmp, pathvec, alias)){<=
br>=C2=A0 =C2=A0 condlog(0, &quot;%s: failed to get device info.&quot;, ali=
as);<br>=C2=A0 =C2=A0 ret =3D MPATH_PR_DMMP_ERROR;<br>=C2=A0 =C2=A0 goto ou=
t1;<br>=C2=A0 } =C2=A0</i><br><br>I believe the DI_CHECKER bit in path_disc=
overy() API is not needed.<br>This is because the path status checking is a=
lready done on the specific mpath device in the get_mpvec API.<br><br>The g=
et_mpvec() gets the required struct multipath *mpp, and then invokes<br>pat=
hinfo(pp, conf-&gt;hwtable, DI_CHECKER) for each path in the multipath dev.=
<br>And this checks state of each path for the multipath device.<br>=C2=A0<=
i> if (mask &amp; DI_CHECKER) {<br>=C2=A0 =C2=A0 pp-&gt;chkrstate =3D pp-&g=
t;state =3D get_state(pp, 0);</i><br><br><b>Possible solution:</b><br>I hav=
e a patch ready that simply removes the DI_CHECKER bit from the path_discov=
ery() calls inside mpath_persistent_reserve_in() and mpath_persistent_reser=
ve_out(). Attached the patch.<br>I have tested out the following PRIN and P=
ROUT commands and don&#39;t see any errors.<br>mpathpersist -i -k /dev/mapp=
er/mpathig<br>mpathpersist -i -r /dev/mapper/mpathig<br>mpathpersist --out =
--register --param-rk=3D0A041D3d /dev/mapper/mpathig<br>mpathpersist --out =
--register --param-sark=3D0A041D3d /dev/mapper/mpathig<br>mpathpersist --ou=
t --reserve --param-rk=3D0A041D3D --prout-type=3D5 --verbose=3D3 /dev/mappe=
r/mpathig<br><br>Request someone to review the patch, suggest changes and g=
uide me in fixing this issue.<br><br>Thanks,<br>Satyajit</div>

--089e0112d0b899f325051e5a546b--

--089e0112d0b899f329051e5a546d
Content-Type: application/octet-stream;
	name="mpath_persist_remove_checker_from_discovery.patch"
Content-Disposition: attachment;
	filename="mpath_persist_remove_checker_from_discovery.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_idvc8haf0

ZGlmZiAtdU5yIG11bHRpcGF0aC10b29scy8uZ2l0aWdub3JlIG11bHRpcGF0aC10b29scy0yLy5n
aXRpZ25vcmUKLS0tIG11bHRpcGF0aC10b29scy8uZ2l0aWdub3JlCTIwMDktMTAtMjAgMTM6NDY6
MjguMDAwMDAwMDAwIC0wNzAwCisrKyBtdWx0aXBhdGgtdG9vbHMtMi8uZ2l0aWdub3JlCTE5Njkt
MTItMzEgMTY6MDA6MDAuMDAwMDAwMDAwIC0wODAwCkBAIC0xLDkgKzAsMCBAQAotKi5vCi0uZG90
ZXN0Ci0qfgotKi5zbwotKi5hCi0qLmd6Ci1rcGFydHgKLW11bHRpcGF0aAotbXVsdGlwYXRoZApk
aWZmIC11TnIgbXVsdGlwYXRoLXRvb2xzL2xpYm1wYXRocGVyc2lzdC9tcGF0aF9wZXJzaXN0LmMg
bXVsdGlwYXRoLXRvb2xzLTIvbGlibXBhdGhwZXJzaXN0L21wYXRoX3BlcnNpc3QuYwotLS0gbXVs
dGlwYXRoLXRvb2xzL2xpYm1wYXRocGVyc2lzdC9tcGF0aF9wZXJzaXN0LmMJMjAxNS0wOC0yNyAy
Mjo1ODoyMC45Mzg4Mzg2MDAgLTA3MDAKKysrIG11bHRpcGF0aC10b29scy0yL2xpYm1wYXRocGVy
c2lzdC9tcGF0aF9wZXJzaXN0LmMJMjAxNS0wOC0yNyAyMjo1OTo0Mi43NjM0NjY3MTEgLTA3MDAK
QEAgLTE4Miw3ICsxODIsNyBAQAogCQlnb3RvIG91dDsKIAl9CiAKLQlpZiAocGF0aF9kaXNjb3Zl
cnkocGF0aHZlYywgY29uZiwgRElfU1lTRlMgfCBESV9DSEVDS0VSKSkgeworCWlmIChwYXRoX2Rp
c2NvdmVyeShwYXRodmVjLCBjb25mLCBESV9TWVNGUykpIHsKIAkJcmV0ID0gTVBBVEhfUFJfRE1N
UF9FUlJPUjsKIAkJZ290byBvdXQxOwogCX0KQEAgLTI3Miw3ICsyNzIsNyBAQAogICAgICAgICAg
ICAgICAgIGdvdG8gb3V0OwogICAgICAgICB9CiAKLQlpZiAocGF0aF9kaXNjb3ZlcnkocGF0aHZl
YywgY29uZiwgRElfU1lTRlMgfCBESV9DSEVDS0VSKSkgeworCWlmIChwYXRoX2Rpc2NvdmVyeShw
YXRodmVjLCBjb25mLCBESV9TWVNGUykpIHsKIAkJcmV0ID0gTVBBVEhfUFJfRE1NUF9FUlJPUjsK
IAkJZ290byBvdXQxOwogCX0K
--089e0112d0b899f329051e5a546d
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--089e0112d0b899f329051e5a546d--
