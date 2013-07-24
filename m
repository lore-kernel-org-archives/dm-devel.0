From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] dm-thin: Add data block size limits to the
 Documentation
Date: Wed, 24 Jul 2013 11:32:00 +0200
Message-ID: <51EF9F10.3030304@redhat.com>
References: <1374588196-9510-1-git-send-email-cmaiolino@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1374588196-9510-1-git-send-email-cmaiolino@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/23/2013 04:03 PM, Carlos Maiolino wrote:
> $data_block_size can't be any arbitrary number, i.e. its value should be between
> 64K and 1G. Also, it should be a multiple of 64K.

The limits 64K and 1G are correct and enforced by the pool constructor 
in the target.

Blocksize is _not_ a multiple of 64K; it has to be power of 2.

Thus 64K,128K,256K,512K and 1G are valid block sizes for the pool with 
the current pool constructor limits enforced.

-- lvmguy

> Add this information to the dm-thin documentation in order to let users know
> which values they must use.
>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>   Documentation/device-mapper/thin-provisioning.txt | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
> index 30b8b83..ff1629b 100644
> --- a/Documentation/device-mapper/thin-provisioning.txt
> +++ b/Documentation/device-mapper/thin-provisioning.txt
> @@ -104,8 +104,8 @@ primarily interested in thin provisioning may want to use a value such
>   as 1024 (512KB).  People doing lots of snapshotting may want a smaller value
>   such as 128 (64KB).  If you are not zeroing newly-allocated data,
>   a larger $data_block_size in the region of 256000 (128MB) is suggested.
> -$data_block_size must be the same for the lifetime of the
> -metadata device.
> +$data_block_size must be between 128 (64KB) and 2097152 (1GB) and be a multiple
> +of 128 (64KB), and the same for the lifetime of the metadata device.
>   
>   $low_water_mark is expressed in blocks of size $data_block_size.  If
>   free space on the data device drops below this level then a dm event
