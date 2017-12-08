From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_dh: add new rdac devices
Date: Thu, 07 Dec 2017 21:34:34 -0500
Message-ID: <yq1bmjauev9.fsf@oracle.com>
References: <20171117210513.9667-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20171117210513.9667-1-xose.vazquez@gmail.com> (Xose Vazquez
        Perez's message of "Fri, 17 Nov 2017 22:05:13 +0100")
Sender: linux-scsi-owner@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


Xose,

> Add IBM 3542 and 3552, arrays: FAStT200 and FAStT500.
> Add full STK OPENstorage family, arrays: 9176, D173, D178, D210, D220, D240 and D280.
> Add STK BladeCtlr family, arrays: B210, B220, B240 and B280.
>
> These changes were done in multipath-tools time ago.

Applied to 4.16/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
