From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/9] Zoned block device enhancements and
 zone report rework
Date: Tue, 12 Nov 2019 23:06:10 -0800
Message-ID: <20191113070610.GA17875@infradead.org>
References: <20191111023930.638129-1-damien.lemoal@wdc.com>
 <a0c1c1bf-d6e5-8be1-ed99-6bfed3483d1d@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <a0c1c1bf-d6e5-8be1-ed99-6bfed3483d1d@kernel.dk>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
List-Id: dm-devel.ids

On Tue, Nov 12, 2019 at 07:16:39PM -0700, Jens Axboe wrote:
> We're taking branching to new levels... I created for-5.5/zoned for this,
> which is for-5.5/block + for-5.5/drivers + for-5.5/drivers-post combined.
> The latter is a branch with the SCSI dependencies from Martin pulled in.

So I guess the report of the partitioning series has to go on top of
that?  Let me try..
