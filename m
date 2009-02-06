From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Patchwork and patch flow
Date: Fri, 06 Feb 2009 15:42:25 +0900 (JST)
Message-ID: <20090206.154225.189717016.ryov@valinux.co.jp>
References: <20090205.204508.71105166.ryov@valinux.co.jp>
	<A5C05773-7C8F-4D59-B742-DBDC85799DFB@redhat.com>
	<20090205224831.GV20668@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090205224831.GV20668@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Jonathan and Alasdair,

Thanks for your advices.

> > To add a Tested-by tag, how much test do we actually need?
> > We've already done several tests of dm-ioband:
> >  Proportional I/O bandwidth controlling
> >  Loading/unloading driver and changing settings while under I/O load
> >  Bounds checking of setting parameters
> >  Benchmarks
> > Do you think these are enough for adding the tag?
> > It's very difficult for me to determine whether it's qualified or not.
> > It would be helpful if you could give me some advice.
> 
> Interesting question...  If it was me, I'd like to see exactly what
> you wrote above.  State that you tested it and how you tested it. If
> there are a number of people who test it and the things they
> describe offer a broad spectrum of tests, I think that's helpful.
> Also, if extra testing is wanted, it can be suggested based on what
> tests have been performed.

O.K. I will post my test items and results on my website sometime
soon.

> The key thing I'm looking for in Tested-By is independence from
> the original developers.

I think so. I hope someone will do the test by posting my test items.

Thanks,
Ryo Tsuruta
