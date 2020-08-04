From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: don't call report zones for more than the user requested
Date: Tue, 4 Aug 2020 10:36:25 -0400
Message-ID: <20200804143625.GA14672@redhat.com>
References: <20200804092501.7938-1-johannes.thumshirn@wdc.com>
 <CY4PR04MB3751EB538B7F29FBDBB4EBA4E74A0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <SN4PR0401MB3598A9D49399D70697DCEC789B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB3598A9D49399D70697DCEC789B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Naohiro Aota <Naohiro.Aota@wdc.com>
List-Id: dm-devel.ids

On Tue, Aug 04 2020 at  7:26am -0400,
Johannes Thumshirn <Johannes.Thumshirn@wdc.com> wrote:

> On 04/08/2020 12:17, Damien Le Moal wrote:
> > 
> > Looks good. I think this needs a Cc: stable.
> 
> Indeed, Mike can you add these two when applying or do you want me to resend?
> 
> Fixes: d41003513e61 ("block: rework zone reporting")
> Cc: stable@vger.kernel.org # v5.5+

I can apply those tags, thanks.
