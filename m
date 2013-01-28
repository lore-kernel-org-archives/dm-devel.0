From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 6/8] [persistent-data] Add a
	transactional	array.
Date: Mon, 28 Jan 2013 20:25:46 +0000
Message-ID: <20130128202546.GC30665@agk-dp.fab.redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-7-git-send-email-ejt@redhat.com>
	<20130125201106.GJ3122@agk-dp.fab.redhat.com>
	<20130128130628.GD2442@raspberrypi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130128130628.GD2442@raspberrypi>
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

On Mon, Jan 28, 2013 at 01:06:28PM +0000, Joe Thornber wrote:
> Which tool are you using to get these warnings?  I'm not seeing any
> with sparse or gcc, or perhaps you're building on a 32bit machine?
 
make EXTRA_CFLAGS=-Wconversion

Off by default as it's very noisy and most implicit conversions don't
matter.

Alasdair
