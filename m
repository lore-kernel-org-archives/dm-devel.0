From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 22/57] multipath: use option '-i' when called
	from udev
Date: Tue, 3 May 2016 16:39:54 +0200
Message-ID: <5728B83A.3000006@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-23-git-send-email-hare@suse.de>
	<20160502153124.GP26117@octiron.msp.redhat.com>
	<57283ABF.4080304@suse.de>
	<CABr-GncAsFSouftGFZgnMR5FLsF+U3GYYLtbe8MTY3LG3g7=rw@mail.gmail.com>
	<20160503141412.GA26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160503141412.GA26117@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 05/03/2016 04:14 PM, Benjamin Marzinski wrote:
> On Tue, May 03, 2016 at 08:37:08AM +0200, Christophe Varoqui wrote:
>>    Ben,
>>    does this patch actually break the Red Hat integration ?
>>    I'm inclined to merge it if not.
> =

> Like we talked about earlier, RedHat uses a completely different
> multipath.rules file, which includes some command options that were
> NAK'ed for inclusion. We can sort that out. Either we will or we won't
> come to an agreement on how multipath should interact with udev. If we
> don't we can probably just keep different rules files for the different
> distributions. But having a mostly-but-not-quite working version of the
> SUSE rules file really benefits nobody. I'm in favor of this going it.
> =

I've just send the rules file for completeness; I'm perfectly fine
with it not going in.

Or maybe having a 'multipath.rules.suse' and
'multipath.rules.redhat'; that way both rules are visible upstream
and people will know there's a difference.

Especially as we're already have RH and SUSE specific init files.
So there is a precedent.

As for systemd/udev integration itself:

For SUSE our setup is a follows:

1) We stick to the original concept of autoconfiguration, ie if
multipath/multipathd is started it will claim all devices. Any
device which should be omitted need to be blacklisted.
2) Corollary to the above: the /etc/multipath.wwids file is not
required to be present.
3) For udev integration we rely on 56-multipath.rules to set the
variable 'ENV{DM_MULTIPATH_DEVICE_PATH}=3D"1"' if a device should be
handled by multipath; this rule also sets the 'SYSTEMD_READY=3D0'
variable to instruct systemd to skip this path.
This has the potential scalability issue that we need to call
'multipath' to set this variable. In our setup we call multipath
with '-u' to connect to multipathd; so if we run at a large system
the CLI interface might become overloaded.
I must admit I'm not overly happy with this design, so if anyone has
better ideas I'd be happy to accomodate it.
4) From 2) and 3) follows that we need to use the option '-i' in
56-multipath.rules to avoid failures during booting.

Seeing that there now is an option 'ignore_new_boot_devs' maybe we
can extend it to cover these differences, ie that for SUSE we will
always set this to '0', and for RedHat one would set it to '1' per
default. Alternatively we could add (yet another) configuration
variable, which could be used to switch between SUSE-style
autoconfiguration and RedHat-style wwid files.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
