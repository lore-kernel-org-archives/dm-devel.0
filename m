From: Flavio Junior <billpp@gmail.com>
Subject: [code] prio_callout for r/w and r/o devices
Date: Thu, 7 May 2009 19:22:47 -0300
Message-ID: <58aa8d780905071522xf370fb6kd8e193088103f230@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0551503811=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============0551503811==
Content-Type: multipart/alternative; boundary=001e680f0c889e0fb9046959f318

--001e680f0c889e0fb9046959f318
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi folks,

Based on the scenario i've described below I wrote a simple, totally based
on pp_rdac.c, code to send a SCSI command WRITE_AND_VERITY (0x2E) and decid=
e
if that path is read-write or read-only.

The code is here: http://pastebin.com/m22b06f04

I'm sending it to the list to request for improve, tips, recommendations,
anything... I'm not a developer anyway.

--

Fl=E1vio do Carmo J=FAnior aka waKKu

On Fri, Apr 24, 2009 at 11:21 PM, Flavio Junior <billpp@gmail.com> wrote:

> On Fri, Apr 24, 2009 at 10:24 PM, Chandra Seetharaman
> <sekharan@us.ibm.com> wrote:
> > Hi Flavio,
>
> Hi Chandra ;)
>
> >
> > Since you are using LSI's (I think it is not IBM's :) rdac driver, whic=
h
> > do provide multipathing functionality (as you see only one device per
> > lun) why do you want to use dm-multipath ?
>
> I'm using dm-multipath to group LUN's at different storages. But, IBM
> DS4700 ERM just allows (really makes sense) read-write operations on
> the primary storage device, so this is why I need to different prio
> for paths.
>
> >
> > >From your explanation it looks like you want to use mirroring on top o=
f
> > the multipathed storage (but you are trying to use multipath) ?! correc=
t
> > me if I am wrong.
>
> Yes, exactly is. But the LSI RDAC driver is doing the one multipath
> channel (channel-A) for the the read-write LUN's (all r/w LUN's are in
> the same primary storage and have the same scsi_id) and another
> multipath channel (channel-B) for all read-only LUN's (all r/o LUN's
> are in the same *secundary* storage and have the same scsi_id).
>
> So, I've 2 devices that says to be the "same" by ERM, but one as
> primary=3Drw and another as secundary=3Dro, to reach primary i've
> channel-A and reach secundary i've channel-B.
>
> What I'm doing is: Grouping channel-A + channel-B into a single mpath
> device, and it is working as expected (i dont know if someone that
> really know about it would consider me a freak-crazy man, but it
> works).
>
> >
> > Following are based on my understanding as explained above :)
> >
> > BTW, dm-multipath will change the path group only when all the paths in
> > a path group fails. And, as soon as a path in the higher priority path
> > group comes back up (path checker returns success), dm-multipath will
> > start sending I/Os on that path.
> >
> > Looks like changing the "secondary=3Dread-only" to primary=3Dread-write=
 is
