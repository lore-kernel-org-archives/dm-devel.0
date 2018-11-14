From: Martin Wilck <mwilck@suse.de>
Subject: Re: [dm-devel] multipath-tools: add ANA support for NVMe device
Date: Wed, 14 Nov 2018 11:36:31 +0100
Message-ID: <3ade435ef087d61a293863a62c1b794ecf8dba14.camel@suse.de>
References: <1541657381-7452-1-git-send-email-lijie34@huawei.com>
         <2691abf6733f791fb16b86d96446440e4aaff99f.camel@suse.com>
         <20181112215323.GA7983@redhat.com>
         <20181113161838.GC9827@localhost.localdomain>
         <20181113180008.GA12513@redhat.com> <20181114053837.GA15086@redhat.com>
         <30cf7af7-8826-55bd-e39a-4f81ed032f6d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <30cf7af7-8826-55bd-e39a-4f81ed032f6d@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <keith.busch@intel.com>, axboe@kernel.dk, hch@lst.de, Mike Snitzer <snitzer@redhat.com>
Cc: xose.vazquez@gmail.com, chengjike.cheng@huawei.com, lijie <lijie34@huawei.com>, shenhong09@huawei.com, wangzhoumengjian@huawei.com, linux-nvme@lists.infradead.org, sschremm@netapp.com, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, 2018-11-14 at 08:49 +0100, Hannes Reinecke wrote:
> On 11/14/18 6:38 AM, Mike Snitzer wrote:
> > 
> > Not holding my breath BUT:
> > if decoupling the reading of ANA state from native NVMe
> > multipathing
> > specific work during nvme request completion were an acceptable
> > advancement I'd gladly do the work.
> > 
> I'd be happy to work on that, given that we'll have to have 'real'
> ANA 
> support for device-mapper anyway for SLE12 SP4 etc.

So, what's the way ahead for multipath-tools? 

Given that, IIUC, at least one official kernel (4.19) has been released
with ANA support but without the ANA sysfs attributes exported to user
space, multipath-tools can't rely on them being present. I for one have
no issue with copying code from nvme-cli and doing NVMe ioctls from
multipath-tools, as in Lijie's patch. When those sysfs attributes are
added (and work as expected), we will use them, but IMO we'll need to
fall back to ioctls until then, and also afterwards, because we can't
assume to be always running on the latest kernel.

Best,
Martin
