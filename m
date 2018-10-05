From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH RESEND 0/4] multipath-tools: fixes for path
 wwid detection and path change uevents
Date: Fri, 5 Oct 2018 18:07:04 -0500
Message-ID: <20181005230704.GH3172@octiron.msp.redhat.com>
References: <20180307232152.15538-1-mwilck@suse.com>
	<20180314174013.GF14513@octiron.msp.redhat.com>
	<7aa1314c9095e3315e02525ec2e005030898a9b4.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <7aa1314c9095e3315e02525ec2e005030898a9b4.camel@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Oct 02, 2018 at 11:02:50PM +0200, Martin Wilck wrote:
> Hi Ben, Christophe,
> =

> I found a problem with this old patch series of mine.
> =

> while I am still pondering about your latest series, it occured to me
> that my patch "get_uid: don't quit prematurely without udev" is against
> the spirit of your "retrigger uevents to try and get the uid through
> udev" patch from 2016 (688aa22b).
> =

> "get_uid: don't quit prematurely without udev" has been merged a while
> ago (08d42ee6). Should it be reverted??
> =

> Pro: the patch is against the "udev first" philosophy and subverts the
> retrigger logic.
> Con: with the patch, we'll be able to retrieve WWIDs more quickly in
> some situations, as we don't have to wait for udev.
> =

> Either way (but more likely with my patch), it may happen that we
> retrieve a WWID from sysfs or elsewhere first, and from udev later.
> These WWIDs may not necessarily match, and a "WWID changed" problem may
> occur.
> =

> Please tell me what you think.

I'm having a hard time seeing how get_uid() could get called on a path
without a udev device attached in multipathd. It can happen because of
update_paths() in multipath, for paths that don't get discovered when
searching for paths, but do belong to an existing multipath device. I
don't think you patch will hurt anything here. So, unless I'm missing
some code path in multipathd, I don't see a problem with this patch.

In fact, we should probably make scsi_uid_fallback() skip (or at least
always pass) the retrigger check if we aren't in the daemon, so we
always try the failback when we run multipath.

-Ben

> =

> Martin
> =

> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
