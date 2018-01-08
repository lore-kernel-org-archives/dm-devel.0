From: Hannes Reinecke <hare@suse.de>
Subject: Re: [for-4.16 PATCH v2 0/5] block, nvme, dm: allow DM multipath to
 use NVMe's error handler
Date: Mon, 8 Jan 2018 07:52:46 +0100
Message-ID: <31d7df8b-1197-c7aa-3c05-d8e7b5a63854@suse.de>
References: <20171227032257.8182-1-snitzer@redhat.com>
 <20180102232943.GC26533@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180102232943.GC26533@localhost.localdomain>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>, Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, hch@lst.de, emilne@redhat.com, james.smart@broadcom.com, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 01/03/2018 12:29 AM, Keith Busch wrote:
> Instead of hiding NVMe path related errors, the NVMe driver needs to
> code an appropriate generic block status from an NVMe status.
> 
> We already do this translation whether or not CONFIG_NVME_MULTIPATHING is
> set, so I think it's silly NVMe native multipathing has a second status
> decoder. This just doubles the work if we need to handle any new NVMe
> status codes in the future.
> 
> I have a counter-proposal below that unifies NVMe-to-block status
> translations, and combines common code for determining if an error is a
> path failure. This should work for both NVMe and DM, and DM won't need
> NVMe specifics.
> 
> I can split this into a series if there's indication this is ok and
> satisfies the need.
> 
I'm all for it. Go.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