> > not getting reflected in your prio callout functionality.
> >
>
> Here you figure out my problem with annoying log messages :). So I'd
> understand i need to change prio when changing storage
> primary/secundary role. :)
>
>
> > Since your path checker (tur) returns success for the path with higher
> > priority, mutipathd daemon reinstates that path, and since the path
> > priority of that group is higher than the other one, it is made the
> > active one, and  i/os are sent on that path, which fails and that leads
> > to failing the path... but.... (goto the start of this paragraph :)
> >
> Ouch! ... I almost go into a infinity loop here ;).
>
>
> Well, you point my problem, now i'll think someway to calculate prio
> (inside that really restrict namespace) dynamically when changing the
> path.
>
> Really thanks, you make things a bit clear for me :).
>
> And if you (or anyone else) understand my scenario and knows it is not
> a good approach, please let me know before start production.
>
> Thanks all.
>
> --
>
> Fl=E1vio do Carmo J=FAnior aka waKKu
>
> >
> > On Fri, 2009-04-24 at 20:47 -0300, Flavio Junior wrote:
> >> Hi folks, good evening.
> >>
> >> My idea is set dm-multipath to only change from a path if it fails.
> >> How can I do that?
> >>
> >> Setup is something as:
> >>
> >> - 2x DS4700 IBM Storages
> >> - 4x Fiber Switches (2 for each storage)
> >> - 4x Path to each LUN (2 controllers x 2 switches) - But it shows to
> >> me as a single device, because I'm using IBM rdac driver too.
> >>
> >> Now, I've a primary storage as read-write AND a secundary mirrored
> >> (bit by bit synchronous) as read-only. Of course, the LUN id's at each
> >> storage are different so comes my first "hack" using getuid_callout to
> >> group paths, and prio_callout to set priority higher for primary
> >> storage and lower for secundary one.
> >>
> >> Everything is working like a charm, configured as:
> >>
> >> Link: http://pastebin.com/f4de2f7ca
> >>
> >> # multipath.conf
> >> defaults {
> >>         user_friendly_names     yes
> >>         path_grouping_policy    failover
> >>         path_checker            tur
> >>         hardware_handler        "rdac"
> >> #       getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
> >>         getuid_callout          "/etc/multipath/get_lun_path.sh %n"
> >> #       prio_callout            /bin/true
> >>         prio_callout            "/bin/bash
> >> /etc/multipath/get_lun_path.sh %n prio"
> >>         failback                8
> >> }
> >>
> >> devices {
> >>         device {
> >>                 vendor       "dummy"
> >>                 product      "dummy"
> >>                 prio_callout "/sbin/scsi_id"
> >>         }
> >> }
> >>
> >> [root@pinky ~]# cat /etc/multipath/get_lun_path.sh
> >> #!/bin/bash
> >>
> >> DEVICE=3D"$(/sbin/scsi_id -g -u -s /block/$1)"
> >> SCSI_ID_TABLE=3D"/etc/multipath/scsi_id_multipath"
> >>
> >> if [ $# -lt 1 ]; then
> >>         exit 1
> >> fi
> >>
> >> if [ "$2" =3D=3D "prio" ]; then
> >>         while read SCSI_ID WWID PRIO; do [ "$SCSI_ID" =3D=3D "${DEVICE=
}" ]
> >> && echo $PRIO; done < $SCSI_ID_TABLE
> >>         exit 0
> >> else
> >>         while read SCSI_ID WWID PRIO; do [ "$SCSI_ID" =3D=3D "${DEVICE=
}" ]
> >> && echo $WWID; done < $SCSI_ID_TABLE
> >>         exit 0
> >> fi
> >>
> >> [root@pinky ~]# cat /etc/multipath/scsi_id_multipath
> >> 3600a0b800048834e0000150149dcc594       HomeMaildir1            2
> >> 3600a0b80004884c4000016e649dcc5a5       HomeMaildir2            2
> >> 3600a0b80004884c4000016e449dcc534       WebPages                2
> >> 3600a0b800048834e000014ff49dcc51b       MailQuorumDisk          2
> >> 3600a0b800048834e0000172c49e76cbb       FileSystemDLM           2
> >> 3600a0b80004885b40000b78f49dcd7f8       MailQuorumDisk          1
> >> 3600a0b80004885b40000b79149dcd817       HomeMaildir1            1
> >> 3600a0b80004885a00000c13349dcd9e5       HomeMaildir2            1
> >> 3600a0b80004885b40000baa149ec46b5       FileSystemDLM           1
> >> 3600a0b80004885a00000c13149dcd9c3       WebPages                1
> >>
> >> [root@pinky ~]# multipath -ll
> >> fs_dlm0 (FileSystemDLM) dm-8 IBM,VirtualDisk
> >> [size=3D300M][features=3D0][hwhandler=3D0][rw]
> >> \_ round-robin 0 [prio=3D2][active]
> >>  \_ 3:0:0:4 sdf 8:80  [active][ready]
> >> \_ round-robin 0 [prio=3D1][enabled]
> >>  \_ 3:0:1:3 sdj 8:144 [active][ready]
> >> homemaildir1 (HomeMaildir2) dm-5 IBM,VirtualDisk
> >> [size=3D25G][features=3D0][hwhandler=3D0][rw]
> >> \_ round-robin 0 [prio=3D2][active]
> >>  \_ 3:0:0:1 sdc 8:32  [active][ready]
> >> \_ round-robin 0 [prio=3D1][enabled]
> >>  \_ 3:0:1:2 sdi 8:128 [active][ready]
> >> webpages0 (WebPages) dm-6 IBM,VirtualDisk
> >> [size=3D4.0G][features=3D0][hwhandler=3D0][rw]
> >> \_ round-robin 0 [prio=3D2][active]
> >>  \_ 3:0:0:2 sdd 8:48  [active][ready]
> >> \_ round-robin 0 [prio=3D1][enabled]
> >>  \_ 3:0:1:4 sdk 8:160 [active][ready]
> >> homemaildir0 (HomeMaildir1) dm-4 IBM,VirtualDisk
> >> [size=3D25G][features=3D0][hwhandler=3D0][rw]
> >> \_ round-robin 0 [prio=3D2][active]
> >>  \_ 3:0:0:0 sdb 8:16  [active][ready]
> >> \_ round-robin 0 [prio=3D1][enabled]
> >>  \_ 3:0:1:1 sdh 8:112 [active][ready]
> >> qdisk0 (MailQuorumDisk) dm-7 IBM,VirtualDisk
> >> [size=3D200M][features=3D0][hwhandler=3D0][rw]
> >> \_ round-robin 0 [prio=3D2][active]
> >>  \_ 3:0:0:3 sde 8:64  [active][ready]
> >> \_ round-robin 0 [prio=3D1][enabled]
> >>  \_ 3:0:1:0 sdg 8:96  [active][ready]
> >>
> >> #####
> >>
> >> The problem comes when my higher priority path goes down (it happens
> >> if I change secundary=3Dread-only storage role to primary=3Dread-write=
),
> >> so dm-multipath fail to secundary path but it keeps trying to change
> >> back for my "primary" path, and fill /var/log/messages with it (is at
> >> last of above post link):
> >>
> >> Apr 24 20:26:52 cerebro multipathd: homemaildir0: switch to path group
> #2
> >> Apr 24 20:26:53 cerebro kernel: 91
> >> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7
> >> Apr 24 20:26:53 cerebro kernel: 492
> >> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20095 pdev
> >> H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1
> >> Apr 24 20:26:53 cerebro kernel: sd 3:0:1:0: SCSI error: return code =
=3D
> 0x08000002
> >> Apr 24 20:26:53 cerebro kernel: sdg: Current: sense key: Data Protect
> >> Apr 24 20:26:53 cerebro kernel:     Add. Sense: Write protected
> >> Apr 24 20:26:53 cerebro kernel:
> >> Apr 24 20:26:53 cerebro kernel: end_request: I/O error, dev sdg, secto=
r
> 1289
> >> Apr 24 20:26:53 cerebro kernel: device-mapper: multipath: Failing path
> 8:96.
> >> Apr 24 20:26:53 cerebro multipathd: dm-5: add map (uevent)
> >> Apr 24 20:26:53 cerebro multipathd: dm-5: devmap already registered
> >> Apr 24 20:26:58 cerebro multipathd: 8:96: mark as failed
> >> Apr 24 20:26:58 cerebro multipathd: homemaildir0: remaining active
> paths: 1
> >> Apr 24 20:26:58 cerebro multipathd: sdg: tur checker reports path is u=
p
> >> Apr 24 20:26:58 cerebro multipathd: 8:96: reinstated
> >> Apr 24 20:26:58 cerebro multipathd: homemaildir0: remaining active
> paths: 2
> >> Apr 24 20:26:58 cerebro multipathd: dm-5: add map (uevent)
> >> Apr 24 20:26:58 cerebro multipathd: dm-5: devmap already registered
> >> Apr 24 20:27:06 cerebro multipathd: homemaildir0: switch to path group
> #2
> >> Apr 24 20:27:07 cerebro kernel: 91
> >> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7
> >> Apr 24 20:27:07 cerebro kernel: 492
> >> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20212 pdev
> >> H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1
> >> Apr 24 20:27:07 cerebro kernel: sd 3:0:1:0: SCSI error: return code =
=3D
> 0x08000002
> >> Apr 24 20:27:07 cerebro kernel: sdg: Current: sense key: Data Protect
> >> Apr 24 20:27:07 cerebro kernel:     Add. Sense: Write protected
> >> Apr 24 20:27:07 cerebro kernel:
> >> Apr 24 20:27:07 cerebro kernel: end_request: I/O error, dev sdg, secto=
r
> 1289
> >> Apr 24 20:27:07 cerebro kernel: device-mapper: multipath: Failing path
> 8:96.
> >> Apr 24 20:27:07 cerebro multipathd: dm-5: add map (uevent)
> >> Apr 24 20:27:07 cerebro multipathd: dm-5: devmap already registered
> >> Apr 24 20:27:07 cerebro multipathd: 8:96: mark as failed
> >> Apr 24 20:27:07 cerebro multipathd: homemaildir0: remaining active
> paths: 1
> >> Apr 24 20:27:12 cerebro multipathd: sdg: tur checker reports path is u=
p
> >> Apr 24 20:27:12 cerebro multipathd: 8:96: reinstated
> >> Apr 24 20:27:12 cerebro multipathd: homemaildir0: remaining active
> paths: 2
> >> Apr 24 20:27:12 cerebro multipathd: dm-5: add map (uevent)
> >> Apr 24 20:27:12 cerebro multipathd: dm-5: devmap already registered
> >> Apr 24 20:27:20 cerebro multipathd: homemaildir0: switch to path group
> #2
> >> Apr 24 20:27:21 cerebro kernel: 91
> >> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7
> >> Apr 24 20:27:21 cerebro kernel: 492
> >> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20305 pdev
> >> H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1
> >> Apr 24 20:27:21 cerebro kernel: sd 3:0:1:0: SCSI error: return code =
=3D
> 0x08000002
> >> Apr 24 20:27:21 cerebro kernel: sdg: Current: sense key: Data Protect
> >> Apr 24 20:27:21 cerebro kernel:     Add. Sense: Write protected
> >> Apr 24 20:27:21 cerebro kernel:
> >> Apr 24 20:27:21 cerebro kernel: end_request: I/O error, dev sdg, secto=
r
> 1289
> >> Apr 24 20:27:21 cerebro kernel: device-mapper: multipath: Failing path
> 8:96.
> >> Apr 24 20:27:21 cerebro multipathd: dm-5: add map (uevent)
> >> Apr 24 20:27:21 cerebro multipathd: dm-5: devmap already registered
> >> Apr 24 20:27:21 cerebro multipathd: 8:96: mark as failed
> >> Apr 24 20:27:21 cerebro multipathd: homemaildir0: remaining active
> paths: 1
> >> Apr 24 20:27:26 cerebro multipathd: sdg: tur checker reports path is u=
p
> >> Apr 24 20:27:26 cerebro multipathd: 8:96: reinstated
> >> Apr 24 20:27:26 cerebro multipathd: homemaildir0: remaining active
> paths: 2
> >> Apr 24 20:27:26 cerebro multipathd: dm-5: add map (uevent)
> >> Apr 24 20:27:26 cerebro multipathd: dm-5: devmap already registered
> >> Apr 24 20:27:34 cerebro multipathd: homemaildir0: switch to path group
> #2
> >> Apr 24 20:27:35 cerebro kernel: 91
> >> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7
> >> Apr 24 20:27:35 cerebro kernel: 492
> >> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20419 pdev
> >> H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1
> >> Apr 24 20:27:35 cerebro kernel: sd 3:0:1:0: SCSI error: return code =
=3D
> 0x08000002
> >> Apr 24 20:27:35 cerebro kernel: sdg: Current: sense key: Data Protect
> >> Apr 24 20:27:35 cerebro kernel:     Add. Sense: Write protected
> >> Apr 24 20:27:35 cerebro kernel:
> >> Apr 24 20:27:35 cerebro kernel: end_request: I/O error, dev sdg, secto=
r
> 1289
> >> Apr 24 20:27:35 cerebro kernel: device-mapper: multipath: Failing path
> 8:96.
> >> Apr 24 20:27:35 cerebro multipathd: dm-5: add map (uevent)
> >> Apr 24 20:27:35 cerebro multipathd: dm-5: devmap already registered
> >> Apr 24 20:27:35 cerebro multipathd: 8:96: mark as failed
> >> Apr 24 20:27:35 cerebro multipathd: homemaildir0: remaining active
> paths: 1
> >> Apr 24 20:27:40 cerebro multipathd: sdg: tur checker reports path is u=
p
> >> Apr 24 20:27:40 cerebro multipathd: 8:96: reinstated
> >> Apr 24 20:27:40 cerebro multipathd: homemaildir0: remaining active
> paths: 2
> >> Apr 24 20:27:40 cerebro multipathd: dm-5: add map (uevent)
> >> Apr 24 20:27:40 cerebro multipathd: dm-5: devmap already registered
> >> #############
> >>
> >>
> >> My idea is set dm-multipath to only change from a path if it fails.
> >> How can I do that?
> >>
> >> Any comments, doubts or suggest for this config would be appreciated
> >> as i'm new to all this hardware/setup.
> >>
> >> Thanks in advance.
> >>
> >> --
> >>
> >> Fl=E1vio do Carmo J=FAnior aka waKKu
> >>
> >> --
> >> dm-devel mailing list
> >> dm-devel@redhat.com
> >> https://www.redhat.com/mailman/listinfo/dm-devel
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
>

--001e680f0c889e0fb9046959f318
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi folks,<br><br>Based on the scenario i&#39;ve described below I wrote a s=
imple, totally based on pp_rdac.c, code to send a SCSI command WRITE_AND_VE=
RITY (0x2E) and decide if that path is read-write or read-only.<br><br>The =
code is here: <a href=3D"http://pastebin.com/m22b06f04">http://pastebin.com=
/m22b06f04</a><br>
<br>I&#39;m sending it to the list to request for improve, tips, recommenda=
tions, anything... I&#39;m not a developer anyway.<br><br>--<br><br>Fl=E1vi=
o do Carmo J=FAnior aka waKKu <br><br><div class=3D"gmail_quote">On Fri, Ap=
r 24, 2009 at 11:21 PM, Flavio Junior <span dir=3D"ltr">&lt;<a href=3D"mail=
to:billpp@gmail.com">billpp@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">On Fri, Apr 24, 2=
009 at 10:24 PM, Chandra Seetharaman<br>
&lt;<a href=3D"mailto:sekharan@us.ibm.com">sekharan@us.ibm.com</a>&gt; wrot=
e:<br>
&gt; Hi Flavio,<br>
<br>
Hi Chandra ;)<br>
<div class=3D"im"><br>
&gt;<br>
&gt; Since you are using LSI&#39;s (I think it is not IBM&#39;s :) rdac dri=
ver, which<br>
&gt; do provide multipathing functionality (as you see only one device per<=
br>
&gt; lun) why do you want to use dm-multipath ?<br>
<br>
</div>I&#39;m using dm-multipath to group LUN&#39;s at different storages. =
But, IBM<br>
DS4700 ERM just allows (really makes sense) read-write operations on<br>
the primary storage device, so this is why I need to different prio<br>
for paths.<br>
<div class=3D"im"><br>
&gt;<br>
&gt; &gt;From your explanation it looks like you want to use mirroring on t=
op of<br>
&gt; the multipathed storage (but you are trying to use multipath) ?! corre=
ct<br>
&gt; me if I am wrong.<br>
<br>
</div>Yes, exactly is. But the LSI RDAC driver is doing the one multipath<b=
r>
channel (channel-A) for the the read-write LUN&#39;s (all r/w LUN&#39;s are=
 in<br>
