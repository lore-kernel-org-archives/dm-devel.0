From: Song Liu <song@kernel.org>
Subject: Re: dm-integrity
Date: Mon, 13 Jan 2020 10:58:05 -0800
Message-ID: <CAPhsuW6urOBa5s9od-znfn9J2jhz3cCOxmqu6tABvyoCEx5BHQ@mail.gmail.com>
References: <CAJH6TXhnkB10BUENn0P+qXy4nunwY6QVtgDvaFVpfGDpvE-V=Q@mail.gmail.com>
 <CAPhsuW6srGADYYD4dsUbVVBcz4bfJ-taoOy6ccpXjyU26jVTEg@mail.gmail.com> <20200113181654.GA7645@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200113181654.GA7645@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, dm-devel@redhat.com, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, Jan 13, 2020 at 10:17 AM Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
>
> On Mon, Jan 13, 2020 at 10:11:00AM -0800, Song Liu wrote:
> > + dm-devel
> >
> > On Sun, Jan 12, 2020 at 5:43 AM Gandalf Corvotempesta
> > <gandalf.corvotempesta@gmail.com> wrote:
> > >
> > > I'm testing dm-integrity.
> > > Simple question: when corrupted data are found, repair is done
> > > immediately or on next scrub?
> > >
> > > This is what I have:
> > >
> > > [ 6727.395808] md: data-check of RAID array md0
> > > [ 6727.528589] device-mapper: integrity: Checksum failed at sector 0xe228
> > > [ 6727.938689] md: md0: data-check done.
> > > [ 6749.125075] md: data-check of RAID array md0
> > > [ 6749.664269] md: md0: data-check done.
> > >
> > > if repair is done immediatly, would be possible to add a single log
> > > line saying that ?
> > > something like:
> > > [ 6727.528589] md: md0: Repaired data at sector 0xe228
> >
> > I guess this belongs to dm-integrity instead of md?
>
> Eh, well, no.
> He is asking about "md" in case the underlying
> layer, dm-integrity in this case, returns an error.
>
> This could be the case also if the HDD returns
> a read error which the RAID will correct and,
> if I get it right, rewrite.

I see. Thanks for the clarification.

>
> But I guess "md" already returns where the
> correction happened, isn't like that?
> I recall seeing in the logs something about
> it, but it was some time ago...

Right now, md_done_sync() doesn't really print any message. I think this is
easy to add. However, md check/recovery is at block granularity, so we
probably cannot print exact which sector got fixed.

Thanks,
Song
