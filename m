From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] dm-crypt: add missing error handling
Date: Mon, 19 Mar 2012 13:21:19 +0100
Message-ID: <4F6724BF.6010003@redhat.com>
References: <Pine.LNX.4.64.1201232131240.17493@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1201232131240.17493@hs20-bc2-1.build.redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On 01/24/2012 03:32 AM, Mikulas Patocka wrote:
> dm-crypt: add missing error handling
>
> There were cases where error code would be used only if we finish processing
> the last sector. If there were other encryption operations in flight, error
> would be ignored and bio would be returned with success as if no error
> happened.

> +static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
>   {
>   	struct bio *clone = io->ctx.bio_out;
>   	struct crypt_config *cc = io->target->private;
>
> -	if (unlikely(error<  0)) {
> +	if (unlikely(io->error<  0)) {

Remove unlikely()... it is removed elsewhere below in this patch and it really
makes no much sense here.

Reviewed-by: Milan Broz <mbroz@redhat.com>
