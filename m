From: "Greg Cockburn" <gergnz@gmail.com>
Subject: multipath rdac - recover from both paths lost
Date: Mon, 20 Oct 2008 21:29:16 +1100
Message-ID: <bd4583d00810200329x652c28b8xbfa1aa23c22912e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1102789180=="
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

--===============1102789180==
Content-Type: multipart/alternative;
	boundary="----=_Part_169485_8677947.1224498557000"

------=_Part_169485_8677947.1224498557000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I am trying to get back from a strage situation.

I have had both paths in a RDAC setup fail and then come back.

I want to know if there is a way to recover from this without a reboot.

(OS = CentOS 5.1)

multipath -ll
mpath2 (3600a0b800035ebc8000001a94652ae50) dm-4 IBM,1726-4xx  FAStT
[size=1.4T][features=0][hwhandler=1 rdac]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:1 sde 8:80  [failed][ghost]
\_ round-robin 0 [prio=100][active]
 \_ 1:0:0:1 sdf 8:96  [failed][ready]

dmsetup info mpath2
Name:              mpath2
State:             ACTIVE
Tables present:    LIVE
Open count:        20
Event number:      3
Major, minor:      253, 4
Number of targets: 1
UUID: mpath-3600a0b800035ebc8000001a94652ae50

vgscan
  Reading all physical volumes.  This may take a while...
  /dev/mapper/mpath2: read failed after 0 of 4096 at 1497314033664:
Input/output error
  /dev/mapper/mpath2: read failed after 0 of 4096 at 0: Input/output error

dmsetup remove --force mpath2



device-mapper: remove ioctl failed: Device or resource busy
Command failed

multipath -f mpath2 (just exits with return code 1)


dmesg

    <<vendor>> ASC=0xe0 ASCQ=0x6ASC=0xe0 ASCQ=0x6

sde: Current: sense key: Recovered Error
    <<vendor>> ASC=0xe0 ASCQ=0x6ASC=0xe0 ASCQ=0x6

sdf: Current: sense key: Recovered Error
    <<vendor>> ASC=0xe0 ASCQ=0x6ASC=0xe0 ASCQ=0x6

end_request: I/O error, dev sdf, sector 61118720
device-mapper: multipath: Failing path 8:80.
end_request: I/O error, dev sdf, sector 599510512

device-mapper: ioctl: unable to remove open device mpath2
device-mapper: ioctl: unable to remove open device mpath2

Any advice would be greatly appreciated.

Thanks,
Greg.

------=_Part_169485_8677947.1224498557000
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hi,<br><br>I am trying to get back from a strage situation.<br><br>I have had both paths in a RDAC setup fail and then come back.<br><br>I want to know if there is a way to recover from this without a reboot.<br>
<br>(OS = CentOS 5.1)<br><br>multipath -ll<br>mpath2 (3600a0b800035ebc8000001a94652ae50) dm-4 IBM,1726-4xx&nbsp; FAStT<br>[size=1.4T][features=0][hwhandler=1 rdac]<br>\_ round-robin 0 [prio=0][enabled]<br>&nbsp;\_ 2:0:0:1 sde 8:80&nbsp; [failed][ghost]<br>
\_ round-robin 0 [prio=100][active]<br>&nbsp;\_ 1:0:0:1 sdf 8:96&nbsp; [failed][ready]<br><br>dmsetup info mpath2<br>Name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mpath2<br>State:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ACTIVE<br>Tables present:&nbsp;&nbsp;&nbsp; LIVE<br>Open count:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20<br>Event number:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3<br>
Major, minor:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 253, 4<br>Number of targets: 1<br>UUID: mpath-3600a0b800035ebc8000001a94652ae50<br><br>vgscan<br>&nbsp; Reading all physical volumes.&nbsp; This may take a while...<br>&nbsp; /dev/mapper/mpath2: read failed after 0 of 4096 at 1497314033664: Input/output error<br>
&nbsp; /dev/mapper/mpath2: read failed after 0 of 4096 at 0: Input/output error<br><br>dmsetup remove --force mpath2<br><br><br><br>device-mapper: remove ioctl failed: Device or resource busy<br>Command failed<br><br>multipath -f mpath2 (just exits with return code 1)<br>
<br><br>dmesg<br><br>&nbsp;&nbsp;&nbsp; &lt;&lt;vendor&gt;&gt; ASC=0xe0 ASCQ=0x6ASC=0xe0 ASCQ=0x6<br><br>sde: Current: sense key: Recovered Error<br>&nbsp;&nbsp;&nbsp; &lt;&lt;vendor&gt;&gt; ASC=0xe0 ASCQ=0x6ASC=0xe0 ASCQ=0x6<br><br>sdf: Current: sense key: Recovered Error<br>
&nbsp;&nbsp;&nbsp; &lt;&lt;vendor&gt;&gt; ASC=0xe0 ASCQ=0x6ASC=0xe0 ASCQ=0x6<br><br>end_request: I/O error, dev sdf, sector 61118720<br>device-mapper: multipath: Failing path 8:80.<br>end_request: I/O error, dev sdf, sector 599510512<br>
<br>device-mapper: ioctl: unable to remove open device mpath2<br>device-mapper: ioctl: unable to remove open device mpath2<br><br>Any advice would be greatly appreciated.<br><br>Thanks,<br>Greg.<br></div>

------=_Part_169485_8677947.1224498557000--


--===============1102789180==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1102789180==--
