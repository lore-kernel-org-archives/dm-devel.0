From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/2] dm-ioband: I/O bandwidth controller
	v1.10.0: Source code and patch
Date: Wed, 21 Jan 2009 17:18:17 +0000
Message-ID: <20090121171817.GP9859@agk.fab.redhat.com>
References: <20090120.141022.193708059.ryov@valinux.co.jp>
	<20090120.141114.226778416.ryov@valinux.co.jp>
	<20090120145208.GE9859@agk.fab.redhat.com>
	<20090121.220356.39155811.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090121.220356.39155811.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

I'm asking whether or not restructuring that little bit of code would improve
clarity, or whether it would become more convoluted.

Last time we had this, changing the functions so locks were acquired then
released actually improved clarity - I'm asking if the same is true here
or not.

Alasdair
-- 
agk@redhat.com
