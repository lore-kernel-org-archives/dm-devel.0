From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v3 18/19] libmultipath: Don't blank
	intialized paths
Date: Fri, 5 Oct 2018 14:38:43 -0500
Message-ID: <20181005193843.GF3172@octiron.msp.redhat.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
	<1537571127-10143-19-git-send-email-bmarzins@redhat.com>
	<3bb1c108b1e43a85d296eed9a63cefe7a6de2d01.camel@suse.com>
	<f87221ecedb072a7f3551ea0f62e7df586d075f1.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <f87221ecedb072a7f3551ea0f62e7df586d075f1.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 03, 2018 at 12:37:17AM +0200, Martin Wilck wrote:
> Hi Ben,
> =

> > I am uncertain about this one. The old code sets pp->initialized to
> > INIT_FAILED. If the state had been INIT_MISSING_UDEV or
> > INIT_REQUESTED_UDEV before, this patch might change how the code
> > behaves later in check_path(), where these conditions are checked.
> > =

> > Likewise, tests for strlen(pp->wwid) are used in various places
> > around
> > the code. These tests would now yield different results for paths in
> > "recoverable error" state.
> > =

> > Have you considered these possible side effects?
> =

> I've pondered over this a lot. The dust is clearing up a bit.
> =

> 1. With your patch in place, INIT_FAILED is never set except in
> alloc_path() (we might rename it to INIT_NEW or the like, but see
> below).

Correct. The idea is that INIT_FAILED means that the path has never been
fully initialized and that it is missing more than simply the wwid
(which would set INIT_MISSING_UDEV instead).

> 2. I don't understand how you handle repeated failure to retrieve the
> WWID. I see that get_uid() (actually, scsi_uid_fallback()) would
> retrieve the WWID from sysfs after retriggers are exhausted. But I
> don't see how pathinfo(DI_WWID) would ever be called in this situation:
>
> In the last invocation, pathinfo() had failed to retrieve the WWID and
> set pp->initialized =3D INIT_MISSING_UDEV. There it will remain because
> check_path() won't set it to INIT_REQUESTED_UDEV any more after retries
> are exhausted. And now, check_path() won't call pathinfo(DI_ALL) any
> more from the "add missing path" code, because of the (pp->initialized
> !=3D INIT_MISSING_UDEV) condition.
> =

> Am I overlooking something?

Your analysis looks right. This shouldn't have anything to do with the
correctness of the not blanking initialized paths, but we should fix it
anyway.  Right now, as you mentioned, if multipathd fails to get the
wwid after retrigger_tries new uevents, it only has one shot at the
failback methods, and then mutipathd cannot use that path in the future.
However, it will still check if the path is up or down, which is pretty
pointless. It should either

1. set pp->intialized to INIT_OK, to keep it from being checked at all
in the future, or

2. try to grab the missing pathinfo, so that it can use the path.

The benefit of doing the first is that mutipathd doesn't keep messing
with paths that really aren't set up to be multipathed. On the other
hand it might ignore some paths that really should be multipathed.
perhaps the best idea is to keep trying to get the missing info, but
just increase pp->tick (possibly progressively) so we try less often.

> 3. If "blank" state means that important device information couldn't be
> retrieved because of presumably transient failure conditions, we should
> retry to retrieve this information by calling pathinfo again later. But
> unless the WWID is (reset to) the empty string, check_path() won't call
> pathinfo(DI_ALL) any more.

But if we set the wwid at some point in time, that means we got all the
necessary information.  My argument is that if something happens to
cause a later pathinfo() call to fail, we shouldn't pretend like we
didn't already get this info.
 =

> 4. The "blank" logic in pathinfo() combines several very different
> cases.
>   a) PATH_REMOVED status from path_offline(). This means that
> elementary sysfs attributes were missing. This is almost the same as
> failure in sysfs_pathinfo(), which results in PATHINFO_FAILED return
> status; but for PATH_REMOVED we return PATHINFO_OK and keep the path
> around.

True, but I've always assumed that this means that we will be getting a
uevent to remove this path momentarily, so I doesn't really matter what
we do with it. We could blank the path here, but if we already go the
necessary info, it seems like just setting the path to PATH_DOWN, and
waiting for the remove uevent should be fine.

>   b) Failure in checker_check(). If the path is offline in the first
> place, the checker isn't called, and WWID determination is attempted.
> But if the checker returns PATH_UNCHECKED or PATH_WILD, we goto "blank"
> state.

This is clearly the wrong thing to do.

>   c) Failure in scsi_ioctl_pathinfo() or cciss_ioctl_pathinfo(). Both
> functions never fail, so this can't happen. I've patches here to fix
> that.

I just ignored this state because it was impossible. But even with your
patches, my argument remains the same. If we already got this info,
failing to get it again shouldn't cause us to delete the wwid. We should
probably remember the existing values, to make sure that we don't lose
them if the calls fail for some reason.

>   d) Failure to open pp->fd. =


This is clearly the right thing to do.

> d) is the only case in which the "blank" logic makes really sense to
> me. It can happen only at the first pathinfo() invocation, meaning =

> pp->wwid is still empty, and pp->initialized is INIT_FAILED. Your patch
> would change nothing for this case.
> =

> a) and b) can happen for paths that have been initialized already. I
> think in case a) the WWID should be reset, probably initialized should
> be set to INIT_FAILED, and PATHINFO_FAILED should be returned. In case
> b) we should IMO proceed normally rather than goto "blank". Resetting
> the WWID in case b) is nonsense, agreed.
> =

> Altogether, if my analysis is correct, your patch (not blanking the
> WWID) should be applied to case b) only.

I don't really care about blanking the wwid in case a). I just think
it's unnecessary.  Why do you think we should blank it in case c) if we
have previously gotten those values?

-Ben

> Please comment - I still feel a bit confused and may have overlooked
> something essential.
> =

> Regards
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