the same primary storage and have the same scsi_id) and another<br>
multipath channel (channel-B) for all read-only LUN&#39;s (all r/o LUN&#39;=
s<br>
are in the same *secundary* storage and have the same scsi_id).<br>
<br>
So, I&#39;ve 2 devices that says to be the &quot;same&quot; by ERM, but one=
 as<br>
primary=3Drw and another as secundary=3Dro, to reach primary i&#39;ve<br>
channel-A and reach secundary i&#39;ve channel-B.<br>
<br>
What I&#39;m doing is: Grouping channel-A + channel-B into a single mpath<b=
r>
device, and it is working as expected (i dont know if someone that<br>
really know about it would consider me a freak-crazy man, but it<br>
works).<br>
<div class=3D"im"><br>
&gt;<br>
&gt; Following are based on my understanding as explained above :)<br>
&gt;<br>
&gt; BTW, dm-multipath will change the path group only when all the paths i=
n<br>
&gt; a path group fails. And, as soon as a path in the higher priority path=
<br>
&gt; group comes back up (path checker returns success), dm-multipath will<=
br>
&gt; start sending I/Os on that path.<br>
&gt;<br>
&gt; Looks like changing the &quot;secondary=3Dread-only&quot; to primary=
=3Dread-write is<br>
&gt; not getting reflected in your prio callout functionality.<br>
&gt;<br>
<br>
</div>Here you figure out my problem with annoying log messages :). So I&#3=
9;d<br>
understand i need to change prio when changing storage<br>
primary/secundary role. :)<br>
<div class=3D"im"><br>
<br>
&gt; Since your path checker (tur) returns success for the path with higher=
<br>
&gt; priority, mutipathd daemon reinstates that path, and since the path<br=
>
&gt; priority of that group is higher than the other one, it is made the<br=
>
&gt; active one, and =A0i/os are sent on that path, which fails and that le=
ads<br>
&gt; to failing the path... but.... (goto the start of this paragraph :)<br=
>
&gt;<br>
</div>Ouch! ... I almost go into a infinity loop here ;).<br>
<br>
<br>
Well, you point my problem, now i&#39;ll think someway to calculate prio<br=
>
(inside that really restrict namespace) dynamically when changing the<br>
path.<br>
<br>
Really thanks, you make things a bit clear for me :).<br>
<br>
And if you (or anyone else) understand my scenario and knows it is not<br>
a good approach, please let me know before start production.<br>
<br>
Thanks all.<br>
<div><div></div><div class=3D"h5"><br>
--<br>
<br>
Fl=E1vio do Carmo J=FAnior aka waKKu<br>
<br>
&gt;<br>
&gt; On Fri, 2009-04-24 at 20:47 -0300, Flavio Junior wrote:<br>
&gt;&gt; Hi folks, good evening.<br>
&gt;&gt;<br>
&gt;&gt; My idea is set dm-multipath to only change from a path if it fails=
.<br>
&gt;&gt; How can I do that?<br>
&gt;&gt;<br>
&gt;&gt; Setup is something as:<br>
&gt;&gt;<br>
&gt;&gt; - 2x DS4700 IBM Storages<br>
&gt;&gt; - 4x Fiber Switches (2 for each storage)<br>
&gt;&gt; - 4x Path to each LUN (2 controllers x 2 switches) - But it shows =
to<br>
&gt;&gt; me as a single device, because I&#39;m using IBM rdac driver too.<=
br>
&gt;&gt;<br>
&gt;&gt; Now, I&#39;ve a primary storage as read-write AND a secundary mirr=
ored<br>
&gt;&gt; (bit by bit synchronous) as read-only. Of course, the LUN id&#39;s=
 at each<br>
