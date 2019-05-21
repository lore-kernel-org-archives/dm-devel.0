From: Guilherme Piccoli <gpiccoli@canonical.com>
Subject: Re: [PATCH V2 1/2] block: Fix a NULL pointer dereference in generic_make_request()
Date: Tue, 21 May 2019 09:07:38 -0300
Message-ID: <CAHD1Q_wkziJYx4z0JcBavmQRzTh3a4g5xZG8bhVX+TYTkhaTrg@mail.gmail.com>
References: <20190520220911.25192-1-gpiccoli@canonical.com> <CAPhsuW6KayaNR-0eFHpvPG-LVuPFL_1OFjvZpOcnapVFe2vC9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW6KayaNR-0eFHpvPG-LVuPFL_1OFjvZpOcnapVFe2vC9Q@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Song Liu <liu.song.a23@gmail.com>
Cc: linux-block@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>, Jay Vosburgh <jay.vosburgh@canonical.com>, "Guilherme G. Piccoli" <kernel@gpiccoli.net>, stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@redhat.com>, Eric Ren <renzhengeek@gmail.com>
List-Id: dm-devel.ids

On Tue, May 21, 2019 at 2:59 AM Song Liu <liu.song.a23@gmail.com> wrote:
> Applied both patches! Thanks for the fix!
>

Thanks Song!
