From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: data corruption with 'splt' workload to XFS on DM
 cache with its 3 underlying devices being on same NVMe device
Date: Tue, 24 Jul 2018 14:25:41 +0000
Message-ID: <bc63227473a19cb23d6b2bb38eefa564dfec1ffc.camel@wdc.com>
References: <20180723163357.GA29658@redhat.com>
	<e761830f-e3f7-3e88-1697-b4b150e84e5f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e761830f-e3f7-3e88-1697-b4b150e84e5f@suse.de>
Content-Language: en-US
Content-ID: <28710C1A463C7745ADC5B8B28518F96C@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, 2018-07-24 at 08:00 +0200, Hannes Reinecke wrote:
> So, have you tested that request-based multipathing works on a partition 
> _at all_? I'm not sure if partition mapping is done correctly here; we 
> never remap the start of the request (nor bio, come to speak of it), so 
> it looks as if we would be doing the wrong things here.
> 
> Have you checked that partition remapping is done correctly?

I think generic_make_request() takes care of partition remapping by calling
blk_partition_remap(). generic_make_request() is called by submit_bio(). Is
that sufficient to cover all dm drivers?

Bart.
