From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: Unnecessary scanning of all SCSI devices in
 mpath_persistent_reserve_in/out command, sent to a specific mpath device,
Date: Tue, 6 Oct 2015 09:05:14 +0200
Message-ID: <CABr-Gnc9g0wdc+mFcAXzT5DE-+Wbz4XSAcEGPWwb1-6TpEurhw@mail.gmail.com>
References: <CAO6eWML_u5H4jyMxv=mjCDLxPj_jSMz20zk7acFwAC8SeJ315w@mail.gmail.com>
	<CAO6eWMLVS5ZoaJoDiP3T-pyKjuCBH=HGdPPWatJrrCtDYFt6jg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4449670633128467832=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAO6eWMLVS5ZoaJoDiP3T-pyKjuCBH=HGdPPWatJrrCtDYFt6jg@mail.gmail.com>
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

--===============4449670633128467832==
Content-Type: multipart/alternative; boundary=001a11c3cb406455ac05216a40c7

--001a11c3cb406455ac05216a40c7
Content-Type: text/plain; charset=UTF-8

Any comment on this mpath_persist optimization suggested by Satyajit ? I'd
be inclined to merge it.

Best regards,
Christophe Varoqui

diff -uNr multipath-tools/libmpathpersist/mpath_persist.c
multipath-tools-2/libmpathpersist/mpath_persist.c
--- multipath-tools/libmpathpersist/mpath_persist.c	2015-08-27
22:58:20.938838600 -0700
+++ multipath-tools-2/libmpathpersist/mpath_persist.c	2015-08-27
22:59:42.763466711 -0700
@@ -182,7 +182,7 @@
 		goto out;
 	}

-	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER)) {
+	if (path_discovery(pathvec, conf, DI_SYSFS)) {
 		ret = MPATH_PR_DMMP_ERROR;
 		goto out1;
 	}
@@ -272,7 +272,7 @@
                 goto out;
         }

-	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER)) {
+	if (path_discovery(pathvec, conf, DI_SYSFS)) {
 		ret = MPATH_PR_DMMP_ERROR;
 		goto out1;
 	}


On Mon, Aug 31, 2015 at 10:54 AM, Satyajit Deshmukh <
satyajit.s.deshmukh@gmail.com> wrote:

> Quick update on this issue-
> We spoke to Hannes Reinecke and understood that we were using a
> sub-optimal checker aka 'directio' for testing the paths.
> As recommended to us by Hannes, we tried the 'tur' (Test Unit Ready)
> instead of the 'directio'.
> Result: We saw huge improvements in the times for the PROUT/PRIN commands.
> This was the change needed:
> libmultipath/checkers.h
> - #define DEFAULT_CHECKER DIRECTIO
> + #define DEFAULT_CHECKER TUR
>
> However, I still believe that the path_discovery() API should not have the
> DI_CHECKER bit in the flags passed to it.
> By removing this bit, we saw even better times (about 3x faster) for the
> PROUT/PRIN commands.
> Thus, if there are no side-effects/repercussions of removing this bit from
> the place I mentioned, we could remove the bit IMO.
>
> Thanks,
> Satyajit
>
> On Fri, Aug 28, 2015 at 12:49 AM, Satyajit Deshmukh <
> satyajit.s.deshmukh@gmail.com> wrote:
>
>> Hello,
>>
>> This is related to an issue raised by Richard Sharpe recently.
>> https://www.redhat.com/archives/dm-devel/2015-August/msg00154.html
>>
>> The RPM that was used-
>>
>> http://vault.centos.org/6.6/updates/Source/SPackages/device-mapper-multipath-0.4.9-80.el6_6.3.src.rpm
>>
>> *Problem:*
>> From reading the source code, I understand that 2 APIs defined in
>> libmpathpersist/mpath_persist.c do a system-wide scan of all SCSI devices
>> by sending asynchronous IO (io_submit calls) to test if SCSI device path is
>> good:
>>
>>
>>
>> *extern int mpath_persistent_reserve_in (int fd, int rq_servact, struct
>> prin_resp *resp, int noisy, int verbose);extern int
>> mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
>> unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy,
>> int verbose);*
>>
>> So, to get a persistent reservation on a single /dev/mapper/mpathx device
>> on a system having 400 SCSI devices, current code does 400 reads of 4K
>> each.(512 bytes of 8 sectors), leading to huge delays.
>>
>> *Root cause of the system wide device scan:*
>> The system-wide scan is triggered by setting the DI_CHECKER bit in the
>> flags argument to a path_discovery() API:
>>
>>
>>
>>
>>
>>
>>
>>
>>
>>
>> * if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER)) {    ret =
>> MPATH_PR_DMMP_ERROR;    goto out1;  }  /* get info of all paths from the dm
>> device */  if (get_mpvec (curmp, pathvec, alias)){    condlog(0, "%s:
>> failed to get device info.", alias);    ret = MPATH_PR_DMMP_ERROR;    goto
>> out1;  }  *
>>
>> I believe the DI_CHECKER bit in path_discovery() API is not needed.
>> This is because the path status checking is already done on the specific
>> mpath device in the get_mpvec API.
>>
>> The get_mpvec() gets the required struct multipath *mpp, and then invokes
>> pathinfo(pp, conf->hwtable, DI_CHECKER) for each path in the multipath
>> dev.
>> And this checks state of each path for the multipath device.
>>
>> * if (mask & DI_CHECKER) {    pp->chkrstate = pp->state = get_state(pp,
>> 0);*
>>
>> *Possible solution:*
>> I have a patch ready that simply removes the DI_CHECKER bit from the
>> path_discovery() calls inside mpath_persistent_reserve_in() and
>> mpath_persistent_reserve_out(). Attached the patch.
>> I have tested out the following PRIN and PROUT commands and don't see any
>> errors.
>> mpathpersist -i -k /dev/mapper/mpathig
>> mpathpersist -i -r /dev/mapper/mpathig
>> mpathpersist --out --register --param-rk=0A041D3d /dev/mapper/mpathig
>> mpathpersist --out --register --param-sark=0A041D3d /dev/mapper/mpathig
>> mpathpersist --out --reserve --param-rk=0A041D3D --prout-type=5
>> --verbose=3 /dev/mapper/mpathig
>>
>> Request someone to review the patch, suggest changes and guide me in
>> fixing this issue.
>>
>> Thanks,
>> Satyajit
>>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11c3cb406455ac05216a40c7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Any comment on this mpath_persist optimization suggested b=
y Satyajit ? I&#39;d be inclined to merge it.<div><br></div><div>Best regar=
ds,</div><div>Christophe Varoqui<br><div><br></div><div>
=09
=09
=09


<pre class=3D"">diff -uNr multipath-tools/libmpathpersist/mpath_persist.c m=
ultipath-tools-2/libmpathpersist/mpath_persist.c
--- multipath-tools/libmpathpersist/mpath_persist.c	2015-08-27 22:58:20.938=
838600 -0700
+++ multipath-tools-2/libmpathpersist/mpath_persist.c	2015-08-27 22:59:42.7=
63466711 -0700
@@ -182,7 +182,7 @@
 		goto out;
 	}
=20
-	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER)) {
+	if (path_discovery(pathvec, conf, DI_SYSFS)) {
 		ret =3D MPATH_PR_DMMP_ERROR;
 		goto out1;
 	}
@@ -272,7 +272,7 @@
                 goto out;
         }
