From: Eli Klein <elijah@aclue.com>
Subject: Re: Question regarding failback option in multipath.conf
Date: Thu, 1 Oct 2009 19:01:15 -0600
Message-ID: <3f5a695c0910011801r607e0890t45802be2bbb52a26@mail.gmail.com>
References: <5A70833B-9208-470E-88B7-7C351EED2122@aclue.com>
	<4AC3AC88.9020404@redhat.com>
	<06F122DE-B7E5-4721-BA08-D0453D10581C@aclue.com>
	<4AC3B084.4060700@redhat.com>
	<B38A0B62-A47C-4400-B113-5D46D13453D6@aclue.com>
	<3f5a695c0910011416i6d87dcbcr94a04dfd825fba04@mail.gmail.com>
	<1254443952.6539.11.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1253991545=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254443952.6539.11.camel@jaspav.missionsit.net.missionsit.net>
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

--===============1253991545==
Content-Type: multipart/alternative; boundary=00504502da6c35a9a30474e94e61

--00504502da6c35a9a30474e94e61
Content-Type: text/plain; charset=ISO-8859-1

Sorry, I forgot to mention that I did.. it didn't help.
In addition, from the output of multipath -v3, multipathd is picking up all
of the correct settings, even with the two separate default sections.

-Eli

On Thu, Oct 1, 2009 at 6:39 PM, John A. Sullivan III <
jsullivan@opensourcedevel.com> wrote:

