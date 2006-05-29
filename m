From: "Matthias Rudolph" <Matthias.Rudolph@hds.com>
Subject: Hitachi storage and Multipath-Tools
Date: Mon, 29 May 2006 15:56:35 +0100
Message-ID: <C67364BD62907640A033D1F4094CA7B7043CECBC@UKSPKEVS101.corp.hds.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com, Matthias.Rudolph@hds.com
List-Id: dm-devel.ids

Hi Christopher,

I have checked the latest file hwtable.c on /pub/mirrors/kernel.org/pub/s=
cm/linux/storage/multipath-tools and I do not understand the entries for =
vendor HP and Hitachi. I hope you can help.

Here are some background information:

Vendor Hitachi build two different storage classes with fibre channel con=
nectivity: Enterprise class and Modular class.
The SCSI product inquiry for Enterprise classe always begins with "OPEN-"=
 and the rest of the string depends on the LUN type (for example "OPEN-V*=
10" for a MetaLUN/LUSE build from 10 different internal LUNs). The LUNs o=
f the Enterprise Class can be accessed active/active (multibus). There ar=
e different versions of the Enterprise class and all with nearly the same=
 internal crossbar/switch architecture (no bus): 9910, 9960, 9970V, 9980V=
, USP100, USP600 and USP1100.
The other storage class made by Hitachi is the Modular class. The SCSI pr=
oduct inquiry for Modular class always begins with "DF". The LUNs of the =
Modular class can be accessed active/passive (group_by_prio) and for spre=
ading the load you need a prioritizer (pp_hds_modular). There are also a =
lot of different versions of the Hitachi Modular class and all with a two=
-controller-architecture: 9200, 9520V, 9530V, 9570V, 9580V, 9585V, WMS, A=
MS500, AMS1000 and so on. The Hitachi internal naming for 9200 is DF500x,=
 for 95xxV is DF600x and for AMS/WMS is DF700x. The SCSI product inquiry =
changes depending on the Hitachi internal name and the LUN type (for exam=
ple "DF600F-CM" for a 9580V LUN with Command Device functionality.

I am an employee of HDS - Hitachi Data Systems. It is a 100% doughter of =
Hitachi Limited in Japan and we are the responsible for selling and for s=
ervice of the Storage products from Hitachi worldwide.

Hawlett Packard (HP) does also sell the Hitachi Enterprise class. The onl=
y difference is the different SCSI inquiry for vendor (HP) and the names.=
 The SCSI inquiry for product "OPEN-" is the same. HP sells the Hitachi E=
nterprise class under the name XPxxxxx.
The product A6189A is HPs own developed Modular storage class and is sell=
ed under the name EVA. It is not compatible to Hitachi products.

SUN Microsystems is also selling the Hitachi Enterprise class but they do=
 not change the SCSI vendor inquiry. They use "HITACHI" as vendor string.



Here are the questions to the latest hwtable.c:


	{
		.vendor        =3D "HITACHI",
		.product       =3D "{A6189A,OPEN-}",
		.getuid        =3D DEFAULT_GETUID,
		.getprio       =3D NULL,
		.features      =3D DEFAULT_FEATURES,
		.hwhandler     =3D DEFAULT_HWHANDLER,
		.selector      =3D DEFAULT_SELECTOR,
		.pgpolicy      =3D MULTIBUS,
		.pgfailback    =3D FAILBACK_UNDEF,
		.rr_weight     =3D RR_WEIGHT_NONE,
		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
		.minio         =3D DEFAULT_MINIO,
		.checker_name  =3D READSECTOR0,
	},
The product A6189A is a HP product. It needs an entry under vendor=3D"HP"=
. The product should only be "OPEN-" and the vendor should be "{HITACHI,H=
P}".


	{
		.vendor        =3D "HP",
		.product       =3D "DF[456]00",
		.getuid        =3D DEFAULT_GETUID,
		.getprio       =3D NULL,
		.features      =3D DEFAULT_FEATURES,
		.hwhandler     =3D DEFAULT_HWHANDLER,
		.selector      =3D DEFAULT_SELECTOR,
		.pgpolicy      =3D MULTIBUS,
		.pgfailback    =3D FAILBACK_UNDEF,
		.rr_weight     =3D RR_WEIGHT_NONE,
		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
		.minio         =3D DEFAULT_MINIO,
		.checker_name  =3D READSECTOR0,
	},
The vendor here should be "HITACHI" and the product should be "DF". getpr=
io should be "/sbin/pp_hds_modular %d", pgpolicy=3DGROUP_BY_PRIO and pgfa=
ilback=3D FAILBACK_IMMEDIATE.

Sorry for the confusion....

Regards
Matthias Rudolph
Hitachi Data Systems


-----Urspr=FCngliche Nachricht-----
Von: Matthias Rudolph=20
Gesendet: Mittwoch, 26. April 2006 17:15
An: 'dm-devel@redhat.com'
Cc: 'christophe varoqui'
Betreff: Re: [dm-devel] Hitachi prioritizer ?


Hi Christopher,

sorry - the software development is not my daily business....

The file hwtable.c should be changed from:

...
r +=3D store_hwe(hw, "HITACHI", "DF400", MULTIBUS, DEFAULT_GETUID);
r +=3D store_hwe(hw, "HITACHI", "DF500", MULTIBUS, DEFAULT_GETUID);
r +=3D store_hwe(hw, "HITACHI", "DF600", MULTIBUS, DEFAULT_GETUID);
...

to:

...
r +=3D store_hwe(hw, "HITACHI", "DF", GROUP_BY_PRIO, DEFAULT_GETUID, "/sb=
in/pp_hds_modular %d", "0", "0", "readsector0", FAILBACK_IMMEDIATE);
r +=3D store_hwe(hw, "HITACHI", "OPEN-", MULTIBUS, DEFAULT_GETUID);
...

First entry is for Hitachi Modular Storage Active/Passive. The Product in=
quiry always begins with "DF".
Second entry is for Hitachi Enterprise Storage Active/Active. The Product=
 inquiry always begins with "OPEN-".

Regards, Matthias
