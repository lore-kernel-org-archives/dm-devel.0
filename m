From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Add UNPLUG traces to all appropriate places
Date: Thu, 8 Nov 2007 21:15:45 +0100
Message-ID: <20071108201544.GB13741@kernel.dk>
References: <473319F3.30706@hp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <473319F3.30706@hp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: dm-devel@redhat.com, btrace <linux-btrace@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Nov 08 2007, Alan D. Brunelle wrote:
> Added blk_unplug interface, allowing all invocations of unplugs to result
> in a generated blktrace UNPLUG. Previously, we saw a PLUG on each of the
> underlying devices, and an UNPLUG on the volume. This patch ensures that
> we see the UNPLUG calls for each of the underlying devices.

Looks fine Alan, applied.

-- 
Jens Axboe
