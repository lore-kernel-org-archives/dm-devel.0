From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 0/2] dm verity: add support for error correction
Date: Thu, 3 Dec 2015 18:05:38 -0500
Message-ID: <20151203230538.GB5444@redhat.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
 <1449152791-33586-1-git-send-email-samitolvanen@google.com>
 <20151203195401.GA5444@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151203195401.GA5444@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

On Thu, Dec 03 2015 at  2:54pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Dec 03 2015 at  9:26am -0500,
> Sami Tolvanen <samitolvanen@google.com> wrote:
> 
> > Changes since v1:
> > 
> >   - Added CONFIG_DM_VERITY_FEC and split error correction into
> >     dm-verity-fec.[ch] to further separate the functionality from the
> >     rest of dm-verity. Follows the same pattern as dm-uevent.
> > 
> >   - Added missing dependencies for REED_SOLOMON to Kconfig.
> > 
> >   - Renamed dm-verity.c to dm-verity-target.c to allow an optional
> >     object to be added. Follows the naming convention of dm-cache and
> >     dm-era.
> > 
> >   - Changed the algorithm to work with one or more small buffers (~4k)
> >     instead of a single large one. The more buffers we can allocate,
> >     the faster it will work, but we don't have to preallocate a large
> >     amount of memory anymore.
> > 
> >   - Changed memory allocation to use mempools. v2 preallocates all the
> >     memory required for each worker thread to guarantee forward
> >     progress in case of memory pressure. The code attempts to allocate
> >     more buffers (using GFP_NOIO) and uses them if available.
> > 
> >   - Added graceful handling of IO errors, which are now treated as any
> >     other corruption.
> > 
> >   - Rebased against linux-dm/for-next.
> 
> Thanks a lot for these advances, at a high-level it sounds like you've
> handled the issues raised as part of v1 review very well.
> 
> I'll review closer now.  Goal is to get these changes staged in
> linux-next for upstream inclusion during the 4.5 merge window.

I took a first pass through your code and pushed the result to this
temporary branch here:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=dm-verity-fec

As you'll see, I focused primarily on splitting the dm-verity core
changes out from the FEC and ignore_zero_blocks changes.

Along the way I tweaked some style-nits here or there but the biggest
difference between your v2 and what I pushed is captured in this commit:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=dm-verity-fec&id=cc1339fae225d8cdc8fffeff30f0a9981367d6c0

If you're OK with those changes I'll fold that commit into your main FEC
commit.

I'll carry on with reviewing your new code (outside of dm-verity core)
tomorrow.

Mike
