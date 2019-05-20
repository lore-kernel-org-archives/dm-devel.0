From: Eric Ren <renzhengeek@gmail.com>
Subject: Re: [PATCH 1/2] block: Fix a NULL pointer dereference in generic_make_request()
Date: Mon, 20 May 2019 10:43:44 +0800
Message-ID: <CAKM4AeyJs8KUB3vi=GPDnb-yjED2oFYvn7O=CPNi3Er3orAbfg@mail.gmail.com>
References: <20190430223722.20845-1-gpiccoli@canonical.com>
 <CAKM4Aez=eC96uyqJa+=Aom2M2eQnknQW_uY4v9NMVpROSiuKSg@mail.gmail.com> <CALJn8nME9NQGsSqLXHQPEizFfKUzxozfYy-2510MHyMPHRzhfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CALJn8nME9NQGsSqLXHQPEizFfKUzxozfYy-2510MHyMPHRzhfw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: "Guilherme G. Piccoli" <kernel@gpiccoli.net>
Cc: "Guilherme G. Piccoli" <gpiccoli@canonical.com>, linux-block@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>, Jay Vosburgh <jay.vosburgh@canonical.com>, Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org
List-Id: dm-devel.ids

Hi,

On Sat, 18 May 2019 at 00:17, Guilherme G. Piccoli <kernel@gpiccoli.net> wrote:
>
> On Fri, May 17, 2019 at 12:33 AM Eric Ren <renzhengeek@gmail.com> wrote:
> >
> > Hello,
> > [...]
> > Thanks for the bugfix. I also had a panic having very similar
> > calltrace below as this one,
> > when using devicemapper in container scenario and deleting many thin
> > snapshots by dmsetup
> > remove_all -f, meanwhile executing lvm command like vgs.
> >
> > After applied this one, my testing doesn't crash kernel any more for
> > one week.  Could the block
> > developers please give more feedback/priority on this one?
> >
>
> Thanks Eric, for the testing! I think you could send your Tested-by[0]
> tag, which could be added
> in the patch before merge. It's good to know the patch helped somebody
> and your testing improves
> confidence in the change.

Please consider Ming's comments and send patch v2, then feel free to add:
Tested-by: Eric Ren <renzhengeek@gmail.com>

Thanks!
Eric
