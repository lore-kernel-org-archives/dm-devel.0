From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] nvme: allow ANA support to be independent of native
 multipathing
Date: Fri, 16 Nov 2018 10:49:47 +0100
Message-ID: <20181116094947.GA19296@lst.de>
References: <20181112215323.GA7983@redhat.com> <20181113161838.GC9827@localhost.localdomain> <20181113180008.GA12513@redhat.com> <20181114053837.GA15086@redhat.com> <30cf7af7-8826-55bd-e39a-4f81ed032f6d@suse.de> <20181114174746.GA18526@redhat.com> <87c931e5-4ac9-1795-8d40-cc5541d3ebcf@suse.de> <20181115174605.GA19782@redhat.com> <20181116091458.GA17267@lst.de> <37098edd-4dea-b58f-bca6-3be9af8ec4ee@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <37098edd-4dea-b58f-bca6-3be9af8ec4ee@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk, Martin Wilck <mwilck@suse.com>, lijie <lijie34@huawei.com>, xose.vazquez@gmail.com, chengjike.cheng@huawei.com, shenhong09@huawei.com, dm-devel@redhat.com, wangzhoumengjian@huawei.com, christophe.varoqui@opensvc.com, bmarzins@redhat.com, sschremm@netapp.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Nov 16, 2018 at 10:40:40AM +0100, Hannes Reinecke wrote:
>>> Introduce ability to always re-read ANA log page as required due to ANA
>>> error and make current ANA state available via sysfs -- even if native
>>> multipathing is disabled on the host (e.g. nvme_core.multipath=N).
>>
>> The first part I could see, but I still want to make it conditional
>> in some way as nvme is going into deeply embedded setups, and I don't
>> want to carry the weight of the ANA code around for everyone.
>>
> Can you clarify this a bit?
> We _do_ have the NVME multipath config option to deconfigure the whole 
> thing during compile time; that isn't influenced with this patch.
> So are you worried about the size of the ANA implementation itself?
> Or are you worried about the size of the ANA structures?

I just see the next step of wanting to move ANA code into the core
which is implied above.
>
>> The second I fundamentally disagree with.  And even if you found agreement
>> it would have to be in a separate patch as it is a separate feature.
>>
> Why? Where's the problem with re-reading the ANA log pages if we get an 
> event indicating that we should?

"second" here means the sysfs file.
