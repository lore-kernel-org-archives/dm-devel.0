From: <joshi.k@samsung.com>
Subject: RE: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Date: Thu, 13 Feb 2020 10:41:28 +0530
Message-ID: <00d001d5e22c$0ebf63c0$2c3e2b40$@samsung.com>
References: <CGME20200107181551epcas5p4f47eeafd807c28a26b4024245c4e00ab@epcas5p4.samsung.com>
        <BYAPR04MB5749820C322B40C7DBBBCA02863F0@BYAPR04MB5749.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <BYAPR04MB5749820C322B40C7DBBBCA02863F0@BYAPR04MB5749.namprd04.prod.outlook.com>
Content-Language: en-us
Sender: linux-block-owner@vger.kernel.org
To: 'Chaitanya Kulkarni' <Chaitanya.Kulkarni@wdc.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com, lsf-pc@lists.linux-foundation.org
Cc: axboe@kernel.dk, msnitzer@redhat.com, bvanassche@acm.org, "'Martin K. Petersen'" <martin.petersen@oracle.com>, 'Matias Bjorling' <Matias.Bjorling@wdc.com>, 'Stephen Bates' <sbates@raithlin.com>, roland@purestorage.com, joshi.k@samsung.com, mpatocka@redhat.com, hare@suse.de, 'Keith Busch' <kbusch@kernel.org>, rwheeler@redhat.com, 'Christoph Hellwig' <hch@lst.de>, frederick.knight@netapp.com, zach.brown@ni.comjoshi.k@samsung.com, javier@javigon.com
List-Id: dm-devel.ids

I am very keen on this topic.
I've been doing some work for =22NVMe simple copy=22, and would like to dis=
cuss
and solicit opinion of community on the following:

- Simple-copy, unlike XCOPY and P2P, is limited to copy within a single
namespace. Some of the problems that original XCOPY work =5B2=5D faced may =
not
be applicable for simple-copy, e.g. split of single copy due to differing
device-specific limits.
Hope I'm not missing something in thinking so?

- =5BBlock I/O=5D Async interface (through io-uring or AIO) so that multipl=
e
copy operations can be queued.

- =5BFile I/O to user-space=5D I think it may make sense to extend
copy_file_range API to do in-device copy as well.

- =5BF2FS=5D GC of F2FS may leverage the interface. Currently it uses
page-cache, which is fair. But, for relatively cold/warm data (if that need=
s
to be garbage-collected anyway), it can rather bypass the Host and skip
running into a scenario when something (useful) gets thrown out of cache.

- =5BZNS=5D ZNS users (kernel or user-space) would be log-structured, and w=
ill
benefit from internal copy. But failure scenarios (partial copy,
write-pointer position) need to be discussed.

Thanks,
Kanchan

> -----Original Message-----
> From: linux-nvme =5Bmailto:linux-nvme-bounces=40lists.infradead.org=5D On=
 Behalf
