From: Stewart Smith <stew@cleepdar.com>
Subject: Re: rdac path failure - Sun 6140
Date: Thu, 13 Aug 2009 13:27:47 -0700
Message-ID: <f7500f4e0908131327x442a5ddfkc6e2aef58cf5bbfc@mail.gmail.com>
References: <f7500f4e0908131150r54b21a0dr9cb7d4a8456e69e8@mail.gmail.com>
	<E463DF2B2E584B4A82673F53D62C2EF474AEB7FC@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1437416828=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474AEB7FC@cosmail01.lsi.com>
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

--===============1437416828==
Content-Type: multipart/alternative; boundary=00221504892bd6a33a04710bc49d

--00221504892bd6a33a04710bc49d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

after a fresh, multipath -F and start of multipathd with -v 2 I see the
following messages.

After starting multipathd I mounted /dev/mapper/vol1 and generated some
simple I/O to it using dd


Aug 13 16:23:14.888 localhost kernel: device-mapper: multipath: Failing path
8:208.
Aug 13 16:23:14.000 localhost multipathd: 8:208: mark as failed
Aug 13 16:23:16.000 localhost multipathd: 8:208: reinstated
Aug 13 16:23:30.462 localhost kernel: device-mapper: multipath: Failing path
8:208.
Aug 13 16:23:30.000 localhost multipathd: 8:208: mark as failed
Aug 13 16:23:39.000 localhost multipathd: 8:208: reinstated
Aug 13 16:23:46.430 localhost kernel: device-mapper: multipath: Failing path
8:208.
Aug 13 16:23:46.000 localhost multipathd: 8:208: mark as failed
Aug 13 16:23:51.041 localhost kernel: device-mapper: multipath: Failing path
8:208.
Aug 13 16:23:51.000 localhost multipathd: 8:208: mark as failed
Aug 13 16:23:59.000 localhost multipathd: 8:208: reinstated
Aug 13 16:24:06.465 localhost kernel: device-mapper: multipath: Failing path
8:208.
Aug 13 16:24:06.000 localhost multipathd: 8:208: mark as failed
Aug 13 16:24:09.000 localhost multipathd: 8:208: reinstated


Thanks,
--
Stew




On Thu, Aug 13, 2009 at 12:42 PM, Moger, Babu <Babu.Moger@lsi.com> wrote:

