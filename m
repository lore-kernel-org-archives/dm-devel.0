From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm-crypt: Reject sector_size feature if
 device length is not aligned to it
Date: Sat, 30 Sep 2017 20:31:09 +0200
Message-ID: <b6c539ce-c841-a21c-1a2c-4ee93d826680@gmail.com>
References: <20170913134556.23145-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170913134556.23145-1-gmazyland@gmail.com>
Content-Language: en-US
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On 09/13/2017 03:45 PM, Milan Broz wrote:
> If a crypt mapping uses optional sector_size feature, additional
> restrictions to mapped device segment size must be applied in constructor,
> otherwise the device activation will fail later.

Hi,

we had some discussion with Mikulas if this check should be better in generic DM code.

I think that for this case it is not a good idea - dm-crypt can increase
encryption sector size during load (it is stupid to do, but I see no reason why to block it).
And then only constructor of the target itself know what is possible and what should be rejected.

Anyway, there is a short reproducer what this patch solves:

Create simple mapping with 4096 encryption sector:

# dmsetup create test --table "0 8 crypt cipher_null - 0 /dev/sdb 0 1 sector_size:4096"

Now load new unaligned-length table (this should fail!)
# dmsetup load test --table "0 9 crypt cipher_null - 0 /dev/sdb 0 1 sector_size:4096"

Inactive table is apparently accepted:
# dmsetup table --inactive
test: 0 9 crypt cipher_null 0 0 8:16 0 1 sector_size:4096

And now, resume fails, keeping the device in suspended state afterward:

# dmsetup resume test
device-mapper: resume ioctl on test failed: Invalid argument
Command failed
kernel: device-mapper: table: 254:0: len=9 not aligned to h/w logical block size 4096 of sdb

# dmsetup info -c
Name             Maj Min Stat Open Targ Event  UUID
test             254   0 L-sw    0    1      0

With the patch applied, the load step correctly fails:
# dmsetup load test --table "0 9 crypt cipher_null - 0 /dev/sdb 0 1 sector_size:4096"
device-mapper: reload ioctl on test failed: Invalid argument
kernel: device-mapper: table: 254:0: crypt: Device size is not multiple of sector_size feature

Please consider this for 4.14 (and stable 4.12+ perhaps).

Thanks,
Milan

> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
>  drivers/md/dm-crypt.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 54aef8ed97db..488ecd0b1bd0 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2584,6 +2584,10 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
>  				ti->error = "Invalid feature value for sector_size";
>  				return -EINVAL;
>  			}
> +			if (ti->len & ((cc->sector_size >> SECTOR_SHIFT) - 1)) {
> +				ti->error = "Device size is not multiple of sector_size feature";
> +				return -EINVAL;
> +			}
>  			cc->sector_shift = __ffs(cc->sector_size) - SECTOR_SHIFT;
>  		} else if (!strcasecmp(opt_string, "iv_large_sectors"))
>  			set_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags);
> 
