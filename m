From: Flavio Junior <billpp@gmail.com>
Subject: How to config dm-multipath to change a path only if it
	fails
Date: Fri, 24 Apr 2009 20:47:15 -0300
Message-ID: <58aa8d780904241647g6fed16c3l5d59c8d9336718b5@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi folks, good evening.

My idea is set dm-multipath to only change from a path if it fails.
How can I do that?

Setup is something as:

- 2x DS4700 IBM Storages
- 4x Fiber Switches (2 for each storage)
- 4x Path to each LUN (2 controllers x 2 switches) - But it shows to
me as a single device, because I'm using IBM rdac driver too.

Now, I've a primary storage as read-write AND a secundary mirrored
(bit by bit synchronous) as read-only. Of course, the LUN id's at each
storage are different so comes my first "hack" using getuid_callout to
group paths, and prio_callout to set priority higher for primary
storage and lower for secundary one.

Everything is working like a charm, configured as:

Link: http://pastebin.com/f4de2f7ca

# multipath.conf
defaults {
        user_friendly_names     yes
        path_grouping_policy    failover
        path_checker            tur
        hardware_handler        "rdac"
#       getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        getuid_callout          "/etc/multipath/get_lun_path.sh %n"
#       prio_callout            /bin/true
        prio_callout            "/bin/bash
/etc/multipath/get_lun_path.sh %n prio"
        failback                8
}

devices {
        device {
                vendor       "dummy"
                product      "dummy"
                prio_callout "/sbin/scsi_id"
        }
}

[root@pinky ~]# cat /etc/multipath/get_lun_path.sh
#!/bin/bash

DEVICE=3D"$(/sbin/scsi_id -g -u -s /block/$1)"
SCSI_ID_TABLE=3D"/etc/multipath/scsi_id_multipath"

