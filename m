Return-Path: <SRS0=/P3g=KH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E46C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 08:03:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E52AB613B4
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 08:03:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E52AB613B4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=erwinvanlonden.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-P8Knu3NQMRSsEww0nncfjg-1; Wed, 12 May 2021 04:03:04 -0400
X-MC-Unique: P8Knu3NQMRSsEww0nncfjg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FB6A19251AB;
	Wed, 12 May 2021 08:03:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AE945D9C0;
	Wed, 12 May 2021 08:03:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 049C7E16F;
	Wed, 12 May 2021 08:02:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14C82tPw026624 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 May 2021 04:02:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 12F0810EB2AB; Wed, 12 May 2021 08:02:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D63910EB2A8
	for <dm-devel@redhat.com>; Wed, 12 May 2021 08:02:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9545083395A
	for <dm-devel@redhat.com>; Wed, 12 May 2021 08:02:51 +0000 (UTC)
Received: from gateway36.websitewelcome.com (gateway36.websitewelcome.com
	[192.185.200.11]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-587-LFAqBzY4PseVirhFZ6cTaw-1; Wed, 12 May 2021 04:02:49 -0400
X-MC-Unique: LFAqBzY4PseVirhFZ6cTaw-1
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
	by gateway36.websitewelcome.com (Postfix) with ESMTP id 6DA97400CA335
	for <dm-devel@redhat.com>; Wed, 12 May 2021 02:41:19 -0500 (CDT)
Received: from just2098.justhost.com ([173.254.31.45]) by cmsmtp with SMTP
	id gjUcloB7q8ElSgjUdlL6eh; Wed, 12 May 2021 02:41:19 -0500
X-Authority-Reason: nr=8
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:39340
	helo=[192.168.1.104])
	by just2098.justhost.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
	(envelope-from <erwin@erwinvanlonden.net>)
	id 1lgjUb-000VAM-Od; Wed, 12 May 2021 01:41:18 -0600
Message-ID: <9e1898e3905dfaff25ddef59a4e2fc6c590fc8e8.camel@erwinvanlonden.net>
From: Erwin van Londen <erwin@erwinvanlonden.net>
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
In-Reply-To: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
Date: Wed, 12 May 2021 17:36:02 +1000
MIME-Version: 1.0
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33)
X-AntiAbuse: This header was added to track abuse,
	please include it with any abuse report
X-AntiAbuse: Primary Hostname - just2098.justhost.com
X-AntiAbuse: Original Domain - redhat.com
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - erwinvanlonden.net
X-BWhitelist: no
X-Source-IP: 116.240.66.4
X-Source-L: No
X-Exim-ID: 1lgjUb-000VAM-Od
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([192.168.1.104])
	[116.240.66.4]:39340
X-Source-Auth: erwin@erwinvanlonden.net
X-Email-Count: 14
X-Source-Cap: aGl0YWNoaTE7aGl0YWNoaTE7anVzdDIwOTguanVzdGhvc3QuY29t
X-Local-Domain: yes
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"hch@lst.de" <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
 Offload
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============7856776635630984785=="

--===============7856776635630984785==
Content-Type: multipart/alternative; boundary="=-uSPdWrFKFXArN7HrIx2R"

--=-uSPdWrFKFXArN7HrIx2R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable



