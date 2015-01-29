From: Keith Busch <keith.busch@intel.com>
Subject: Re: blk-mq DM changes for 3.20 [was: Re: blk-mq request
 allocation stalls]X
Date: Thu, 29 Jan 2015 23:44:38 +0000 (UTC)
Message-ID: <alpine.LNX.2.00.1501292310330.15481@localhost.lm.intel.com>
References: <alpine.LNX.2.00.1501121738000.4026@localhost.lm.intel.com>
	<54B40E8A.6010005@kernel.dk>
	<alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
	<alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
	<54B532EE.20700@kernel.dk>
	<20150127184258.GB2078@redhat.com> <54C91172.10002@kernel.dk>
	<20150128174442.GA11951@redhat.com> <54C92127.4030408@kernel.dk>
	<alpine.LNX.2.00.1501292233230.15481@localhost.lm.intel.com>
	<20150129230924.GA24657@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150129230924.GA24657@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Thu, 29 Jan 2015, Mike Snitzer wrote:
> On Thu, Jan 29 2015 at  5:43pm -0500,
>> One of my commits relocated the initialization, but I didn't realize it
>> had a hard dependency on the follow-on commit.  Should we reorder that
>> part of the series?
>
> Which follow on commit are you referring to?  Please be specific about
> which commits you think are out of order.
>
> Also, what are you testing... are you using the linux-dm.git tree's
> 'dm-for-3.20' branch which builds on Jens' 'for-3.20/core'?
>
> If not please test that and see if you still have problems (without the
> associated DM changes all the block preparation changes that Jens
> cherry-picked shouldn't cause any problems at all).

I'm using Jens' linux-block for-3.20/core branch. The last dm commit
is this:

  commit febf71588c2a750e04dc2a8b0824ce120c48bd9e
  Author: Keith Busch <keith.busch@intel.com>
  Date:   Fri Oct 17 17:46:35 2014 -0600

     block: require blk_rq_prep_clone() be given an initialized clone request

Looking at this again, the above was incorrect in the first place: it
initialized the original, but the intent was to initialize the clone. This
slipped by me since the next part of the series fixed it. In your linux-dm
dm-for-3.20, it's this commit:

  commit 102e38b1030e883efc022dfdc7b7e7a3de70d1c5
  Author: Mike Snitzer <snitzer@redhat.com>
  Date:   Fri Dec 5 17:11:05 2014 -0500

      dm: split request structure out from dm_rq_target_io structure


So I was confused earlier, there's no need to reorder anything. I just
need to fix the broken part.
