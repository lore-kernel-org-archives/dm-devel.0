From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] dm: Add support for data integrity to DM
Date: Tue, 23 Sep 2008 14:41:10 -0400
Message-ID: <1222195272-18674-1-git-send-email-martin.petersen@oracle.com>
References: <20080920211433.9e1a6872.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080920211433.9e1a6872.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@sourceware.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids


>>>>> "Andrew" == Andrew Morton <akpm@linux-foundation.org> writes:

Sorry about the delayed response.  I'm still on the road after LPC.

Andrew> For better or for worse, the developers of dm.c have chosen to
Andrew> keep the whole file presentable in an 80-col display.  This
Andrew> patch breaks that, and they might not like this.

I've broken the lines.


[Excessive BUG_ONs]

Andrew> This will provide no more information than the oops which will
Andrew> happen two lines later.

Debugging debris.  Gone.


>> +struct request_queue *dm_queue(struct mapped_device *md)
>> +{
>> +    return md->queue;
>> +}

Andrew> This (unused, undocumented) function should be inlined.

 - It's not unused.

 - return md->queue is more descriptive than anything I could possibly
   put in a comment.

 - None of the other accessor functions in DM are inlined.  I'll let
   Alasdair decide.

Updated patches follow.

-- 
Martin K. Petersen      Oracle Linux Engineering