> I don't have the expertise to help very much but did you address the
> previous comment about duplicate default blocks? Good luck - John
>
> On Thu, 2009-10-01 at 15:16 -0600, Eli Klein wrote:
> > Any ideas on this? Not sure if this e-mail made it out to the list.
> >
> >
> > Thanks!
> >
> >
> > -Eli
> >
> > On Wed, Sep 30, 2009 at 1:36 PM, Eli Klein <elijah@aclue.com> wrote:
> >
> >         On Sep 30, 2009, at 1:24 PM, John Brier wrote:
> >
> >         > On 09/30/2009 03:16 PM, Eli Klein wrote:
> >         > >
> >         > > Here's the abbreviated output from multipath -v3:
> >         > >
> >         > > mpath1: pgfailback = 120 (config file default)
> >         > > mpath1: pgpolicy = multibus (config file default)
> >         > > mpath1: selector = round-robin 0 (internal default)
> >         > > mpath1: features = 1 queue_if_no_path (internal default)
> >         > > mpath1: hwhandler = 0 (internal default)
> >         > > mpath1: rr_weight = 2 (config file default)
> >         > > mpath1: minio = 10 (config file default)
> >         > > mpath1: no_path_retry = 1 (config file default)
> >         > > pg_timeout = NONE (internal default)
> >         > > mpath1: set ACT_NOTHING (map unchanged)
> >         > >
> >         > > It's definitely picking up the settings correctly from
> >         > > multipath.conf,
> >         > > but the paths are still reinstated immediately once
> >         > > they're reconnected
> >         > > (even if it's just for a split second).
> >         > >
> >         >
> >         > What does /var/log/messages look like when this happens?
> >         > Since you changed failback to 120 did you restart multipathd
> >         > or restart the box?
> >         >
> >         > John Brier
> >         >
> >         > --
> >         > dm-devel mailing list
> >         > dm-devel@redhat.com
> >         > https://www.redhat.com/mailman/listinfo/dm-devel
> >         >
> >
> >
> >         I've tried rebooting, restarting multipath (and iscsid),
> >         flushing multipath (-F), removing all the iscsi targets
> >         completely and then reinitializing the targets.  Nothing
> >         changes the behavior.  Here's output from /var/log/messages..
> >         note the time between when the link becomes active (13:31:08)
> >         to when the path is reinstated (13:31:15):
> >
> >
> >         Sep 30 13:30:28 testbox kernel:  connection7:0: ping timeout
> >         of 5 secs expired, recv timeout 5, last rx 4470061909, last
> >         ping 4470066909, now 4470071909
> >         Sep 30 13:30:28 testbox kernel:  connection7:0: detected conn
> >         error (1011)
> >         Sep 30 13:30:28 testbox multipathd: sdf: readsector0 checker
> >         reports path is down
> >         Sep 30 13:30:28 testbox multipathd: checker failed path 8:80
> >         in map mpath0
> >         Sep 30 13:30:28 testbox multipathd: mpath0: remaining active
> >         paths: 1
> >         Sep 30 13:30:28 testbox kernel: device-mapper: multipath:
> >         Failing path 8:80.
> >         Sep 30 13:30:28 testbox iscsid: Kernel reported iSCSI
> >         connection 7:0 error (1011) state (3)
> >         Sep 30 13:30:29 testbox kernel:  connection9:0: ping timeout
> >         of 5 secs expired, recv timeout 5, last rx 4470063232, last
> >         ping 4470068232, now 4470073232
> >         Sep 30 13:30:29 testbox kernel:  connection9:0: detected conn
> >         error (1011)
> >         Sep 30 13:30:29 testbox multipathd: sdg: readsector0 checker
> >         reports path is down
> >         Sep 30 13:30:29 testbox multipathd: checker failed path 8:96
> >         in map mpath1
> >         Sep 30 13:30:29 testbox multipathd: mpath1: remaining active
> >         paths: 1
> >         Sep 30 13:30:29 testbox kernel: device-mapper: multipath:
> >         Failing path 8:96.
> >         Sep 30 13:30:30 testbox kernel:  connection11:0: ping timeout
> >         of 5 secs expired, recv timeout 5, last rx 4470064373, last
> >         ping 4470069373, now 4470074373
> >         Sep 30 13:30:30 testbox kernel:  connection11:0: detected conn
> >         error (1011)
> >         Sep 30 13:30:30 testbox iscsid: Kernel reported iSCSI
> >         connection 9:0 error (1011) state (3)
> >         Sep 30 13:30:30 testbox multipathd: sdh: readsector0 checker
> >         reports path is down
> >         Sep 30 13:30:30 testbox multipathd: checker failed path 8:112
> >         in map mpath2
> >         Sep 30 13:30:30 testbox kernel: device-mapper: multipath:
> >         Failing path 8:112.
> >         Sep 30 13:30:30 testbox multipathd: mpath2: remaining active
> >         paths: 1
> >         Sep 30 13:30:30 testbox multipathd: dm-4: add map (uevent)
> >         Sep 30 13:30:30 testbox multipathd: dm-4: devmap already
> >         registered
> >         Sep 30 13:30:30 testbox multipathd: dm-2: add map (uevent)
> >         Sep 30 13:30:30 testbox multipathd: dm-2: devmap already
> >         registered
> >         Sep 30 13:30:30 testbox multipathd: dm-3: add map (uevent)
> >         Sep 30 13:30:30 testbox multipathd: dm-3: devmap already
> >         registered
> >         Sep 30 13:30:31 testbox iscsid: Kernel reported iSCSI
> >         connection 11:0 error (1011) state (3)
> >         Sep 30 13:30:43 testbox kernel:  session7: session recovery
> >         timed out after 15 secs
> >         Sep 30 13:30:43 testbox multipathd: sdf: readsector0 checker
> >         reports path is down
> >         Sep 30 13:30:44 testbox kernel:  session9: session recovery
> >         timed out after 15 secs
> >         Sep 30 13:30:44 testbox multipathd: sdg: readsector0 checker
> >         reports path is down
> >         Sep 30 13:30:45 testbox kernel:  session11: session recovery
> >         timed out after 15 secs
> >         Sep 30 13:30:45 testbox kernel: sd 13:0:0:0: SCSI error:
> >         return code = 0x000f0000
> >         Sep 30 13:30:45 testbox kernel: end_request: I/O error, dev
> >         sdh, sector 407978223
> >         Sep 30 13:30:45 testbox multipathd: sdh: readsector0 checker
> >         reports path is down
> >         Sep 30 13:30:55 testbox multipathd: sdf: readsector0 checker
> >         reports path is down
> >         Sep 30 13:31:05 testbox multipathd: sdg: readsector0 checker
> >         reports path is down
> >         Sep 30 13:31:05 testbox multipathd: sdh: readsector0 checker
> >         reports path is down
> >         Sep 30 13:31:05 testbox multipathd: sdf: readsector0 checker
> >         reports path is down
> >         Sep 30 13:31:05 testbox multipathd: sdg: readsector0 checker
> >         reports path is down
> >         Sep 30 13:31:05 testbox multipathd: sdh: readsector0 checker
> >         reports path is down
> >         Sep 30 13:31:08 testbox iscsid: connection9:0 is operational
> >         after recovery (3 attempts)
> >         Sep 30 13:31:08 testbox iscsid: connection11:0 is operational
> >         after recovery (3 attempts)
> >         Sep 30 13:31:11 testbox iscsid: connection7:0 is operational
> >         after recovery (3 attempts)
> >         Sep 30 13:31:15 testbox multipathd: sdf: readsector0 checker
> >         reports path is up
> >         Sep 30 13:31:15 testbox multipathd: 8:80: reinstated
> >         Sep 30 13:31:15 testbox multipathd: mpath0: remaining active
> >         paths: 2
> >         Sep 30 13:31:15 testbox multipathd: sdg: readsector0 checker
> >         reports path is up
> >         Sep 30 13:31:15 testbox multipathd: 8:96: reinstated
> >         Sep 30 13:31:15 testbox multipathd: mpath1: remaining active
> >         paths: 2
> >         Sep 30 13:31:15 testbox multipathd: sdh: readsector0 checker
> >         reports path is up
> >         Sep 30 13:31:15 testbox multipathd: 8:112: reinstated
> >         Sep 30 13:31:15 testbox multipathd: mpath2: remaining active
> >         paths: 2
> >         Sep 30 13:31:15 testbox multipathd: dm-4: add map (uevent)
> >         Sep 30 13:31:15 testbox multipathd: dm-4: devmap already
> >         registered
> >         Sep 30 13:31:15 testbox multipathd: dm-2: add map (uevent)
> >         Sep 30 13:31:15 testbox multipathd: dm-2: devmap already
> >         registered
> >         Sep 30 13:31:15 testbox multipathd: dm-3: add map (uevent)
> >         Sep 30 13:31:15 testbox multipathd: dm-3: devmap already
> >         registered
> >
> >
> >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> --
> John A. Sullivan III
> Open Source Development Corporation
> +1 207-985-7880
> jsullivan@opensourcedevel.com
>
> http://www.spiritualoutreach.com
> Making Christianity intelligible to secular society
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--00504502da6c35a9a30474e94e61
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Sorry, I forgot to mention that I did.. it didn&#39;t help.<div><br></div><=
div>In addition, from the output of multipath -v3, multipathd is picking up=
 all of the correct settings, even with the two separate default sections.<=
/div>

<div><br></div><div>-Eli</div><div><br><div class=3D"gmail_quote">On Thu, O=
ct 1, 2009 at 6:39 PM, John A. Sullivan III <span dir=3D"ltr">&lt;<a href=
=3D"mailto:jsullivan@opensourcedevel.com">jsullivan@opensourcedevel.com</a>=
&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex;">I don&#39;t have the expertise to help very=
 much but did you address the<br>
previous comment about duplicate default blocks? Good luck - John<br>
<div><div></div><div class=3D"h5"><br>
On Thu, 2009-10-01 at 15:16 -0600, Eli Klein wrote:<br>
&gt; Any ideas on this? Not sure if this e-mail made it out to the list.<br=
>
&gt;<br>
&gt;<br>
&gt; Thanks!<br>
&gt;<br>
&gt;<br>
&gt; -Eli<br>
&gt;<br>
&gt; On Wed, Sep 30, 2009 at 1:36 PM, Eli Klein &lt;<a href=3D"mailto:elija=
h@aclue.com">elijah@aclue.com</a>&gt; wrote:<br>
&gt;<br>
&gt; =A0 =A0 =A0 =A0 On Sep 30, 2009, at 1:24 PM, John Brier wrote:<br>
&gt;<br>
&gt; =A0 =A0 =A0 =A0 &gt; On 09/30/2009 03:16 PM, Eli Klein wrote:<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt;<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; Here&#39;s the abbreviated output from multi=
path -v3:<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt;<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; mpath1: pgfailback =3D 120 (config file defa=
ult)<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; mpath1: pgpolicy =3D multibus (config file d=
efault)<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; mpath1: selector =3D round-robin 0 (internal=
 default)<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; mpath1: features =3D 1 queue_if_no_path (int=
ernal default)<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; mpath1: hwhandler =3D 0 (internal default)<b=
r>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; mpath1: rr_weight =3D 2 (config file default=
)<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; mpath1: minio =3D 10 (config file default)<b=
r>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; mpath1: no_path_retry =3D 1 (config file def=
ault)<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; pg_timeout =3D NONE (internal default)<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; mpath1: set ACT_NOTHING (map unchanged)<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt;<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; It&#39;s definitely picking up the settings =
correctly from<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; multipath.conf,<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; but the paths are still reinstated immediate=
ly once<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; they&#39;re reconnected<br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt; (even if it&#39;s just for a split second).<=
br>
&gt; =A0 =A0 =A0 =A0 &gt; &gt;<br>
&gt; =A0 =A0 =A0 =A0 &gt;<br>
&gt; =A0 =A0 =A0 =A0 &gt; What does /var/log/messages look like when this h=
appens?<br>
&gt; =A0 =A0 =A0 =A0 &gt; Since you changed failback to 120 did you restart=
 multipathd<br>
&gt; =A0 =A0 =A0 =A0 &gt; or restart the box?<br>
&gt; =A0 =A0 =A0 =A0 &gt;<br>
&gt; =A0 =A0 =A0 =A0 &gt; John Brier<br>
&gt; =A0 =A0 =A0 =A0 &gt;<br>
&gt; =A0 =A0 =A0 =A0 &gt; --<br>
&gt; =A0 =A0 =A0 =A0 &gt; dm-devel mailing list<br>
&gt; =A0 =A0 =A0 =A0 &gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@r=
edhat.com</a><br>
&gt; =A0 =A0 =A0 =A0 &gt; <a href=3D"https://www.redhat.com/mailman/listinf=
o/dm-devel" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-de=
vel</a><br>
&gt; =A0 =A0 =A0 =A0 &gt;<br>
&gt;<br>
&gt;<br>
&gt; =A0 =A0 =A0 =A0 I&#39;ve tried rebooting, restarting multipath (and is=
csid),<br>
&gt; =A0 =A0 =A0 =A0 flushing multipath (-F), removing all the iscsi target=
s<br>
&gt; =A0 =A0 =A0 =A0 completely and then reinitializing the targets. =A0Not=
hing<br>
&gt; =A0 =A0 =A0 =A0 changes the behavior. =A0Here&#39;s output from /var/l=
og/messages..<br>
&gt; =A0 =A0 =A0 =A0 note the time between when the link becomes active (13=
:31:08)<br>
&gt; =A0 =A0 =A0 =A0 to when the path is reinstated (13:31:15):<br>
&gt;<br>
&gt;<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:28 testbox kernel: =A0connection7:0: ping=
 timeout<br>
