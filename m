From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] nvme: allow ANA support to be independent of native
 multipathing
Date: Fri, 16 Nov 2018 10:40:40 +0100
Message-ID: <37098edd-4dea-b58f-bca6-3be9af8ec4ee@suse.de>
References: <1541657381-7452-1-git-send-email-lijie34@huawei.com>
 <2691abf6733f791fb16b86d96446440e4aaff99f.camel@suse.com>
 <20181112215323.GA7983@redhat.com>
 <20181113161838.GC9827@localhost.localdomain>
 <20181113180008.GA12513@redhat.com> <20181114053837.GA15086@redhat.com>
 <30cf7af7-8826-55bd-e39a-4f81ed032f6d@suse.de>
 <20181114174746.GA18526@redhat.com>
 <87c931e5-4ac9-1795-8d40-cc5541d3ebcf@suse.de>
 <20181115174605.GA19782@redhat.com> <20181116091458.GA17267@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181116091458.GA17267@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk, Martin Wilck <mwilck@suse.com>, lijie <lijie34@huawei.com>, xose.vazquez@gmail.com, chengjike.cheng@huawei.com, shenhong09@huawei.com, dm-devel@redhat.com, wangzhoumengjian@huawei.com, christophe.varoqui@opensvc.com, bmarzins@redhat.com, sschremm@netapp.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 11/16/18 10:14 AM, Christoph Hellwig wrote:
> On Thu, Nov 15, 2018 at 12:46:05PM -0500, Mike Snitzer wrote:
>> Whether or not ANA is present is a choice of the target implementation;
>> the host (and whether it supports multipathing) has _zero_ influence on
>> this.  If the target declares a path as 'inaccessible' the path _is_
>> inaccessible to the host.  As such, ANA support should be functional
>> even if native multipathing is not.
>>
>> Introduce ability to always re-read ANA log page as required due to ANA
>> error and make current ANA state available via sysfs -- even if native
>> multipathing is disabled on the host (e.g. nvme_core.multipath=N).
> 
> The first part I could see, but I still want to make it conditional
> in some way as nvme is going into deeply embedded setups, and I don't
> want to carry the weight of the ANA code around for everyone.
> 
Can you clarify this a bit?
We _do_ have the NVME multipath config option to deconfigure the whole 
thing during compile time; that isn't influenced with this patch.
So are you worried about the size of the ANA implementation itself?
Or are you worried about the size of the ANA structures?

> The second I fundamentally disagree with.  And even if you found agreement
> it would have to be in a separate patch as it is a separate feature.
> 
Why? Where's the problem with re-reading the ANA log pages if we get an 
event indicating that we should?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
