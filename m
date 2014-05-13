From: Brian Bunker <brian@purestorage.com>
Subject: path coalescing once more
Date: Tue, 13 May 2014 16:55:42 -0700
Message-ID: <ED745309-08E8-4C83-86BD-F9D7246CA8F6@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/mixed; boundary="===============3308787600119314137=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============3308787600119314137==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_131486DA-A9F5-4008-83B3-1CF7EEB3750F"


--Apple-Mail=_131486DA-A9F5-4008-83B3-1CF7EEB3750F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

We continue to run into problems with the device-mapper presumably =
putting LUNs which do not belong with the dm under its control. Here is =
the latest (I am picking out just dm-2 but there are others in this same =
state):

3624a9370c90d0d631ef8783e00010004 dm-2 PURE,FlashArray
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- 7:0:0:3 sdj  8:144  active ready running
  |- 3:0:0:3 sdba 67:64  active ready running
  |- 0:0:0:3 sdaz 67:48  active ready running
  |- 5:0:0:3 sdbb 67:80  active ready running
  |- 6:0:0:3 sdcc 69:0   active ready running
  |- 1:0:0:1 sdaj 66:48  active ready running
  `- 2:0:0:1 sdbv 68:144 active ready running

I see the following kernel messages in the syslog when the device sdaj =
arrives to when it is put in the wrong place:
May 13 11:28:27 rb9init4 kernel: scsi 1:0:0:1: Direct-Access     PURE    =
 FlashArray       400B PQ: 0 ANSI: 6
May 13 11:28:27 rb9init4 kernel: sd 1:0:0:1: [sdaj] 1048576000 512-byte =
logical blocks: (536 GB/500 GiB)
May 13 11:28:27 rb9init4 kernel: sd 1:0:0:1: Attached scsi generic sg1 =
type 0
May 13 11:28:27 rb9init4 kernel: sd 1:0:0:1: [sdaj] Write Protect is off
May 13 11:28:27 rb9init4 kernel: sd 1:0:0:1: [sdaj] Write cache: =
disabled, read cache: enabled, doesn't support DPO or FUA
May 13 11:28:27 rb9init4 kernel: sdaj:
May 13 11:28:27 rb9init4 kernel: unknown partition table
May 13 11:28:27 rb9init4 kernel: sd 1:0:0:1: [sdaj] Attached SCSI disk
May 13 11:28:28 rb9init4 multipathd: sdaj: add path (uevent)
May 13 11:28:28 rb9init4 multipathd: sdaj path added to devmap =
3624a9370c90d0d631ef8783e00010004

I don=92t understand where it gets 3624a9370c90d0d631ef8783e00010004. =
When I run the =91multipath -v6 -d=92 so that it prints out what it =
wants to do but doesn=92t do it, I see:
May 13 16:45:15 | Discover device /sys/block/sdaj
May 13 16:45:15 | sdaj: not found in pathvec
May 13 16:45:15 | sdaj: mask =3D 0x3f
May 13 16:45:15 | sdaj: dev_t =3D 66:48
May 13 16:45:15 | sdaj: size =3D 1048576000
May 13 16:45:15 | sdaj: subsystem =3D scsi
May 13 16:45:15 | sdaj: vendor =3D PURE
May 13 16:45:15 | sdaj: product =3D FlashArray
May 13 16:45:15 | sdaj: rev =3D 400B
May 13 16:45:15 | sdaj: h:b:t:l =3D 1:0:0:1
May 13 16:45:15 | sdaj: tgt_node_name =3D 0x524a937000016901
May 13 16:45:15 | sdaj: serial =3D C90D0D631EF8783E00010002
May 13 16:45:15 | sdaj: get_state
May 13 16:45:15 | loading /lib64/multipath/libchecktur.so checker
May 13 16:45:15 | sdaj: path checker =3D tur (controller setting)
May 13 16:45:15 | sdaj: checker timeout =3D 30000 ms (sysfs setting)
May 13 16:45:15 | sdaj: state =3D running
May 13 16:45:15 | sdaj: state =3D 3
May 13 16:45:15 | sdaj: getuid =3D /lib/udev/scsi_id --whitelisted =
--device=3D/dev/%n (config file default)
May 13 16:45:15 | sdaj: uid =3D 3624a9370c90d0d631ef8783e00010002 =
(callout)
May 13 16:45:15 | sdaj: state =3D running
May 13 16:45:15 | sdaj: detect_prio =3D 1 (config file default)
May 13 16:45:15 | sdaj: prio =3D const (config file default)
May 13 16:45:15 | sdaj: const prio =3D 1

So it seems to know thats its serial ends in =9302=94 and not =9304=94 =
like where it put the device. I don=92t understand how to debug this =
further, so any help would be appreciated.

Thanks,
Brian


Brian Bunker
brian@purestorage.com




--Apple-Mail=_131486DA-A9F5-4008-83B3-1CF7EEB3750F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=windows-1252

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dwindows-1252"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;">We =
continue to run into problems with the device-mapper presumably putting =
LUNs which do not belong with the dm under its control. Here is the =
latest (I am picking out just dm-2 but there are others in this same =
state):<div><br></div><div><div>3624a9370c90d0d631ef8783e00010004 dm-2 =
PURE,FlashArray</div><div>size=3D500G features=3D'0' hwhandler=3D'0' =
wp=3Drw</div><div>`-+- policy=3D'round-robin 0' prio=3D1 =
status=3Dactive</div><div>&nbsp; |- 7:0:0:3 sdj &nbsp;8:144 &nbsp;active =
ready running</div><div>&nbsp; |- 3:0:0:3 sdba 67:64 &nbsp;active ready =
running</div><div>&nbsp; |- 0:0:0:3 sdaz 67:48 &nbsp;active ready =
running</div><div>&nbsp; |- 5:0:0:3 sdbb 67:80 &nbsp;active ready =
running</div><div>&nbsp; |- 6:0:0:3 sdcc 69:0 &nbsp; active ready =
running</div><div>&nbsp; |- 1:0:0:1 sdaj 66:48 &nbsp;active ready =
running</div><div>&nbsp; `- 2:0:0:1 sdbv 68:144 active ready =
running</div><div><br></div><div>I see the following kernel messages in =
the syslog when the device sdaj arrives to when it is put in the wrong =
place:</div><div><pre style=3D"margin-top: 0px; margin-bottom: 0px; =
padding: 0px; max-height: 30em; overflow: auto; word-wrap: normal; =
word-break: normal; color: rgb(51, 51, 51); line-height: 16px; =
background-color: rgb(245, 245, 245);"><font face=3D"Helvetica">May 13 =
11:28:27 rb9init4 kernel: scsi 1:0:0:1: Direct-Access     PURE     =
FlashArray       400B PQ: 0 ANSI: 6
May 13 11:28:27 rb9init4 kernel: sd 1:0:0:1: [sdaj] 1048576000 512-byte =
logical blocks: (536 GB/500 GiB)
May 13 11:28:27 rb9init4 kernel: sd 1:0:0:1: Attached scsi generic sg1 =
type 0
May 13 11:28:27 rb9init4 kernel: sd 1:0:0:1: [sdaj] Write Protect is off
May 13 11:28:27 rb9init4 kernel: sd 1:0:0:1: [sdaj] Write cache: =
disabled, read cache: enabled, doesn't support DPO or FUA
May 13 11:28:27 rb9init4 kernel: sdaj:
May 13 11:28:27 rb9init4 kernel: unknown partition table
May 13 11:28:27 rb9init4 kernel: sd 1:0:0:1: [sdaj] Attached SCSI disk
May 13 11:28:28 rb9init4 multipathd: sdaj: add path (uevent)
May 13 11:28:28 rb9init4 multipathd: sdaj path added to devmap =
3624a9370c90d0d631ef8783e00010004</font></pre><div><br></div></div><div>I =
don=92t understand where it gets&nbsp;<span style=3D"background-color: =
rgb(245, 245, 245);"><font color=3D"#333333"><span style=3D"line-height: =
16px;">3624a9370c90d0d631ef8783e00010004. When I run the&nbsp;=91multipath=
 -v6 -d=92 so that it prints out what it wants to do but doesn=92t do =
it, I see:</span></font></span></div><div><span style=3D"background-color:=
 rgb(245, 245, 245);"><font color=3D"#333333"><span style=3D"line-height: =
16px;"><div>May 13 16:45:15 | Discover device =
/sys/block/sdaj</div><div>May 13 16:45:15 | sdaj: not found in =
pathvec</div><div>May 13 16:45:15 | sdaj: mask =3D 0x3f</div><div>May 13 =
16:45:15 | sdaj: dev_t =3D 66:48</div><div>May 13 16:45:15 | sdaj: size =
=3D 1048576000</div><div>May 13 16:45:15 | sdaj: subsystem =3D =
scsi</div><div>May 13 16:45:15 | sdaj: vendor =3D PURE</div><div>May 13 =
16:45:15 | sdaj: product =3D FlashArray</div><div>May 13 16:45:15 | =
sdaj: rev =3D 400B</div><div>May 13 16:45:15 | sdaj: h:b:t:l =3D =
1:0:0:1</div><div>May 13 16:45:15 | sdaj: tgt_node_name =3D =
0x524a937000016901</div><div>May 13 16:45:15 | sdaj: serial =3D =
C90D0D631EF8783E00010002</div><div>May 13 16:45:15 | sdaj: =
get_state</div><div>May 13 16:45:15 | loading =
/lib64/multipath/libchecktur.so checker</div><div>May 13 16:45:15 | =
sdaj: path checker =3D tur (controller setting)</div><div>May 13 =
16:45:15 | sdaj: checker timeout =3D 30000 ms (sysfs =
setting)</div><div>May 13 16:45:15 | sdaj: state =3D =
running</div><div>May 13 16:45:15 | sdaj: state =3D 3</div><div>May 13 =
16:45:15 | sdaj: getuid =3D /lib/udev/scsi_id --whitelisted =
--device=3D/dev/%n (config file default)</div><div>May 13 16:45:15 | =
sdaj: uid =3D 3624a9370c90d0d631ef8783e00010002 (callout)</div><div>May =
13 16:45:15 | sdaj: state =3D running</div><div>May 13 16:45:15 | sdaj: =
detect_prio =3D 1 (config file default)</div><div>May 13 16:45:15 | =
sdaj: prio =3D const (config file default)</div><div>May 13 16:45:15 | =
sdaj: const prio =3D 1</div><div><br></div><div>So it seems to know =
thats its serial ends in =9302=94 and not =9304=94 like where it put the =
device. I don=92t understand how to debug this further, so any help =
would be =
appreciated.</div><div><br></div><div>Thanks,</div><div>Brian</div></span>=
</font></span></div><div><br></div><div><br><div =
apple-content-edited=3D"true">
<span class=3D"Apple-style-span" style=3D"border-collapse: separate; =
border-spacing: 0px;"><div>Brian Bunker</div><div><a =
href=3D"mailto:brian@purestorage.com">brian@purestorage.com</a></div><div>=
<br></div></span><br class=3D"Apple-interchange-newline">

</div>
<br></div></div></body></html>=

--Apple-Mail=_131486DA-A9F5-4008-83B3-1CF7EEB3750F--


--===============3308787600119314137==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3308787600119314137==--
