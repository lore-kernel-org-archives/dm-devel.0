From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: core: fix missing .cleanup_rq for
	SCSI hosts without request batching
Date: Wed, 18 Sep 2019 11:22:39 -0400
Message-ID: <yq1lful8w8w.fsf@oracle.com>
References: <20190807144948.28265-1-maier@linux.ibm.com>
	<20190807144948.28265-2-maier@linux.ibm.com>
	<CACVXFVM0tFj8CmcHON04_KjxR=QErCbUx0abJgG2W9OBb7akZA@mail.gmail.com>
	<yq136iccsbw.fsf@oracle.com>
	<bec80a65-9a8c-54a9-fe70-876fcbe3d592@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <bec80a65-9a8c-54a9-fe70-876fcbe3d592@linux.ibm.com> (Steffen
	Maier's message of "Wed, 18 Sep 2019 17:09:50 +0200")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Steffen Maier <maier@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>, linux-s390 <linux-s390@vger.kernel.org>, Benjamin Block <bblock@linux.ibm.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Lei <tom.leiming@gmail.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Hannes Reinecke <hare@suse.com>, "Ewan D . Milne" <emilne@redhat.com>, Ming Lei <ming.lei@redhat.com>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Mark Brown <broonie@kernel.org>, Mike Snitzer <snitzer@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids


Steffen,

> Martin, is it possible that you re-wrote your for-next and it now no
> longer contains a merged 5.4/scsi-postmerge with those fixes?  At
> least I cannot find the fix code in next-20190917 and it fails again
> for me.

Yes, looks like you're right. Not sure how I managed to mess that up. I
must have inadvertently done a reset in the wrong worktree because my
for-next branch maintenance script only does merges.

In any case, since Linus has pulled the block tree dependencies, I'll
rebase the postmerge branch on top of current linus/master and create a
new for-next.

Thanks for the heads-up!

-- 
Martin K. Petersen	Oracle Linux Engineering
