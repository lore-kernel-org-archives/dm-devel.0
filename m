From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH resend] block: silently error unsupported
	empty barriers too
Date: Thu, 15 Oct 2009 15:11:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0910151510340.22075@hs20-bc2-1.build.redhat.com>
References: <1251992870.3084.125.camel@blaa>
	<20091015002350.GV16950@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091015002350.GV16950@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Mark McLoughlin <markmc@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel <linux-kernel@vger.kernel.org>, virtualization <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids



On Thu, 15 Oct 2009, Alasdair G Kergon wrote:

> On Thu, Sep 03, 2009 at 04:47:50PM +0100, Mark McLoughlin wrote:
> > We should error all barriers, even empty barriers, on devices like
> > virtio_blk which don't support them.
> 
> Acked-by: Alasdair G Kergon <agk@redhat.com>

Acked-by: Mikulas Patocka <mpatocka@redhat.com>
