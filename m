From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH resend] block: silently error unsupported
	empty barriers too
Date: Thu, 15 Oct 2009 01:23:50 +0100
Message-ID: <20091015002350.GV16950@agk-dp.fab.redhat.com>
References: <1251992870.3084.125.camel@blaa>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1251992870.3084.125.camel@blaa>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mark McLoughlin <markmc@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel <linux-kernel@vger.kernel.org>, virtualization <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 03, 2009 at 04:47:50PM +0100, Mark McLoughlin wrote:
> We should error all barriers, even empty barriers, on devices like
> virtio_blk which don't support them.

Acked-by: Alasdair G Kergon <agk@redhat.com>
