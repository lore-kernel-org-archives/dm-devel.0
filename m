From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3 0/5] dm-rq: improve sequential I/O
	performance
Date: Fri, 12 Jan 2018 17:26:54 +0000
Message-ID: <1515778013.2396.3.camel@wdc.com>
References: <20180111060159.12991-1-ming.lei@redhat.com>
	<20180111220742.GA31944@redhat.com>
	<1515710256.2752.72.camel@sandisk.com>
	<20180112014232.GB25090@ming.t460p> <20180112015721.GB32298@redhat.com>
	<20180112033308.GC25090@ming.t460p> <20180112171840.GA4541@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180112171840.GA4541@redhat.com>
Content-Language: en-US
Content-ID: <8858E602951E514A97ACC7907CFCA135@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "snitzer@redhat.com" <snitzer@redhat.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@fb.com" <axboe@fb.com>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2018-01-12 at 12:18 -0500, Mike Snitzer wrote:
> This is going upstream for 4.16:
> https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/commit/?h=dm-4.16&id=5b18cff4baedde77e0d69bd62a13ae78f9488d89

That is really gross. I have explained many times in detail on the dm-devel
list why that blk_mq_delay_run_hw_queue() call is necessary. So I think it is
wrong if you remove it. Isn't the responsibility of you as the device mapper
kernel maintainer to avoid regressions instead of introducing regressions?

Bart.
