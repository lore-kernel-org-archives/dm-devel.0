From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH v2] dm mpath: maintain reference count for
 underlying devices
Date: Tue, 20 Sep 2011 20:31:34 +0900
Message-ID: <4E787996.6050507@ce.jp.nec.com>
References: <1316181571-4691-1-git-send-email-snitzer@redhat.com>	<4E76E5E8.9040701@ce.jp.nec.com>
	<20110919143411.GA7965@redhat.com>	<4E7824CB.9030405@ce.jp.nec.com>
	<1316502834.2971.7.camel@dabdike>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1316502834.2971.7.camel@dabdike>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com, roland@purestorage.com, Al Viro <viro@zeniv.linux.org.uk>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi James,

On 09/20/11 16:13, James Bottomley wrote:
>> James's suggestion was to fix b) by not freeing elevator
>> until blk_release_queue() is called:
>>   https://lkml.org/lkml/2011/8/10/421
>> But it would hit the same issue that there's no guarantee
>> of q->queue_lock validity after blk_cleanup_queue().
>> James's other suggestion was to add a callback mechanism
>> for driver to free q->queue_lock.
> 
> Actually, there isn't a problem with this patch:  Any driver that
> expects blk_cleanup_queue to guarantee last use of the lock has to call
> it as the last releaser.  If it doesn't, it would oops (or would have
> oopsed before we started putting the block guards in).

'q->sysfs_lock' seems to protect the queue access via sysfs.
Are you sure it never delay the last put?

The separation of blk_cleanup_queue() and blk_release_queue()
was introduced with the following commit:

  commit 483f4afc421435b7cfe5e88f74eea0b73a476d75
  Author: Al Viro <viro@zeniv.linux.org.uk>
  Date:   Sat Mar 18 18:34:37 2006 -0500
  [PATCH] fix sysfs interaction and lifetime rules handling for queues

I added Al to Cc hoping he knows why elevator_exit() was
placed in blk_cleanup_queue() from the first time.

Other than the above concern, I have no objection to your patch.

>> I was trying to fix a) in the following thread:
>>   https://lkml.org/lkml/2011/8/18/103
>> but haven't gotten response from James so it seems rejected.
> 
> I think I said quite a few times that this would reintroduce the oops I
> was trying to fix.  Alan seems to think that there are sufficient guards
> just to move the blk_cleanup_queue(), but I'd prefer to get
> blk_cleanup_queue() working properly like the del method it's supposed
> to be.

I think you haven't mentioned what oops would be reintroduced.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