&gt; =A0 =A0 =A0 =A0 of 5 secs expired, recv timeout 5, last rx 4470061909,=
 last<br>
&gt; =A0 =A0 =A0 =A0 ping 4470066909, now 4470071909<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:28 testbox kernel: =A0connection7:0: dete=
cted conn<br>
&gt; =A0 =A0 =A0 =A0 error (1011)<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:28 testbox multipathd: sdf: readsector0 c=
hecker<br>
&gt; =A0 =A0 =A0 =A0 reports path is down<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:28 testbox multipathd: checker failed pat=
h 8:80<br>
&gt; =A0 =A0 =A0 =A0 in map mpath0<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:28 testbox multipathd: mpath0: remaining =
active<br>
&gt; =A0 =A0 =A0 =A0 paths: 1<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:28 testbox kernel: device-mapper: multipa=
th:<br>
&gt; =A0 =A0 =A0 =A0 Failing path 8:80.<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:28 testbox iscsid: Kernel reported iSCSI<=
br>
&gt; =A0 =A0 =A0 =A0 connection 7:0 error (1011) state (3)<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:29 testbox kernel: =A0connection9:0: ping=
 timeout<br>
&gt; =A0 =A0 =A0 =A0 of 5 secs expired, recv timeout 5, last rx 4470063232,=
 last<br>
