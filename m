From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 22/57] multipath: use option '-i' when called
	from udev
Date: Tue, 3 May 2016 07:44:31 +0200
Message-ID: <57283ABF.4080304@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-23-git-send-email-hare@suse.de>
	<20160502153124.GP26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160502153124.GP26117@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 05/02/2016 05:31 PM, Benjamin Marzinski wrote:
> On Wed, Apr 27, 2016 at 01:10:23PM +0200, Hannes Reinecke wrote:
>> multipath should be using the option '-i' to ignore the wwids
>> file when called from udev. Otherwise we might run into a race
>> condition with systemd and the system might not boot up correctly.
> =

> The race condition being? Are you talking about the udev rules not
> claiming a path for multipath, but then having multipathd create a
> multipath device using that path? I agree that this can be an issue.
> Another way to solve it is to run mutipathd with the -n option in the
> initramfs (see commit a8efa5838cf215febd853f282c26af62c0daa862). That
> commit solves the race by making mutipathd ignore devices that aren't
> already in the wwids file.  This also keeps the initramfs from picking a
> different user_friendly_name than will be picked in late boot (but
> hopefully that issue has been sorted out by other patches already).
> =

This is in fact SUSE-specific, as we do _not_ require any a-priory
configuration. So we will start out with a system without any wwid file,
_but_ expect multipath to start up properly.
As the wwid file will only be created by multipathd the udev check will
always being false, and none of the multipath devices will be created.

> I'm not NAKing this. The question of what to do about the differnces in
> the distribution's systemd and udev configurations can be hashed out
> outside of patch reviewing. I just want to make sure I understand the
> race this is solving.
> =

This is in fact a good question.
We should be coming up with a common approach which would suit both needs.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
