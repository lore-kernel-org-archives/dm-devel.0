From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1.5/2] dm-stripe: optimize sector division
Date: Wed, 28 Jul 2010 10:43:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007281029440.22479@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1007271737310.14765@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007271738500.14765@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007271811220.21698@hs20-bc2-1.build.redhat.com>
	<20100728135332.GA31387@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100728135332.GA31387@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, 28 Jul 2010, Mike Snitzer wrote:

> Looking closer I'm seeing something odd:
> 
> On Tue, Jul 27 2010 at  6:12pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > @@ -212,7 +217,11 @@ static void stripe_map_sector(struct str
> >  {
> >  	sector_t offset = sector - sc->ti->begin;
> >  	sector_t chunk = offset >> sc->chunk_shift;
> > -	*stripe = sector_div(chunk, sc->stripes);
> > +	if (likely(sc->stripes_shift >= 0))
> > +		*stripe = chunk & ((1 << sc->stripes_shift) - 1),
> > +		chunk >>= sc->stripes_shift;
> 
> What's going on here with the comma?  Shouldn't it be a semi-colon?  And
> if so we need curly-braces around the if (likely...).

I'ts just a syntactic trick to avoid the braces. If you think it is weird, 
you can change it to:
if (likely(sc->stripes_shift >= 0)) {
	*stripe = chunk & ((1 << sc->stripes_shift) - 1);
	chunk >>= sc->stripes_shift;
} else

The comma operator in C (if not used to denote function arguments) means 
"evaluate the expression before the comma and discard the result, then 
evaluate the expression after the comma and return the result".

Comma has the lowest priority of all operators. Even lower than "=".

So "a = (1, 2, 3);" means "a = 3;"
"a = 1, 2, 3" is parsed as "(a = 1), 2, 3" and it assigns 1 to a, discards 
2 and returns 3 (if used as part of another expression; if used 
standalone, it discards that 3).

"if (c) a = 1, b = 2;" assigns 1 to a and 2 to b if c is non-zero. It is 
equivalent to "if (c) { a = 1; b = 2; }"

Another common use for comma is to stuff arbitrary function calls into the 
expression --- i.e. for example
#define read_register(x) (printk("reading register %x\n", x), inb(BASE + (x)))
which could then be used as
int r3 = read_register(3);

Mikulas

> > +	else
> > +		*stripe = sector_div(chunk, sc->stripes);
> >  	*result = (chunk << sc->chunk_shift) | (offset & sc->chunk_mask);
> >  }
> 
