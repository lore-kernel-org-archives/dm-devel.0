From: thornber@redhat.com
Subject: Re: [PATCH 4/8] [dm-bio-prison] Change the bio-prison
 interface so the memory for the cells is passed in.
Date: Mon, 14 Jan 2013 14:06:58 +0000
Message-ID: <20130114140657.GA2545@raspberrypi>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-5-git-send-email-ejt@redhat.com>
	<20130114100259.GA18927@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130114100259.GA18927@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jan 14, 2013 at 10:02:59AM +0000, Alasdair G Kergon wrote:
> On Thu, Dec 13, 2012 at 08:19:12PM +0000, Joe Thornber wrote:
> > ---
> 
> What is the motivation for changing this?

Avoiding allocating memory on the main map path for dm-cache.
