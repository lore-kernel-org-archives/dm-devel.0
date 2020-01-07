From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
Date: Tue, 7 Jan 2020 18:14:17 +0000
Message-ID: <BYAPR04MB5749820C322B40C7DBBBCA02863F0@BYAPR04MB5749.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "msnitzer@redhat.com" <msnitzer@redhat.com>, "bvanassche@acm.org" <bvanassche@acm.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph, Matias Bjorling <Matias.Bjorling@wdc.com>, Stephen Bates <sbates@raithlin.com>, "roland@purestorage.com" <roland@purestorage.com>, "mpatocka@redhat.com" <mpatocka@redhat.com>, Keith Busch <kbusch@kernel.org>, "rwheeler@redhat.com" <rwheeler@redhat.com>, Hellwig <hch@lst.de>, "frederick.knight@netapp.com" <frederick.knight@netapp.com>, "zach.brown@ni.com" <zach.brown@ni.com>
List-Id: dm-devel.ids

Hi all,

* Background :-
-----------------------------------------------------------------------

Copy offload is a feature that allows file-systems or storage devices
to be instructed to copy files/logical blocks without requiring
involvement of the local CPU.

With reference to the RISC-V summit keynote [1] single threaded
performance is limiting due to Denard scaling and multi-threaded
performance is slowing down due Moore's law limitations. With the rise
of SNIA Computation Technical Storage Working Group (TWG) [2],
offloading computations to the device or over the fabrics is becoming
popular as there are several solutions available [2]. One of the common
operation which is popular in the kernel and is not merged yet is Copy
offload over the fabrics or on to the device.

* Problem :-
-----------------------------------------------------------------------

The original work which is done by Martin is present here [3]. The
latest work which is posted by Mikulas [4] is not merged yet. These two
approaches are totally different from each other. Several storage
vendors discourage mixing copy offload requests with regular READ/WRITE
I/O. Also, the fact that the operation fails if a copy request ever
needs to be split as it traverses the stack it has the unfortunate
side-effect of preventing copy offload from working in pretty much
every common deployment configuration out there.

* Current state of the work :-
-----------------------------------------------------------------------

With [3] being hard to handle arbitrary DM/MD stacking without
splitting the command in two, one for copying IN and one for copying
OUT. Which is then demonstrated by the [4] why [3] it is not a suitable
candidate. Also, with [4] there is an unresolved problem with the
two-command approach about how to handle changes to the DM layout
between an IN and OUT operations.

* Why Linux Kernel Storage System needs Copy Offload support now ?
-----------------------------------------------------------------------

With the rise of the SNIA Computational Storage TWG and solutions [2],
existing SCSI XCopy support in the protocol, recent advancement in the
Linux Kernel File System for Zoned devices (Zonefs [5]), Peer to Peer
DMA support in the Linux Kernel mainly for NVMe devices [7] and
eventually NVMe Devices and subsystem (NVMe PCIe/NVMeOF) will benefit
from Copy offload operation.

With this background we have significant number of use-cases which are
strong candidates waiting for outstanding Linux Kernel Block Layer Copy
Offload support, so that Linux Kernel Storage subsystem can to address
previously mentioned problems [1] and allow efficient offloading of the
data related operations. (Such as move/copy etc.)

For reference following is the list of the use-cases/candidates waiting
for Copy Offload support :-

1. SCSI-attached storage arrays.
2. Stacking drivers supporting XCopy DM/MD.
3. Computational Storage solutions.
7. File systems :- Local, NFS and Zonefs.
4. Block devices :- Distributed, local, and Zoned devices.
5. Peer to Peer DMA support solutions.
6. Potentially NVMe subsystem both NVMe PCIe and NVMeOF.

* What we will discuss in the proposed session ?
-----------------------------------------------------------------------

I'd like to propose a session to go over this topic to understand :-

1. What are the blockers for Copy Offload implementation ?
2. Discussion about having a file system interface.
3. Discussion about having right system call for user-space.
4. What is the right way to move this work forward ?
5. How can we help to contribute and move this work forward ?

* Required Participants :-
-----------------------------------------------------------------------

I'd like to invite block layer, device drivers and file system
developers to:-

1. Share their opinion on the topic.
2. Share their experience and any other issues with [4].
3. Uncover additional details that are missing from this proposal.

Required attendees :-

Martin K. Petersen
Jens Axboe
Christoph Hellwig
Bart Van Assche
Stephen Bates
Zach Brown
Roland Dreier
Ric Wheeler
Trond Myklebust
Mike Snitzer
Keith Busch
Sagi Grimberg
Hannes Reinecke
Frederick Knight
Mikulas Patocka
Matias Bj=F8rling

[1]https://content.riscv.org/wp-content/uploads/2018/12/A-New-Golden-Age-fo=
r-Computer-Architecture-History-Challenges-and-Opportunities-David-Patterso=
n-.pdf
[2] https://www.snia.org/computational
https://www.napatech.com/support/resources/solution-descriptions/napatech-s=
martnic-solution-for-hardware-offload/
      https://www.eideticom.com/products.html
https://www.xilinx.com/applications/data-center/computational-storage.html
[3] git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git xcopy
[4] https://www.spinics.net/lists/linux-block/msg00599.html
[5] https://lwn.net/Articles/793585/
[6] https://nvmexpress.org/new-nvmetm-specification-defines-zoned-
namespaces-zns-as-go-to-industry-technology/
[7] https://github.com/sbates130272/linux-p2pmem
[8] https://kernel.dk/io_uring.pdf

Regards,
Chaitanya
