From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1.5/2] dm-stripe: optimize sector division
Date: Wed, 28 Jul 2010 09:53:33 -0400
Message-ID: <20100728135332.GA31387@redhat.com>
References: <Pine.LNX.4.64.1007271737310.14765@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007271738500.14765@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007271811220.21698@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1007271811220.21698@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Looking closer I'm seeing something odd:

On Tue, Jul 27 2010 at  6:12pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> @@ -212,7 +217,11 @@ static void stripe_map_sector(struct str
>  {
>  	sector_t offset = sector - sc->ti->begin;
>  	sector_t chunk = offset >> sc->chunk_shift;
> -	*stripe = sector_div(chunk, sc->stripes);
> +	if (likely(sc->stripes_shift >= 0))
> +		*stripe = chunk & ((1 << sc->stripes_shift) - 1),
> +		chunk >>= sc->stripes_shift;

What's going on here with the comma?  Shouldn't it be a semi-colon?  And
if so we need curly-braces around the if (likely...).

> +	else
> +		*stripe = sector_div(chunk, sc->stripes);
>  	*result = (chunk << sc->chunk_shift) | (offset & sc->chunk_mask);
>  }
