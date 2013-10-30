From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/2] dm-crypt: Add TCW IV mode for old
	CBC	TCRYPT containers.
Date: Wed, 30 Oct 2013 18:12:41 +0000
Message-ID: <20131030181241.GA24325@agk-dp.fab.redhat.com>
References: <1382275000-10660-1-git-send-email-gmazyland@gmail.com>
	<1382998864-10380-1-git-send-email-gmazyland@gmail.com>
	<1382998864-10380-2-git-send-email-gmazyland@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1382998864-10380-2-git-send-email-gmazyland@gmail.com>
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

On Mon, Oct 28, 2013 at 11:21:04PM +0100, Milan Broz wrote:
> +++ b/Documentation/device-mapper/dm-crypt.txt
> @@ -4,12 +4,15 @@ dm-crypt

> +	crypto_xor(buf, (u8*)&sector, 8);
                           ^
Please insert a single space in casts like this: (u8 *)

> +	for (i = 0; i < 4; i++) {
> +		if ((r = crypto_shash_init(&sdesc.desc)))
> +			goto out;

Please change these to this form:
		r = crypto_shash_init(&sdesc.desc));
		if (r)
			goto out;

Alasdair
