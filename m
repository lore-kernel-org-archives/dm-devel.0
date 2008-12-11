From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [patch] leastpending_io load balancing policy
Date: Thu, 11 Dec 2008 10:43:21 +0900
Message-ID: <49407039.3070708@ct.jp.nec.com>
References: <2118D41AB77C214BBF7D2330CD977BCF1BB395790D@GVW1162EXB.americas.hpqcorp.net>	<20081203220819.GO26097@agk.fab.redhat.com>
	<20081203230140.GE5098@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081203230140.GE5098@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Balasubramanian, Vijayakumar (STSD)" <vijayakumar@hp.com>, Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair, Vijayakumar,

Alasdair G Kergon wrote:
> Also look at request based multipath patch rqdm-dlb-02-queue-length-dlb.patch
> which addresses some but not all of those points.

FYI.
The rqdm-dlb-* patches don't depend on request-based dm-multipath,
so those can work on bio-based dm-multipath, too, with some cosmetic
changes.

Alasdair,
If you want to apply dynamic load balancer patches before request-based
dm-multipath patches, I can rebase my load balancer patches.

The reason why I've been posting those patches on top of request-based
patches is that load balancer doesn't work well in bio-based dm-multipath.
Bio-based dm-multipath is on top of the I/O scheduler, so I/O merging and
I/O sorting may occur after path switching.

Thanks,
Kiyoshi Ueda
