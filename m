From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/18] libmultipath: add ignore_new_boot_devs
 option
Date: Mon, 12 Oct 2015 09:08:17 +0200
Message-ID: <561B5C61.6010201@suse.de>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
	<1444333491-16265-14-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-14-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/08/2015 09:44 PM, Benjamin Marzinski wrote:
> When multipath relies on the wwids file to determine whether a device is
> a multipath path (with "multipath -c"), it will fail the first time a
> new multipathable device is discovered, since the wwid clearly won't be
> in the wwids file.  This is usually fine.  Multipath will still set
> itself up on the device, and add the wwid to the wwids file. However,
> this causes a race, where multipath won't claim the path immediately,
> and something else may.  Later multipath will try, and possibly succeed
> at, setting itself up on that device.
> =

> I've seen cases where this can cause problems during boot on and
> immediately after install, where multipath racing with LVM on an already
> labelled device can get the machine into a state where boot fails. This
> can be avoided if multipath simply doesn't set itself up on any devices
> that it didn't claim (with "multipath -c") in the initramfs.  It can
> still safely attempt to set itself up on these devices later in boot,
> after the regular filesystem has been set up.
> =

> To allow this, this patch adds a new option, ignore_new_boot_devs.  When
> enabled, this patch simply keeps multipath from being set up on devices
> that aren't already in the wwids file (along with all the other checks
> that multipath already does). This means that only devices that are
> claimed by "multipath -c" will be used by multipath.
> =

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
Well, as SUSE is not relying on /etc/wwids during boot we don't have
this issue :-)

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
