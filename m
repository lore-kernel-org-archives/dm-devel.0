From: Keith Busch <keith.busch@intel.com>
Subject: Re: awful request merge results while simulating high
 IOPS multipath
Date: Wed, 25 Feb 2015 23:57:09 +0000 (UTC)
Message-ID: <alpine.LNX.2.00.1502252327150.32385@localhost.lm.intel.com>
References: <54ECAC08.7040603@kernel.dk> <20150224172259.GA39226@redhat.com>
	<54ECBA78.6020204@kernel.dk>
	<20150224181257.GA11444@redhat.com> <54ECC000.40604@kernel.dk>
	<20150224183256.GA11566@redhat.com>
	<20150225005608.GA13348@redhat.com>
	<alpine.LNX.2.00.1502250401330.32385@localhost.lm.intel.com>
	<54EDE62D.7010308@kernel.dk>
	<B58D82457FDA0744A320A2FC5AC253B93BA8BF21@fmsmsx104.amr.corp.intel.com>
	<20150225221047.GA22281@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150225221047.GA22281@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, shivakrishna.merla@netapp.com, Bart Van Assche <bvanassche@acm.org>, dm-devel@redhat.com, "Busch, Keith" <keith.busch@intel.com>, jmoyer@redhat.com
List-Id: dm-devel.ids

On Wed, 25 Feb 2015, Mike Snitzer wrote:
> On Wed, Feb 25 2015 at  1:17pm -0500,
> Busch, Keith <keith.busch@intel.com> wrote:
>> Our first bottleneck appears to be the device mapper's single lock
>> request queue.
>
> Obviously if we switched dm-multipath over to blk-mq we'd eliminate
> that.  I'll see how things go and will share any changes I come up
> with.

Yes, I'm also looking at blk-mq. It appears conversion helps a lot.
I'm not sure though how many tags or h/w contexts to allocate to ensure
there's enough but not too many. You can't use the underlying device's
blk-tagset count (assuming you could even get to it) since those are
potentially shared among many block devices.
