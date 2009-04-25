From: Flavio Junior <billpp@gmail.com>
Subject: Re: How to config dm-multipath to change a path only if it
	fails
Date: Fri, 24 Apr 2009 23:21:53 -0300
Message-ID: <58aa8d780904241921u39cc444vad9c8cbf66cd0613@mail.gmail.com>
References: <58aa8d780904241647g6fed16c3l5d59c8d9336718b5@mail.gmail.com>
	<1240622688.4844.55.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1240622688.4844.55.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Apr 24, 2009 at 10:24 PM, Chandra Seetharaman
<sekharan@us.ibm.com> wrote:
> Hi Flavio,

Hi Chandra ;)

>
> Since you are using LSI's (I think it is not IBM's :) rdac driver, whic=
h
> do provide multipathing functionality (as you see only one device per
> lun) why do you want to use dm-multipath ?

I'm using dm-multipath to group LUN's at different storages. But, IBM
DS4700 ERM just allows (really makes sense) read-write operations on
the primary storage device, so this is why I need to different prio
for paths.

>
> >From your explanation it looks like you want to use mirroring on top o=
f
> the multipathed storage (but you are trying to use multipath) ?! correc=
t
> me if I am wrong.

Yes, exactly is. But the LSI RDAC driver is doing the one multipath
channel (channel-A) for the the read-write LUN's (all r/w LUN's are in
the same primary storage and have the same scsi_id) and another
multipath channel (channel-B) for all read-only LUN's (all r/o LUN's
are in the same *secundary* storage and have the same scsi_id).

So, I've 2 devices that says to be the "same" by ERM, but one as
primary=3Drw and another as secundary=3Dro, to reach primary i've
channel-A and reach secundary i've channel-B.

What I'm doing is: Grouping channel-A + channel-B into a single mpath
device, and it is working as expected (i dont know if someone that
really know about it would consider me a freak-crazy man, but it
works).

>
> Following are based on my understanding as explained above :)
>
> BTW, dm-multipath will change the path group only when all the paths in
> a path group fails. And, as soon as a path in the higher priority path
> group comes back up (path checker returns success), dm-multipath will
> start sending I/Os on that path.
>
> Looks like changing the "secondary=3Dread-only" to primary=3Dread-write=
 is
> not getting reflected in your prio callout functionality.
>

Here you figure out my problem with annoying log messages :). So I'd
understand i need to change prio when changing storage
primary/secundary role. :)


> Since your path checker (tur) returns success for the path with higher
> priority, mutipathd daemon reinstates that path, and since the path
> priority of that group is higher than the other one, it is made the
> active one, and =A0i/os are sent on that path, which fails and that lea=
ds
> to failing the path... but.... (goto the start of this paragraph :)
>
Ouch! ... I almost go into a infinity loop here ;).


Well, you point my problem, now i'll think someway to calculate prio
(inside that really restrict namespace) dynamically when changing the
path.

Really thanks, you make things a bit clear for me :).

And if you (or anyone else) understand my scenario and knows it is not
a good approach, please let me know before start production.

Thanks all.

--

Fl=E1vio do Carmo J=FAnior aka waKKu

