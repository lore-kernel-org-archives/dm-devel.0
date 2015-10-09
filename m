From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] block: Inline blk_integrity in struct
	gendisk
Date: Fri, 9 Oct 2015 00:36:15 -0700
Message-ID: <20151009073615.GA9144@infradead.org>
References: <20150721120102.GB1654@infradead.org>
	<1440103314-31610-1-git-send-email-martin.petersen@oracle.com>
	<1440103314-31610-6-git-send-email-martin.petersen@oracle.com>
	<20150916010720.GA21398@redhat.com>
	<20150921204506.GA36289@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150921204506.GA36289@redhat.com>
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
Cc: Jens Axboe <axboe@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Matthew Wilcox <willy@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: dm-devel.ids

On Mon, Sep 21, 2015 at 04:45:07PM -0400, Mike Snitzer wrote:
> Here is what I came up with.  Leaves something to be desired given the
> integrity profile is being established on first table load (as opposed
> to during resume like the old DM and block integrity code did).. but we
> can iterate on this as needed.
> 
> Feel free to fold it into your last patch and add my Signed-off-by.

Martin, any chance to repost with Mike's changes folded in?  I'd really
hate to miss 4.4 for the series.
