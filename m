From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 4/8] [dm-bio-prison] Change the
	bio-prison	interface so the memory for the cells is passed in.
Date: Tue, 22 Jan 2013 12:10:32 +0000
Message-ID: <20130122121032.GI27093@agk-dp.fab.redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-5-git-send-email-ejt@redhat.com>
	<20130121233245.GF27093@agk-dp.fab.redhat.com>
	<20130122113148.GA5462@raspberrypi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130122113148.GA5462@raspberrypi>
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

On Tue, Jan 22, 2013 at 11:31:49AM +0000, Joe Thornber wrote:
> Note the mempool alloc _can_ fail with GFP_NOIO/GFP_NOWAIT.

Not with GFP_NOIO.

include/linux/gfp.h:
#define GFP_NOIO        (__GFP_WAIT)

mempool_alloc():
        might_sleep_if(gfp_mask & __GFP_WAIT);

Alasdair
