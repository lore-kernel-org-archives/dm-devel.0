From: Jakov Sosic <jakov.sosic@srce.hr>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Tue, 25 Aug 2009 01:22:03 +0200
Message-ID: <20090825012203.07a1be4f@pc-jsosic.srce.hr>
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
	<1251155895.24406.63.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1251155895.24406.63.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 24 Aug 2009 16:18:15 -0700
Chandra Seetharaman <sekharan@us.ibm.com> wrote:

> yup. But, I mentioned earlier, this _won't_ solve the problem you are
> seeing.

Thank you... I'll try other things then.

The interesting part is, while I was connected only to one controller,
and didn't have the multipath, there wasn't any dropouts of that single
path.

Now, with multipath, being AVT or RDAC, it works much worse... I just
don't get it, why all those flopping is going around :(

And I waited a month to get new SAS cables shipped in - so that a
SAS controler would't be a SPOF in my RHCS installation :)


-- 
|    Jakov Sosic    |    ICQ: 28410271    |   PGP: 0x965CAE2D   |
=================================================================
| start fighting cancer -> http://www.worldcommunitygrid.org/   |
