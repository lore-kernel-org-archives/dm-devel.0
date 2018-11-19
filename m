From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: nvme: allow ANA support to be independent of native
	multipathing
Date: Mon, 19 Nov 2018 09:56:50 -0500
Message-ID: <20181119145650.GB13470@redhat.com>
References: <20181114174746.GA18526@redhat.com>
	<87c931e5-4ac9-1795-8d40-cc5541d3ebcf@suse.de>
	<20181115174605.GA19782@redhat.com> <20181116091458.GA17267@lst.de>
	<37098edd-4dea-b58f-bca6-3be9af8ec4ee@suse.de>
	<20181116094947.GA19296@lst.de>
	<bbaf4637-209c-5cfe-2749-3fcc54f7a35f@suse.de>
	<20181116101752.GA21531@lst.de> <20181116192802.GA30057@redhat.com>
	<20181119093938.GA11757@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181119093938.GA11757@lst.de>
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, lijie <lijie34@huawei.com>, shenhong09@huawei.com, xose.vazquez@gmail.com, Sagi Grimberg <sagi@grimberg.me>, chengjike.cheng@huawei.com, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, wangzhoumengjian@huawei.com, Martin Wilck <mwilck@suse.com>, sschremm@netapp.com
List-Id: dm-devel.ids

On Mon, Nov 19 2018 at  4:39am -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Fri, Nov 16, 2018 at 02:28:02PM -0500, Mike Snitzer wrote:
> > You rejected the idea of allowing fine-grained control over whether
> > native NVMe multipathing is enabled or not on a per-namespace basis.
> > All we have is the coarse-grained nvme_core.multipath=N knob.  Now
> > you're forecasting removing even that.  Please don't do that.
> 
> The whole point is that this hook was intended as a band aid for the
> hypothetical pre-existing setups.  Not ever for new development.

It pains me that you're marching us towards increased conflict that
needs resolution through more formal means.  And that now I'm going to
have to document the timeline of your authoritarian approach to
stifling another Linux maintainer's freedom to do his job of delivering
on functionality I've been depended on for many years.

> > Please, PLEASE take v2 of this patch.. please? ;)
> 
> See the previous mail for the plan ahead.   I'm sick and tired of you
> trying to sneak your new developemts back in.

I've only ever posted patches in the open and never has it been with the
idea of sneaking anything in.  Miscategorizing my actions as such is a
gross abuse that I will not tolerate.

If we were to confine ourselves to this v2 patch I pleaded with you to
take: https://lkml.org/lkml/2018/11/17/4

1) Hannes proposed a simplistic patch that didn't account for the fact
   that NVMe's ana workqueue wouldn't get kicked, his intent was to make
   ANA work independent of your native multipathing.  (The fact he or I
   even need to post such patches, to unwind your tight-coupling of ANA
   and multipathing, speaks to how you've calculatingly undermined any
   effort to implement proper NVMe multipathing outside of the NVMe
   driver)

2) ANA and multipathing are completely disjoint on an NVMe spec level.
   You know this.

SO: will you be taking my v2 patch for 4.21 or not?

Please advise, thanks.
Mike
