From: Satyajit Deshmukh <satyajit.s.deshmukh@gmail.com>
Subject: Re: Unnecessary scanning of all SCSI devices in
 mpath_persistent_reserve_in/out command, sent to a specific mpath device,
Date: Mon, 31 Aug 2015 01:54:11 -0700
Message-ID: <CAO6eWMLVS5ZoaJoDiP3T-pyKjuCBH=HGdPPWatJrrCtDYFt6jg@mail.gmail.com>
References: <CAO6eWML_u5H4jyMxv=mjCDLxPj_jSMz20zk7acFwAC8SeJ315w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5620459876579591905=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAO6eWML_u5H4jyMxv=mjCDLxPj_jSMz20zk7acFwAC8SeJ315w@mail.gmail.com>
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

--===============5620459876579591905==
Content-Type: multipart/alternative; boundary=089e01536ebac21bd1051e9793bb

--089e01536ebac21bd1051e9793bb
Content-Type: text/plain; charset=UTF-8

Quick update on this issue-
We spoke to Hannes Reinecke and understood that we were using a sub-optimal
checker aka 'directio' for testing the paths.
As recommended to us by Hannes, we tried the 'tur' (Test Unit Ready)
instead of the 'directio'.
Result: We saw huge improvements in the times for the PROUT/PRIN commands.
This was the change needed:
libmultipath/checkers.h
- #define DEFAULT_CHECKER DIRECTIO
+ #define DEFAULT_CHECKER TUR

However, I still believe that the path_discovery() API should not have the
DI_CHECKER bit in the flags passed to it.
By removing this bit, we saw even better times (about 3x faster) for the
PROUT/PRIN commands.
Thus, if there are no side-effects/repercussions of removing this bit from
the place I mentioned, we could remove the bit IMO.

Thanks,
Satyajit

On Fri, Aug 28, 2015 at 12:49 AM, Satyajit Deshmukh <
satyajit.s.deshmukh@gmail.com> wrote:

