From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: nvme: allow ANA support to be independent of native multipathing
Date: Tue, 20 Nov 2018 08:37:19 -0500
Message-ID: <20181120133719.GB18991@redhat.com>
References: <20181115174605.GA19782@redhat.com>
 <20181116091458.GA17267@lst.de>
 <37098edd-4dea-b58f-bca6-3be9af8ec4ee@suse.de>
 <20181116094947.GA19296@lst.de>
 <bbaf4637-209c-5cfe-2749-3fcc54f7a35f@suse.de>
 <20181116101752.GA21531@lst.de>
 <20181116192802.GA30057@redhat.com>
 <20181119093938.GA11757@lst.de>
 <20181119145650.GB13470@redhat.com>
 <20181120094201.GB7742@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181120094201.GB7742@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk, Martin Wilck <mwilck@suse.com>, lijie <lijie34@huawei.com>, xose.vazquez@gmail.com, chengjike.cheng@huawei.com, shenhong09@huawei.com, dm-devel@redhat.com, wangzhoumengjian@huawei.com, christophe.varoqui@opensvc.com, bmarzins@redhat.com, sschremm@netapp.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Nov 20 2018 at  4:42am -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Nov 19, 2018 at 09:56:50AM -0500, Mike Snitzer wrote:
> > SO: will you be taking my v2 patch for 4.21 or not?
> 
> No.

This isn't how a Linux maintainer engages in technical discussion.

You _clearly_ just want to prevent further use of multipath-tools and
DM-multipath.  You will resort to rejecting a patch that improves the
NVMe driver's standards compliance if it allows you hijack NVMe
multipathing because you think you have the best way and nobody else
should be allowed to use a well established competing _open_ _Linux_
solution.  Simple as that.

You haven't made a single technical argument against my v2 patch, yet
you're rejecting it.  Purely on the basis that having NVMe's ANA updates
work independent on native NVMe multipathing happens to benefit an
alternative (and that benefit is just to not have multipath-tools to be
so crude with a pure userspace ANA state tracking).

Jens, this entire situation has gotten well beyond acceptable and you or
other NVMe co-maintainers need to step in.  We need reasoned _technical_
discussion or this entire process falls apart.

Mike
