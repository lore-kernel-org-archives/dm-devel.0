From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm-crypt: Properly handle extra key
 string in initialization
Date: Mon, 28 Oct 2013 11:44:47 -0400
Message-ID: <20131028154447.GA25212@redhat.com>
References: <1382275000-10660-1-git-send-email-gmazyland@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1382275000-10660-1-git-send-email-gmazyland@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Oct 20 2013 at  9:16am -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> Some encryption modes use extra keys (e.g. loopAES has IV seed)
> which are not used in block cipher initialization but are part
> of key string in table constructor.
> 
> Patch adds additional field which described lengh of this extra
> keys and substracts it before real key encryption setting.

typo, s/lengh/length/

But that aside, an example of the extra keys use with a theoretical
example via ctr input -- documented in patch header -- would be
helpful.  As it stands the code is doing some unituitive things (see
below).

> Because extra keys are calculated during IV mode setting,
> key initialization is moved after this step.
> 
> For now, this change has no effect to supported modes
> (thanks to ilog2 rounding) but is required by following patch.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
>  drivers/md/dm-crypt.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 0fce0bc..878bda7 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1497,14 +1495,23 @@ static int crypt_ctr_cipher(struct dm_target *ti,
>  		 * to length of provided multi-key string.
>  		 * If present (version 3), last key is used as IV seed.
>  		 */
> -		if (cc->key_size % cc->key_parts)
> +		if (cc->key_size % cc->key_parts) {
>  			cc->key_parts++;
> +			cc->key_extra_size = cc->key_size / cc->key_parts;
> +		}

This is leveraging existing heuristics of bumping key_parts and then
using it to establish 'key_extra_size' -- but the definition of "extra
size" is eluding me.  Say key_size=101, kepyparts=10 -- remainder is 1.
So then key_extra_size = 9.

All a bit opaque to me without a ctr usage example to help document in
the patch header.