> Of Chaitanya Kulkarni
> Sent: Tuesday, January 7, 2020 11:44 PM
> To: linux-block=40vger.kernel.org; linux-scsi=40vger.kernel.org; linux-
> nvme=40lists.infradead.org; dm-devel=40redhat.com; lsf-pc=40lists.linux-
> foundation.org
> Cc: axboe=40kernel.dk; msnitzer=40redhat.com; bvanassche=40acm.org; Marti=
n K.
> Petersen <martin.petersen=40oracle.com>; Matias Bjorling
> <Matias.Bjorling=40wdc.com>; Stephen Bates <sbates=40raithlin.com>;
> roland=40purestorage.com; mpatocka=40redhat.com; hare=40suse.de; Keith Bu=
sch
> <kbusch=40kernel.org>; rwheeler=40redhat.com; Christoph Hellwig <hch=40ls=
t.de>;
> frederick.knight=40netapp.com; zach.brown=40ni.com
> Subject: =5BLSF/MM/BFP ATTEND=5D =5BLSF/MM/BFP TOPIC=5D Storage: Copy Off=
load
>=20
> Hi all,
>=20
> * Background :-
> -----------------------------------------------------------------------
>=20
> Copy offload is a feature that allows file-systems or storage devices to
be
> instructed to copy files/logical blocks without requiring involvement of
the local
> CPU.
>=20
> With reference to the RISC-V summit keynote =5B1=5D single threaded
performance is
> limiting due to Denard scaling and multi-threaded performance is slowing
down
> due Moore's law limitations. With the rise of SNIA Computation Technical
> Storage Working Group (TWG) =5B2=5D, offloading computations to the devic=
e or
> over the fabrics is becoming popular as there are several solutions
available =5B2=5D.
> One of the common operation which is popular in the kernel and is not
merged
> yet is Copy offload over the fabrics or on to the device.
>=20
> * Problem :-
> -----------------------------------------------------------------------
>=20
> The original work which is done by Martin is present here =5B3=5D. The la=
test
work
> which is posted by Mikulas =5B4=5D is not merged yet. These two approache=
s are
> totally different from each other. Several storage vendors discourage
mixing
> copy offload requests with regular READ/WRITE I/O. Also, the fact that th=
e
> operation fails if a copy request ever needs to be split as it traverses
the stack it
> has the unfortunate side-effect of preventing copy offload from working i=
n
> pretty much every common deployment configuration out there.
>=20
> * Current state of the work :-
> -----------------------------------------------------------------------
>=20
> With =5B3=5D being hard to handle arbitrary DM/MD stacking without splitt=
ing
the
> command in two, one for copying IN and one for copying OUT. Which is then
> demonstrated by the =5B4=5D why =5B3=5D it is not a suitable candidate. A=
lso, with
=5B4=5D
> there is an unresolved problem with the two-command approach about how to
> handle changes to the DM layout between an IN and OUT operations.
>=20
> * Why Linux Kernel Storage System needs Copy Offload support now ?
> -----------------------------------------------------------------------
>=20
> With the rise of the SNIA Computational Storage TWG and solutions =5B2=5D=
,
existing
> SCSI XCopy support in the protocol, recent advancement in the Linux Kerne=
l
File
> System for Zoned devices (Zonefs =5B5=5D), Peer to Peer DMA support in th=
e
Linux
> Kernel mainly for NVMe devices =5B7=5D and eventually NVMe Devices and
subsystem
> (NVMe PCIe/NVMeOF) will benefit from Copy offload operation.
>=20
> With this background we have significant number of use-cases which are
strong
> candidates waiting for outstanding Linux Kernel Block Layer Copy Offload
> support, so that Linux Kernel Storage subsystem can to address previously
> mentioned problems =5B1=5D and allow efficient offloading of the data rel=
ated
> operations. (Such as move/copy etc.)
>=20
> For reference following is the list of the use-cases/candidates waiting
for Copy
> Offload support :-
>=20
> 1. SCSI-attached storage arrays.
> 2. Stacking drivers supporting XCopy DM/MD.
> 3. Computational Storage solutions.
> 7. File systems :- Local, NFS and Zonefs.
> 4. Block devices :- Distributed, local, and Zoned devices.
> 5. Peer to Peer DMA support solutions.
> 6. Potentially NVMe subsystem both NVMe PCIe and NVMeOF.
>=20
> * What we will discuss in the proposed session ?
> -----------------------------------------------------------------------
>=20
> I'd like to propose a session to go over this topic to understand :-
>=20
> 1. What are the blockers for Copy Offload implementation ?
> 2. Discussion about having a file system interface.
> 3. Discussion about having right system call for user-space.
> 4. What is the right way to move this work forward ?
> 5. How can we help to contribute and move this work forward ?
>=20
> * Required Participants :-
> -----------------------------------------------------------------------
>=20
> I'd like to invite block layer, device drivers and file system developers
to:-
>=20
> 1. Share their opinion on the topic.
> 2. Share their experience and any other issues with =5B4=5D.
> 3. Uncover additional details that are missing from this proposal.
>=20
> Required attendees :-
>=20
> Martin K. Petersen
> Jens Axboe
> Christoph Hellwig
> Bart Van Assche
> Stephen Bates
> Zach Brown
> Roland Dreier
> Ric Wheeler
> Trond Myklebust
> Mike Snitzer
> Keith Busch
> Sagi Grimberg
> Hannes Reinecke
> Frederick Knight
> Mikulas Patocka
> Matias Bj=F8rling=0D=0A>=20=0D=0A>=20=5B1=5Dhttps://protect2.fireeye.com/=
url?k=3D22656b2d-7fb63293-2264e062-=0D=0A>=200cc47a31ba82-2308b42828f59271&=
u=3Dhttps://content.riscv.org/wp-=0D=0A>=20content/uploads/2018/12/A-New-Go=
lden-Age-for-Computer-Architecture-=0D=0A>=20History-Challenges-and-Opportu=
nities-David-Patterson-.pdf=0D=0A>=20=5B2=5D=20https://protect2.fireeye.com=
/url?k=3D44e3336c-19306ad2-44e2b823-=0D=0A>=200cc47a31ba82-70c015d1b0aaeb3f=
&u=3Dhttps://www.snia.org/computational=0D=0A>=20https://protect2.fireeye.c=
om/url?k=3Da366c2dc-feb59b62-a3674993-=0D=0A>=200cc47a31ba82-=0D=0A>=2020bc=
672ec82b62b3&u=3Dhttps://www.napatech.com/support/resources/solution=0D=0A>=
=20-descriptions/napatech-smartnic-solution-for-hardware-offload/=0D=0A>=20=
=20=20=20=20=20=20https://protect2.fireeye.com/url?k=3D90febdca-cd2de474-90=
ff3685-=0D=0A>=200cc47a31ba82-=0D=0A>=20277b6b09d36e6567&u=3Dhttps://www.ei=
deticom.com/products.html=0D=0A>=20https://protect2.fireeye.com/url?k=3D419=
5e835-1c46b18b-4194637a-=0D=0A>=200cc47a31ba82-=0D=0A>=20a11a4c2e4f0d8a58&u=
=3Dhttps://www.xilinx.com/applications/data-=0D=0A>=20center/computational-=
storage.html=0D=0A>=20=5B3=5D=20git://git.kernel.org/pub/scm/linux/kernel/g=
it/mkp/linux.git=20xcopy=20=5B4=5D=0D=0A>=20https://protect2.fireeye.com/ur=
l?k=3D455ff23c-188cab82-455e7973-=0D=0A>=200cc47a31ba82-e8e6695611f4cc1f&u=
=3Dhttps://www.spinics.net/lists/linux-=0D=0A>=20block/msg00599.html=0D=0A>=
=20=5B5=5D=20https://lwn.net/Articles/793585/=0D=0A>=20=5B6=5D=20https://pr=
otect2.fireeye.com/url?k=3D08eb17f6-55384e48-08ea9cb9-=0D=0A>=200cc47a31ba8=
2-1b80cd012aa4f6a3&u=3Dhttps://nvmexpress.org/new-nvmetm-=0D=0A>=20specific=
ation-defines-zoned-=0D=0A>=20namespaces-zns-as-go-to-industry-technology/=
=0D=0A>=20=5B7=5D=20https://protect2.fireeye.com/url?k=3D54b372ee-09602b50-=
54b2f9a1-=0D=0A>=200cc47a31ba82-ea67c60915bfd63b&u=3Dhttps://github.com/sba=
tes130272/linux-=0D=0A>=20p2pmem=0D=0A>=20=5B8=5D=20https://protect2.fireey=
e.com/url?k=3D30c2303c-6d116982-30c3bb73-=0D=0A>=200cc47a31ba82-95f0ddc1afe=
635fe&u=3Dhttps://kernel.dk/io_uring.pdf=0D=0A>=20=0D=0A>=20Regards,=0D=0A>=
=20Chaitanya=0D=0A>=20=0D=0A>=20___________________________________________=
____=0D=0A>=20linux-nvme=20mailing=20list=0D=0A>=20linux-nvme=40lists.infra=
dead.org=0D=0A>=20https://protect2.fireeye.com/url?k=3Dd145dc5a-8c9685e4-d1=
445715-=0D=0A>=200cc47a31ba82-=0D=0A>=203bf90c648f67ccdd&u=3Dhttp://lists.i=
nfradead.org/mailman/listinfo/linux-nvme=0D=0A=0D=0A
