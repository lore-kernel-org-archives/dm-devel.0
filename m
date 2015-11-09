From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH 0/4] dm verity: add support for error correction
Date: Mon, 9 Nov 2015 19:19:25 +0000
Message-ID: <20151109191925.GA29185@google.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
 <563B066C.6050202@redhat.com>
 <20151105173306.GA22302@google.com>
 <20151109163735.GA28884@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151109163735.GA28884@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

On Mon, Nov 09, 2015 at 11:37:35AM -0500, Mike Snitzer wrote:
> I'm left wondering: can the new error correction code be made an
> optional feature that is off by default? -- so as to preserve some
> isolation of this new code from the old dm-verity behaviour.

It's optional in the sense that you must specify error correction
parameters in the table to turn it on. Otherwise, verity_dec_decode
returns -1 and dm-verity handles errors as before.

> might be good to add a wrapper like verity_fec_is_enabled().

Sure. I can do this in v2 and address the other feedback and build
issues as well.

> Also, the 2 other big questions from Mikulas need answering:
> 1) why aren't you actually adjustng error codes, returning success, if
>    dm-verity was able to trap/correct the corruption?

We don't see actual I/O errors very often. Most corruption we've seen
is caused by flaky hardware that doesn't return errors. However, I can
certainly change to code to attempt recovery in this case too.

> 2) please fix the code to preallocate all required memory -- so that
>    verity_fec_alloc_buffers() isn't called in map.

I tried to avoid preallocating the buffers because they are relatively
large (up to 1 MiB depending on the Reed-Solomon parameters) and not
required unless we have errors to correct. I suppose there's no way to
safely do this in the middle of I/O?

> If this error correction feature is going to go upstream we really
> should see any associated userspace enablement also included in
> veritysetup.

I can look into this.

Sami
