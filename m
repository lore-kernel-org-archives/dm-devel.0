From: Brian Bunker <brian@purestorage.com>
Subject: why doesn't multipathd use the device?
Date: Thu, 21 Jun 2012 16:54:53 -0700
Message-ID: <A01D98BC-7342-4771-B139-F0A5F757D431@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: multipart/mixed; boundary="===============1899254704786027095=="
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


--===============1899254704786027095==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_F0088B44-31BC-4649-9516-0C99FC03F338"


--Apple-Mail=_F0088B44-31BC-4649-9516-0C99FC03F338
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hello everyone,

We have hit this problem a couple of times now on our RHEL 6.2 =
initiators using our FC target. We have many dm devices which should =
have 4 paths to each. Sometimes we see that some of the dm devices do =
not have the 4 paths. The underlying /dev/sd devices do exist but they =
are not used by the dm device. Here is what I see:

mpathbbt (3624a9370f9b69331bb3d16650001000b) dm-11 PURE,FlashArray
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
 |- 1:0:1:12 sds  65:32  active ready running
 `- 1:0:0:12 sdae 65:224 active ready running

However there are devices for the remaining two paths they are just not =
being used by multipathd:

/dev/sg18  1 0 1 12  0  /dev/sds  PURE      FlashArray        100=20
/dev/sg30  1 0 0 12  0  /dev/sdae  PURE      FlashArray        100=20
/dev/sg39  0 0 1 12  0  /dev/sdan  PURE      FlashArray        100=20
/dev/sg48  0 0 0 12  0  /dev/sdaw  PURE      FlashArray        100

You can see by the LUN serial number that the devices do point to the =
same LUN on the array. I am including just the LUN serial number, page =
0x80, in the interest of space page 0x83's NAA number also matches for =
the 4 devices:

root@r13init31 ~]# sg_inq -p 0x80 /dev/sg18
VPD INQUIRY: Unit serial number page
Unit serial number: F9B69331BB3D16650001000B

[root@r13init31 ~]# sg_inq -p 0x80 /dev/sg30
VPD INQUIRY: Unit serial number page
Unit serial number: F9B69331BB3D16650001000B

[root@r13init31 ~]# sg_inq -p 0x80 /dev/sg39
VPD INQUIRY: Unit serial number page
Unit serial number: F9B69331BB3D16650001000B

[root@r13init31 ~]# sg_inq -p 0x80 /dev/sg48
VPD INQUIRY: Unit serial number page
Unit serial number: F9B69331BB3D16650001000B

I can see in the syslog that there are syslog messages about each of the =
devices which don't get added to the multipath device like this:
Jun 21 09:23:50 r13init31 kernel: sd 0:0:1:12: [sdan] Attached SCSI disk
Jun 21 09:23:50 r13init31 multipathd: sdan: add path (uevent)
Jun 21 09:23:50 r13init31 multipathd: mpathbbt: failed in domap for =
addition of new path sdan

My multipath tools version is:
device-mapper-multipath-libs-0.4.9-46.el6_2.2.x86_64
device-mapper-multipath-0.4.9-46.el6_2.2.x86_64

Any ideas why the paths are being rejected by domap?

Thanks,
Brian

Brian Bunker
brian@purestorage.com




--Apple-Mail=_F0088B44-31BC-4649-9516-0C99FC03F338
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; ">Hello =
everyone,<div><br></div><div>We have hit this problem a couple of times =
now on our RHEL 6.2 initiators using our FC target. We have many dm =
devices which should have 4 paths to each. Sometimes we see that some of =
the dm devices do not have the 4 paths. The underlying /dev/sd devices =
do exist but they are not used by the dm device. Here is what I =
see:</div><div><br></div><div><span class=3D"Apple-style-span" =
style=3D"line-height: 13px; "><pre style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: =
0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; =
line-height: 1.3em; max-height: 30em; overflow-x: auto; overflow-y: =
auto; word-wrap: normal; "><font class=3D"Apple-style-span" =
face=3D"Helvetica">mpathbbt (3624a9370f9b69331bb3d16650001000b) dm-11 =
PURE,FlashArray
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
 |- 1:0:1:12 sds  65:32  active ready running
 `- 1:0:0:12 sdae 65:224 active ready =