> Do you have /var/log/messages file for this problem?
>
> Thanks
> Babu Moger
>
> > -----Original Message-----
> > From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On
> > Behalf Of Stewart Smith
> > Sent: Thursday, August 13, 2009 1:51 PM
> > To: dm-devel@redhat.com
> > Subject: [dm-devel] rdac path failure - Sun 6140
> >
> > Hello All,
> >
> > I am seeing many of these messages when my Sun 6140 array is under heavy
> > I/O
> > device-mapper: multipath: Failing path 8:208.
> > device-mapper: multipath: Failing path 8:208.
> > device-mapper: multipath: Failing path 8:208.
> > device-mapper: multipath: Failing path 8:208.
> > device-mapper: multipath: Failing path 8:208.
> >
> >
> > I am running a Fedora 10 server, with two fiber connections to two
> > different switches.  Both controllers on the 6140 have one connection
> > to each switch as well.  The end result is that I see four paths to
> > each LUN.
> >
> > When the volume is mounted and under significant load I see the
> > messages above every few seconds.  They seem to appear every
> > "no_path_retry" seconds.
> >
> > The 6140 controller firmware is up to date at version 07.50.08.10 and
> > I have installed the latest firmware for my Emulex LPe11002 cards.  I
> > have reproduced the problem using both Cisco MDS and Brocade fiber
> > channel switches as well.
> >
> > Using CAM, I have set the initiator Host Type to "Linux" at the
> > moment.  I have tried other options as well without success.
> >
> > I have NOT installed the RDAC drivers from either Sun or LSI -
> > primarily because they do not seem to build on my Fedora 10 kernel.
> >
> > Any ideas would be greatly appreciated!!!
> >
> > configs and debugging multipathd output is below.
> >
> >
> >
> >
> >
> > Kernel: 2.6.27.24-170.2.68.fc10.x86_64
> >
> > # multipath -lll
> > vol1 (3600a0b800048335200001e5d48b68a9b) dm-1 SUN,CSM200_R
> > [size=12T][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
> > \_ round-robin 0 [prio=6][active]
> >  \_ 5:0:1:2 sdj 8:144 [active][ready]
> >  \_ 2:0:1:2 sdn 8:208 [active][ready]
> > \_ round-robin 0 [prio=0][enabled]
> >  \_ 2:0:0:2 sdb 8:16  [active][ghost]
> >  \_ 5:0:0:2 sdd 8:48  [active][ghost]
> >
> >
> > # cat /etc/multipath.conf
> >
> > blacklist {
> >         devnode "^sd[a-z][[0-9]*]"
> >         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
> >         devnode "^hd[a-z][0-9]*"
> >         devnode "^cciss!c[0-9]d[0-9](p[0-9]*)*"
> > }
> >
> > defaults {
> >         udev_dir                /dev
> >         polling_interval        10
> >         selector                "round-robin 0"
> >         path_grouping_policy    multibus
> >         getuid_callout          "/sbin/scsi_id --whitelisted /dev/%n"
> >         prio                    alua
> >         path_checker            readsector0
> >         rr_min_io               100
> >         max_fds                 8192
> >         rr_weight               priorities
> >         failback                immediate
> >         no_path_retry           fail
> >         user_friendly_names     yes
> > }
> > devices {
> >         device {
> >                 vendor                  "SUN"
> >                 product                 "CSM200_R"
> >                 product_blacklist       "Universal Xport"
> >                 getuid_callout          "/sbin/scsi_id --whitelisted
> > /dev/%n"
> >                 features                "0"
> >                 hardware_handler        "1 rdac"
> >                 path_selector           "round-robin 0"
> >                 path_grouping_policy    group_by_prio
> >                 failback                immediate
> >                 rr_weight               uniform
> >                 no_path_retry           queue
> >                 rr_min_io               1000
> >                 path_checker            rdac
> >                 prio                    rdac
> >         }
> > }
> >
> > multipaths {
> >         multipath {
> >                 wwid                    3600a0b800048335200001e5d48b68a9b
> >                 alias                   vol1
> >                 rr_weight               priorities
> >                 no_path_retry           5
> >                 rr_min_io               100
> >         }
> > }
> >
> >
> >
> > # multipathd -d v3
> >
> >
> > Aug 13 14:48:53 | sdb: ownership set to vol1
> > Aug 13 14:48:53 | sdb: not found in pathvec
> > Aug 13 14:48:53 | sdb: mask = 0xc
> > Aug 13 14:48:53 | sdb: path checker = rdac (controller setting)
> > Aug 13 14:48:53 | sdb: state = 4
> > Aug 13 14:48:53 | sdb: rdac prio = 0
> > Aug 13 14:48:53 | sdd: ownership set to vol1
> > Aug 13 14:48:53 | sdd: not found in pathvec
> > Aug 13 14:48:53 | sdd: mask = 0xc
> > Aug 13 14:48:53 | sdd: path checker = rdac (controller setting)
> > Aug 13 14:48:53 | sdd: state = 4
> > Aug 13 14:48:53 | sdd: rdac prio = 0
> > Aug 13 14:48:53 | sdj: ownership set to vol1
> > Aug 13 14:48:53 | sdj: not found in pathvec
> > Aug 13 14:48:53 | sdj: mask = 0xc
> > Aug 13 14:48:53 | sdj: path checker = rdac (controller setting)
> > Aug 13 14:48:53 | sdj: state = 2
> > Aug 13 14:48:53 | sdj: rdac prio = 3
> > Aug 13 14:48:53 | sdn: ownership set to vol1
> > Aug 13 14:48:53 | sdn: not found in pathvec
> > Aug 13 14:48:53 | sdn: mask = 0xc
> > Aug 13 14:48:53 | sdn: path checker = rdac (controller setting)
> > Aug 13 14:48:53 | sdn: state = 2
> > Aug 13 14:48:53 | sdn: rdac prio = 3
> > Aug 13 14:48:53 | vol1: pgfailback = -2 (controller setting)
> > Aug 13 14:48:53 | vol1: pgpolicy = group_by_prio (controller setting)
> > Aug 13 14:48:53 | vol1: selector = round-robin 0 (controller setting)
> > Aug 13 14:48:53 | vol1: features = 0 (controller setting)
> > Aug 13 14:48:53 | vol1: hwhandler = 1 rdac (controller setting)
> > Aug 13 14:48:53 | vol1: rr_weight = 2 (LUN setting)
> > Aug 13 14:48:53 | vol1: minio = 100 (LUN setting)
> > Aug 13 14:48:53 | vol1: no_path_retry = 5 (multipath setting)
> > Aug 13 14:48:53 | pg_timeout = NONE (internal default)
> > Aug 13 14:48:53 | vol1: set ACT_CREATE (map does not exist)
> > create: vol1 (3600a0b800048335200001e5d48b68a9b) n/a SUN,CSM200_R
> > [size=12T][features=0][hwhandler=1 rdac][n/a]
> > \_ round-robin 0 [prio=6][undef]
> >  \_ 5:0:1:2 sdj 8:144 [undef][ready]
> >  \_ 2:0:1:2 sdn 8:208 [undef][ready]
> > \_ round-robin 0 [prio=0][undef]
> >  \_ 2:0:0:2 sdb 8:16 [undef][ghost]
> >  \_ 5:0:0:2 sdd 8:48 [undef][ghost]
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--00221504892bd6a33a04710bc49d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div><br></div><div>after a fresh, multipath -F and start of multipathd wit=
h -v 2 I see the following messages.</div><div><br></div><div>After startin=
g multipathd I mounted /dev/mapper/vol1 and generated some simple I/O to it=
 using dd</div>
<div><br></div><div><br></div><div><div>Aug 13 16:23:14.888 localhost kerne=
l: device-mapper: multipath: Failing path 8:208.</div><div>Aug 13 16:23:14.=
000 localhost multipathd: 8:208: mark as failed</div><div>Aug 13 16:23:16.0=
00 localhost multipathd: 8:208: reinstated</div>
<div>Aug 13 16:23:30.462 localhost kernel: device-mapper: multipath: Failin=
g path 8:208.=A0</div><div>Aug 13 16:23:30.000 localhost multipathd: 8:208:=
 mark as failed</div><div>Aug 13 16:23:39.000 localhost multipathd: 8:208: =
reinstated</div>
<div>Aug 13 16:23:46.430 localhost kernel: device-mapper: multipath: Failin=
g path 8:208.=A0</div><div>Aug 13 16:23:46.000 localhost multipathd: 8:208:=
 mark as failed</div><div>Aug 13 16:23:51.041 localhost kernel: device-mapp=
er: multipath: Failing path 8:208.=A0</div>
<div>Aug 13 16:23:51.000 localhost multipathd: 8:208: mark as failed</div><=
div>Aug 13 16:23:59.000 localhost multipathd: 8:208: reinstated</div><div>A=
ug 13 16:24:06.465 localhost kernel: device-mapper: multipath: Failing path=
 8:208.</div>
<div>Aug 13 16:24:06.000 localhost multipathd: 8:208: mark as failed</div><=
div>Aug 13 16:24:09.000 localhost multipathd: 8:208: reinstated</div><div><=
br></div><div><br></div><div>Thanks,</div><div>--</div><div>Stew</div></div=
>
<div><br></div><div><br></div><br><br><div class=3D"gmail_quote">On Thu, Au=
g 13, 2009 at 12:42 PM, Moger, Babu <span dir=3D"ltr">&lt;<a href=3D"mailto=
:Babu.Moger@lsi.com">Babu.Moger@lsi.com</a>&gt;</span> wrote:<br><blockquot=
e class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc sol=
id;padding-left:1ex;">
Do you have /var/log/messages file for this problem?<br>
<br>
Thanks<br>
Babu Moger<br>
<div><div></div><div class=3D"h5"><br>
&gt; -----Original Message-----<br>
&gt; From: <a href=3D"mailto:dm-devel-bounces@redhat.com">dm-devel-bounces@=
redhat.com</a> [mailto:<a href=3D"mailto:dm-devel-bounces@redhat.com">dm-de=
vel-bounces@redhat.com</a>] On<br>
&gt; Behalf Of Stewart Smith<br>
&gt; Sent: Thursday, August 13, 2009 1:51 PM<br>
&gt; To: <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt; Subject: [dm-devel] rdac path failure - Sun 6140<br>
&gt;<br>
&gt; Hello All,<br>
&gt;<br>
&gt; I am seeing many of these messages when my Sun 6140 array is under hea=
vy<br>
&gt; I/O<br>
&gt; device-mapper: multipath: Failing path 8:208.<br>
&gt; device-mapper: multipath: Failing path 8:208.<br>
&gt; device-mapper: multipath: Failing path 8:208.<br>
&gt; device-mapper: multipath: Failing path 8:208.<br>
&gt; device-mapper: multipath: Failing path 8:208.<br>
&gt;<br>
&gt;<br>
&gt; I am running a Fedora 10 server, with two fiber connections to two<br>
&gt; different switches.=A0=A0Both=A0controllers on the 6140 have one conne=
ction<br>
&gt; to each switch as well. =A0The end result is that I see four paths to<=
br>
&gt; each LUN.<br>
&gt;<br>
&gt; When the volume is mounted and under significant load I see the<br>
&gt; messages above every few seconds. =A0They seem to appear every<br>
&gt; &quot;no_path_retry&quot; seconds.<br>
&gt;<br>
&gt; The 6140 controller firmware is up to date at version 07.50.08.10 and<=
br>
&gt; I have installed the latest firmware for my Emulex LPe11002 cards. =A0=
I<br>
&gt; have reproduced the problem using both Cisco MDS and Brocade fiber<br>
&gt; channel switches as well.<br>
&gt;<br>
&gt; Using CAM, I have set the initiator Host Type to &quot;Linux&quot; at =
the<br>
&gt; moment. =A0I have tried other options as well without success.<br>
&gt;<br>
&gt; I have NOT installed the RDAC drivers from either Sun or LSI -<br>
&gt; primarily because they do not seem to build on my Fedora 10 kernel.<br=
>
&gt;<br>
&gt; Any ideas would be greatly appreciated!!!<br>
&gt;<br>
&gt; configs and debugging multipathd output is below.<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; Kernel: 2.6.27.24-170.2.68.fc10.x86_64<br>
&gt;<br>
&gt; # multipath -lll<br>
&gt; vol1 (3600a0b800048335200001e5d48b68a9b) dm-1 SUN,CSM200_R<br>
&gt; [size=3D12T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac][rw]<br=
>
&gt; \_ round-robin 0 [prio=3D6][active]<br>
&gt; =A0\_ 5:0:1:2 sdj 8:144 [active][ready]<br>
&gt; =A0\_ 2:0:1:2 sdn 8:208 [active][ready]<br>
&gt; \_ round-robin 0 [prio=3D0][enabled]<br>
&gt; =A0\_ 2:0:0:2 sdb 8:16 =A0[active][ghost]<br>
&gt; =A0\_ 5:0:0:2 sdd 8:48 =A0[active][ghost]<br>
&gt;<br>
&gt;<br>
&gt; # cat /etc/multipath.conf<br>
&gt;<br>
&gt; blacklist {<br>
&gt; =A0 =A0 =A0 =A0 devnode &quot;^sd[a-z][[0-9]*]&quot;<br>
&gt; =A0 =A0 =A0 =A0 devnode &quot;^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]=
*&quot;<br>
&gt; =A0 =A0 =A0 =A0 devnode &quot;^hd[a-z][0-9]*&quot;<br>
&gt; =A0 =A0 =A0 =A0 devnode &quot;^cciss!c[0-9]d[0-9](p[0-9]*)*&quot;<br>
&gt; }<br>
&gt;<br>
&gt; defaults {<br>
&gt; =A0 =A0 =A0 =A0 udev_dir =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/dev<br>
&gt; =A0 =A0 =A0 =A0 polling_interval =A0 =A0 =A0 =A010<br>
&gt; =A0 =A0 =A0 =A0 selector =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&quot;round-ro=
bin 0&quot;<br>
&gt; =A0 =A0 =A0 =A0 path_grouping_policy =A0 =A0multibus<br>
&gt; =A0 =A0 =A0 =A0 getuid_callout =A0 =A0 =A0 =A0 =A0&quot;/sbin/scsi_id =
--whitelisted /dev/%n&quot;<br>
&gt; =A0 =A0 =A0 =A0 prio =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0alua<br>
&gt; =A0 =A0 =A0 =A0 path_checker =A0 =A0 =A0 =A0 =A0 =A0readsector0<br>
&gt; =A0 =A0 =A0 =A0 rr_min_io =A0 =A0 =A0 =A0 =A0 =A0 =A0 100<br>
&gt; =A0 =A0 =A0 =A0 max_fds =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 8192<br>
&gt; =A0 =A0 =A0 =A0 rr_weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 priorities<br>
&gt; =A0 =A0 =A0 =A0 failback =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0immediate<br>
&gt; =A0 =A0 =A0 =A0 no_path_retry =A0 =A0 =A0 =A0 =A0 fail<br>
&gt; =A0 =A0 =A0 =A0 user_friendly_names =A0 =A0 yes<br>
&gt; }<br>
&gt; devices {<br>
&gt; =A0 =A0 =A0 =A0 device {<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vendor =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0&quot;SUN&quot;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 product =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 &quot;CSM200_R&quot;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 product_blacklist =A0 =A0 =A0 &quot;Un=
iversal Xport&quot;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 getuid_callout =A0 =A0 =A0 =A0 =A0&quo=
t;/sbin/scsi_id --whitelisted<br>
&gt; /dev/%n&quot;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 features =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0&quot;0&quot;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hardware_handler =A0 =A0 =A0 =A0&quot;=
1 rdac&quot;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path_selector =A0 =A0 =A0 =A0 =A0 &quo=
t;round-robin 0&quot;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path_grouping_policy =A0 =A0group_by_p=
rio<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 failback =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0immediate<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rr_weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
uniform<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 no_path_retry =A0 =A0 =A0 =A0 =A0 queu=
e<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rr_min_io =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
1000<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path_checker =A0 =A0 =A0 =A0 =A0 =A0rd=
ac<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prio =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0rdac<br>
&gt; =A0 =A0 =A0 =A0 }<br>
&gt; }<br>
&gt;<br>
&gt; multipaths {<br>
&gt; =A0 =A0 =A0 =A0 multipath {<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wwid =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A03600a0b800048335200001e5d48b68a9b<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 alias =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 vol1<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rr_weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
priorities<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 no_path_retry =A0 =A0 =A0 =A0 =A0 5<br=
>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rr_min_io =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
100<br>
&gt; =A0 =A0 =A0 =A0 }<br>
&gt; }<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; # multipathd -d v3<br>
&gt;<br>
&gt;<br>
&gt; Aug 13 14:48:53 | sdb: ownership set to vol1<br>
&gt; Aug 13 14:48:53 | sdb: not found in pathvec<br>
&gt; Aug 13 14:48:53 | sdb: mask =3D 0xc<br>
&gt; Aug 13 14:48:53 | sdb: path checker =3D rdac (controller setting)<br>
&gt; Aug 13 14:48:53 | sdb: state =3D 4<br>
&gt; Aug 13 14:48:53 | sdb: rdac prio =3D 0<br>
&gt; Aug 13 14:48:53 | sdd: ownership set to vol1<br>
&gt; Aug 13 14:48:53 | sdd: not found in pathvec<br>
&gt; Aug 13 14:48:53 | sdd: mask =3D 0xc<br>
&gt; Aug 13 14:48:53 | sdd: path checker =3D rdac (controller setting)<br>
&gt; Aug 13 14:48:53 | sdd: state =3D 4<br>
&gt; Aug 13 14:48:53 | sdd: rdac prio =3D 0<br>
&gt; Aug 13 14:48:53 | sdj: ownership set to vol1<br>
&gt; Aug 13 14:48:53 | sdj: not found in pathvec<br>
&gt; Aug 13 14:48:53 | sdj: mask =3D 0xc<br>
&gt; Aug 13 14:48:53 | sdj: path checker =3D rdac (controller setting)<br>
&gt; Aug 13 14:48:53 | sdj: state =3D 2<br>
&gt; Aug 13 14:48:53 | sdj: rdac prio =3D 3<br>
&gt; Aug 13 14:48:53 | sdn: ownership set to vol1<br>
&gt; Aug 13 14:48:53 | sdn: not found in pathvec<br>
&gt; Aug 13 14:48:53 | sdn: mask =3D 0xc<br>
&gt; Aug 13 14:48:53 | sdn: path checker =3D rdac (controller setting)<br>
&gt; Aug 13 14:48:53 | sdn: state =3D 2<br>
&gt; Aug 13 14:48:53 | sdn: rdac prio =3D 3<br>
&gt; Aug 13 14:48:53 | vol1: pgfailback =3D -2 (controller setting)<br>
&gt; Aug 13 14:48:53 | vol1: pgpolicy =3D group_by_prio (controller setting=
)<br>
&gt; Aug 13 14:48:53 | vol1: selector =3D round-robin 0 (controller setting=
)<br>
&gt; Aug 13 14:48:53 | vol1: features =3D 0 (controller setting)<br>
&gt; Aug 13 14:48:53 | vol1: hwhandler =3D 1 rdac (controller setting)<br>
&gt; Aug 13 14:48:53 | vol1: rr_weight =3D 2 (LUN setting)<br>
&gt; Aug 13 14:48:53 | vol1: minio =3D 100 (LUN setting)<br>
&gt; Aug 13 14:48:53 | vol1: no_path_retry =3D 5 (multipath setting)<br>
&gt; Aug 13 14:48:53 | pg_timeout =3D NONE (internal default)<br>
&gt; Aug 13 14:48:53 | vol1: set ACT_CREATE (map does not exist)<br>
&gt; create: vol1 (3600a0b800048335200001e5d48b68a9b) n/a SUN,CSM200_R<br>
&gt; [size=3D12T][features=3D0][hwhandler=3D1 rdac][n/a]<br>
&gt; \_ round-robin 0 [prio=3D6][undef]<br>
&gt; =A0\_ 5:0:1:2 sdj 8:144 [undef][ready]<br>
&gt; =A0\_ 2:0:1:2 sdn 8:208 [undef][ready]<br>
&gt; \_ round-robin 0 [prio=3D0][undef]<br>
&gt; =A0\_ 2:0:0:2 sdb 8:16 [undef][ghost]<br>
&gt; =A0\_ 5:0:0:2 sdd 8:48 [undef][ghost]<br>
&gt;<br>
</div></div>&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D=
"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
<font color=3D"#888888"><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</font></blockquote></div><br>

--00221504892bd6a33a04710bc49d--


--===============1437416828==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1437416828==--
