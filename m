From: Christoph Hellwig <hch@infradead.org>
Subject: Re: data corruption with 'splt' workload to XFS on DM
 cache with its 3 underlying devices being on same NVMe device
Date: Tue, 24 Jul 2018 10:42:41 -0700
Message-ID: <20180724174241.GA828@infradead.org>
References: <20180723163357.GA29658@redhat.com>
	<e761830f-e3f7-3e88-1697-b4b150e84e5f@suse.de>
	<20180724130703.GA30804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180724130703.GA30804@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

On Tue, Jul 24, 2018 at 09:07:03AM -0400, Mike Snitzer wrote:
> True.  We only ever support mapping the partitions ontop of
> request-based multipath (via dm-linear volumes created by kpartx).
> 
> > So, have you tested that request-based multipathing works on a
> > partition _at all_? I'm not sure if partition mapping is done
> > correctly here; we never remap the start of the request (nor bio,
> > come to speak of it), so it looks as if we would be doing the wrong
> > things here.
> > 
> > Have you checked that partition remapping is done correctly?
> 
> It clearly doesn't work.  Not quite following why but...

blk_insert_cloned_request seems to be missing a call to
blk_partition_remap.  Given that no one but dm-multipath uses this
request clone insert helper, and people generally run multipath on
the whole device this is a code path that is almost never exercised.
