From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 4/8] [dm-bio-prison] Change the
	bio-prison	interface so the memory for the cells is passed in.
Date: Mon, 14 Jan 2013 14:22:47 +0000
Message-ID: <20130114142247.GB18927@agk-dp.fab.redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-5-git-send-email-ejt@redhat.com>
	<20130114100259.GA18927@agk-dp.fab.redhat.com>
	<20130114140657.GA2545@raspberrypi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130114140657.GA2545@raspberrypi>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jan 14, 2013 at 02:06:58PM +0000, Joe Thornber wrote:
> On Mon, Jan 14, 2013 at 10:02:59AM +0000, Alasdair G Kergon wrote:
> > What is the motivation for changing this?
> Avoiding allocating memory on the main map path for dm-cache.
 
What is the different about dm-cache that makes this a problem
where it is not a problem for dm-thin?

Alasdair
