From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/4] dm verity: add support for error correction
Date: Wed, 2 Dec 2015 15:22:03 -0500
Message-ID: <20151202202203.GB51353@redhat.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
 <563B066C.6050202@redhat.com>
 <20151105173306.GA22302@google.com>
 <20151109163735.GA28884@redhat.com>
 <20151109191925.GA29185@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151109191925.GA29185@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, Mandeep Baines <msb@chromium.org>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Mark Salyzyn <salyzyn@google.com>, Alasdair Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 09 2015 at  2:19P -0500,
Sami Tolvanen <samitolvanen@google.com> wrote:

> On Mon, Nov 09, 2015 at 11:37:35AM -0500, Mike Snitzer wrote:
> > I'm left wondering: can the new error correction code be made an
> > optional feature that is off by default? -- so as to preserve some
> > isolation of this new code from the old dm-verity behaviour.
> 
> It's optional in the sense that you must specify error correction
> parameters in the table to turn it on. Otherwise, verity_dec_decode
> returns -1 and dm-verity handles errors as before.
> 
> > might be good to add a wrapper like verity_fec_is_enabled().
> 
> Sure. I can do this in v2 and address the other feedback and build
> issues as well.

Hi Sami,

Any progress on v2 that takes into account previous review feedback?

Note I've staged the first 2 patches in this series for Linux 4.5
inclusion, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.5

Mike
