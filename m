From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Mon, 24 Aug 2009 16:18:15 -0700
Message-ID: <1251155895.24406.63.camel@chandra-ubuntu>
References: <20090823210536.4730636d@nb-jsosic>
	<20090823213448.154d6cff@nb-jsosic>
	<Pine.LNX.4.64.0908241128370.27199@e-smith.charlieb.ott.istop.com>
	<20090824174834.35a7038f@pc-jsosic.srce.hr>
	<20090824180058.7cc4edcb@pc-jsosic.srce.hr>
	<1251139098.24406.1.camel@chandra-ubuntu>
	<20090824205529.6b78aa3a@pc-jsosic.srce.hr>
	<1251145456.24406.16.camel@chandra-ubuntu>
	<20090824223745.33425c32@pc-jsosic.srce.hr>
	<1251146674.24406.20.camel@chandra-ubuntu>
	<20090824225324.1ee86d9f@pc-jsosic.srce.hr>
	<Pine.LNX.4.64.0908241852270.21130@e-smith.charlieb.ott.istop.com>
	<20090825010948.0b7fa554@pc-jsosic.srce.hr>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090825010948.0b7fa554@pc-jsosic.srce.hr>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Tue, 2009-08-25 at 01:09 +0200, Jakov Sosic wrote:
> On Mon, 24 Aug 2009 18:58:24 -0400 (EDT)
> Charlie Brady <charlieb-dm-devel@budge.apana.org.au> wrote:
> 
> > Chandra says that the patch won't help you. Perhaps he can clarify.
> > My understanding is that if you configure multipath to use RDAC that
> > the driver does have to be patched so that the RDAC handler will be
> > used. I did find that to be the case with the StorageTek 2510
> > "LCMS100_I").
> > 
> > My understanding also is that RDAC is superior, so RDAC hander
> > support is desirable.
> 
> Is it enough to just add a new line to the list of the devices? For
> example:

yup. But, I mentioned earlier, this _won't_ solve the problem you are
seeing.

> 
> const struct scsi_dh_devlist rdac_dev_list[] = {
>         {"IBM", "1722"},
>         {"IBM", "1724"},
>         {"IBM", "1726"},
>         {"IBM", "1742"},
>         {"IBM", "1814"},
>         {"IBM", "1815"},
>         {"IBM", "1818"},
>         {"IBM", "3526"},
>         {"SGI", "TP9400"},
>         {"SGI", "TP9500"},
>         {"SGI", "IS"},
>         {"STK", "OPENstorage D280"},
>         {"SUN", "CSM200_R"},
>         {"SUN", "LCSM100_F"},
>         {"SUN", "LCSM100_I"},
>         {"SUN", "LCSM100_S"},
>         {NULL, NULL},
> };
> 
> ?
> 
> 
> > > Sorry, I'm easily flammable...
> > 
> > You would be wise to control your urges, if you wish people to help
> > you.
> 
> Well you misunderstood me both - I was just bashing around, and nothing
> was said at neither yours neither his account. It was just because this
> project I'm working on is taking so so so long :( This is like 10th
> problem I've encountered that is out of my order, and the amount of
> user-hours has already 3-4x exceeded the amount of money project
> brings :( So I'm really really... angry :-/
> 
> 
