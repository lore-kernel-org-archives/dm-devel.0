From: thornber@redhat.com
Subject: Re: [PATCH 4/8] [dm-bio-prison] Change the
	bio-prison	interface so the memory for the cells is passed in.
Date: Tue, 22 Jan 2013 11:31:49 +0000
Message-ID: <20130122113148.GA5462@raspberrypi>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-5-git-send-email-ejt@redhat.com>
	<20130121233245.GF27093@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130121233245.GF27093@agk-dp.fab.redhat.com>
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

Alasdair,

I've pushed changes to the thin-dev and all-caches branches of my
github tree:

https://github.com/jthornber/linux-2.6.git

https://github.com/jthornber/linux-2.6/commit/ed52136ac238af0958b89b29749e27f049e0cb0c
https://github.com/jthornber/linux-2.6/commit/cf5273fe5f4e77b3df3acdbfc6bb09ff76dafcbd
https://github.com/jthornber/linux-2.6/commit/6e77ba56b8bbd21f43f00c2551c01a2e7d10aaf9

Note the mempool alloc _can_ fail with GFP_NOIO/GFP_NOWAIT.

- Joe