if [ $# -lt 1 ]; then
        exit 1
fi

if [ "$2" =3D=3D "prio" ]; then
        while read SCSI_ID WWID PRIO; do [ "$SCSI_ID" =3D=3D "${DEVICE}" =
]
&& echo $PRIO; done < $SCSI_ID_TABLE
        exit 0
else
        while read SCSI_ID WWID PRIO; do [ "$SCSI_ID" =3D=3D "${DEVICE}" =
]
&& echo $WWID; done < $SCSI_ID_TABLE
        exit 0
fi

[root@pinky ~]# cat /etc/multipath/scsi_id_multipath
3600a0b800048834e0000150149dcc594       HomeMaildir1            2
3600a0b80004884c4000016e649dcc5a5       HomeMaildir2            2
3600a0b80004884c4000016e449dcc534       WebPages                2
3600a0b800048834e000014ff49dcc51b       MailQuorumDisk          2
3600a0b800048834e0000172c49e76cbb       FileSystemDLM           2
3600a0b80004885b40000b78f49dcd7f8       MailQuorumDisk          1
3600a0b80004885b40000b79149dcd817       HomeMaildir1            1
3600a0b80004885a00000c13349dcd9e5       HomeMaildir2            1
3600a0b80004885b40000baa149ec46b5       FileSystemDLM           1
3600a0b80004885a00000c13149dcd9c3       WebPages                1

[root@pinky ~]# multipath -ll
fs_dlm0 (FileSystemDLM) dm-8 IBM,VirtualDisk
[size=3D300M][features=3D0][hwhandler=3D0][rw]
\_ round-robin 0 [prio=3D2][active]
 \_ 3:0:0:4 sdf 8:80  [active][ready]
\_ round-robin 0 [prio=3D1][enabled]
 \_ 3:0:1:3 sdj 8:144 [active][ready]
homemaildir1 (HomeMaildir2) dm-5 IBM,VirtualDisk
[size=3D25G][features=3D0][hwhandler=3D0][rw]
\_ round-robin 0 [prio=3D2][active]
 \_ 3:0:0:1 sdc 8:32  [active][ready]
\_ round-robin 0 [prio=3D1][enabled]
 \_ 3:0:1:2 sdi 8:128 [active][ready]
webpages0 (WebPages) dm-6 IBM,VirtualDisk
[size=3D4.0G][features=3D0][hwhandler=3D0][rw]
\_ round-robin 0 [prio=3D2][active]
 \_ 3:0:0:2 sdd 8:48  [active][ready]
\_ round-robin 0 [prio=3D1][enabled]
 \_ 3:0:1:4 sdk 8:160 [active][ready]
homemaildir0 (HomeMaildir1) dm-4 IBM,VirtualDisk
[size=3D25G][features=3D0][hwhandler=3D0][rw]
\_ round-robin 0 [prio=3D2][active]
 \_ 3:0:0:0 sdb 8:16  [active][ready]
\_ round-robin 0 [prio=3D1][enabled]
 \_ 3:0:1:1 sdh 8:112 [active][ready]
qdisk0 (MailQuorumDisk) dm-7 IBM,VirtualDisk
[size=3D200M][features=3D0][hwhandler=3D0][rw]
\_ round-robin 0 [prio=3D2][active]
 \_ 3:0:0:3 sde 8:64  [active][ready]
\_ round-robin 0 [prio=3D1][enabled]
 \_ 3:0:1:0 sdg 8:96  [active][ready]

#####

The problem comes when my higher priority path goes down (it happens
if I change secundary=3Dread-only storage role to primary=3Dread-write),
so dm-multipath fail to secundary path but it keeps trying to change
back for my "primary" path, and fill /var/log/messages with it (is at
last of above post link):

Apr 24 20:26:52 cerebro multipathd: homemaildir0: switch to path group #2
Apr 24 20:26:53 cerebro kernel: 91
[RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7
Apr 24 20:26:53 cerebro kernel: 492
[RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20095 pdev
H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1
Apr 24 20:26:53 cerebro kernel: sd 3:0:1:0: SCSI error: return code =3D 0=
x08000002
Apr 24 20:26:53 cerebro kernel: sdg: Current: sense key: Data Protect
Apr 24 20:26:53 cerebro kernel:     Add. Sense: Write protected
Apr 24 20:26:53 cerebro kernel:
Apr 24 20:26:53 cerebro kernel: end_request: I/O error, dev sdg, sector 1=
289
Apr 24 20:26:53 cerebro kernel: device-mapper: multipath: Failing path 8:=
96.
Apr 24 20:26:53 cerebro multipathd: dm-5: add map (uevent)
Apr 24 20:26:53 cerebro multipathd: dm-5: devmap already registered
Apr 24 20:26:58 cerebro multipathd: 8:96: mark as failed
Apr 24 20:26:58 cerebro multipathd: homemaildir0: remaining active paths:=
 1
Apr 24 20:26:58 cerebro multipathd: sdg: tur checker reports path is up
Apr 24 20:26:58 cerebro multipathd: 8:96: reinstated
Apr 24 20:26:58 cerebro multipathd: homemaildir0: remaining active paths:=
 2
Apr 24 20:26:58 cerebro multipathd: dm-5: add map (uevent)
Apr 24 20:26:58 cerebro multipathd: dm-5: devmap already registered
Apr 24 20:27:06 cerebro multipathd: homemaildir0: switch to path group #2
Apr 24 20:27:07 cerebro kernel: 91
[RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7
Apr 24 20:27:07 cerebro kernel: 492
[RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20212 pdev
H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1
Apr 24 20:27:07 cerebro kernel: sd 3:0:1:0: SCSI error: return code =3D 0=
x08000002
Apr 24 20:27:07 cerebro kernel: sdg: Current: sense key: Data Protect
Apr 24 20:27:07 cerebro kernel:     Add. Sense: Write protected
Apr 24 20:27:07 cerebro kernel:
Apr 24 20:27:07 cerebro kernel: end_request: I/O error, dev sdg, sector 1=
289
Apr 24 20:27:07 cerebro kernel: device-mapper: multipath: Failing path 8:=
96.
Apr 24 20:27:07 cerebro multipathd: dm-5: add map (uevent)
Apr 24 20:27:07 cerebro multipathd: dm-5: devmap already registered
Apr 24 20:27:07 cerebro multipathd: 8:96: mark as failed
Apr 24 20:27:07 cerebro multipathd: homemaildir0: remaining active paths:=
 1
Apr 24 20:27:12 cerebro multipathd: sdg: tur checker reports path is up
Apr 24 20:27:12 cerebro multipathd: 8:96: reinstated
Apr 24 20:27:12 cerebro multipathd: homemaildir0: remaining active paths:=
 2
Apr 24 20:27:12 cerebro multipathd: dm-5: add map (uevent)
Apr 24 20:27:12 cerebro multipathd: dm-5: devmap already registered
Apr 24 20:27:20 cerebro multipathd: homemaildir0: switch to path group #2
Apr 24 20:27:21 cerebro kernel: 91
[RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7
Apr 24 20:27:21 cerebro kernel: 492
[RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20305 pdev
H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1
Apr 24 20:27:21 cerebro kernel: sd 3:0:1:0: SCSI error: return code =3D 0=
x08000002
Apr 24 20:27:21 cerebro kernel: sdg: Current: sense key: Data Protect
Apr 24 20:27:21 cerebro kernel:     Add. Sense: Write protected
Apr 24 20:27:21 cerebro kernel:
Apr 24 20:27:21 cerebro kernel: end_request: I/O error, dev sdg, sector 1=
289
Apr 24 20:27:21 cerebro kernel: device-mapper: multipath: Failing path 8:=
96.
Apr 24 20:27:21 cerebro multipathd: dm-5: add map (uevent)
Apr 24 20:27:21 cerebro multipathd: dm-5: devmap already registered
Apr 24 20:27:21 cerebro multipathd: 8:96: mark as failed
Apr 24 20:27:21 cerebro multipathd: homemaildir0: remaining active paths:=
 1
Apr 24 20:27:26 cerebro multipathd: sdg: tur checker reports path is up
Apr 24 20:27:26 cerebro multipathd: 8:96: reinstated
Apr 24 20:27:26 cerebro multipathd: homemaildir0: remaining active paths:=
 2
Apr 24 20:27:26 cerebro multipathd: dm-5: add map (uevent)
Apr 24 20:27:26 cerebro multipathd: dm-5: devmap already registered
Apr 24 20:27:34 cerebro multipathd: homemaildir0: switch to path group #2
Apr 24 20:27:35 cerebro kernel: 91
[RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 Unrecognized SK - 7
Apr 24 20:27:35 cerebro kernel: 492
[RAIDarray.mpp]IBM_DS4700_SITE1:1:0:0 IO FAILURE. vcmnd SN 20419 pdev
H1:C0:T1:L0 0x07/0x27/0x00 0x08000002 mpp_status:1
Apr 24 20:27:35 cerebro kernel: sd 3:0:1:0: SCSI error: return code =3D 0=
x08000002
Apr 24 20:27:35 cerebro kernel: sdg: Current: sense key: Data Protect
Apr 24 20:27:35 cerebro kernel:     Add. Sense: Write protected
Apr 24 20:27:35 cerebro kernel:
Apr 24 20:27:35 cerebro kernel: end_request: I/O error, dev sdg, sector 1=
289
Apr 24 20:27:35 cerebro kernel: device-mapper: multipath: Failing path 8:=
96.
Apr 24 20:27:35 cerebro multipathd: dm-5: add map (uevent)
Apr 24 20:27:35 cerebro multipathd: dm-5: devmap already registered
Apr 24 20:27:35 cerebro multipathd: 8:96: mark as failed
Apr 24 20:27:35 cerebro multipathd: homemaildir0: remaining active paths:=
 1
Apr 24 20:27:40 cerebro multipathd: sdg: tur checker reports path is up
Apr 24 20:27:40 cerebro multipathd: 8:96: reinstated
Apr 24 20:27:40 cerebro multipathd: homemaildir0: remaining active paths:=
 2
Apr 24 20:27:40 cerebro multipathd: dm-5: add map (uevent)
Apr 24 20:27:40 cerebro multipathd: dm-5: devmap already registered
#############


My idea is set dm-multipath to only change from a path if it fails.
How can I do that?

Any comments, doubts or suggest for this config would be appreciated
as i'm new to all this hardware/setup.

Thanks in advance.

--

Fl=E1vio do Carmo J=FAnior aka waKKu