On Tue, 2021-05-11 at 00:15 +0000, Chaitanya Kulkarni wrote:
> Hi,
>=20
> * Background :-
> ---------------------------------------------------------------------
> --
>=20
> Copy offload is a feature that allows file-systems or storage devices
> to be instructed to copy files/logical blocks without requiring
> involvement of the local CPU.
>=20
> With reference to the RISC-V summit keynote [1] single threaded
> performance is limiting due to Denard scaling and multi-threaded
> performance is slowing down due Moore's law limitations. With the
> rise
> of SNIA Computation Technical Storage Working Group (TWG) [2],
> offloading computations to the device or over the fabrics is becoming
> popular as there are several solutions available [2]. One of the
> common
> operation which is popular in the kernel and is not merged yet is
> Copy
> offload over the fabrics or on to the device.
>=20
> * Problem :-
> ---------------------------------------------------------------------
> --
>=20
> The original work which is done by Martin is present here [3]. The
> latest work which is posted by Mikulas [4] is not merged yet. These
> two
> approaches are totally different from each other. Several storage
> vendors discourage mixing copy offload requests with regular
> READ/WRITE
> I/O. Also, the fact that the operation fails if a copy request ever
> needs to be split as it traverses the stack it has the unfortunate
> side-effect of preventing copy offload from working in pretty much
> every common deployment configuration out there.
>=20
> * Current state of the work :-
> ---------------------------------------------------------------------
> --
>=20
> With [3] being hard to handle arbitrary DM/MD stacking without
> splitting the command in two, one for copying IN and one for copying
> OUT. Which is then demonstrated by the [4] why [3] it is not a
> suitable
> candidate. Also, with [4] there is an unresolved problem with the
> two-command approach about how to handle changes to the DM layout
> between an IN and OUT operations.
>=20
> * Why Linux Kernel Storage System needs Copy Offload support now ?
> ---------------------------------------------------------------------
> --
>=20
> With the rise of the SNIA Computational Storage TWG and solutions
> [2],
> existing SCSI XCopy support in the protocol, recent advancement in
> the
> Linux Kernel File System for Zoned devices (Zonefs [5]), Peer to Peer
> DMA support in the Linux Kernel mainly for NVMe devices [7] and
> eventually NVMe Devices and subsystem (NVMe PCIe/NVMeOF) will benefit
> from Copy offload operation.
>=20
> With this background we have significant number of use-cases which
> are
> strong candidates waiting for outstanding Linux Kernel Block Layer
> Copy
> Offload support, so that Linux Kernel Storage subsystem can to
> address
> previously mentioned problems [1] and allow efficient offloading of
> the
> data related operations. (Such as move/copy etc.)
>=20
> For reference following is the list of the use-cases/candidates
> waiting
> for Copy Offload support :-
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
> ---------------------------------------------------------------------
> --
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
> ---------------------------------------------------------------------
> --
>=20
> I'd like to invite file system, block layer, and device drivers
> developers to:-
>=20
> 1. Share their opinion on the topic.
> 2. Share their experience and any other issues with [4].
> 3. Uncover additional details that are missing from this proposal.
>=20
> Required attendees :-
>=20
> Martin K. Petersen
> Jens Axboe
> Christoph Hellwig
> Bart Van Assche
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
> Keith Busch
>=20
> Regards,
> Chaitanya
>=20

+1 here. I would like to see how this pans out as many differences may
be observed from a standards, implementation and operations point of
view.

> [1]https://content.riscv.org/wp-content/uploads/2018/12/A-New-Golden-Age-=
for-Computer-Architecture-History-Challenges-and-Opportunities-David-Patter=
son-.pdf
> [2] https://www.snia.org/computational
> https://www.napatech.com/support/resources/solution-descriptions/napatech=
-smartnic-solution-for-hardware-offload/
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 https://www.eideticom.com/products.html
> https://www.xilinx.com/applications/data-center/computational-storage.htm=
l
> [3] git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git xcopy
> [4] https://www.spinics.net/lists/linux-block/msg00599.html
> [5] https://lwn.net/Articles/793585/
> [6] https://nvmexpress.org/new-nvmetm-specification-defines-zoned-
> namespaces-zns-as-go-to-industry-technology/
> [7] https://github.com/sbates130272/linux-p2pmem
> [8] https://kernel.dk/io_uring.pdf
>=20
>=20
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>=20

--=-uSPdWrFKFXArN7HrIx2R
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div><br></div><div><span></span></div><div><br></=
div><div>On Tue, 2021-05-11 at 00:15 +0000, Chaitanya Kulkarni wrote:</div>=
<blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729f=
cf solid;padding-left:1ex"><div>Hi,<br></div><div><br></div><div>* Backgrou=
nd :-<br></div><div>-------------------------------------------------------=
----------------<br></div><div><br></div><div>Copy offload is a feature tha=
t allows file-systems or storage devices<br></div><div>to be instructed to =
copy files/logical blocks without requiring<br></div><div>involvement of th=
e local CPU.<br></div><div><br></div><div>With reference to the RISC-V summ=
it keynote [1] single threaded<br></div><div>performance is limiting due to=
 Denard scaling and multi-threaded<br></div><div>performance is slowing dow=