&gt; =A0 =A0 =A0 =A0 ping 4470068232, now 4470073232<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:29 testbox kernel: =A0connection9:0: dete=
cted conn<br>
&gt; =A0 =A0 =A0 =A0 error (1011)<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:29 testbox multipathd: sdg: readsector0 c=
hecker<br>
&gt; =A0 =A0 =A0 =A0 reports path is down<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:29 testbox multipathd: checker failed pat=
h 8:96<br>
&gt; =A0 =A0 =A0 =A0 in map mpath1<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:29 testbox multipathd: mpath1: remaining =
active<br>
&gt; =A0 =A0 =A0 =A0 paths: 1<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:29 testbox kernel: device-mapper: multipa=
th:<br>
&gt; =A0 =A0 =A0 =A0 Failing path 8:96.<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:30 testbox kernel: =A0connection11:0: pin=
g timeout<br>
&gt; =A0 =A0 =A0 =A0 of 5 secs expired, recv timeout 5, last rx 4470064373,=
 last<br>
&gt; =A0 =A0 =A0 =A0 ping 4470069373, now 4470074373<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:30 testbox kernel: =A0connection11:0: det=
ected conn<br>
&gt; =A0 =A0 =A0 =A0 error (1011)<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:30 testbox iscsid: Kernel reported iSCSI<=
br>
&gt; =A0 =A0 =A0 =A0 connection 9:0 error (1011) state (3)<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:30 testbox multipathd: sdh: readsector0 c=
hecker<br>
&gt; =A0 =A0 =A0 =A0 reports path is down<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:30 testbox multipathd: checker failed pat=
h 8:112<br>
&gt; =A0 =A0 =A0 =A0 in map mpath2<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:30 testbox kernel: device-mapper: multipa=
th:<br>
&gt; =A0 =A0 =A0 =A0 Failing path 8:112.<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:30 testbox multipathd: mpath2: remaining =
active<br>
&gt; =A0 =A0 =A0 =A0 paths: 1<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:30 testbox multipathd: dm-4: add map (uev=
ent)<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:30 testbox multipathd: dm-4: devmap alrea=
dy<br>
&gt; =A0 =A0 =A0 =A0 registered<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:30 testbox multipathd: dm-2: add map (uev=
ent)<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:30 testbox multipathd: dm-2: devmap alrea=
dy<br>
&gt; =A0 =A0 =A0 =A0 registered<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:30 testbox multipathd: dm-3: add map (uev=
ent)<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:30 testbox multipathd: dm-3: devmap alrea=
dy<br>
&gt; =A0 =A0 =A0 =A0 registered<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:31 testbox iscsid: Kernel reported iSCSI<=
br>
&gt; =A0 =A0 =A0 =A0 connection 11:0 error (1011) state (3)<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:43 testbox kernel: =A0session7: session r=
ecovery<br>
&gt; =A0 =A0 =A0 =A0 timed out after 15 secs<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:43 testbox multipathd: sdf: readsector0 c=
hecker<br>
&gt; =A0 =A0 =A0 =A0 reports path is down<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:44 testbox kernel: =A0session9: session r=
ecovery<br>
&gt; =A0 =A0 =A0 =A0 timed out after 15 secs<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:44 testbox multipathd: sdg: readsector0 c=
hecker<br>
&gt; =A0 =A0 =A0 =A0 reports path is down<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:45 testbox kernel: =A0session11: session =
recovery<br>
&gt; =A0 =A0 =A0 =A0 timed out after 15 secs<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:45 testbox kernel: sd 13:0:0:0: SCSI erro=
r:<br>
&gt; =A0 =A0 =A0 =A0 return code =3D 0x000f0000<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:45 testbox kernel: end_request: I/O error=
, dev<br>
&gt; =A0 =A0 =A0 =A0 sdh, sector 407978223<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:45 testbox multipathd: sdh: readsector0 c=
hecker<br>
&gt; =A0 =A0 =A0 =A0 reports path is down<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:30:55 testbox multipathd: sdf: readsector0 c=
hecker<br>
&gt; =A0 =A0 =A0 =A0 reports path is down<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:05 testbox multipathd: sdg: readsector0 c=
hecker<br>
&gt; =A0 =A0 =A0 =A0 reports path is down<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:05 testbox multipathd: sdh: readsector0 c=
hecker<br>
&gt; =A0 =A0 =A0 =A0 reports path is down<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:05 testbox multipathd: sdf: readsector0 c=
hecker<br>
&gt; =A0 =A0 =A0 =A0 reports path is down<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:05 testbox multipathd: sdg: readsector0 c=
hecker<br>
&gt; =A0 =A0 =A0 =A0 reports path is down<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:05 testbox multipathd: sdh: readsector0 c=
hecker<br>
&gt; =A0 =A0 =A0 =A0 reports path is down<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:08 testbox iscsid: connection9:0 is opera=
tional<br>
&gt; =A0 =A0 =A0 =A0 after recovery (3 attempts)<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:08 testbox iscsid: connection11:0 is oper=
ational<br>
&gt; =A0 =A0 =A0 =A0 after recovery (3 attempts)<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:11 testbox iscsid: connection7:0 is opera=
tional<br>
&gt; =A0 =A0 =A0 =A0 after recovery (3 attempts)<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:15 testbox multipathd: sdf: readsector0 c=
hecker<br>
&gt; =A0 =A0 =A0 =A0 reports path is up<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:15 testbox multipathd: 8:80: reinstated<b=
r>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:15 testbox multipathd: mpath0: remaining =
active<br>
&gt; =A0 =A0 =A0 =A0 paths: 2<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:15 testbox multipathd: sdg: readsector0 c=
hecker<br>
&gt; =A0 =A0 =A0 =A0 reports path is up<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:15 testbox multipathd: 8:96: reinstated<b=
r>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:15 testbox multipathd: mpath1: remaining =
active<br>
&gt; =A0 =A0 =A0 =A0 paths: 2<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:15 testbox multipathd: sdh: readsector0 c=
hecker<br>
&gt; =A0 =A0 =A0 =A0 reports path is up<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:15 testbox multipathd: 8:112: reinstated<=
br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:15 testbox multipathd: mpath2: remaining =
active<br>
&gt; =A0 =A0 =A0 =A0 paths: 2<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:15 testbox multipathd: dm-4: add map (uev=
ent)<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:15 testbox multipathd: dm-4: devmap alrea=
dy<br>
&gt; =A0 =A0 =A0 =A0 registered<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:15 testbox multipathd: dm-2: add map (uev=
ent)<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:15 testbox multipathd: dm-2: devmap alrea=
dy<br>
&gt; =A0 =A0 =A0 =A0 registered<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:15 testbox multipathd: dm-3: add map (uev=
ent)<br>
&gt; =A0 =A0 =A0 =A0 Sep 30 13:31:15 testbox multipathd: dm-3: devmap alrea=
dy<br>
&gt; =A0 =A0 =A0 =A0 registered<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D=
"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</div></div><font color=3D"#888888">--<br>
John A. Sullivan III<br>
Open Source Development Corporation<br>
+1 207-985-7880<br>
<a href=3D"mailto:jsullivan@opensourcedevel.com">jsullivan@opensourcedevel.=
com</a><br>
<br>
<a href=3D"http://www.spiritualoutreach.com" target=3D"_blank">http://www.s=
piritualoutreach.com</a><br>
Making Christianity intelligible to secular society<br>
</font><div><div></div><div class=3D"h5"><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</div></div></blockquote></div><br></div>

--00504502da6c35a9a30474e94e61--


--===============1253991545==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1253991545==--
