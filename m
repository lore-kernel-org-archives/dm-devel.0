From: Hannes Reinecke <hare@suse.de>
Subject: Re: [for-4.16 PATCH v2 2/3] block: cope with gendisk's 'queue' being
 added later
Date: Wed, 10 Jan 2018 13:01:51 +0100
Message-ID: <f55e6226-ec66-2df9-c66e-9cb19a2c83b4@suse.de>
References: <20180110024104.34885-1-snitzer@redhat.com>
 <20180110024104.34885-3-snitzer@redhat.com> <20180110083231.GC10185@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180110083231.GC10185@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, Bart.VanAssche@wdc.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 01/10/2018 09:32 AM, Christoph Hellwig wrote:
> On Tue, Jan 09, 2018 at 09:41:03PM -0500, Mike Snitzer wrote:
>> Since I can remember DM has forced the block layer to allow the
>> allocation and initialization of the request_queue to be distinct
>> operations.  Reason for this was block/genhd.c:add_disk() has required
>> that the request_queue (and associated bdi) be tied to the gendisk
>> before add_disk() is called -- because add_disk() also deals with
>> exposing the request_queue via blk_register_queue().
> 
> Hmm.  I don't even know how that could be safe given that the disk
> is live and visible to userspace once added..
> 
We're getting an additional 'change' event once the tables are loaded
and setup properly. That's not a problem, and in fact the DASD driver
has the very same issue/feature/design.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
