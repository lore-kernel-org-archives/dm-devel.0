From: kj@orbekk.com
Subject: Re: [PATCH] dm: track io errors per mapped device
Date: Fri, 08 May 2020 15:22:33 -0400
Message-ID: <dd7b8b91-776b-4458-a83a-18ab4953d2f4@www.fastmail.com>
References: <20200507230532.5733-1-kj@orbekk.com>
 <DM6PR04MB49726E28257263F5A1C643B386A20@DM6PR04MB4972.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <DM6PR04MB49726E28257263F5A1C643B386A20@DM6PR04MB4972.namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc: "harshads@google.com" <harshads@google.com>, Khazhismel Kumykov <khazhy@google.com>
List-Id: dm-devel.ids

On Thu, May 7, 2020, at 21:12, Chaitanya Kulkarni wrote:
> On 05/07/2020 04:06 PM, Kjetil Orbekk wrote:
> > +		if (tio->error)
> > +			atomic_inc(&md->ioerr_cnt);
> 
> Given that there are so many errors how would user know what
> kind of error is generated and how many times?

The intended use case is to provide an easy way to check if errors have occurred at all, and then the user needs to investigate using other means. I replied with more detail to Alasdair's email.

-- 
KJ
