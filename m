From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: CFQ and dm-crypt
Date: Mon, 25 Oct 2010 10:22:11 -0400
Message-ID: <x49sjzumjxo.fsf@segfault.boston.devel.redhat.com>
References: <4CC439ED.8090400@dcs.fmph.uniba.sk> <4CC45BAD.2060308@redhat.com>
	<4CC553A3.5070308@dcs.fmph.uniba.sk> <4CC5655E.2070102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CC5655E.2070102@redhat.com> (Milan Broz's message of "Mon, 25
	Oct 2010 13:09:18 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, axboe@kernel.dk
List-Id: dm-devel.ids

Milan Broz <mbroz@redhat.com> writes:

> On 10/25/2010 11:53 AM, Richard Kralovic wrote:
>
>> Do you think it is possible to handle this in device-mapper, without any
>> support from the cfq code?
>> 
>> I also noticed that a solution for this problem was proposed a few years
>> ago by Hirokazu Takahashi (a patch for linux-2.6.25,
>> http://lkml.org/lkml/2008/4/22/193), but there was no response to it. Is
>> such an approach wrong?
>
> Not sure but it will be discussed now.
> There are more situations where the process id is lost because of other queue,
> a lot of new recent code (including internal thread in dm-core).

It would probably be helpful to CC Jens (which I did).

I haven't looked very deeply at the approach in the referenced mail
thread (though I did look far enough to tell that the aio bits were
wrong), but in general I think this sort of thing is worthwhile.  I'm
not sure what the barriers are.  Jens?

Cheers,
Jeff

>>>> Other possibility is to avoid using separate threads for doing io in dm
>>>> modules. The attached patch (against 2.6.36) modifies dm-crypt in this
>>>> way, what results into much better behavior of cfq (e.g., io priorities
>>>> work correctly).
>>>
>>> Sorry, this completely dismantles the way how dm-crypt solves problems
>>> with stacking dm devices.
>>> Basically it reintroduces possible deadlocks for low memory
>>> situations (the reason why there are these threads).
>> 
>> Would the problem with deadlock be still present if the io worker queue
>> was used for writes only, but reads were issued directly? (Even this
>> would be a significant improvement for people using cfq and a full-disk
>> encryption over dm-crypt, since asynchronous writes are not supported by
>> cfq anyway.)
>
> Sorry, both must be issued from separate thread, you must not block in
> common crypt_map() call:
>
> - READ must first allocate BIO clone for ciphertext data
> (it can wait here - memory allocation, imagine it waits for swap -> swap is
> on another crypt device -> deadlock)
>
> - WRITES first run encryption thus must allocate memory too.
> Moreover if encryption runs in async mode, it can block when encryption queue
> is full (waiting for condition triggerred from async callback) -> again,
> possible deadlock if in common thread.
>
> Of course it will work most of the time, but the design must be robust even
> for not common situations.
>
> Milan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
