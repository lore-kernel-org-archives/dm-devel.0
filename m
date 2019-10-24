From: Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 1/4] block: Enhance
	blk_revalidate_disk_zones()
Date: Thu, 24 Oct 2019 16:20:31 +0900
Message-ID: <20191024072031.GA29028@redsun51.ssa.fujisawa.hgst.com>
References: <20191024065006.8684-1-damien.lemoal@wdc.com>
	<20191024065006.8684-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191024065006.8684-2-damien.lemoal@wdc.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Oct 24, 2019 at 03:50:03PM +0900, Damien Le Moal wrote:
> -=09/* Do a report zone to get max_lba and the same field */
> -=09ret =3D sd_zbc_do_report_zones(sdkp, buf, bufsize, 0, false);
> +=09/* Do a report zone to get max_lba and the size of the first zone */
> +=09ret =3D sd_zbc_do_report_zones(sdkp, buf, SD_BUF_SIZE, 0, false);

This is no longer reading all the zones here, so you could set the
'partial' field to true. And then since this was the only caller that
had set partial to false, you can also remove that parameter.
