From: "Ryan O'Hara" <rohara@redhat.com>
Subject: Re: Fwd: IO error on DM device
Date: Thu, 30 Mar 2006 12:59:56 -0600
Message-ID: <442C2AAC.1020405@redhat.com>
References: <39daa5689df1bf4a05a144891cc3563d@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <39daa5689df1bf4a05a144891cc3563d@redhat.com>
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
Cc: Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids


Pardon the top-post.

When a port gets disabled or unplugged, etc. the switch issues an RSCN=20
event. This is normal. All the HBAs still connected to the switch (and=20
in the same zone, if I understand) will see this RSCN event. This is=20
propagated as a DID_BUS_BUSY, which is the 0x20000 you are seeing and=20
should be transient. However this error seems to cause all other IO=20
paths to die when caught in a multipath environment.

For md, the solution is to use mdmpd (md's version of the multipath=20
daemon). This keeps the "innocent" IO paths up and running. Without it,=20
unplugging one HBA will cause all the IO paths to fail.

So based on the comments below and steps to reproduce, I'd say this is=20
expected behavior since multipathd is turned off. What happens if=20
multipathd is left running? It is implied that not stopping multipathd=20
will still cause a failure but will take much longer. I am no expert on=20
multipathd, so perhaps one of the dm developers can comment on=20
multipathd handling these SCSI error.

Ryan



Jonathan E Brassow wrote:
 >
> This is the bus busy error that makes it through the multipath=20
> drivers... Do you guys have any comments/status that you can give on=20
> this issue?
>=20
> brassow
>=20
> Begin forwarded message:
>=20
>     *From: *"Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.c=
om>
>     *Date: *March 29, 2006 10:03:03 AM CST
>     *To: *"Alasdair G Kergon" <agk@redhat.com>
>     *Cc: *device-mapper development <dm-devel@redhat.com>, Securelinux
>     <securelinux@hp.com>
>     *Subject: [dm-devel] IO error on DM device
>     Reply-To: *device-mapper development <dm-devel@redhat.com>
>=20
>     Hi Alasdair,
>=20
>     We are seeing an IO error problem on a DM device, when the HBA port=
s
>     of another host, seen through the same switch are disabled/enable.
>     We are not understanding on why the paths are failed when ports on
>     other hosts are disabled. Please explain.
>=20
>     Below is the problem description and steps to reproduce.
>=20
>     *Problem     : * I/O Error on DM device on one host when HBA ports
>     of another host are disabled.
>=20
>     *OS distros :*  RHEL4.0 U2/U3.
>=20
>     *HOW-TO reproduce the problem:*
>=20
>     1. Configure 2 storage arrays (A1, A2) and two host (H1, H2) in the
>     same zone, so that both the hosts can see both the arrays. Create
>     and present LUNs (L1, L2) from array (A1) to host (H1)
>=20
>     2. Stop the multipathd daemon (for testing purpose on why the IO
>     error when ports of other hosts are failed). Not stopping it may
>     take long time to reproduce the problem.
>=20
>     3. Start I/O on DM device representing luns L1 and L2 on host H1. W=
e
>     used* dt tool* for IO exercising.
>=20
>     4. Disable host ports of host H2 or any port of array A2 one after
>     the other (few times) OR disable and enable the same port of the
>     other host =96 few times (may be 4-5 times).
>=20
>     5. Application (dt tool) aborts with IO error on host H1.
>=20
>=20
>     =3D=3D=3D=3D=3D
>=20
>      Snippet of* sys log output* (while doing I/O on /dev/dm-0)
>=20
>=20
>     Feb  1 11:47:14 apwtest52 kernel: SCSI error : <2 0 0 1> return cod=
e
>     =3D 0x20000          =20
>=20
>     Feb  1 11:47:14 apwtest52 kernel: end_request: I/O error, dev sda,
>     sector 1584600
>=20
>     Feb  1 11:47:14 apwtest52 kernel: device-mapper: dm-multipath:
>     Failing path 8:0.     <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3Dpath failed, after
>     disabling/enabling the H2 host port 1
>=20
>     Feb  1 11:47:14 apwtest52 kernel: end_request: I/O error, dev sda,
>     sector 1584608
>=20
>     Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 1 1> return cod=
e
>     =3D 0x20000               =20
>=20
>     Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sdg,
>     sector 861400
>=20
>     Feb  1 11:47:45 apwtest52 kernel: device-mapper: dm-multipath:
>     Failing path 8:96.   <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3Dpath failed, after
>     disabling/enabling  the H2 host port 2
>=20
>     Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sdg,
>     sector 861408
>=20
>     Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 0 1> return cod=
e
>     =3D 0x20000
>=20
>     Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
>     sector 452760
>=20
>     Feb  1 11:47:45 apwtest52 kernel: device-mapper: dm-multipath:
>     Failing path 8:64.  <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3Dpath failed after
>     disabling/enabling the H2 host port 1
>=20
>     Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
>     sector 452768
>=20
>     Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 0 1> return cod=
e
>     =3D 0x20000
>=20
>     Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
>     sector 453784
>=20
>     Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
>     sector 453792
>=20
>     Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 0 1> return cod=
e
>     =3D 0x20000
>=20
>     Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
>     sector 454808
>=20
>     Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
>     sector 454816
>=20
>     Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 0 1> return cod=
e
>     =3D 0x20000
>=20
>     Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
>     sector 863960
>=20
>     Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
>     sector 863968
>=20
>     Feb  1 11:48:40 apwtest52 kernel: SCSI error : <2 0 1 1> return cod=
e
>     =3D 0x20000
>=20
>     Feb  1 11:48:40 apwtest52 kernel: end_request: I/O error, dev sdc,
>     sector 935384
>=20
>     Feb  1 11:48:40 apwtest52 kernel: device-mapper: dm-multipath:
>     Failing path 8:32.  <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D after disabling/enabling  the
>     H2 host port 2
>=20
>     Feb  1 11:48:40 apwtest52 kernel: end_request: I/O error, dev sdc,
>     sector 935392
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116924    <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DAll pa=
th to the device
>     /dev/dm-0 failed
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116925
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116926
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116927
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116928
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116929
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116930
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116931
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116932
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116933
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116934
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116935
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116936
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116937
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116938
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116939
>=20
>     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
>     logical block 116940
>=20
>                            =20
>=20
>     *Observations :*
>=20
>           As we do the port failure on the other host, paths of the dm
>     device is failed and the subsequent port (i.e A2 or H2 ports)
>     disabling/enabling results into more numbers of path failure and
>     that leads into all path failure condition, which in turn results
>     into IO error on RHEL4.0 U2/U3.
>=20
>          Through the device-mapper debug driver we are finding that the
>     there is no valid path in*/ __choose_pgpath()/* and */
>     m->current_pgpath/* (m is pointer to struct multipath) is null when
>     it comes to map_io() in dm-mpath.c.
>=20
>     Another observation is that we are not seeing any IO errors when th=
e
>     same test is executed on SLES9 SP3/SP4.
>=20
>     Please provide some pointers on why we are seeing this behavior or
>     is this a known thing at this point in time?
>=20
>     Thanks and regards
>=20
>     -Murthy
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>     =20
>=20
>     =20
>=20
>     --=20
>     dm-devel mailing list
>     dm-devel@redhat.com
>     https://www.redhat.com/mailman/listinfo/dm-devel
>=20
