From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: dm-integrity
Date: Mon, 13 Jan 2020 19:16:54 +0100
Message-ID: <20200113181654.GA7645@lazy.lzy>
References: <CAJH6TXhnkB10BUENn0P+qXy4nunwY6QVtgDvaFVpfGDpvE-V=Q@mail.gmail.com>
 <CAPhsuW6srGADYYD4dsUbVVBcz4bfJ-taoOy6ccpXjyU26jVTEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPhsuW6srGADYYD4dsUbVVBcz4bfJ-taoOy6ccpXjyU26jVTEg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, dm-devel@redhat.com, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, Jan 13, 2020 at 10:11:00AM -0800, Song Liu wrote:
> + dm-devel
> 
> On Sun, Jan 12, 2020 at 5:43 AM Gandalf Corvotempesta
> <gandalf.corvotempesta@gmail.com> wrote:
> >
> > I'm testing dm-integrity.
> > Simple question: when corrupted data are found, repair is done
> > immediately or on next scrub?
> >
> > This is what I have:
> >
> > [ 6727.395808] md: data-check of RAID array md0
> > [ 6727.528589] device-mapper: integrity: Checksum failed at sector 0xe228
> > [ 6727.938689] md: md0: data-check done.
> > [ 6749.125075] md: data-check of RAID array md0
> > [ 6749.664269] md: md0: data-check done.
> >
> > if repair is done immediatly, would be possible to add a single log
> > line saying that ?
> > something like:
> > [ 6727.528589] md: md0: Repaired data at sector 0xe228
> 
> I guess this belongs to dm-integrity instead of md?

Eh, well, no.
He is asking about "md" in case the underlying
layer, dm-integrity in this case, returns an error.

This could be the case also if the HDD returns
a read error which the RAID will correct and,
if I get it right, rewrite.

But I guess "md" already returns where the
correction happened, isn't like that?
I recall seeing in the logs something about
it, but it was some time ago...

bye,

-- 

piergiorgio
