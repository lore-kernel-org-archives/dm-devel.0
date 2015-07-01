From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: DM_CACHE_SMQ is experimental and enabled by default? (was: Re: dm
 cache: add stochastic-multi-queue (smq) policy)
Date: Wed, 1 Jul 2015 09:25:49 +0200
Message-ID: <CAMuHMdXTwuOczLM8vBMzMTph4ms6uAODvtHNYxmfR1W-4WAgsQ@mail.gmail.com>
References: <CAMuHMdVfK8x8xXqaq=yX41qZA0L3VP-sezKfDureYMa-QqfM6g@mail.gmail.com>
	<20150626160549.GA15434@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150626160549.GA15434@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>, linux-raid@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Mike,

On Fri, Jun 26, 2015 at 6:05 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Fri, Jun 26 2015 at  3:47am -0400,
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
>> On Fri, Jun 26, 2015 at 2:13 AM, Linux Kernel Mailing List
>> <linux-kernel@vger.kernel.org> wrote:
>> > Gitweb:     http://git.kernel.org/linus/;a=commit;h=66a636356647a9be8885c2ce2948de126577698a
>> > Commit:     66a636356647a9be8885c2ce2948de126577698a
>> >
>> >     dm cache: add stochastic-multi-queue (smq) policy
>>
>> > diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> > index edcf4ab..b597273 100644
>> > --- a/drivers/md/Kconfig
>> > +++ b/drivers/md/Kconfig
>> > @@ -304,6 +304,18 @@ config DM_CACHE_MQ
>> >           This is meant to be a general purpose policy.  It prioritises
>> >           reads over writes.
>> >
>> > +config DM_CACHE_SMQ
>> > +       tristate "Stochastic MQ Cache Policy (EXPERIMENTAL)"
>> > +       depends on DM_CACHE
>> > +       default y
>>
>> A feature cannot be "EXPERIMENTAL", and be enabled by default.
>> Please drop (at least) one of them.
>
> Thanks for your concern, but: no.
>
> If you look closer the entirety of DM cache is marked EXPERIMENTAL:
>
> config DM_CACHE
>        tristate "Cache target (EXPERIMENTAL)"

I stand corrected. Sorry for the fuss.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
