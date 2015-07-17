From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 2/3] dm: Export function dm_suspend_md()
Date: Fri, 17 Jul 2015 10:04:39 -0400
Message-ID: <20150717140438.GA29704@redhat.com>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <1434885634-19895-1-git-send-email-pali.rohar@gmail.com>
 <1434885634-19895-3-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434885634-19895-3-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Sun, Jun 21 2015 at  7:20am -0400,
Pali Roh=E1r <pali.rohar@gmail.com> wrote:

> This patch exports function dm_suspend_md() which suspend mapped devi=
ce so other
> kernel drivers can use it and could suspend mapped device when needed=
=2E
>=20
> Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
> ---
>  drivers/md/dm.c |    6 ++++++
>  drivers/md/dm.h |    5 +++++
>  2 files changed, 11 insertions(+)
>=20
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 2caf492..03298ff 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -3343,6 +3343,12 @@ out:
>  	return r;
>  }
> =20
> +int dm_suspend_md(struct mapped_device *md)
> +{
> +	return dm_suspend(md, DM_SUSPEND_LOCKFS_FLAG);
> +}
> +EXPORT_SYMBOL_GPL(dm_suspend_md);
> +
>  /*
>   * Internal suspend/resume works like userspace-driven suspend. It w=
aits
>   * until all bios finish and prevents issuing new bios to the target=
 drivers.

To do this properly you should be introducing a variant of
dm_internal_suspend.  We currently have two variants:
dm_internal_suspend_fast
dm_internal_suspend_noflush

The reason to use a dm_internal_suspend variant is this suspend was
_not_ initiated by an upper level ioctl (from userspace).  It was
done internally from within the target.

You're explicitly using DM_SUSPEND_LOCKFS_FLAG above.. meaning you're
interested in flushing all pending IO (in the FS layered on dm-crupt, i=
f
one exists).

But see the comment in __dm_internal_suspend() about TASK_UNINTERRUPTIB=
LE.
If you're OK with the dm-crypt initiated suspend being
TASK_UNINTERRUPTIBLE then you could just introduce:

void dm_internal_suspend_uninterruptible_flush(struct mapped_device *md=
)
{
        mutex_lock(&md->suspend_lock);
        __dm_internal_suspend(md, DM_SUSPEND_LOCKFS_FLAG);
        mutex_unlock(&md->suspend_lock);
}
EXPORT_SYMBOL_GPL(dm_internal_suspend_uninterruptible_flush);

Otherwise, there is much more extensive DM core changes needed to
__dm_internal_suspend() and .presuspend to properly support
TASK_INTERRUPTIBLE.
