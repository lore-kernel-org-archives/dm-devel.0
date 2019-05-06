From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
Date: Mon, 6 May 2019 17:07:16 -0400
Message-ID: <CAPhsuW6ahmkUhCgns=9WHPXSvYefB0Gmr1oB7gdZiD86sKyHFg@mail.gmail.com>
References: <20190430223722.20845-1-gpiccoli@canonical.com>
 <20190430223722.20845-2-gpiccoli@canonical.com> <CAPhsuW4SeUhNOJJkEf9wcLjbbc9qX0=C8zqbyCtC7Q8fdL91hw@mail.gmail.com>
 <c8721ba3-5d38-7906-5049-e2b16e967ecf@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <c8721ba3-5d38-7906-5049-e2b16e967ecf@canonical.com>
Sender: stable-owner@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: linux-block@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>, Jay Vosburgh <jay.vosburgh@canonical.com>, kernel@gpiccoli.net, Ming Lei <ming.lei@redhat.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, stable@vger.kernel.org
List-Id: dm-devel.ids

On Mon, May 6, 2019 at 2:48 PM Guilherme G. Piccoli
<gpiccoli@canonical.com> wrote:
>
> On 06/05/2019 13:50, Song Liu wrote:
> > [...]
> > IIUC, we need this for all raid types. Is it possible to fix that in md.c so
> > all types get the fix?
> >
> > Thanks,
> > Song
> >
>
> Hi Song, thanks again for reviewing my code and provide input, much
> appreciated!
>
> I understand this could in theory affects all the RAID levels, but in
> practice I don't think it'll happen. RAID0 is the only "blind" mode of
> RAID, in the sense it's the only one that doesn't care at all with
> failures. In fact, this was the origin of my other thread [0], regarding
> the change of raid0's behavior in error cases..because it currently does
> not care with members being removed and rely only in filesystem failures
> (after submitting many BIOs to the removed device).
>
> That said, in this change I've only took care of raid0, since in my
> understanding the other levels won't submit BIOs to dead devices; we can
> experiment that to see if it's true.

Could you please run a quick test with raid5? I am wondering whether
some race condition could get us into similar crash. If we cannot easily
trigger the bug, we can process with this version.

Thanks,
Song

>
> But I'd be happy to change all other levels also if you think it's
> appropriate (or a simple generic change to md.c if it is enough). Do you
> think we could go ahead with this change, and further improve that (to
> cover all raid cases if necessary)?
>
> Cheers,
>
>
> Guilherme
>
>
>
> [0] https://marc.info/?l=linux-raid&m=155562509905735