&gt;&gt; storage are different so comes my first &quot;hack&quot; using get=
uid_callout to<br>
&gt;&gt; group paths, and prio_callout to set priority higher for primary<b=
r>
&gt;&gt; storage and lower for secundary one.<br>
&gt;&gt;<br>
&gt;&gt; Everything is working like a charm, configured as:<br>
&gt;&gt;<br>
&gt;&gt; Link: <a href=3D"http://pastebin.com/f4de2f7ca" target=3D"_blank">=
http://pastebin.com/f4de2f7ca</a><br>
&gt;&gt;<br>
&gt;&gt; # multipath.conf<br>
&gt;&gt; defaults {<br>
&gt;&gt; =A0 =A0 =A0 =A0 user_friendly_names =A0 =A0 yes<br>
&gt;&gt; =A0 =A0 =A0 =A0 path_grouping_policy =A0 =A0failover<br>
&gt;&gt; =A0 =A0 =A0 =A0 path_checker =A0 =A0 =A0 =A0 =A0 =A0tur<br>
&gt;&gt; =A0 =A0 =A0 =A0 hardware_handler =A0 =A0 =A0 =A0&quot;rdac&quot;<b=
r>
&gt;&gt; # =A0 =A0 =A0 getuid_callout =A0 =A0 =A0 =A0 =A0&quot;/sbin/scsi_i=
d -g -u -s /block/%n&quot;<br>
&gt;&gt; =A0 =A0 =A0 =A0 getuid_callout =A0 =A0 =A0 =A0 =A0&quot;/etc/multi=
path/get_lun_path.sh %n&quot;<br>
&gt;&gt; # =A0 =A0 =A0 prio_callout =A0 =A0 =A0 =A0 =A0 =A0/bin/true<br>
&gt;&gt; =A0 =A0 =A0 =A0 prio_callout =A0 =A0 =A0 =A0 =A0 =A0&quot;/bin/bas=
h<br>
&gt;&gt; /etc/multipath/get_lun_path.sh %n prio&quot;<br>
&gt;&gt; =A0 =A0 =A0 =A0 failback =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A08<br>
&gt;&gt; }<br>
&gt;&gt;<br>
&gt;&gt; devices {<br>
&gt;&gt; =A0 =A0 =A0 =A0 device {<br>
&gt;&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vendor =A0 =A0 =A0 &quot;dummy&quo=
t;<br>
&gt;&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 product =A0 =A0 =A0&quot;dummy&quo=
t;<br>
&gt;&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prio_callout &quot;/sbin/scsi_id&q=
uot;<br>
&gt;&gt; =A0 =A0 =A0 =A0 }<br>
&gt;&gt; }<br>
&gt;&gt;<br>
&gt;&gt; [root@pinky ~]# cat /etc/multipath/get_lun_path.sh<br>
&gt;&gt; #!/bin/bash<br>
&gt;&gt;<br>
&gt;&gt; DEVICE=3D&quot;$(/sbin/scsi_id -g -u -s /block/$1)&quot;<br>
&gt;&gt; SCSI_ID_TABLE=3D&quot;/etc/multipath/scsi_id_multipath&quot;<br>
&gt;&gt;<br>
&gt;&gt; if [ $# -lt 1 ]; then<br>
&gt;&gt; =A0 =A0 =A0 =A0 exit 1<br>
&gt;&gt; fi<br>
&gt;&gt;<br>
&gt;&gt; if [ &quot;$2&quot; =3D=3D &quot;prio&quot; ]; then<br>
&gt;&gt; =A0 =A0 =A0 =A0 while read SCSI_ID WWID PRIO; do [ &quot;$SCSI_ID&=
quot; =3D=3D &quot;${DEVICE}&quot; ]<br>
&gt;&gt; &amp;&amp; echo $PRIO; done &lt; $SCSI_ID_TABLE<br>
&gt;&gt; =A0 =A0 =A0 =A0 exit 0<br>
&gt;&gt; else<br>
&gt;&gt; =A0 =A0 =A0 =A0 while read SCSI_ID WWID PRIO; do [ &quot;$SCSI_ID&=
quot; =3D=3D &quot;${DEVICE}&quot; ]<br>
&gt;&gt; &amp;&amp; echo $WWID; done &lt; $SCSI_ID_TABLE<br>
&gt;&gt; =A0 =A0 =A0 =A0 exit 0<br>
&gt;&gt; fi<br>
&gt;&gt;<br>
&gt;&gt; [root@pinky ~]# cat /etc/multipath/scsi_id_multipath<br>
&gt;&gt; 3600a0b800048834e0000150149dcc594 =A0 =A0 =A0 HomeMaildir1 =A0 =A0=
 =A0 =A0 =A0 =A02<br>
&gt;&gt; 3600a0b80004884c4000016e649dcc5a5 =A0 =A0 =A0 HomeMaildir2 =A0 =A0=
 =A0 =A0 =A0 =A02<br>
&gt;&gt; 3600a0b80004884c4000016e449dcc534 =A0 =A0 =A0 WebPages =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A02<br>
&gt;&gt; 3600a0b800048834e000014ff49dcc51b =A0 =A0 =A0 MailQuorumDisk =A0 =
=A0 =A0 =A0 =A02<br>
&gt;&gt; 3600a0b800048834e0000172c49e76cbb =A0 =A0 =A0 FileSystemDLM =A0 =
=A0 =A0 =A0 =A0 2<br>
&gt;&gt; 3600a0b80004885b40000b78f49dcd7f8 =A0 =A0 =A0 MailQuorumDisk =A0 =
=A0 =A0 =A0 =A01<br>
&gt;&gt; 3600a0b80004885b40000b79149dcd817 =A0 =A0 =A0 HomeMaildir1 =A0 =A0=
 =A0 =A0 =A0 =A01<br>
&gt;&gt; 3600a0b80004885a00000c13349dcd9e5 =A0 =A0 =A0 HomeMaildir2 =A0 =A0=
 =A0 =A0 =A0 =A01<br>
&gt;&gt; 3600a0b80004885b40000baa149ec46b5 =A0 =A0 =A0 FileSystemDLM =A0 =
=A0 =A0 =A0 =A0 1<br>
&gt;&gt; 3600a0b80004885a00000c13149dcd9c3 =A0 =A0 =A0 WebPages =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A01<br>
&gt;&gt;<br>
&gt;&gt; [root@pinky ~]# multipath -ll<br>
&gt;&gt; fs_dlm0 (FileSystemDLM) dm-8 IBM,VirtualDisk<br>
&gt;&gt; [size=3D300M][features=3D0][hwhandler=3D0][rw]<br>
&gt;&gt; \_ round-robin 0 [prio=3D2][active]<br>
&gt;&gt; =A0\_ 3:0:0:4 sdf 8:80 =A0[active][ready]<br>
&gt;&gt; \_ round-robin 0 [prio=3D1][enabled]<br>
&gt;&gt; =A0\_ 3:0:1:3 sdj 8:144 [active][ready]<br>
&gt;&gt; homemaildir1 (HomeMaildir2) dm-5 IBM,VirtualDisk<br>
&gt;&gt; [size=3D25G][features=3D0][hwhandler=3D0][rw]<br>
&gt;&gt; \_ round-robin 0 [prio=3D2][active]<br>
&gt;&gt; =A0\_ 3:0:0:1 sdc 8:32 =A0[active][ready]<br>
&gt;&gt; \_ round-robin 0 [prio=3D1][enabled]<br>
&gt;&gt; =A0\_ 3:0:1:2 sdi 8:128 [active][ready]<br>
&gt;&gt; webpages0 (WebPages) dm-6 IBM,VirtualDisk<br>
&gt;&gt; [size=3D4.0G][features=3D0][hwhandler=3D0][rw]<br>
&gt;&gt; \_ round-robin 0 [prio=3D2][active]<br>
&gt;&gt; =A0\_ 3:0:0:2 sdd 8:48 =A0[active][ready]<br>
&gt;&gt; \_ round-robin 0 [prio=3D1][enabled]<br>
&gt;&gt; =A0\_ 3:0:1:4 sdk 8:160 [active][ready]<br>
&gt;&gt; homemaildir0 (HomeMaildir1) dm-4 IBM,VirtualDisk<br>
&gt;&gt; [size=3D25G][features=3D0][hwhandler=3D0][rw]<br>
&gt;&gt; \_ round-robin 0 [prio=3D2][active]<br>
&gt;&gt; =A0\_ 3:0:0:0 sdb 8:16 =A0[active][ready]<br>
&gt;&gt; \_ round-robin 0 [prio=3D1][enabled]<br>
&gt;&gt; =A0\_ 3:0:1:1 sdh 8:112 [active][ready]<br>
&gt;&gt; qdisk0 (MailQuorumDisk) dm-7 IBM,VirtualDisk<br>
&gt;&gt; [size=3D200M][features=3D0][hwhandler=3D0][rw]<br>
&gt;&gt; \_ round-robin 0 [prio=3D2][active]<br>
&gt;&gt; =A0\_ 3:0:0:3 sde 8:64 =A0[active][ready]<br>
&gt;&gt; \_ round-robin 0 [prio=3D1][enabled]<br>
&gt;&gt; =A0\_ 3:0:1:0 sdg 8:96 =A0[active][ready]<br>
&gt;&gt;<br>
&gt;&gt; #####<br>
&gt;&gt;<br>
&gt;&gt; The problem comes when my higher priority path goes down (it happe=
ns<br>
&gt;&gt; if I change secundary=3Dread-only storage role to primary=3Dread-w=
rite),<br>
&gt;&gt; so dm-multipath fail to secundary path but it keeps trying to chan=
ge<br>
&gt;&gt; back for my &quot;primary&quot; path, and fill /var/log/messages w=
ith it (is at<br>
&gt;&gt; last of above post link):<br>
&gt;&gt;<br>
&gt;&gt; Apr 24 20:26:52 cerebro multipathd: homemaildir0: switch to path g=
roup #2<br>
&gt;&gt; Apr 24 20:26:53 cerebro kernel: 91<br>
&gt;&gt; [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7<br>
&gt;&gt; Apr 24 20:26:53 cerebro kernel: 492<br>
&gt;&gt; [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20095 p=
dev<br>
&gt;&gt; H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1<br>
&gt;&gt; Apr 24 20:26:53 cerebro kernel: sd 3:0:1:0: SCSI error: return cod=
e =3D 0x08000002<br>
&gt;&gt; Apr 24 20:26:53 cerebro kernel: sdg: Current: sense key: Data Prot=
ect<br>
&gt;&gt; Apr 24 20:26:53 cerebro kernel: =A0 =A0 Add. Sense: Write protecte=
d<br>
&gt;&gt; Apr 24 20:26:53 cerebro kernel:<br>
&gt;&gt; Apr 24 20:26:53 cerebro kernel: end_request: I/O error, dev sdg, s=
ector 1289<br>
&gt;&gt; Apr 24 20:26:53 cerebro kernel: device-mapper: multipath: Failing =
path 8:96.<br>
&gt;&gt; Apr 24 20:26:53 cerebro multipathd: dm-5: add map (uevent)<br>
&gt;&gt; Apr 24 20:26:53 cerebro multipathd: dm-5: devmap already registere=
d<br>
&gt;&gt; Apr 24 20:26:58 cerebro multipathd: 8:96: mark as failed<br>
&gt;&gt; Apr 24 20:26:58 cerebro multipathd: homemaildir0: remaining active=
 paths: 1<br>
&gt;&gt; Apr 24 20:26:58 cerebro multipathd: sdg: tur checker reports path =
is up<br>
&gt;&gt; Apr 24 20:26:58 cerebro multipathd: 8:96: reinstated<br>
&gt;&gt; Apr 24 20:26:58 cerebro multipathd: homemaildir0: remaining active=
 paths: 2<br>
&gt;&gt; Apr 24 20:26:58 cerebro multipathd: dm-5: add map (uevent)<br>
&gt;&gt; Apr 24 20:26:58 cerebro multipathd: dm-5: devmap already registere=
d<br>
&gt;&gt; Apr 24 20:27:06 cerebro multipathd: homemaildir0: switch to path g=
roup #2<br>
&gt;&gt; Apr 24 20:27:07 cerebro kernel: 91<br>
&gt;&gt; [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7<br>
&gt;&gt; Apr 24 20:27:07 cerebro kernel: 492<br>
&gt;&gt; [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20212 p=
dev<br>
&gt;&gt; H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1<br>
&gt;&gt; Apr 24 20:27:07 cerebro kernel: sd 3:0:1:0: SCSI error: return cod=
e =3D 0x08000002<br>
&gt;&gt; Apr 24 20:27:07 cerebro kernel: sdg: Current: sense key: Data Prot=
ect<br>
&gt;&gt; Apr 24 20:27:07 cerebro kernel: =A0 =A0 Add. Sense: Write protecte=
d<br>
&gt;&gt; Apr 24 20:27:07 cerebro kernel:<br>
&gt;&gt; Apr 24 20:27:07 cerebro kernel: end_request: I/O error, dev sdg, s=
ector 1289<br>
&gt;&gt; Apr 24 20:27:07 cerebro kernel: device-mapper: multipath: Failing =
path 8:96.<br>
&gt;&gt; Apr 24 20:27:07 cerebro multipathd: dm-5: add map (uevent)<br>
&gt;&gt; Apr 24 20:27:07 cerebro multipathd: dm-5: devmap already registere=
d<br>
&gt;&gt; Apr 24 20:27:07 cerebro multipathd: 8:96: mark as failed<br>
&gt;&gt; Apr 24 20:27:07 cerebro multipathd: homemaildir0: remaining active=
 paths: 1<br>
&gt;&gt; Apr 24 20:27:12 cerebro multipathd: sdg: tur checker reports path =
is up<br>
&gt;&gt; Apr 24 20:27:12 cerebro multipathd: 8:96: reinstated<br>
&gt;&gt; Apr 24 20:27:12 cerebro multipathd: homemaildir0: remaining active=
 paths: 2<br>
&gt;&gt; Apr 24 20:27:12 cerebro multipathd: dm-5: add map (uevent)<br>
&gt;&gt; Apr 24 20:27:12 cerebro multipathd: dm-5: devmap already registere=
d<br>
&gt;&gt; Apr 24 20:27:20 cerebro multipathd: homemaildir0: switch to path g=
roup #2<br>
&gt;&gt; Apr 24 20:27:21 cerebro kernel: 91<br>
&gt;&gt; [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7<br>
&gt;&gt; Apr 24 20:27:21 cerebro kernel: 492<br>
&gt;&gt; [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20305 p=
dev<br>
&gt;&gt; H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1<br>
&gt;&gt; Apr 24 20:27:21 cerebro kernel: sd 3:0:1:0: SCSI error: return cod=
e =3D 0x08000002<br>
&gt;&gt; Apr 24 20:27:21 cerebro kernel: sdg: Current: sense key: Data Prot=
ect<br>
&gt;&gt; Apr 24 20:27:21 cerebro kernel: =A0 =A0 Add. Sense: Write protecte=
d<br>
&gt;&gt; Apr 24 20:27:21 cerebro kernel:<br>
&gt;&gt; Apr 24 20:27:21 cerebro kernel: end_request: I/O error, dev sdg, s=
ector 1289<br>
&gt;&gt; Apr 24 20:27:21 cerebro kernel: device-mapper: multipath: Failing =
path 8:96.<br>
&gt;&gt; Apr 24 20:27:21 cerebro multipathd: dm-5: add map (uevent)<br>
&gt;&gt; Apr 24 20:27:21 cerebro multipathd: dm-5: devmap already registere=
d<br>
&gt;&gt; Apr 24 20:27:21 cerebro multipathd: 8:96: mark as failed<br>
&gt;&gt; Apr 24 20:27:21 cerebro multipathd: homemaildir0: remaining active=
 paths: 1<br>
&gt;&gt; Apr 24 20:27:26 cerebro multipathd: sdg: tur checker reports path =
is up<br>
&gt;&gt; Apr 24 20:27:26 cerebro multipathd: 8:96: reinstated<br>
&gt;&gt; Apr 24 20:27:26 cerebro multipathd: homemaildir0: remaining active=
 paths: 2<br>
&gt;&gt; Apr 24 20:27:26 cerebro multipathd: dm-5: add map (uevent)<br>
&gt;&gt; Apr 24 20:27:26 cerebro multipathd: dm-5: devmap already registere=
d<br>
&gt;&gt; Apr 24 20:27:34 cerebro multipathd: homemaildir0: switch to path g=
roup #2<br>
&gt;&gt; Apr 24 20:27:35 cerebro kernel: 91<br>
&gt;&gt; [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7<br>
&gt;&gt; Apr 24 20:27:35 cerebro kernel: 492<br>
&gt;&gt; [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20419 p=
dev<br>
&gt;&gt; H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1<br>
&gt;&gt; Apr 24 20:27:35 cerebro kernel: sd 3:0:1:0: SCSI error: return cod=
e =3D 0x08000002<br>
&gt;&gt; Apr 24 20:27:35 cerebro kernel: sdg: Current: sense key: Data Prot=
ect<br>
&gt;&gt; Apr 24 20:27:35 cerebro kernel: =A0 =A0 Add. Sense: Write protecte=
d<br>
&gt;&gt; Apr 24 20:27:35 cerebro kernel:<br>
&gt;&gt; Apr 24 20:27:35 cerebro kernel: end_request: I/O error, dev sdg, s=
ector 1289<br>
&gt;&gt; Apr 24 20:27:35 cerebro kernel: device-mapper: multipath: Failing =
path 8:96.<br>
&gt;&gt; Apr 24 20:27:35 cerebro multipathd: dm-5: add map (uevent)<br>
&gt;&gt; Apr 24 20:27:35 cerebro multipathd: dm-5: devmap already registere=
d<br>
&gt;&gt; Apr 24 20:27:35 cerebro multipathd: 8:96: mark as failed<br>
&gt;&gt; Apr 24 20:27:35 cerebro multipathd: homemaildir0: remaining active=
 paths: 1<br>
&gt;&gt; Apr 24 20:27:40 cerebro multipathd: sdg: tur checker reports path =
is up<br>
&gt;&gt; Apr 24 20:27:40 cerebro multipathd: 8:96: reinstated<br>
&gt;&gt; Apr 24 20:27:40 cerebro multipathd: homemaildir0: remaining active=
 paths: 2<br>
&gt;&gt; Apr 24 20:27:40 cerebro multipathd: dm-5: add map (uevent)<br>
&gt;&gt; Apr 24 20:27:40 cerebro multipathd: dm-5: devmap already registere=
d<br>
&gt;&gt; #############<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; My idea is set dm-multipath to only change from a path if it fails=
.<br>
&gt;&gt; How can I do that?<br>
&gt;&gt;<br>
&gt;&gt; Any comments, doubts or suggest for this config would be appreciat=
ed<br>
&gt;&gt; as i&#39;m new to all this hardware/setup.<br>
&gt;&gt;<br>
&gt;&gt; Thanks in advance.<br>
&gt;&gt;<br>
&gt;&gt; --<br>
&gt;&gt;<br>
&gt;&gt; Fl=E1vio do Carmo J=FAnior aka waKKu<br>
&gt;&gt;<br>
&gt;&gt; --<br>
&gt;&gt; dm-devel mailing list<br>
&gt;&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt;&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" targe=
t=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
&gt;<br>
&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D=
"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
&gt;<br>
</div></div></blockquote></div><br>

--001e680f0c889e0fb9046959f318--


--===============0551503811==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0551503811==--