n due Moore's law limitations. With the rise<br></div><div>of SNIA Computat=
ion Technical Storage Working Group (TWG) [2],<br></div><div>offloading com=
putations to the device or over the fabrics is becoming<br></div><div>popul=
ar as there are several solutions available [2]. One of the common<br></div=
><div>operation which is popular in the kernel and is not merged yet is Cop=
y<br></div><div>offload over the fabrics or on to the device.<br></div><div=
><br></div><div>* Problem :-<br></div><div>--------------------------------=
---------------------------------------<br></div><div><br></div><div>The or=
iginal work which is done by Martin is present here [3]. The<br></div><div>=
latest work which is posted by Mikulas [4] is not merged yet. These two<br>=
</div><div>approaches are totally different from each other. Several storag=
e<br></div><div>vendors discourage mixing copy offload requests with regula=
r READ/WRITE<br></div><div>I/O. Also, the fact that the operation fails if =
a copy request ever<br></div><div>needs to be split as it traverses the sta=
ck it has the unfortunate<br></div><div>side-effect of preventing copy offl=
oad from working in pretty much<br></div><div>every common deployment confi=
guration out there.<br></div><div><br></div><div>* Current state of the wor=
k :-<br></div><div>--------------------------------------------------------=
---------------<br></div><div><br></div><div>With [3] being hard to handle =
arbitrary DM/MD stacking without<br></div><div>splitting the command in two=
, one for copying IN and one for copying<br></div><div>OUT. Which is then d=
emonstrated by the [4] why [3] it is not a suitable<br></div><div>candidate=
. Also, with [4] there is an unresolved problem with the<br></div><div>two-=
command approach about how to handle changes to the DM layout<br></div><div=
>between an IN and OUT operations.<br></div><div><br></div><div>* Why Linux=
 Kernel Storage System needs Copy Offload support now ?<br></div><div>-----=
------------------------------------------------------------------<br></div=
><div><br></div><div>With the rise of the SNIA Computational Storage TWG an=
d solutions [2],<br></div><div>existing SCSI XCopy support in the protocol,=
 recent advancement in the<br></div><div>Linux Kernel File System for Zoned=
 devices (Zonefs [5]), Peer to Peer<br></div><div>DMA support in the Linux =
Kernel mainly for NVMe devices [7] and<br></div><div>eventually NVMe Device=
s and subsystem (NVMe PCIe/NVMeOF) will benefit<br></div><div>from Copy off=
load operation.<br></div><div><br></div><div>With this background we have s=
ignificant number of use-cases which are<br></div><div>strong candidates wa=
iting for outstanding Linux Kernel Block Layer Copy<br></div><div>Offload s=
upport, so that Linux Kernel Storage subsystem can to address<br></div><div=
>previously mentioned problems [1] and allow efficient offloading of the<br=
></div><div>data related operations. (Such as move/copy etc.)<br></div><div=
><br></div><div>For reference following is the list of the use-cases/candid=
ates waiting<br></div><div>for Copy Offload support :-<br></div><div><br></=
div><div>1. SCSI-attached storage arrays.<br></div><div>2. Stacking drivers=
 supporting XCopy DM/MD.<br></div><div>3. Computational Storage solutions.<=
br></div><div>7. File systems :- Local, NFS and Zonefs.<br></div><div>4. Bl=
ock devices :- Distributed, local, and Zoned devices.<br></div><div>5. Peer=
 to Peer DMA support solutions.<br></div><div>6. Potentially NVMe subsystem=
 both NVMe PCIe and NVMeOF.<br></div><div><br></div><div>* What we will dis=
cuss in the proposed session ?<br></div><div>------------------------------=
-----------------------------------------<br></div><div><br></div><div>I'd =
like to propose a session to go over this topic to understand :-<br></div><=
div><br></div><div>1. What are the blockers for Copy Offload implementation=
 ?<br></div><div>2. Discussion about having a file system interface.<br></d=
