From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4.5 052/238] dm cache: make sure every
 metadata function checks fail_io
Date: Tue, 12 Apr 2016 13:18:52 -0400
Message-ID: <20160412171851.GA688@redhat.com>
References: <20160410183456.398741366@linuxfoundation.org>
	<20160410183459.304585887@linuxfoundation.org>
	<1460424423.25201.87.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1460424423.25201.87.camel@decadent.org.uk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 11 2016 at  9:27pm -0400,
Ben Hutchings <ben@decadent.org.uk> wrote:

> On Sun, 2016-04-10 at 11:33 -0700, Greg Kroah-Hartman wrote:
> > 4.5-stable review patch.=A0=A0If anyone has any objections, please let =
me know.
> =

> I've dropped stable because this isn't actually broken, but...
> =

> > ------------------
> > =

> > From: Joe Thornber <ejt@redhat.com>
> > =

> > commit d14fcf3dd79c0b8a8d0ba469c44a6b04f3a1403b upstream.
> > =

> > Otherwise operations may be attempted that will only ever go on to crash
> > (since the metadata device is either missing or unreliable if 'fail_io'
> > is set).
> > =

> > Signed-off-by: Joe Thornber <ejt@redhat.com>
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > =

> > ---
> > =A0drivers/md/dm-cache-metadata.c |=A0=A0=A098 ++++++++++++++++++++++++=
-----------------
> > =A0drivers/md/dm-cache-metadata.h |=A0=A0=A0=A04 -
> > =A0drivers/md/dm-cache-target.c=A0=A0=A0|=A0=A0=A012 ++++-
> > =A03 files changed, 71 insertions(+), 43 deletions(-)
> > =

> > --- a/drivers/md/dm-cache-metadata.c
> > +++ b/drivers/md/dm-cache-metadata.c
> > @@ -867,19 +867,40 @@ static int blocks_are_unmapped_or_clean(
> > =A0	return 0;
> > =A0}
> > =A0
> > -#define WRITE_LOCK(cmd) \
> > -	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm)) \
> > +#define WRITE_LOCK(cmd)	\
> > +	down_write(&cmd->root_lock); \
> > +	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm)) { \
> > +		up_write(&cmd->root_lock); \
> > =A0		return -EINVAL; \
> > -	down_write(&cmd->root_lock)
> > +	}
> > =A0
> > =A0#define WRITE_LOCK_VOID(cmd) \
> > -	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm)) \
> > +	down_write(&cmd->root_lock); \
> > +	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm)) { \
> > +		up_write(&cmd->root_lock); \
> > =A0		return; \
> > -	down_write(&cmd->root_lock)
> > +	}
> =

> Whenever a macro expands to multiple statements they should be wrapped
> up in do { ... } while (0) so the macro is safe to use in other
> compound statements.
> =

> That's not a regression for these existing macros, but:
> =

> > =A0#define WRITE_UNLOCK(cmd) \
> > =A0	up_write(&cmd->root_lock)
> > =A0
> > +#define READ_LOCK(cmd) \
> > +	down_read(&cmd->root_lock); \
> > +	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm)) { \
> > +		up_read(&cmd->root_lock); \
> > +		return -EINVAL; \
> > +	}
> > +
> > +#define READ_LOCK_VOID(cmd)	\
> > +	down_read(&cmd->root_lock); \
> > +	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm)) { \
> > +		up_read(&cmd->root_lock); \
> > +		return; \
> > +	}
> [...]
> =

> here you're repeating the same broken pattern in new macros. =A0Which
> checkpatch.pl would have complained about, if you'd thought to run it.
> =

> Hiding return statements in macros is another bad idea (who expects
> exceptions in C?). =A0And once we reject that bad idea, all these macros
> can be inline functions, like:
> =

> static inline bool dm_cm_read_lock(struct dm_cache_metadata *cmd)
> {
> 	down_read(&cmd->root_lock);
> 	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm)) {
> 		up_read(&cmd->root_lock);
> 		return false;
> 	}
> 	return true;
> }
> =

> /* ... */
> =

> 	if (!dm_cm_read_lock(cmd))
> 		return -EINVAL;
> =

> Actually... I said this wasn't broken, but should the READ_LOCK macros
> really fail in case dm_bm_is_read_only(), or only if cmd->fail_io?

Thanks for the report!

I've staged this to go to Linus by the end of the week:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/com=
mit/?h=3Ddm-4.6&id=3Da64204672859248c89c8df796421442fb41e59ec
