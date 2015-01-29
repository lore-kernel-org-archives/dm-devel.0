From: Keith Busch <keith.busch@intel.com>
Subject: Re: blk-mq DM changes for 3.20 [was: Re: blk-mq request
 allocation stalls]X
Date: Thu, 29 Jan 2015 22:43:56 +0000 (UTC)
Message-ID: <alpine.LNX.2.00.1501292233230.15481@localhost.lm.intel.com>
References: <54B3F78D.2020704@kernel.dk> <54B3FE89.200@sandisk.com>
	<54B3FFAE.4070609@kernel.dk>
	<alpine.LNX.2.00.1501121738000.4026@localhost.lm.intel.com>
	<54B40E8A.6010005@kernel.dk>
	<alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
	<alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
	<54B532EE.20700@kernel.dk> <20150127184258.GB2078@redhat.com>
	<54C91172.10002@kernel.dk> <20150128174442.GA11951@redhat.com>
	<54C92127.4030408@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54C92127.4030408@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Wed, 28 Jan 2015, Jens Axboe wrote:
> On 01/28/2015 10:44 AM, Mike Snitzer wrote:
>> On Wed, Jan 28 2015 at 11:42am -0500,
>> Jens Axboe <axboe@kernel.dk> wrote:
>>> I'd prefer to take these prep patches through the block tree.
>> 
>> Great, should I send the patches or can you cherry-pick?
>
> I already cherry picked them, they are in the for-3.20/core branch.

I might be getting ahead of myself for trying this right now (sorry if
that's the case) but 'for-3.20/core' is missing necessary parts of the
series and hits a BUG_ON at blk-core.c:2333. The original request is
initialized when setting up the clone, and in this branch, that happens
in prep_fn before the request was dequeued so it's not in the queuelist
when it started.

One of my commits relocated the initialization, but I didn't realize it
had a hard dependency on the follow-on commit.  Should we reorder that
part of the series?
