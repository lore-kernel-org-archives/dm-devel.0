From: "Greg Freemyer" <greg.freemyer@gmail.com>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Fri, 16 Jun 2006 20:35:45 -0400
Message-ID: <87f94c370606161735g726ff932r8de9147f7d645f8@mail.gmail.com>
References: <20060613235316.7f982af7@localhost>
	<62b0912f0606140419s60c30535pbcc97c30ef99c50d@mail.gmail.com>
	<Pine.LNX.4.63.0606141609310.7019@pingle.local.rsnet>
	<20060614215258.6aa76d0f@localhost>
	<62b0912f0606161121i52d05d08m66c5676ff7895da2@mail.gmail.com>
	<87f94c370606161132u2a7f0adeia790c73f4da58af0@mail.gmail.com>
	<20060617004730.70da7373@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060617004730.70da7373@localhost>
Content-Disposition: inline
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

> I honestly can't find any fault in the hardware, and no logical
> explanation for the software deciding to do this. Anyways, I'll ask the
> IDE guys. If some kind soul could inform me of the location of the
> latest version of their #upstream patch, I=B4d be mighty grateful. I
> didn't see any mention of it in the mailinglist archives for this month=
.
>
I suspect your looking in the wrong archives.

Quoting a 3-week old post from the linux-ide list:

The 'upstream' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

contains the following updates (queued for 2.6.18):

 drivers/ide/pci/amd74xx.c         |    7
 drivers/scsi/Makefile             |    2
 drivers/scsi/ahci.c               |  436 +++---
 drivers/scsi/ata_piix.c           |   25
 drivers/scsi/libata-bmdma.c       |  143 ++
 drivers/scsi/libata-core.c        | 2525 ++++++++++++++++++++++++-------=
-------
 drivers/scsi/libata-eh.c          | 1561 +++++++++++++++++++++++
 drivers/scsi/libata-scsi.c        |  408 +++---
 drivers/scsi/libata.h             |   24
 drivers/scsi/pdc_adma.c           |   10
 drivers/scsi/sata_mv.c            |   70 -
 drivers/scsi/sata_nv.c            |   13
 drivers/scsi/sata_promise.c       |   39
 drivers/scsi/sata_qstor.c         |   14
 drivers/scsi/sata_sil.c           |   66
 drivers/scsi/sata_sil24.c         |  615 +++++----
 drivers/scsi/sata_sis.c           |    3
 drivers/scsi/sata_svw.c           |    5

--=20
Greg Freemyer
The Norcross Group
Forensics for the 21st Century
