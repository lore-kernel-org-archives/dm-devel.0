From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: libnvdimm fixes 5.9-rc6
Date: Sun, 20 Sep 2020 15:03:36 -0700
Message-ID: <CAHk-=whuR1ZHV4c6a7d3EmgRBFfQfYGckD2t1kQXDpwnf50ATA@mail.gmail.com>
References: <CAPcyv4h3oKM-2hoG=FWHJwzVqjptnpQV9C+W6txfp_qcBhd7yQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4h3oKM-2hoG=FWHJwzVqjptnpQV9C+W6txfp_qcBhd7yQ@mail.gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, device-mapper development <dm-devel@redhat.com>, Jan Kara <jack@suse.cz>, Adrian Huang12 <ahuang12@lenovo.com>, Mike Snitzer <snitzer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Sun, Sep 20, 2020 at 11:56 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
>    You will notice that this branch was rebased this
> morning and it has not appeared in -next. I decided to cut short the
> soak time because the infinite-recursion regression is currently
> crashing anyone attempting to test filesystem-dax in 5.9-rc5+.

Thanks for the explanation, all looks fine.

             Linus
