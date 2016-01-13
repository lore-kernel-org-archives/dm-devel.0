From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: 4.4 regression/bisected: error message due to "block/sd: Fix device-imposed transfer length limits"
Date: Wed, 13 Jan 2016 08:22:48 -0500
Message-ID: <yq1ziw9vck7.fsf@sermon.lab.mkp.net>
References: <56964DE0.60407@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <56964DE0.60407@de.ibm.com> (Christian Borntraeger's message of
	"Wed, 13 Jan 2016 14:15:12 +0100")
Sender: linux-scsi-owner@vger.kernel.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

>>>>> "Christian" == Christian Borntraeger <borntraeger@de.ibm.com> writes:

Christian> device-mapper: table: 253:4: adding target device sdq caused
Christian> an alignment inconsistency: physical_block_size=4096,
Christian> logical_block_size=512, alignment_offset=0, start=0

Odd.

Please provide the output of:

# sg_readcap -l /dev/sdN
# sg_vpd -p bl /dev/sdN

-- 
Martin K. Petersen	Oracle Linux Engineering
