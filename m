From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [BUG REPORT] ENOTBLK on create cache if metadata
 device not zeroed (3.9.0-rc7)
Date: Mon, 22 Apr 2013 14:09:07 -0400
Message-ID: <20130422180906.GA2862@redhat.com>
References: <33A0129EBFD46748804DE81B354CA1B2DB1BCB@SACEXCMBX06-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <33A0129EBFD46748804DE81B354CA1B2DB1BCB@SACEXCMBX06-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Mears, Morgan" <Morgan.Mears@netapp.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Apr 22 2013 at 12:47pm -0400,
Mears, Morgan <Morgan.Mears@netapp.com> wrote:

> Hi,
> 
> I was setting up for some dm-cache testing this weekend (using 3.9.0-rc7 x86_64) and ran into the following:
> 
> # dmsetup create cache --table '0 41943040 cache /dev/mapper/metadata /dev/mapper/ssd /dev/mapper/origin 512 1 writeback default 0'
> device-mapper: reload ioctl on cache failed: Block device required
> Command failed
> #
> 
> After this error, /var/log/messages contains:
> 
> [75376.089354] device-mapper: cache metadata: sb_check failed: blocknr 18446744073709551615: wanted 0
> [75376.089362] device-mapper: block manager: superblock validator check failed for block 0
> [75376.089364] device-mapper: cache metadata: couldn't read lock superblock
> [75376.095173] device-mapper: table: 253:5: cache: Error creating metadata object
> [75376.095180] device-mapper: ioctl: error adding target to table
> 
> This comes from sb_check() in drivers/md/dm-cache-metadata.c and drivers/md/dm-thin-metadata.c, and it motivated me to try:
> 
> # dd if=/dev/zero of=/dev/mapper/metadata bs=4k conv=notrunc
> 
> Afterwards, I tried "dmsetup create cache" again and it worked fine.

Right, we check if the superblock is all zeroes, and if so we know this
is the initial cache creation with the specified metadata device.

It should be noted that when lvm2's support for dm-cache is added it
will take care of zeroing the metadata device for you for the initial
create.

I thought we documented the need to zero the start of the metadata device
but it is clearly missing from Documentation/device-mapper/cache.txt.  I
must've been thinking of Documentation/device-mapper/thin-provisioning.txt
(which has the same metadata and data device split as the cache target):

Setting up a fresh pool device
------------------------------

Setting up a pool device requires a valid metadata device, and a
data device.  If you do not have an existing metadata device you can
make one by zeroing the first 4k to indicate empty metadata.

    dd if=/dev/zero of=$metadata_dev bs=4096 count=1