iv><div>3. Discussion about having right system call for user-space.<br></d=
iv><div>4. What is the right way to move this work forward ?<br></div><div>=
5. How can we help to contribute and move this work forward ?<br></div><div=
><br></div><div>* Required Participants :-<br></div><div>------------------=
-----------------------------------------------------<br></div><div><br></d=
iv><div>I'd like to invite file system, block layer, and device drivers<br>=
</div><div>developers to:-<br></div><div><br></div><div>1. Share their opin=
ion on the topic.<br></div><div>2. Share their experience and any other iss=
ues with [4].<br></div><div>3. Uncover additional details that are missing =
from this proposal.<br></div><div><br></div><div>Required attendees :-<br><=
/div><div><br></div><div>Martin K. Petersen<br></div><div>Jens Axboe<br></d=
iv><div>Christoph Hellwig<br></div><div>Bart Van Assche<br></div><div>Zach =
Brown<br></div><div>Roland Dreier<br></div><div>Ric Wheeler<br></div><div>T=
rond Myklebust<br></div><div>Mike Snitzer<br></div><div>Keith Busch<br></di=
v><div>Sagi Grimberg<br></div><div>Hannes Reinecke<br></div><div>Frederick =
Knight<br></div><div>Mikulas Patocka<br></div><div>Keith Busch<br></div><di=
v><br></div><div>Regards,<br></div><div>Chaitanya<br></div><div><br></div><=
/blockquote><div><br></div><div>+1 here. I would like to see how this pans =
out as many differences may be observed from a standards, implementation an=
d operations point of view.</div><div><br></div><blockquote type=3D"cite" s=
tyle=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex">=
<div>[1]<a href=3D"https://content.riscv.org/wp-content/uploads/2018/12/A-N=
ew-Golden-Age-for-Computer-Architecture-History-Challenges-and-Opportunitie=
s-David-Patterson-.pdf">https://content.riscv.org/wp-content/uploads/2018/1=
2/A-New-Golden-Age-for-Computer-Architecture-History-Challenges-and-Opportu=
nities-David-Patterson-.pdf</a><br></div><div>[2] <a href=3D"https://www.sn=
ia.org/computational">https://www.snia.org/computational</a><br></div><div>=
<a href=3D"https://www.napatech.com/support/resources/solution-descriptions=
/napatech-smartnic-solution-for-hardware-offload/">https://www.napatech.com=
/support/resources/solution-descriptions/napatech-smartnic-solution-for-har=
dware-offload/</a><br></div><div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href=3D"=
https://www.eideticom.com/products.html">https://www.eideticom.com/products=
.html</a><br></div><div><a href=3D"https://www.xilinx.com/applications/data=
-center/computational-storage.html">https://www.xilinx.com/applications/dat=
a-center/computational-storage.html</a><br></div><div>[3] git://git.kernel.=
org/pub/scm/linux/kernel/git/mkp/linux.git xcopy<br></div><div>[4] <a href=
=3D"https://www.spinics.net/lists/linux-block/msg00599.html">https://www.sp=
inics.net/lists/linux-block/msg00599.html</a><br></div><div>[5] <a href=3D"=
https://lwn.net/Articles/793585/">https://lwn.net/Articles/793585/</a><br><=
/div><div>[6] <a href=3D"https://nvmexpress.org/new-nvmetm-specification-de=
fines-zoned">https://nvmexpress.org/new-nvmetm-specification-defines-zoned<=
/a>-<br></div><div>namespaces-zns-as-go-to-industry-technology/<br></div><d=
iv>[7] <a href=3D"https://github.com/sbates130272/linux-p2pmem">https://git=
hub.com/sbates130272/linux-p2pmem</a><br></div><div>[8] <a href=3D"https://=
kernel.dk/io_uring.pdf">https://kernel.dk/io_uring.pdf</a><br></div><div><b=
r></div><div><br></div><div><br></div><div><br></div><div>--<br></div><div>=
dm-devel mailing list<br></div><div><a href=3D"mailto:dm-devel@redhat.com">=
dm-devel@redhat.com</a><br></div><div><a href=3D"https://listman.redhat.com=
/mailman/listinfo/dm-devel">https://listman.redhat.com/mailman/listinfo/dm-=
devel</a><br></div><div><br></div></blockquote></body></html>

--=-uSPdWrFKFXArN7HrIx2R--

--===============7856776635630984785==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============7856776635630984785==--

