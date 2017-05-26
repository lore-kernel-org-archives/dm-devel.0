From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 02/13] scsi/osd: don't save block errors into
	req_results
Date: Fri, 26 May 2017 16:24:42 -0400
Message-ID: <yq17f13qsc5.fsf@oracle.com>
References: <20170526085620.3113-1-hch@lst.de>
	<20170526085620.3113-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170526085620.3113-3-hch@lst.de> (Christoph Hellwig's message
	of "Fri, 26 May 2017 11:56:09 +0300")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids


Christoph,

> We will only have sense data if the command exectured and got a SCSI
> result, so this is pointless.

"executed"

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
