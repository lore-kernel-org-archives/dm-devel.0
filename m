From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/4] dm verity: add support for error correction
Date: Mon, 9 Nov 2015 14:58:31 -0500
Message-ID: <20151109195831.GA29996@redhat.com>
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
Cc: Milan Broz <mbroz@redhat.com>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

On Mon, Nov 09 2015 at  2:19pm -0500,
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

Thanks.

> > Also, the 2 other big questions from Mikulas need answering:
> > 1) why aren't you actually adjustng error codes, returning success, if
> >    dm-verity was able to trap/correct the corruption?
> 
> We don't see actual I/O errors very often. Most corruption we've seen
> is caused by flaky hardware that doesn't return errors. However, I can
> certainly change to code to attempt recovery in this case too.

OK, might be worthwhile to simulate underlying storage errors using the
dm-flakey target underneath dm-verity just to validate your changes work
as expected.

> > 2) please fix the code to preallocate all required memory -- so that
> >    verity_fec_alloc_buffers() isn't called in map.
> 
> I tried to avoid preallocating the buffers because they are relatively
> large (up to 1 MiB depending on the Reed-Solomon parameters) and not
> required unless we have errors to correct. I suppose there's no way to
> safely do this in the middle of I/O?

Basically you want to be able to ensure forward progress of dm-verity
IO even in the face of no system memory being generally available.

Hopefully this doesn't seem like make-work for you.  This one of the
design considerations imposed on DM targets because otherwise you run
the risk of failing IO in the face of low memory.  Which results in
users experiencing failures.

1MB is quite large, especially if it is unlikely to be used.  dm-cache
does cope with the need for memory in the IO path, see 'struct
prealloc', prealloc_data_structs() and other related functions in
drivers/md/dm-cache-target.c

But in the dm-cache case a worker thread is processing work and needs
memory for each work item.  So it isn't the .map function that directly
needs the memory.

DM-thinp also pre-allocates memory using a mempool, e.g. see
drivers/md/dm-thin.c:bio_detain().  But again, this portion of dm-thinp
is being run from a worker thread and _not_ the .map functons.

Could you architect the FEC code such that it punts IO to a worker
thread only if errors need correcting?  And have that worker thread's
additional memory allocations be backed by a mempool?
