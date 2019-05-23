From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH V2 1/2] block: Fix a NULL pointer dereference in generic_make_request()
Date: Thu, 23 May 2019 10:06:28 -0700
Message-ID: <CAPhsuW7o9bj5DYnUDkCqDeW7NnfNTSBBWJC5_ZVxhoomDEEJcg@mail.gmail.com>
References: <20190520220911.25192-1-gpiccoli@canonical.com>
 <CAPhsuW6KayaNR-0eFHpvPG-LVuPFL_1OFjvZpOcnapVFe2vC9Q@mail.gmail.com> <3e583b2d-742a-3238-69ed-7a2e6cce417b@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <3e583b2d-742a-3238-69ed-7a2e6cce417b@canonical.com>
Sender: stable-owner@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: linux-block@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>, Gavin Guo <gavin.guo@canonical.com>, Jay Vosburgh <jay.vosburgh@canonical.com>, "Guilherme G. Piccoli" <kernel@gpiccoli.net>, stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@redhat.com>, Eric Ren <renzhengeek@gmail.com>, hch@infradead.org
List-Id: dm-devel.ids

On Thu, May 23, 2019 at 7:36 AM Guilherme G. Piccoli
<gpiccoli@canonical.com> wrote:
>
> On 21/05/2019 02:59, Song Liu wrote:
> >
> > Applied both patches! Thanks for the fix!
>
> Hi Song, sorry for the annoyance, but the situation of both patches is a
> bit confused for me heheh
>
> You mention you've applied both patches - I couldn't find your tree.
> Also, Christoph noticed Ming's series fixes both issues and suggested to
> drop both my patches in favor of Ming's clean-up, or at least make them
> -stable only.
>
> So, what is the current status of the patches? Can we have them on
> -stable trees at least? If so, how should I proceed?
>
> Thanks in advance for the clarification!
> Cheers,
>
>
> Guilherme

Sorry for the confusion and delay. I will send patches to stable@.

Song
