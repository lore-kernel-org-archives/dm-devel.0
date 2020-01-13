From: Song Liu <song@kernel.org>
Subject: Re: dm-integrity
Date: Mon, 13 Jan 2020 10:11:00 -0800
Message-ID: <CAPhsuW6srGADYYD4dsUbVVBcz4bfJ-taoOy6ccpXjyU26jVTEg@mail.gmail.com>
References: <CAJH6TXhnkB10BUENn0P+qXy4nunwY6QVtgDvaFVpfGDpvE-V=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXhnkB10BUENn0P+qXy4nunwY6QVtgDvaFVpfGDpvE-V=Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, dm-devel@redhat.com
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

+ dm-devel

On Sun, Jan 12, 2020 at 5:43 AM Gandalf Corvotempesta
<gandalf.corvotempesta@gmail.com> wrote:
>
> I'm testing dm-integrity.
> Simple question: when corrupted data are found, repair is done
> immediately or on next scrub?
>
> This is what I have:
>
> [ 6727.395808] md: data-check of RAID array md0
> [ 6727.528589] device-mapper: integrity: Checksum failed at sector 0xe228
> [ 6727.938689] md: md0: data-check done.
> [ 6749.125075] md: data-check of RAID array md0
> [ 6749.664269] md: md0: data-check done.
>
> if repair is done immediatly, would be possible to add a single log
> line saying that ?
> something like:
> [ 6727.528589] md: md0: Repaired data at sector 0xe228

I guess this belongs to dm-integrity instead of md?

Thanks,
Song
