From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: Dell MD3000/multipath - huge numbers of I/O errors
	on	boot
Date: Fri, 25 Sep 2009 11:55:02 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474E032F1@cosmail01.lsi.com>
References: <4ABCC970.70603@Calva.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4ABCC970.70603@Calva.COM>
Content-Language: en-US
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

This is a know problem.. As far as I know these errors mostly come during=
 the boot-up if the scsi rdac handler is not there in the initrd image. Y=
ou might want to try building scsi_dh_rdac into the initrd image.  =20

Thanks
Babu Moger=20

> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of John Hughes
> Sent: Friday, September 25, 2009 8:45 AM
> To: dm-devel@redhat.com
> Subject: [dm-devel] Dell MD3000/multipath - huge numbers of I/O errors
> on boot
>=20
> I've got a Dell MD3000 SAS cabinet, connected with two SAS cables using
> multipathd/dm-multipath.
>=20
> Most things work fine, but one problem I have is that the MD3000 wants
> to do failover, it gets very shirty if I access the "ghost" path to a
> LUN without doing some RDAC fancyness.
>=20
> The problem is that when the kernel discovers each LUN it tries to read
> the partition table, which produces insane numbers of read failures on
> boot.  How can I silence them?
>=20
> [  236.136435] scsi 4:0:0:14: Direct-Access     DELL     MD3000
> 0735 PQ: 0 ANSI: 5
> [  236.158631] sd 4:0:0:14: [sdav] 142323712 512-byte hardware sectors:
> (72.8 GB/67.8 GiB)
> [  236.158950] sd 4:0:0:14: [sdav] Write Protect is off
> [  236.159035] sd 4:0:0:14: [sdav] Mode Sense: 77 00 10 08
> [  236.159456] sd 4:0:0:14: [sdav] Write cache: enabled, read cache:
> enabled, supports DPO and FUA
> [  236.159888] sd 4:0:0:14: [sdav] 142323712 512-byte hardware sectors:
> (72.8 GB/67.8 GiB)
> [  236.160199] sd 4:0:0:14: [sdav] Write Protect is off
> [  236.160285] sd 4:0:0:14: [sdav] Mode Sense: 77 00 10 08
> [  236.160679] sd 4:0:0:14: [sdav] Write cache: enabled, read cache:
> enabled, supports DPO and FUA
> [  236.161450] sd 4:0:0:14: [sdav] Attached SCSI disk
> [  236.161546] sd 4:0:0:14: Embedded Enclosure Device
> [  236.368374] sd 4:0:0:14: Attached scsi generic sg49 type 0
> ...
> [  240.579148] sd 3:0:1:14: [sdaf] Result: hostbyte=3DDID_OK
> driverbyte=3DDRIVER_SENSE,SUGGEST_OK
> [  240.579323] sd 3:0:1:14: [sdaf] Sense Key : Illegal Request
> [current]
> [  243.792964] sd 3:0:1:14: [sdaf] <<vendor>> ASC=3D0x94 ASCQ=3D0x1ASC=3D=
0x94
> ASCQ=3D0x1
> [  245.265769] sd 3:0:1:14: [sdaf] Result: hostbyte=3DDID_OK
> driverbyte=3DDRIVER_SENSE,SUGGEST_OK
> [  245.265940] sd 3:0:1:14: [sdaf] Sense Key : Illegal Request
> [current]
> [  245.266215] sd 3:0:1:14: [sdaf] <<vendor>> ASC=3D0x94 ASCQ=3D0x1ASC=3D=
0x94
> ASCQ=3D0x1
> [  245.825586] sd 3:0:1:14: [sdaf] Result: hostbyte=3DDID_OK
> driverbyte=3DDRIVER_SENSE,SUGGEST_OK
> [  245.825752] sd 3:0:1:14: [sdaf] Sense Key : Illegal Request
> [current]
> [  245.826017] sd 3:0:1:14: [sdaf] <<vendor>> ASC=3D0x94 ASCQ=3D0x1ASC=3D=
0x94
> ASCQ=3D0x1
> ... [ MANY MANY ERRORS REMOVED ]
> [  303.486849] sd 3:0:1:14: rdac: LUN 14 (unowned)
> [  303.494695] sd 4:0:0:14: rdac: LUN 14 (owned)
>=20
> # multipath -ll
> ...
> mpath43 (360024e80005b3b23000001b94ab0587f) dm-30 DELL    ,MD3000
> [size=3D68G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
> \_ round-robin 0 [prio=3D3][active]
>  \_ 4:0:0:14 sdav 66:240 [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 3:0:1:14 sdaf 65:240 [active][ghost]
> ...
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
