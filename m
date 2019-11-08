From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 9/9] block: rework zone reporting
Date: Fri, 8 Nov 2019 10:16:16 -0500
Message-ID: <20191108151616.GA8047@redhat.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
	<20191108015702.233102-10-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191108015702.233102-10-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, dm-devel@redhat.com, Jaegeuk Kim <jaegeuk@kernel.org>
List-Id: dm-devel.ids

On Thu, Nov 07 2019 at  8:57pm -0500,
Damien Le Moal <damien.lemoal@wdc.com> wrote:

> From: Christoph Hellwig <hch@lst.de>
>=20
> Avoid the need to allocate a potentially large array of struct blk_zone
> in the block layer by switching the ->report_zones method interface to
> a callback model. Now the caller simply supplies a callback that is
> executed on each reported zone, and private data for it.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
