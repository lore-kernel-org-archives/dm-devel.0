From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] block: silently error unsupported empty
	barriers too
Date: Thu, 6 Aug 2009 12:45:50 +0100
Message-ID: <20090806114550.GL29899@agk-dp.fab.redhat.com>
References: <1249557257.3721.55.camel@blaa>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1249557257.3721.55.camel@blaa>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mark McLoughlin <markmc@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel <linux-kernel@vger.kernel.org>, virtualization <virtualization@lists.linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

On Thu, Aug 06, 2009 at 12:14:17PM +0100, Mark McLoughlin wrote:
> We should error all barriers, even empty barriers, on devices like
> virtio_blk which don't support them.
 
Have you considered whether or not virtio_blk actually needs to
support empty barriers?

Alasdair
