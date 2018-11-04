From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm crypt: use unsigned long long instead of
 sector_t to store iv_offset
Date: Sun, 4 Nov 2018 14:39:45 +0100
Message-ID: <c3960f95-bcb3-942a-a211-8d701066a898@gmail.com>
References: <20a82f81-071e-e742-fc18-2088853efb0f@gmail.com>
	<1541217208-60218-1-git-send-email-alios_sys_security@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1541217208-60218-1-git-send-email-alios_sys_security@linux.alibaba.com>
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
To: AliOS system security <alios_sys_security@linux.alibaba.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 03/11/2018 04:53, AliOS system security wrote:
> The iv_offset in the mapping table of crypt target is a 64bit number
> when iv mode is plain64 or plain64be. It will be assigned to iv_offset of
> struct crypt_config, cc_sector of struct convert_context and iv_sector of
> struct dm_crypt_request. These structures members are defined as a sector_t.
> But sector_t is 32bit when CONFIG_LBDAF is not set in 32bit kernel. In this
> situation sector_t is not big enough to store the 64bit iv_offset.
> 
> Signed-off-by: AliOS system security <alios_sys_security@linux.alibaba.com>

I think there are more IV algorithms that are affected (ESSIV, benbi, ...)

I am ok with "unsigned loing long" there (despite it is u64 in reality),
but we are already using "unsigned long long" when parsing the table in constructor...

We should add reproducer to the patch header, here using the cryptsetup.

Prepare test image and device (loop is automatically allocated by cryptsetup):

  # dd if=/dev/zero of=tst.img bs=1M count=1
  # echo "tst"|cryptsetup open --type plain -c aes-xts-plain64 --skip 500000000000000000 tst.img test

On 32bit system (use IV offset value that overflows to 64bit; CONFIG_LBDAF if off)
and device checksum is wrong:

  # dmsetup table test --showkeys
  0 2048 crypt aes-xts-plain64 dfa7cfe3c481f2239155739c42e539ae8f2d38f304dcc89d20b26f69daaf0933 3551657984 7:0 0

  # sha256sum /dev/mapper/test
  533e25c09176632b3794f35303488c4a8f3f965dffffa6ec2df347c168cb6c19  /dev/mapper/test

On 64bit system (and on 32bit system with the patch), table and checksum is now correct:

  # dmsetup table test --showkeys
  0 2048 crypt aes-xts-plain64 dfa7cfe3c481f2239155739c42e539ae8f2d38f304dcc89d20b26f69daaf0933 500000000000000000 7:0 0

  # sha256sum /dev/mapper/test
  5d16160f9d5f8c33d8051e65fdb4f003cc31cd652b5abb08f03aa6fce0df75fc  /dev/mapper/test


You can add my
Tested-and-Reviewed-by: Milan Broz <gmazyland@gmail.com>

Milan

> ---
>  drivers/md/dm-crypt.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index b8eec51..49be7a6 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -49,7 +49,7 @@ struct convert_context {
>  	struct bio *bio_out;
>  	struct bvec_iter iter_in;
>  	struct bvec_iter iter_out;
> -	sector_t cc_sector;
> +	unsigned long long cc_sector;
>  	atomic_t cc_pending;
>  	union {
>  		struct skcipher_request *req;
> @@ -81,7 +81,7 @@ struct dm_crypt_request {
>  	struct convert_context *ctx;
>  	struct scatterlist sg_in[4];
>  	struct scatterlist sg_out[4];
> -	sector_t iv_sector;
> +	unsigned long long iv_sector;
>  };
>  
>  struct crypt_config;
> @@ -160,7 +160,7 @@ struct crypt_config {
>  		struct iv_lmk_private lmk;
>  		struct iv_tcw_private tcw;
>  	} iv_gen_private;
> -	sector_t iv_offset;
> +	unsigned long long iv_offset;
>  	unsigned int iv_size;
>  	unsigned short int sector_size;
>  	unsigned char sector_shift;
> 
