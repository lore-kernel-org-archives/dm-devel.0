From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
Date: Fri, 10 Jan 2020 00:33:27 -0500
Message-ID: <yq1pnfrx4d4.fsf@oracle.com>
References: <BYAPR04MB5749820C322B40C7DBBBCA02863F0@BYAPR04MB5749.namprd04.prod.outlook.com>
	<fda88fd3-2d75-085e-ca15-a29f89c1e781@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <fda88fd3-2d75-085e-ca15-a29f89c1e781@acm.org> (Bart Van Assche's
	message of "Wed, 8 Jan 2020 19:18:54 -0800")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "roland@purestorage.com" <roland@purestorage.com>, "msnitzer@redhat.com" <msnitzer@redhat.com>, Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matias Bjorling <Matias.Bjorling@wdc.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Stephen Bates <sbates@raithlin.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "mpatocka@redhat.com" <mpatocka@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Keith Busch <kbusch@kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "rwheeler@redhat.com" <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>, "frederick.knight@netapp.com" <frederick.knight@netapp.com>, "zach.brown@ni.com" <zach.brown@ni.com>
List-Id: dm-devel.ids


Bart,

> * Copying must be supported not only within a single storage device but
>   also between storage devices.

Identifying which devices to permit copies between has been challenging.
That has since been addressed in T10.

> * VMware, which uses XCOPY (with a one-byte length ID, aka LID1).

I don't think LID1 vs LID4 is particularly interesting for the Linux use
case. It's just an additional command tag since the copy manager is a
third party.

> * Microsoft, which uses ODX (aka LID4 because it has a four-byte length
>   ID).

Microsoft uses the token commands.

-- 
Martin K. Petersen	Oracle Linux Engineering
