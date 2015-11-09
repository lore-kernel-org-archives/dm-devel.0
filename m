From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/4] dm verity: add support for error correction
Date: Mon, 9 Nov 2015 11:37:35 -0500
Message-ID: <20151109163735.GA28884@redhat.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
 <563B066C.6050202@redhat.com>
 <20151105173306.GA22302@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151105173306.GA22302@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Milan Broz <mbroz@redhat.com>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

On Thu, Nov 05 2015 at 12:33pm -0500,
Sami Tolvanen <samitolvanen@google.com> wrote:

> On Thu, Nov 05, 2015 at 08:34:04AM +0100, Milan Broz wrote:
> > could you please elaborate why is all this needed? To extend support
> > of some faulty flash chips?
> 
> This makes dm-verity more robust against corruption caused by either
> hardware or software bugs, both of which we have seen in the past on
> actual devices.
> 
> Note that unlike the error correction sometimes included in flash
> storage devices, this doesn't merely protect against random bit flips,
> it makes it possible to recover from several megabytes of corrupted
> or lost data.

Google (via Android and/or ChromeOS) is the primary consumer of dm-verity.

As such I'm inclined to trust Google's need for this feature and that it
has been carefully designed and implemented.  But obviously we need to
verify that.

Patches 1 and 2 look fine to me (just refactoring, no functional
change).  I may find something upon closer review but we'll cross that
bridge if/when we get to it.

> > Do you have some statistics that there are really such correctable errors
> > in real devices?
> 
> Sorry, I don't have statistics to share at the moment.
> 
> > Anyway, I really do not understand layer separation here.
> 
> I should have elaborated more on this. Implementing this without
> integrity checking would not be feasible for a few reasons:
> 
>   1. Being able to detect which blocks are corrupted allows us to
>      avoid correcting valid blocks. Correcting errors is slow and
>      this is the only way to keep performance acceptable.
> 
>   2. Due to a property of erasure codes, we can correct twice as
>      many errors if we know where the errors are. Using the hash
>      tree to detect corrupted blocks lets us locate erasures.
> 
>   3. Error correction algorithms may not produce valid output and
>      without integrity checking, there's no reliable way to detect
>      when we actually succeeded in correcting a block.

This all makes sense to me.

So for patch 3:

I'm left wondering: can the new error correction code be made an
optional feature that is off by default? -- so as to preserve some
isolation of this new code from the old dm-verity behaviour.
Looking at the code it isn't immediately clear to me where any of this
is _really_ optional; closest I see if verity_fec_decode() returning
-1 if (!v->fec_bufio)... might be good to add a wrapper like
verity_fec_is_enabled().

The if (v->fec_dev) {} block in verity_ctr() should probably be split
out to a new function.  Similar to how
drivers/md/dm-thin.c:pool_create() will return error string via **error,
etc.

In addition the kbuild errors/warnings (reported by the kbuild test
robot) need fixing.

Also, the 2 other big questions from Mikulas need answering:
1) why aren't you actually adjustng error codes, returning success, if
   dm-verity was able to trap/correct the corruption?

2) please fix the code to preallocate all required memory -- so that
   verity_fec_alloc_buffers() isn't called in map.  Any reason why you
   couldn't collect the table's fec options and determine how much
   additional memory is needed per dm_verity_io?  And then just add that
   to the per-bio-data?

> > Are we sure this combination does not create some unintended
> > gap in integrity checking?
> 
> Yes, I'm sure. Corrupted blocks are integrity checked again after they
> are corrected to make sure only valid data is allowed to pass.

Makes sense.

> > Why the integrity check should even try to do some
> > error correction if there is an intentional integrity attack?
> 
> Most corruption is not malicious and being able to recover from it
> makes the system more reliable. This doesn't make it any easier for an
> attacker to break dm-verity. That would still require finding a hash
> collision (or being able to modify the hash tree).
> 
> > The second question - why are you writing another separate tool
> > for maintenance for dm-verity when there is veritysetup?
> 
> Our tool for generating error correction metadata is independent from
> dm-verity. This data is also used by other software to correct errors
> during software updates, for example. If there's interest, I can help
> in adding this functionality to veritysetup.

If this error correction feature is going to go upstream we really
should see any associated userspace enablement also included in
veritysetup.  Really no sense in fragmenting the utilities used to setup
a dm-verity device.
