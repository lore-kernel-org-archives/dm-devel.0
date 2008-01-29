From: <LittleJ@AE.com>
Subject: RE: Problem using dm-multipath on first of 2 LUNs on system
Date: Tue, 29 Jan 2008 16:40:54 -0500
Message-ID: <08F3F42DB42FBF4E87512A3AB4596D4A03F72CC2@HERSHEY.aeo.ae.com>
References: <08F3F42DB42FBF4E87512A3AB4596D4A03F72CBF@HERSHEY.aeo.ae.com>
	<20080129195818.GA9772@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20080129195818.GA9772@us.ibm.com>
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


When I execute `multipath -v3` the following appears in
/var/log/messages:

Jan 29 16:32:50 svwdcvispay01 kernel: device-mapper: dm-multipath: error
getting device
Jan 29 16:32:50 svwdcvispay01 kernel: device-mapper: error adding target
to table
Jan 29 16:32:52 svwdcvispay01 hald[3620]: Timed out waiting for hotplug
event 361. Rebasing to 362
Jan 29 16:33:06 svwdcvispay01 hal.hotplug[22665]: timout(10000 ms)
waiting for /block/dm-5

I am able to perform I/O to both /dev/sda and /dev/sdc:

[root@svwdcvispay01 ~]# dd if=3D/dev/sda of=3D/dev/null count=3D10
10+0 records in
10+0 records out
[root@svwdcvispay01 ~]# dd if=3D/dev/sdc of=3D/dev/null count=3D10
10+0 records in
10+0 records out
[root@svwdcvispay01 ~]#

Joe Little
littlej@ae.com




-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of malahal@us.ibm.com
Sent: Tuesday, January 29, 2008 2:58 PM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] Problem using dm-multipath on first of 2 LUNs on
system

LittleJ@AE.com [LittleJ@AE.com] wrote:
>    I am attempting to implement dm-multipath on a RHEL4U6 server and I
have
>    been successful in enabling it on the second of 2 LUNs on the
server but
>    for whatever reason it will not create the device special files in
>    /dev/mapper for the fist LUN.  `multipath -d` shows that it
identifies the
>    first LUN and wants to create the mpath0 files:
>=20
>=20
>=20
>    [root@svwdcvispay01 etc]# multipath -d
>=20
>    create: mpath0 (36005076801810085c800000000000194)
>=20
>    [size=3D12 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]
>=20
>    \_ round-robin 0 [prio=3D50]
>=20
>     \_ 1:0:0:0 sda 8:0  [ready]
>=20
>    \_ round-robin 0 [prio=3D10]
>=20
>     \_ 1:0:1:0 sdc 8:32 [ready]

One of the fields (DM path state) is missing from the above output.
Looks like it failed to create mpath0 properly. Make sure you enable
'syslog' and send out the syslog out when you run "multipath -v3"=20

Also, can you do read/write I/O to sda and sdc devices? Try reading
data from both of those devices using dd or something similar. The
following should do:

dd if=3D/dev/sda of=3D/dev/null count=3D10
dd if=3D/dev/sdc of=3D/dev/null count=3D10

Thanks, Malahal.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