running</font></pre></span><div><br></div></div><div>However there are =
devices for the remaining two paths they are just not being used by =
multipathd:</div><div><br></div><div><span class=3D"Apple-style-span" =
style=3D"line-height: 13px; "><pre style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: =
0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; =
line-height: 1.3em; max-height: 30em; overflow-x: auto; overflow-y: =
auto; word-wrap: normal; "><font class=3D"Apple-style-span" =
face=3D"Helvetica">/dev/sg18  1 0 1 12  0  /dev/sds  PURE      =
FlashArray        100=20
/dev/sg30  1 0 0 12  0  /dev/sdae  PURE      FlashArray        100=20
/dev/sg39  0 0 1 12  0  /dev/sdan  PURE      FlashArray        100=20
/dev/sg48  0 0 0 12  0  /dev/sdaw  PURE      FlashArray        =
100</font></pre></span><div><br></div></div><div>You can see by the LUN =
serial number that the devices do point to the same LUN on the array. I =
am including just the LUN serial number, page 0x80, in the interest of =
space page 0x83's NAA number also matches for the 4 =
devices:</div><div><br></div><div><span class=3D"Apple-style-span" =
style=3D"line-height: 13px; "><pre style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: =
0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; =
line-height: 1.3em; max-height: 30em; overflow-x: auto; overflow-y: =
auto; word-wrap: normal; "><font class=3D"Apple-style-span" =
face=3D"Helvetica"><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; line-height: 13px; font: normal =
normal normal 12px/normal Helvetica; ">root@r13init31 ~]# sg_inq -p 0x80 =
/dev/sg18</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; line-height: 13px; font: normal =
normal normal 12px/normal Helvetica; ">VPD INQUIRY: Unit serial number =
page</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; line-height: 13px; font: normal =
normal normal 12px/normal Helvetica; ">Unit serial number: =
F9B69331BB3D16650001000B</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; line-height: =
13px; font: normal normal normal 10px/normal Helvetica; min-height: =
12px; "><br></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; line-height: 13px; font: normal =
normal normal 12px/normal Helvetica; ">[root@r13init31 ~]# sg_inq -p =
0x80 /dev/sg30</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; line-height: 13px; font: normal =
normal normal 12px/normal Helvetica; ">VPD INQUIRY: Unit serial number =
page</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; line-height: 13px; font: normal =
normal normal 12px/normal Helvetica; ">Unit serial number: =
F9B69331BB3D16650001000B</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; line-height: =
13px; font: normal normal normal 12px/normal Helvetica; min-height: =
14px; "><br></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; line-height: 13px; font: normal =
normal normal 12px/normal Helvetica; ">[root@r13init31 ~]# sg_inq -p =
0x80 /dev/sg39</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; line-height: 13px; font: normal =
normal normal 12px/normal Helvetica; ">VPD INQUIRY: Unit serial number =
page</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; line-height: 13px; font: normal =
normal normal 12px/normal Helvetica; ">Unit serial number: =
F9B69331BB3D16650001000B</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; font: normal =
normal normal 12px/normal Helvetica; min-height: 14px; "><br></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; line-height: 13px; font: normal normal normal =
12px/normal Helvetica; ">[root@r13init31 ~]# sg_inq -p 0x80 =
/dev/sg48</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; line-height: 13px; font: normal =
normal normal 12px/normal Helvetica; ">VPD INQUIRY: Unit serial number =
page</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; line-height: 13px; font: normal =
normal normal 12px/normal Helvetica; ">Unit serial number: =
F9B69331BB3D16650001000B</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; line-height: =
13px; font: normal normal normal 12px/normal Helvetica; "><br></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; line-height: 13px; font: normal normal normal =
12px/normal Helvetica; ">I can see in the syslog that there are syslog =
messages about each of the devices which don't get added to the =
multipath device like this:</div></font></pre></span><span =
class=3D"Apple-style-span" style=3D"line-height: 13px; "><pre =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: =
0px; padding-left: 0px; line-height: 1.3em; max-height: 30em; =
overflow-x: auto; overflow-y: auto; word-wrap: normal; "><font =
class=3D"Apple-style-span" face=3D"Helvetica">Jun 21 09:23:50 r13init31 =
kernel: sd 0:0:1:12: [sdan] Attached SCSI disk
Jun 21 09:23:50 r13init31 multipathd: sdan: add path (uevent)
Jun 21 09:23:50 r13init31 multipathd: mpathbbt: failed in domap for =
addition of new path sdan</font></pre></span><div><br></div><div><div>My =
multipath tools version =
is:</div></div></div><div><div>device-mapper-multipath-libs-0.4.9-46.el6_2=
.2.x86_64</div><div>device-mapper-multipath-0.4.9-46.el6_2.2.x86_64</div><=
/div><div><br></div><div>Any ideas why the paths are being rejected by =
domap?</div><div><br></div><div>Thanks,</div><div>Brian</div><div><br></di=
v><div><div apple-content-edited=3D"true">
<div>Brian Bunker</div><div><a =
href=3D"mailto:brian@purestorage.com">brian@purestorage.com</a></div><div>=
<br></div><br class=3D"Apple-interchange-newline">
</div>
<br></div></body></html>=

--Apple-Mail=_F0088B44-31BC-4649-9516-0C99FC03F338--


--===============1899254704786027095==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1899254704786027095==--