> Hello,
>
> This is related to an issue raised by Richard Sharpe recently.
> https://www.redhat.com/archives/dm-devel/2015-August/msg00154.html
>
> The RPM that was used-
>
> http://vault.centos.org/6.6/updates/Source/SPackages/device-mapper-multipath-0.4.9-80.el6_6.3.src.rpm
>
> *Problem:*
> From reading the source code, I understand that 2 APIs defined in
> libmpathpersist/mpath_persist.c do a system-wide scan of all SCSI devices
> by sending asynchronous IO (io_submit calls) to test if SCSI device path is
> good:
>
>
>
> *extern int mpath_persistent_reserve_in (int fd, int rq_servact, struct
> prin_resp *resp, int noisy, int verbose);extern int
> mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
> unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy,
> int verbose);*
>
> So, to get a persistent reservation on a single /dev/mapper/mpathx device
> on a system having 400 SCSI devices, current code does 400 reads of 4K
> each.(512 bytes of 8 sectors), leading to huge delays.
>
> *Root cause of the system wide device scan:*
> The system-wide scan is triggered by setting the DI_CHECKER bit in the
> flags argument to a path_discovery() API:
>
>
>
>
>
>
>
>
>
>
> * if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER)) {    ret =
> MPATH_PR_DMMP_ERROR;    goto out1;  }  /* get info of all paths from the dm
> device */  if (get_mpvec (curmp, pathvec, alias)){    condlog(0, "%s:
> failed to get device info.", alias);    ret = MPATH_PR_DMMP_ERROR;    goto
> out1;  }  *
>
> I believe the DI_CHECKER bit in path_discovery() API is not needed.
> This is because the path status checking is already done on the specific
> mpath device in the get_mpvec API.
>
> The get_mpvec() gets the required struct multipath *mpp, and then invokes
> pathinfo(pp, conf->hwtable, DI_CHECKER) for each path in the multipath dev.
> And this checks state of each path for the multipath device.
>
> * if (mask & DI_CHECKER) {    pp->chkrstate = pp->state = get_state(pp,
> 0);*
>
> *Possible solution:*
> I have a patch ready that simply removes the DI_CHECKER bit from the
> path_discovery() calls inside mpath_persistent_reserve_in() and
> mpath_persistent_reserve_out(). Attached the patch.
> I have tested out the following PRIN and PROUT commands and don't see any
> errors.
> mpathpersist -i -k /dev/mapper/mpathig
> mpathpersist -i -r /dev/mapper/mpathig
> mpathpersist --out --register --param-rk=0A041D3d /dev/mapper/mpathig
> mpathpersist --out --register --param-sark=0A041D3d /dev/mapper/mpathig
> mpathpersist --out --reserve --param-rk=0A041D3D --prout-type=5
> --verbose=3 /dev/mapper/mpathig
>
> Request someone to review the patch, suggest changes and guide me in
> fixing this issue.
>
> Thanks,
> Satyajit
>

--089e01536ebac21bd1051e9793bb
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Quick update on this issue-<div>We spoke to Hannes Reineck=
e and understood that we were using a sub-optimal checker aka &#39;directio=
&#39; for testing the paths.</div><div>As recommended to us by Hannes, we t=
ried the &#39;tur&#39; (Test Unit Ready) instead of the &#39;directio&#39;.=
</div><div>Result: We saw huge improvements in the times for the PROUT/PRIN=
 commands.<br>This was the change needed:</div><div><div style=3D"font-size=
:12.8000001907349px">libmultipath/checkers.h<br>- <font color=3D"#ff0000">#=
define DEFAULT_CHECKER=C2=A0DIRECTIO</font></div><div style=3D"font-size:12=
.8000001907349px">+ <font color=3D"#0000ff">#define DEFAULT_CHECKER=C2=A0TU=
R</font></div></div><div style=3D"font-size:12.8000001907349px"><font color=
=3D"#0000ff"><br></font></div><div style=3D"font-size:12.8000001907349px"><=
font color=3D"#000000">However, I still believe that the path_discovery() A=
PI should not have the DI_CHECKER bit in the flags passed to it.</font></di=
v><div style=3D"font-size:12.8000001907349px"><font color=3D"#000000">By re=
moving this bit, we saw even better times (about 3x faster) for the PROUT/P=
RIN commands.</font></div><div style=3D"font-size:12.8000001907349px">Thus,=
 if there are no side-effects/repercussions of removing this bit from the p=
lace I mentioned, we could remove the bit IMO.</div><div style=3D"font-size=
:12.8000001907349px"><br></div><div style=3D"font-size:12.8000001907349px">=
Thanks,</div><div style=3D"font-size:12.8000001907349px">Satyajit</div></di=
v><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Fri, Aug 28,=
 2015 at 12:49 AM, Satyajit Deshmukh <span dir=3D"ltr">&lt;<a href=3D"mailt=
o:satyajit.s.deshmukh@gmail.com" target=3D"_blank">satyajit.s.deshmukh@gmai=
l.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"m=
argin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"l=
tr">Hello,<br><br>This is related to an issue raised by Richard Sharpe rece=
ntly.<br><a href=3D"https://www.redhat.com/archives/dm-devel/2015-August/ms=
g00154.html" target=3D"_blank">https://www.redhat.com/archives/dm-devel/201=
5-August/msg00154.html</a><br><br>The RPM that was used-<br><a href=3D"http=
://vault.centos.org/6.6/updates/Source/SPackages/device-mapper-multipath-0.=
4.9-80.el6_6.3.src.rpm" target=3D"_blank">http://vault.centos.org/6.6/updat=
es/Source/SPackages/device-mapper-multipath-0.4.9-80.el6_6.3.src.rpm</a><br=
><br><b>Problem:</b><br>From reading the source code, I understand that 2 A=
PIs defined in libmpathpersist/mpath_persist.c do a system-wide scan of all=
 SCSI devices by sending asynchronous IO (io_submit calls) to test if SCSI =
device path is good:<br><i>extern int mpath_persistent_reserve_in (int fd, =
int rq_servact, struct prin_resp *resp, int noisy, int verbose);<br>extern =
int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,<br=
>=C2=A0 =C2=A0 unsigned int rq_type, struct prout_param_descriptor *paramp,=
 int noisy,<br>=C2=A0 =C2=A0 int verbose);</i><br><br>So, to get a persiste=
nt reservation on a single /dev/mapper/mpathx device on a system having 400=
 SCSI devices, current code does 400 reads of 4K each.(512 bytes of 8 secto=
rs), leading to huge delays.<br><br><b>Root cause of the system wide device=
 scan:</b><br>The system-wide scan is triggered by setting the DI_CHECKER b=
it in the flags argument to a path_discovery() API:<br>=C2=A0<i> if (path_d=
iscovery(pathvec, conf, DI_SYSFS | DI_CHECKER)) {<br>=C2=A0 =C2=A0 ret =3D =
MPATH_PR_DMMP_ERROR;<br>=C2=A0 =C2=A0 goto out1;<br>=C2=A0 }<br><br>=C2=A0 =
/* get info of all paths from the dm device */<br>=C2=A0 if (get_mpvec (cur=
mp, pathvec, alias)){<br>=C2=A0 =C2=A0 condlog(0, &quot;%s: failed to get d=
evice info.&quot;, alias);<br>=C2=A0 =C2=A0 ret =3D MPATH_PR_DMMP_ERROR;<br=
>=C2=A0 =C2=A0 goto out1;<br>=C2=A0 } =C2=A0</i><br><br>I believe the DI_CH=
ECKER bit in path_discovery() API is not needed.<br>This is because the pat=
h status checking is already done on the specific mpath device in the get_m=
pvec API.<br><br>The get_mpvec() gets the required struct multipath *mpp, a=
nd then invokes<br>pathinfo(pp, conf-&gt;hwtable, DI_CHECKER) for each path=
 in the multipath dev.<br>And this checks state of each path for the multip=
ath device.<br>=C2=A0<i> if (mask &amp; DI_CHECKER) {<br>=C2=A0 =C2=A0 pp-&=
gt;chkrstate =3D pp-&gt;state =3D get_state(pp, 0);</i><br><br><b>Possible =
solution:</b><br>I have a patch ready that simply removes the DI_CHECKER bi=
t from the path_discovery() calls inside mpath_persistent_reserve_in() and =
mpath_persistent_reserve_out(). Attached the patch.<br>I have tested out th=
e following PRIN and PROUT commands and don&#39;t see any errors.<br>mpathp=
ersist -i -k /dev/mapper/mpathig<br>mpathpersist -i -r /dev/mapper/mpathig<=
br>mpathpersist --out --register --param-rk=3D0A041D3d /dev/mapper/mpathig<=
br>mpathpersist --out --register --param-sark=3D0A041D3d /dev/mapper/mpathi=
g<br>mpathpersist --out --reserve --param-rk=3D0A041D3D --prout-type=3D5 --=
verbose=3D3 /dev/mapper/mpathig<br><br>Request someone to review the patch,=
 suggest changes and guide me in fixing this issue.<br><br>Thanks,<br>Satya=
jit</div>
</blockquote></div><br></div>

--089e01536ebac21bd1051e9793bb--


--===============5620459876579591905==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5620459876579591905==--