=20
-	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER)) {
+	if (path_discovery(pathvec, conf, DI_SYSFS)) {
 		ret =3D MPATH_PR_DMMP_ERROR;
 		goto out1;
 	}</pre></div></div></div><div class=3D"gmail_extra"><br><div class=3D"gma=
il_quote">On Mon, Aug 31, 2015 at 10:54 AM, Satyajit Deshmukh <span dir=3D"=
ltr">&lt;<a href=3D"mailto:satyajit.s.deshmukh@gmail.com" target=3D"_blank"=
>satyajit.s.deshmukh@gmail.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex"><div dir=3D"ltr">Quick update on this issue-<div>We spoke to =
Hannes Reinecke and understood that we were using a sub-optimal checker aka=
 &#39;directio&#39; for testing the paths.</div><div>As recommended to us b=
y Hannes, we tried the &#39;tur&#39; (Test Unit Ready) instead of the &#39;=
directio&#39;.</div><div>Result: We saw huge improvements in the times for =
the PROUT/PRIN commands.<br>This was the change needed:</div><div><div styl=
e=3D"font-size:12.8000001907349px">libmultipath/checkers.h<br>- <font color=
=3D"#ff0000">#define DEFAULT_CHECKER=C2=A0DIRECTIO</font></div><div style=
=3D"font-size:12.8000001907349px">+ <font color=3D"#0000ff">#define DEFAULT=
_CHECKER=C2=A0TUR</font></div></div><div style=3D"font-size:12.800000190734=
9px"><font color=3D"#0000ff"><br></font></div><div style=3D"font-size:12.80=
00001907349px"><font color=3D"#000000">However, I still believe that the pa=
th_discovery() API should not have the DI_CHECKER bit in the flags passed t=
o it.</font></div><div style=3D"font-size:12.8000001907349px"><font color=
=3D"#000000">By removing this bit, we saw even better times (about 3x faste=
r) for the PROUT/PRIN commands.</font></div><div style=3D"font-size:12.8000=
001907349px">Thus, if there are no side-effects/repercussions of removing t=
his bit from the place I mentioned, we could remove the bit IMO.</div><div =
style=3D"font-size:12.8000001907349px"><br></div><div style=3D"font-size:12=
.8000001907349px">Thanks,</div><div style=3D"font-size:12.8000001907349px">=
Satyajit</div></div><div class=3D"HOEnZb"><div class=3D"h5"><div class=3D"g=
mail_extra"><br><div class=3D"gmail_quote">On Fri, Aug 28, 2015 at 12:49 AM=
, Satyajit Deshmukh <span dir=3D"ltr">&lt;<a href=3D"mailto:satyajit.s.desh=
mukh@gmail.com" target=3D"_blank">satyajit.s.deshmukh@gmail.com</a>&gt;</sp=
an> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr">Hello,<br><br=
>This is related to an issue raised by Richard Sharpe recently.<br><a href=
=3D"https://www.redhat.com/archives/dm-devel/2015-August/msg00154.html" tar=
get=3D"_blank">https://www.redhat.com/archives/dm-devel/2015-August/msg0015=
4.html</a><br><br>The RPM that was used-<br><a href=3D"http://vault.centos.=
org/6.6/updates/Source/SPackages/device-mapper-multipath-0.4.9-80.el6_6.3.s=
rc.rpm" target=3D"_blank">http://vault.centos.org/6.6/updates/Source/SPacka=
ges/device-mapper-multipath-0.4.9-80.el6_6.3.src.rpm</a><br><br><b>Problem:=
</b><br>From reading the source code, I understand that 2 APIs defined in l=
ibmpathpersist/mpath_persist.c do a system-wide scan of all SCSI devices by=
 sending asynchronous IO (io_submit calls) to test if SCSI device path is g=
ood:<br><i>extern int mpath_persistent_reserve_in (int fd, int rq_servact, =
struct prin_resp *resp, int noisy, int verbose);<br>extern int mpath_persis=
tent_reserve_out ( int fd, int rq_servact, int rq_scope,<br>=C2=A0 =C2=A0 u=
nsigned int rq_type, struct prout_param_descriptor *paramp, int noisy,<br>=
=C2=A0 =C2=A0 int verbose);</i><br><br>So, to get a persistent reservation =
on a single /dev/mapper/mpathx device on a system having 400 SCSI devices, =
current code does 400 reads of 4K each.(512 bytes of 8 sectors), leading to=
 huge delays.<br><br><b>Root cause of the system wide device scan:</b><br>T=
he system-wide scan is triggered by setting the DI_CHECKER bit in the flags=
 argument to a path_discovery() API:<br>=C2=A0<i> if (path_discovery(pathve=
c, conf, DI_SYSFS | DI_CHECKER)) {<br>=C2=A0 =C2=A0 ret =3D MPATH_PR_DMMP_E=
RROR;<br>=C2=A0 =C2=A0 goto out1;<br>=C2=A0 }<br><br>=C2=A0 /* get info of =
all paths from the dm device */<br>=C2=A0 if (get_mpvec (curmp, pathvec, al=
ias)){<br>=C2=A0 =C2=A0 condlog(0, &quot;%s: failed to get device info.&quo=
t;, alias);<br>=C2=A0 =C2=A0 ret =3D MPATH_PR_DMMP_ERROR;<br>=C2=A0 =C2=A0 =
goto out1;<br>=C2=A0 } =C2=A0</i><br><br>I believe the DI_CHECKER bit in pa=
th_discovery() API is not needed.<br>This is because the path status checki=
ng is already done on the specific mpath device in the get_mpvec API.<br><b=
r>The get_mpvec() gets the required struct multipath *mpp, and then invokes=
<br>pathinfo(pp, conf-&gt;hwtable, DI_CHECKER) for each path in the multipa=
th dev.<br>And this checks state of each path for the multipath device.<br>=
=C2=A0<i> if (mask &amp; DI_CHECKER) {<br>=C2=A0 =C2=A0 pp-&gt;chkrstate =
=3D pp-&gt;state =3D get_state(pp, 0);</i><br><br><b>Possible solution:</b>=
<br>I have a patch ready that simply removes the DI_CHECKER bit from the pa=
th_discovery() calls inside mpath_persistent_reserve_in() and mpath_persist=
ent_reserve_out(). Attached the patch.<br>I have tested out the following P=
RIN and PROUT commands and don&#39;t see any errors.<br>mpathpersist -i -k =
/dev/mapper/mpathig<br>mpathpersist -i -r /dev/mapper/mpathig<br>mpathpersi=
st --out --register --param-rk=3D0A041D3d /dev/mapper/mpathig<br>mpathpersi=
st --out --register --param-sark=3D0A041D3d /dev/mapper/mpathig<br>mpathper=
sist --out --reserve --param-rk=3D0A041D3D --prout-type=3D5 --verbose=3D3 /=
dev/mapper/mpathig<br><br>Request someone to review the patch, suggest chan=
ges and guide me in fixing this issue.<br><br>Thanks,<br>Satyajit</div>
</blockquote></div><br></div>
</div></div><br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br></blockquote></div><br></div>

--001a11c3cb406455ac05216a40c7--


--===============4449670633128467832==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4449670633128467832==--
