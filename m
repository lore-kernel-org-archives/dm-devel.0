From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: dm-integrity
Date: Mon, 13 Jan 2020 22:41:25 +0100
Message-ID: <CAJH6TXjN8V4a4jE6AECCg=quMd9FPA=ST0_9ZtZcGKUzvY5wYg@mail.gmail.com>
References: <CAJH6TXhnkB10BUENn0P+qXy4nunwY6QVtgDvaFVpfGDpvE-V=Q@mail.gmail.com>
 <CAPhsuW6srGADYYD4dsUbVVBcz4bfJ-taoOy6ccpXjyU26jVTEg@mail.gmail.com>
 <20200113181654.GA7645@lazy.lzy> <CAPhsuW6urOBa5s9od-znfn9J2jhz3cCOxmqu6tABvyoCEx5BHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW6urOBa5s9od-znfn9J2jhz3cCOxmqu6tABvyoCEx5BHQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, dm-devel@redhat.com, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

Il giorno lun 13 gen 2020 alle ore 19:58 Song Liu <song@kernel.org> ha scritto:
> Right now, md_done_sync() doesn't really print any message. I think this is
> easy to add. However, md check/recovery is at block granularity, so we
> probably cannot print exact which sector got fixed.

Well, having the exact sector fixed is not mandatory, but really useful.
Better than nothing would be md logging that has fixed "something" and
it's location (a setor, a block, ....)
9 times out of 10 the dm-integrity log would be just above the md log,
so a match between dm-integrity sector and md block would be easy,
just read the line below or above.

I think that md should be a little bit more verbose on certain
actions. (in example, saying what was fixed, the last time of scrub
and it's result, as per my previous thread and so on)
