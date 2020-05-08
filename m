From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: track io errors per mapped device
Date: Fri, 8 May 2020 17:09:26 -0400
Message-ID: <20200508210926.GB19773@redhat.com>
References: <20200507230532.5733-1-kj@orbekk.com>
 <DM6PR04MB49726E28257263F5A1C643B386A20@DM6PR04MB4972.namprd04.prod.outlook.com>
 <dd7b8b91-776b-4458-a83a-18ab4953d2f4@www.fastmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dd7b8b91-776b-4458-a83a-18ab4953d2f4@www.fastmail.com>
Sender: linux-block-owner@vger.kernel.org
To: kj@orbekk.com
Cc: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, Alasdair G Kergon <agk@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "harshads@google.com" <harshads@google.com>, Khazhismel Kumykov <khazhy@google.com>
List-Id: dm-devel.ids

On Fri, May 08 2020 at  3:22pm -0400,
kj@orbekk.com <kj@orbekk.com> wrote:

> On Thu, May 7, 2020, at 21:12, Chaitanya Kulkarni wrote:
> > On 05/07/2020 04:06 PM, Kjetil Orbekk wrote:
> > > +		if (tio->error)
> > > +			atomic_inc(&md->ioerr_cnt);
> > 
> > Given that there are so many errors how would user know what
> > kind of error is generated and how many times?
> 
> The intended use case is to provide an easy way to check if errors
> have occurred at all, and then the user needs to investigate using
> other means. I replied with more detail to Alasdair's email.

But most operations initiated by the user that fail will be felt by the
upper layer that the user is interfacing with.

Only exception that springs to mind is dm-writecache's writeback that
occurs after writes have already been acknowledged back to the upper
layers -- in that case dm-writecache provides an error flag that is
exposed via writecache_status.

Anyway, just not seeing why you need a upper-layer use-case agnostic
flag to know an error occurred in DM.  That layers that interface with
the DM device will have been notified of all errors.

And why just for DM devices?  Why not all block devices (in which case
DM would get this feature "for free")?

Mike
