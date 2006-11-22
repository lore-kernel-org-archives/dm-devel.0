From: Roland Paterson-Jones <roland@rolandpj.com>
Subject: Re: Help/Info on basic snapshot for CoW
Date: Wed, 22 Nov 2006 13:47:08 +0200
Message-ID: <456438BC.1090603@rolandpj.com>
References: <45632199.9000308@amazon.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <45632199.9000308@amazon.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Roland Paterson-Jones wrote:

> So, where is the overlay mapping stored? I believe that this is known 
> as the 'exception store', and I can see some stuff about it in the 
> source, but where does a persistent overlay map end up?
>
> Also, how is the overlay (snapshot) device used? Is there a one-to-one 
> mapping of (logical device) block offsets onto the overlay (snapshot) 
> device? If so, where does the overlay map fit in?

OK, so nobody wants to talk to me :( I'll answer myself, just in case 
anyone is interested.

It seems that the exception store is maintained in a header at the start 
of the overlay device, and that CoW writes are done in chunks mapped 
from the header. There's an in-memory cache of one 'map' area to avoid 
going to the device for the mapping for every request. So, it seems to 
be for now that:
    1. There's no linearity between device offsets on the logical 
snapshot device, and chunk offsets on the (real) overlay device. It 
simply depends on access patterns. I'm guessing that this could cause 
odd head thrashing in obscure cases.
    2. To support the full logical device extent, the real overlay 
device has to have enough space for the header plus the device extent. 
How big is the header?

> Lastly, how do I flush the overlay mapping? Suppose I have had quite 
> enough of the (modified) snapshot and I want to revert to the original 
> origin in a snapshot using the same overlay (snapshot) device. I 
> notice empirically that if I 'dmsetup remove' then 'dmsetup create ... 
> n ...', then 'dmsetup remove ...' once more, and finally 'dmsetup 
> create ... p ...', then I have a clean snapshot of the origin again. 
> I'm guessing there's a better way ;)

Writing over the header at the start of the overlay device does the 
trick. I'm not sure that the above will work in all cases?\

I'm quite keen on a dm-cow plugin that maintains sector offsets (well 
linearity at least) between the origin and the CoW overlay for 
consistent performance. I'd be happy in this case to put the CoW mapping 
on a separate (small) device, or to put it at the front of the overlay 
and use a linear bump for all sectors.

The current snapshot facility seems oriented towards taking a small 
snapshot of a big origin, where all the subsequent action is on the 
origin. My use case is a sparse origin that I want to CoW over, where 
all the action is in the CoW overlay.

The only previous CoW endeavour I can find is the dm-userspace one. I 
don't really have a need to poke through into user-space tho.

Has anyone else persued a basic dm-cow like this. Otherwise I might just 
have to write some code =8-O.

Regards
Roland
