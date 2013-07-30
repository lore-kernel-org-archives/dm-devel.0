From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm cache: verify metadata device is exclussive
Date: Tue, 30 Jul 2013 07:11:19 -0400
Message-ID: <20130730111119.GA9185@redhat.com>
References: <1374713456-20807-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1374713456-20807-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jul 24 2013 at  8:50pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Do not allow a cache device to use a metadata device that is already
> in use by another cache device.
> 
> Add list member to the cache structure.  Also reorder members in the
> cache structure to eliminate 6 out of 7 holes (reclaiming 24 bytes).
> 
> Example:
>  echo "0 8192 linear 253:1 0" | dmsetup create metadata
>  echo "0 2097152 linear 253:1 8192" | dmsetup create ssd
>  echo "0 33554432 linear 253:0 0" | dmsetup create origin
>  echo "0 33554432 cache /dev/mapper/metadata /dev/mapper/ssd /dev/mapper/origin 512 0 default 0" | dmsetup create cache1
>  echo "0 33554432 cache /dev/mapper/metadata /dev/mapper/ssd /dev/mapper/origin 512 0 default 0" | dmsetup create cache2
> device-mapper: reload ioctl on cache2 failed: Device or resource busy
> Command failed
> 
> Kernel log shows:
> device-mapper: table: 253:8: cache: metadata device already in use by a cache
> device-mapper: ioctl: error adding target to table

Self-NACK.

This patch doesn't handle reloading a cache device.  The cache struct
member reshuffle may be useful to better align on cachelines and
eliminate holes but I'll repost a separate patch accordingly.
