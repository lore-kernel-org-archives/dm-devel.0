From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: blk-mq request allocation stalls [was: Re: [PATCH v3
 0/8] dm: add request-based blk-mq support]
Date: Fri, 9 Jan 2015 16:40:16 -0500
Message-ID: <20150109214015.GA1032@redhat.com>
References: <54A6DB1D.4030201@acm.org> <20150105213557.GA5030@redhat.com>
	<54ABAB80.70006@acm.org> <20150106160553.GB10224@redhat.com>
	<54AC0A39.90801@kernel.dk> <54AD0B63.3010505@acm.org>
	<alpine.LNX.2.00.1501071755110.4026@localhost.lm.intel.com>
	<20150109194955.GA32641@redhat.com> <54B042FE.2000205@kernel.dk>
	<54B043FC.8000902@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54B043FC.8000902@kernel.dk>
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
Cc: Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On Fri, Jan 09 2015 at  4:11pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> 
> Actually, try this one instead, it should be a bit more precise than
> the first.
> 

Thanks for the test patch.

I'm still seeing failures that look wrong (last_tag=127 could be edge
condition not handled properly?):

[   14.254632] __bt_get: values before for loop: last_tag=127, index=3
[   14.255841] __bt_get: values after  for loop: last_tag=64, index=2
[   14.257036]
[   14.257036] bt_get: __bt_get() returned -1
[   14.258051] queue_num=0, nr_tags=128, reserved_tags=0, bits_per_word=5
[   14.259246] nr_free=128, nr_reserved=0
[   14.259963] active_queues=0

[  213.115997] __bt_get: values before for loop: last_tag=127, index=3
[  213.117115] __bt_get: values after  for loop: last_tag=96, index=3
[  213.118200]
[  213.118200] bt_get: __bt_get() returned -1
[  213.121593] queue_num=0, nr_tags=128, reserved_tags=0, bits_per_word=5
[  213.123960] nr_free=128, nr_reserved=0
[  213.125880] active_queues=0

[  239.158079] __bt_get: values before for loop: last_tag=8, index=0
[  239.160363] __bt_get: values after  for loop: last_tag=0, index=0
[  239.162896]
[  239.162896] bt_get: __bt_get() returned -1
[  239.166284] queue_num=0, nr_tags=128, reserved_tags=0, bits_per_word=5
[  239.168623] nr_free=127, nr_reserved=0
[  239.170508] active_queues=0