>
> On Fri, 2009-04-24 at 20:47 -0300, Flavio Junior wrote:
>> Hi folks, good evening.
>>
>> My idea is set dm-multipath to only change from a path if it fails.
>> How can I do that?
>>
>> Setup is something as:
>>
>> - 2x DS4700 IBM Storages
>> - 4x Fiber Switches (2 for each storage)
>> - 4x Path to each LUN (2 controllers x 2 switches) - But it shows to
>> me as a single device, because I'm using IBM rdac driver too.
>>
>> Now, I've a primary storage as read-write AND a secundary mirrored
>> (bit by bit synchronous) as read-only. Of course, the LUN id's at each
>> storage are different so comes my first "hack" using getuid_callout to
>> group paths, and prio_callout to set priority higher for primary
>> storage and lower for secundary one.
>>
>> Everything is working like a charm, configured as:
>>
>> Link: http://pastebin.com/f4de2f7ca
>>
>> # multipath.conf
>> defaults {
>> =A0 =A0 =A0 =A0 user_friendly_names =A0 =A0 yes
>> =A0 =A0 =A0 =A0 path_grouping_policy =A0 =A0failover
>> =A0 =A0 =A0 =A0 path_checker =A0 =A0 =A0 =A0 =A0 =A0tur
>> =A0 =A0 =A0 =A0 hardware_handler =A0 =A0 =A0 =A0"rdac"
>> # =A0 =A0 =A0 getuid_callout =A0 =A0 =A0 =A0 =A0"/sbin/scsi_id -g -u -=
s /block/%n"
>> =A0 =A0 =A0 =A0 getuid_callout =A0 =A0 =A0 =A0 =A0"/etc/multipath/get_=
lun_path.sh %n"
>> # =A0 =A0 =A0 prio_callout =A0 =A0 =A0 =A0 =A0 =A0/bin/true
>> =A0 =A0 =A0 =A0 prio_callout =A0 =A0 =A0 =A0 =A0 =A0"/bin/bash
>> /etc/multipath/get_lun_path.sh %n prio"
>> =A0 =A0 =A0 =A0 failback =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A08
>> }
>>
>> devices {
>> =A0 =A0 =A0 =A0 device {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vendor =A0 =A0 =A0 "dummy"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 product =A0 =A0 =A0"dummy"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prio_callout "/sbin/scsi_id"
>> =A0 =A0 =A0 =A0 }
>> }
>>
>> [root@pinky ~]# cat /etc/multipath/get_lun_path.sh
>> #!/bin/bash
>>
>> DEVICE=3D"$(/sbin/scsi_id -g -u -s /block/$1)"
>> SCSI_ID_TABLE=3D"/etc/multipath/scsi_id_multipath"
>>
>> if [ $# -lt 1 ]; then
>> =A0 =A0 =A0 =A0 exit 1
>> fi
>>
>> if [ "$2" =3D=3D "prio" ]; then
>> =A0 =A0 =A0 =A0 while read SCSI_ID WWID PRIO; do [ "$SCSI_ID" =3D=3D "=
${DEVICE}" ]
>> && echo $PRIO; done < $SCSI_ID_TABLE
>> =A0 =A0 =A0 =A0 exit 0
>> else
>> =A0 =A0 =A0 =A0 while read SCSI_ID WWID PRIO; do [ "$SCSI_ID" =3D=3D "=
${DEVICE}" ]
>> && echo $WWID; done < $SCSI_ID_TABLE
>> =A0 =A0 =A0 =A0 exit 0
>> fi
>>
>> [root@pinky ~]# cat /etc/multipath/scsi_id_multipath
>> 3600a0b800048834e0000150149dcc594 =A0 =A0 =A0 HomeMaildir1 =A0 =A0 =A0=
 =A0 =A0 =A02
>> 3600a0b80004884c4000016e649dcc5a5 =A0 =A0 =A0 HomeMaildir2 =A0 =A0 =A0=
 =A0 =A0 =A02
>> 3600a0b80004884c4000016e449dcc534 =A0 =A0 =A0 WebPages =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A02
>> 3600a0b800048834e000014ff49dcc51b =A0 =A0 =A0 MailQuorumDisk =A0 =A0 =A0=
 =A0 =A02
>> 3600a0b800048834e0000172c49e76cbb =A0 =A0 =A0 FileSystemDLM =A0 =A0 =A0=
 =A0 =A0 2
>> 3600a0b80004885b40000b78f49dcd7f8 =A0 =A0 =A0 MailQuorumDisk =A0 =A0 =A0=
 =A0 =A01
>> 3600a0b80004885b40000b79149dcd817 =A0 =A0 =A0 HomeMaildir1 =A0 =A0 =A0=
 =A0 =A0 =A01
>> 3600a0b80004885a00000c13349dcd9e5 =A0 =A0 =A0 HomeMaildir2 =A0 =A0 =A0=
 =A0 =A0 =A01
>> 3600a0b80004885b40000baa149ec46b5 =A0 =A0 =A0 FileSystemDLM =A0 =A0 =A0=
 =A0 =A0 1
>> 3600a0b80004885a00000c13149dcd9c3 =A0 =A0 =A0 WebPages =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A01
>>
>> [root@pinky ~]# multipath -ll
>> fs_dlm0 (FileSystemDLM) dm-8 IBM,VirtualDisk
>> [size=3D300M][features=3D0][hwhandler=3D0][rw]
>> \_ round-robin 0 [prio=3D2][active]
>> =A0\_ 3:0:0:4 sdf 8:80 =A0[active][ready]
>> \_ round-robin 0 [prio=3D1][enabled]
>> =A0\_ 3:0:1:3 sdj 8:144 [active][ready]
>> homemaildir1 (HomeMaildir2) dm-5 IBM,VirtualDisk
>> [size=3D25G][features=3D0][hwhandler=3D0][rw]
>> \_ round-robin 0 [prio=3D2][active]
>> =A0\_ 3:0:0:1 sdc 8:32 =A0[active][ready]
>> \_ round-robin 0 [prio=3D1][enabled]
>> =A0\_ 3:0:1:2 sdi 8:128 [active][ready]
>> webpages0 (WebPages) dm-6 IBM,VirtualDisk
>> [size=3D4.0G][features=3D0][hwhandler=3D0][rw]
>> \_ round-robin 0 [prio=3D2][active]
>> =A0\_ 3:0:0:2 sdd 8:48 =A0[active][ready]
>> \_ round-robin 0 [prio=3D1][enabled]
>> =A0\_ 3:0:1:4 sdk 8:160 [active][ready]
>> homemaildir0 (HomeMaildir1) dm-4 IBM,VirtualDisk
>> [size=3D25G][features=3D0][hwhandler=3D0][rw]
>> \_ round-robin 0 [prio=3D2][active]
>> =A0\_ 3:0:0:0 sdb 8:16 =A0[active][ready]
>> \_ round-robin 0 [prio=3D1][enabled]
>> =A0\_ 3:0:1:1 sdh 8:112 [active][ready]
>> qdisk0 (MailQuorumDisk) dm-7 IBM,VirtualDisk
>> [size=3D200M][features=3D0][hwhandler=3D0][rw]
>> \_ round-robin 0 [prio=3D2][active]
>> =A0\_ 3:0:0:3 sde 8:64 =A0[active][ready]
>> \_ round-robin 0 [prio=3D1][enabled]
>> =A0\_ 3:0:1:0 sdg 8:96 =A0[active][ready]
>>
>> #####
>>
>> The problem comes when my higher priority path goes down (it happens
>> if I change secundary=3Dread-only storage role to primary=3Dread-write=
),
>> so dm-multipath fail to secundary path but it keeps trying to change
>> back for my "primary" path, and fill /var/log/messages with it (is at
>> last of above post link):
>>
>> Apr 24 20:26:52 cerebro multipathd: homemaildir0: switch to path group=
 #2
>> Apr 24 20:26:53 cerebro kernel: 91
>> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7
>> Apr 24 20:26:53 cerebro kernel: 492
>> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20095 pdev
>> H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1
>> Apr 24 20:26:53 cerebro kernel: sd 3:0:1:0: SCSI error: return code =3D=
 0x08000002
>> Apr 24 20:26:53 cerebro kernel: sdg: Current: sense key: Data Protect
>> Apr 24 20:26:53 cerebro kernel: =A0 =A0 Add. Sense: Write protected
>> Apr 24 20:26:53 cerebro kernel:
>> Apr 24 20:26:53 cerebro kernel: end_request: I/O error, dev sdg, secto=
r 1289
>> Apr 24 20:26:53 cerebro kernel: device-mapper: multipath: Failing path=
 8:96.
>> Apr 24 20:26:53 cerebro multipathd: dm-5: add map (uevent)
>> Apr 24 20:26:53 cerebro multipathd: dm-5: devmap already registered
>> Apr 24 20:26:58 cerebro multipathd: 8:96: mark as failed
>> Apr 24 20:26:58 cerebro multipathd: homemaildir0: remaining active pat=
hs: 1
>> Apr 24 20:26:58 cerebro multipathd: sdg: tur checker reports path is u=
p
>> Apr 24 20:26:58 cerebro multipathd: 8:96: reinstated
>> Apr 24 20:26:58 cerebro multipathd: homemaildir0: remaining active pat=
hs: 2
>> Apr 24 20:26:58 cerebro multipathd: dm-5: add map (uevent)
>> Apr 24 20:26:58 cerebro multipathd: dm-5: devmap already registered
>> Apr 24 20:27:06 cerebro multipathd: homemaildir0: switch to path group=
 #2
>> Apr 24 20:27:07 cerebro kernel: 91
>> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7
>> Apr 24 20:27:07 cerebro kernel: 492
>> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20212 pdev
>> H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1
>> Apr 24 20:27:07 cerebro kernel: sd 3:0:1:0: SCSI error: return code =3D=
 0x08000002
>> Apr 24 20:27:07 cerebro kernel: sdg: Current: sense key: Data Protect
>> Apr 24 20:27:07 cerebro kernel: =A0 =A0 Add. Sense: Write protected
>> Apr 24 20:27:07 cerebro kernel:
>> Apr 24 20:27:07 cerebro kernel: end_request: I/O error, dev sdg, secto=
r 1289
>> Apr 24 20:27:07 cerebro kernel: device-mapper: multipath: Failing path=
 8:96.
>> Apr 24 20:27:07 cerebro multipathd: dm-5: add map (uevent)
>> Apr 24 20:27:07 cerebro multipathd: dm-5: devmap already registered
>> Apr 24 20:27:07 cerebro multipathd: 8:96: mark as failed
>> Apr 24 20:27:07 cerebro multipathd: homemaildir0: remaining active pat=
hs: 1
>> Apr 24 20:27:12 cerebro multipathd: sdg: tur checker reports path is u=
p
>> Apr 24 20:27:12 cerebro multipathd: 8:96: reinstated
>> Apr 24 20:27:12 cerebro multipathd: homemaildir0: remaining active pat=
hs: 2
>> Apr 24 20:27:12 cerebro multipathd: dm-5: add map (uevent)
>> Apr 24 20:27:12 cerebro multipathd: dm-5: devmap already registered
>> Apr 24 20:27:20 cerebro multipathd: homemaildir0: switch to path group=
 #2
>> Apr 24 20:27:21 cerebro kernel: 91
>> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7
>> Apr 24 20:27:21 cerebro kernel: 492
>> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20305 pdev
>> H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1
>> Apr 24 20:27:21 cerebro kernel: sd 3:0:1:0: SCSI error: return code =3D=
 0x08000002
>> Apr 24 20:27:21 cerebro kernel: sdg: Current: sense key: Data Protect
>> Apr 24 20:27:21 cerebro kernel: =A0 =A0 Add. Sense: Write protected
>> Apr 24 20:27:21 cerebro kernel:
>> Apr 24 20:27:21 cerebro kernel: end_request: I/O error, dev sdg, secto=
r 1289
>> Apr 24 20:27:21 cerebro kernel: device-mapper: multipath: Failing path=
 8:96.
>> Apr 24 20:27:21 cerebro multipathd: dm-5: add map (uevent)
>> Apr 24 20:27:21 cerebro multipathd: dm-5: devmap already registered
>> Apr 24 20:27:21 cerebro multipathd: 8:96: mark as failed
>> Apr 24 20:27:21 cerebro multipathd: homemaildir0: remaining active pat=
hs: 1
>> Apr 24 20:27:26 cerebro multipathd: sdg: tur checker reports path is u=
p
>> Apr 24 20:27:26 cerebro multipathd: 8:96: reinstated
>> Apr 24 20:27:26 cerebro multipathd: homemaildir0: remaining active pat=
hs: 2
>> Apr 24 20:27:26 cerebro multipathd: dm-5: add map (uevent)
>> Apr 24 20:27:26 cerebro multipathd: dm-5: devmap already registered
>> Apr 24 20:27:34 cerebro multipathd: homemaildir0: switch to path group=
 #2
>> Apr 24 20:27:35 cerebro kernel: 91
>> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7
>> Apr 24 20:27:35 cerebro kernel: 492
>> [RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20419 pdev
>> H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1
>> Apr 24 20:27:35 cerebro kernel: sd 3:0:1:0: SCSI error: return code =3D=
 0x08000002
>> Apr 24 20:27:35 cerebro kernel: sdg: Current: sense key: Data Protect
>> Apr 24 20:27:35 cerebro kernel: =A0 =A0 Add. Sense: Write protected
>> Apr 24 20:27:35 cerebro kernel:
>> Apr 24 20:27:35 cerebro kernel: end_request: I/O error, dev sdg, secto=
r 1289
>> Apr 24 20:27:35 cerebro kernel: device-mapper: multipath: Failing path=
 8:96.
>> Apr 24 20:27:35 cerebro multipathd: dm-5: add map (uevent)
>> Apr 24 20:27:35 cerebro multipathd: dm-5: devmap already registered
>> Apr 24 20:27:35 cerebro multipathd: 8:96: mark as failed
>> Apr 24 20:27:35 cerebro multipathd: homemaildir0: remaining active pat=
hs: 1
>> Apr 24 20:27:40 cerebro multipathd: sdg: tur checker reports path is u=
p
>> Apr 24 20:27:40 cerebro multipathd: 8:96: reinstated
>> Apr 24 20:27:40 cerebro multipathd: homemaildir0: remaining active pat=
hs: 2
>> Apr 24 20:27:40 cerebro multipathd: dm-5: add map (uevent)
>> Apr 24 20:27:40 cerebro multipathd: dm-5: devmap already registered
>> #############
>>
>>
>> My idea is set dm-multipath to only change from a path if it fails.
>> How can I do that?
>>
>> Any comments, doubts or suggest for this config would be appreciated
>> as i'm new to all this hardware/setup.
>>
>> Thanks in advance.
>>
>> --
>>
>> Fl=E1vio do Carmo J=FAnior aka waKKu
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
