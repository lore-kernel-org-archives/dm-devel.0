From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 5/5] dm-mpath: convert to request-based
Date: Thu, 27 Aug 2009 18:54:19 +0100
Message-ID: <20090827175419.GQ643@agk-dp.fab.redhat.com>
References: <4A24CD74.80708@ct.jp.nec.com> <4A24CEBD.8010807@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A24CEBD.8010807@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 02, 2009 at 04:03:25PM +0900, Kiyoshi Ueda wrote:
> This patch converts dm-multipath target to request-based from bio-based.
 
How much effort would it be to retain the old mpath implementation
in parallel?

I'm rather concerned that we're losing some useful functionality in
2.6.31 with this patch - stacking over bio-based devices (test beds use
this and it's helpful for debugging), barrier support - and supporting
both would make it easier for people to compare the two implementations
and stick to the old one if in their particular circumstances it worked
better.

Perhaps, dm-mpath could just register two targets (like snapshot does),
one bio-based, and one rq-based, sharing most of the functions with
wrappers to indicate which is which where necessary?

Alasdair
