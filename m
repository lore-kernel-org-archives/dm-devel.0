From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: blacklist all RDAC devices for BLIST_NO_ULD_ATTACH
Date: Tue, 16 Aug 2016 00:58:58 -0400
Message-ID: <yq1shu5joml.fsf@sermon.lab.mkp.net>
References: <1471042563-5084-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1471042563-5084-1-git-send-email-xose.vazquez@gmail.com> (Xose
	Vazquez Perez's message of "Sat, 13 Aug 2016 00:56:03 +0200")
Sender: linux-scsi-owner@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Sean Stewart <Sean.Stewart@netapp.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

>>>>> "Xose" == Xose Vazquez Perez <xose.vazquez@gmail.com> writes:

Xose> "Universal Xport" LUN is used for in-band storage array
Xose> management.

Applied to 4.8/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
