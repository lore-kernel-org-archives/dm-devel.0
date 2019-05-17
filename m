From: "Guilherme G. Piccoli" <kernel@gpiccoli.net>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
Date: Fri, 17 May 2019 13:19:18 -0300
Message-ID: <CALJn8nOTCcOtFJ1SzZAuJxNuxzf2Tq7Yw34h1E5XE-mbn5CUbg@mail.gmail.com>
References: <20190430223722.20845-1-gpiccoli@canonical.com>
 <20190430223722.20845-2-gpiccoli@canonical.com> <CAPhsuW4SeUhNOJJkEf9wcLjbbc9qX0=C8zqbyCtC7Q8fdL91hw@mail.gmail.com>
 <c8721ba3-5d38-7906-5049-e2b16e967ecf@canonical.com> <CAPhsuW6ahmkUhCgns=9WHPXSvYefB0Gmr1oB7gdZiD86sKyHFg@mail.gmail.com>
 <5CD2A172.4010302@youngman.org.uk> <0ad36b2f-ec36-6930-b587-da0526613567@gpiccoli.net>
 <5CD3096B.4030302@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <5CD3096B.4030302@youngman.org.uk>
Sender: stable-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Song Liu <liu.song.a23@gmail.com>, axboe@kernel.dk
Cc: "Guilherme G. Piccoli" <gpiccoli@canonical.com>, linux-block@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, Gavin Guo <gavin.guo@canonical.com>, Jay Vosburgh <jay.vosburgh@canonical.com>, Ming Lei <ming.lei@redhat.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, stable@vger.kernel.org
List-Id: dm-devel.ids

Jens / Song, any news in this one?

I think would be good to have this raid0 fix rather sooner than later
if possible - it's easy
to reproduce the crash.

Thanks,


Guilherme
