From: Keith Busch <keith.busch@intel.com>
Subject: Re: awful request merge results while simulating high
 IOPS multipath
Date: Thu, 26 Feb 2015 00:28:39 +0000 (UTC)
Message-ID: <alpine.LNX.2.00.1502260018560.32385@localhost.lm.intel.com>
References: <54ECBA78.6020204@kernel.dk> <20150224181257.GA11444@redhat.com>
	<54ECC000.40604@kernel.dk> <20150224183256.GA11566@redhat.com>
	<20150225005608.GA13348@redhat.com>
	<alpine.LNX.2.00.1502250401330.32385@localhost.lm.intel.com>
	<54EDE62D.7010308@kernel.dk>
	<B58D82457FDA0744A320A2FC5AC253B93BA8BF21@fmsmsx104.amr.corp.intel.com>
	<20150225221047.GA22281@redhat.com>
	<alpine.LNX.2.00.1502252327150.32385@localhost.lm.intel.com>
	<20150226001114.GA22484@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150226001114.GA22484@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, shivakrishna.merla@netapp.com, Bart Van Assche <bvanassche@acm.org>, jmoyer@redhat.com, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, 25 Feb 2015, Mike Snitzer wrote:
> On Wed, Feb 25 2015 at  6:57pm -0500,
> Keith Busch <keith.busch@intel.com> wrote:
>
>> Yes, I'm also looking at blk-mq. It appears conversion helps a lot.
>
> Oh, so you've already started a conversion of request-based DM?

Actually no, I've only barely started looking at it. I'm guessing
improvement based on using a bio-based device mapper on top of nvme. In
my experience blk-mq performs similiar or better than bio on benchmarks,
so I hope it's a fair assumption here too.
