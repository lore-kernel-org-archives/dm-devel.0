From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 3/3] dm: separate device deletion
	from	dm_put()
Date: Fri, 23 Jul 2010 18:59:01 +0100
Message-ID: <20100723175901.GO19063@agk-dp.fab.redhat.com>
References: <4C0E19A0.1040804@ct.jp.nec.com> <4C0E1B08.7060201@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4C0E1B08.7060201@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Tue, Jun 08, 2010 at 07:27:20PM +0900, Kiyoshi Ueda wrote:
> For the unlikely case of the forced module unload, dm_destroy_nowait(),
> which doesn't wait and forcibly deletes the mapped_device, is also
> introduced and used in dm_hash_remove_all().  Otherwise, "rmmod -f"
> may be stuck and never return.

> And now, because the mapped_device is deleted at this point, subsequent
> accesses to the mapped_device may cause NULL pointer references.

Do we get a warning message logged when this situation occurs
and md->holders is still set or should we add one?

> +	if (wait) {
> +		while (atomic_read(&md->holders))
> +			msleep(1);

Alasdair
