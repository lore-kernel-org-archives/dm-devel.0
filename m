From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 1/1] dm-zoned: Zoned block device target
Date: Fri, 10 Feb 2017 09:51:58 +0900
Message-ID: <a35368f9-ac5d-3144-7701-11f0fb7f10e3@wdc.com>
References: <20170209041849.30964-1-damien.lemoal@wdc.com>
	<20170209093606.GA8189@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170209093606.GA8189@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Christoph,

On 2/9/17 18:36, Christoph Hellwig wrote:
> On Thu, Feb 09, 2017 at 01:18:49PM +0900, Damien Le Moal wrote:
>> +
>> +/*
>> + * Target BIO completion.
>> + */
>> +static inline void dmz_bio_end(struct bio *bio, int err)
>> +{
>> +	struct dm_zone_bioctx *bioctx =
>> +		dm_per_bio_data(bio, sizeof(struct dm_zone_bioctx));
>> +
>> +	if (atomic_dec_and_test(&bioctx->ref)) {
> 
> It seems like this could be simplified a bit by using bio_chain
> to chain the clones to the original bio.

Thank you for the hint. I will look into this.

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
