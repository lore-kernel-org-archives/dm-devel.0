From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] dm crypt: Convert essiv from ahash to shash
Date: Mon, 16 Jul 2018 12:23:56 +0200
Message-ID: <CAK8P3a10ONoVAt8+5TNaYzM2qaH=0THkx16tZCd7hpcx-TWvBQ@mail.gmail.com>
References: <20180716035912.GA32261@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716035912.GA32261@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@google.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, Jul 16, 2018 at 5:59 AM, Kees Cook <keescook@chromium.org> wrote:
> In preparing to remove all stack VLA usage from the kernel[1], this
> removes the discouraged use of AHASH_REQUEST_ON_STACK in favor of
> the smaller SHASH_DESC_ON_STACK by converting from ahash-wrapped-shash
> to direct shash. The stack allocation will be made a fixed size in a
> later patch to the crypto subsystem.
>
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

This looks very nice, it should also make the operation more efficient in the
process by removing one indirection layer.

     Arnd
