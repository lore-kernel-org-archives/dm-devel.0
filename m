From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/7] dm: Fix the second dec_pending()
 argument in __split_and_process_bio()
Date: Thu, 10 Aug 2017 15:02:38 +0000
Message-ID: <1502377354.2309.1.camel@wdc.com>
References: <20170809183216.526-1-bart.vanassche@wdc.com>
	<20170809183216.526-2-bart.vanassche@wdc.com>
	<1502375298.8615.3.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1502375298.8615.3.camel@redhat.com>
Content-Language: en-US
Content-ID: <F3BA982E91B2F8409E78259C4DC67476@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "loberman@redhat.com" <loberman@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

On Thu, 2017-08-10 at 10:28 -0400, Laurence Oberman wrote:
> The soft lockups are gone for me with 10 parallel writes.
> I also have not seen a hard lockup so far.

That's great news!

> What is important to note is that if I use the [none] scheduler I am
> still stable but I will sporadically get the      ******
> "[38071.773471] device-mapper: multipath: blk_get_request() returned
> -11 - requeuing"
> 
> However that is not unexpected I guess.

Yes, this is expected.

> For the series except PATCH2/7 and including
> 
> [PATCH] block: Make blk_mq_delay_kick_requeue_list() rerun the queue at
> a quiet time
> 
> Tested-by: Laurence Oberman <loberman@redhat.com>

Thanks for the testing!

Bart.
