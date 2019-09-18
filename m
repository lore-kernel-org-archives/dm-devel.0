From: Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH 1/2] scsi: core: fix missing .cleanup_rq for
 SCSI hosts without request batching
Date: Wed, 18 Sep 2019 17:09:50 +0200
Message-ID: <bec80a65-9a8c-54a9-fe70-876fcbe3d592@linux.ibm.com>
References: <20190807144948.28265-1-maier@linux.ibm.com>
	<20190807144948.28265-2-maier@linux.ibm.com>
	<CACVXFVM0tFj8CmcHON04_KjxR=QErCbUx0abJgG2W9OBb7akZA@mail.gmail.com>
	<yq136iccsbw.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <yq136iccsbw.fsf@oracle.com>
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
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Lei <tom.leiming@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, Mark Brown <broonie@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390 <linux-s390@vger.kernel.org>, Benjamin Block <bblock@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "James E . J . Bottomley" <jejb@linux.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Hannes Reinecke <hare@suse.com>, "Ewan D . Milne" <emilne@redhat.com>, Ming Lei <ming.lei@redhat.com>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

On 8/8/19 4:18 AM, Martin K. Petersen wrote:
> 
> Ming,
> 
>>> +       .cleanup_rq     = scsi_cleanup_rq,
>>>          .busy           = scsi_mq_lld_busy,
>>>          .map_queues     = scsi_map_queues,
>>>   };
>>
>> This one is a cross-tree thing, either scsi/5.4/scsi-queue needs to
>> pull for-5.4/block, or do it after both land linus tree.
> 
> I'll set up an amalgamated for-next branch tomorrow.

Martin, is it possible that you re-wrote your for-next and it now no longer 
contains a merged 5.4/scsi-postmerge with those fixes?
At least I cannot find the fix code in next-20190917 and it fails again for me.


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
