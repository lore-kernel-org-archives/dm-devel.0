From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 06/12] multipathd: fix device creation issues
Date: Tue, 30 Jan 2018 12:34:34 -0600
Message-ID: <20180130183434.GK14513@octiron.msp.redhat.com>
References: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
	<1512672546-12785-7-git-send-email-bmarzins@redhat.com>
	<1517331063.4072.57.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1517331063.4072.57.camel@suse.com>
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

On Tue, Jan 30, 2018 at 05:51:03PM +0100, Martin Wilck wrote:
> On Thu, 2017-12-07 at 12:49 -0600, Benjamin Marzinski wrote:
> =

> > However, it is possible to create a device with no paths, which means
> > the device cannot know which hwentry to use for its device
> > configuration.  __setup_multipath() used to help with this via
> > extract_hwe_from_path(), which grabbed the hwentry from a path if the
> > multipath device didn't already have it set. This is now done both
> > when
> > paths are added or the map is updated, which means that
> > extract_hwe_from_path() runs before the device is configured in
> > setup_map() instead of after the table has already been loaded. This
> > is
> > a good thing. But because of this, it can't check the dmstate or the
> > pathgroup state.  I don't believe it's necessary to care what state
> > the
> > path is in, especially now that we use libudev. The vendor and
> > product
> > information gets cached by libudev when the path device is first
> > added,
> > and should remain the same regardless of whether or not the device is
> > currently up.  My version does try to take the hwe information from a
> > path in the PATH_UP state first, but this is mostly to satisfy the
> > paranoia of the old version.
> =

> It just occured to me while reviewing this patch once more that this
> might cause problems if the path WWID changes, as recently
> discussed.Perhaps you should at least skip paths with the
> "wwid_changed" attribute?

I thought that we agreed that updating pp->udev was a bad idea if the
wwid changed.  I'm still not sure that we need to update the udev device
at all.  For things that might reasonably change, we should grab them
from sysfs or from the current uevent (without necessarily updating the
one attached to the path). For things that aren't supposed to change, we
can get them through libudev, and then they'll be cached for the future.

But at any rate, as long as we don't update pp->udev when the new udev
device has a different wwid, this shouldn't be a problem. right?

-Ben

> =

> =

> Regards,
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
