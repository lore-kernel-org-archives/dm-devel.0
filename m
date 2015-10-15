From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/18] Fix issues with user_friendly_names
 initramfs bindings
Date: Thu, 15 Oct 2015 10:52:31 +0200
Message-ID: <561F694F.3010309@suse.de>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
	<1444333491-16265-9-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-9-git-send-email-bmarzins@redhat.com>
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
> Multipath has an issue with user_friendly_names set in the initramfs.
> If the bindings are in the initramfs bindings file, it will create them,
> and it may use bindings that are different than the ones in the regular
> file system.  Once multipathd starts up in the regular file system, it
> will try to register the existing bindings, but that may (and in many
> cases, is likely to) fail. If it can't reanme it, will pick a new
> binding. Since when multipathd starts discovering the existing devices,
> it obviously doesn't know all of the existing devices yet, it may very
> well pick a binding that's already in use by a device that it hasn't
> discovered yet. In this case multipath will be unable to rename the
> device to the new binding. Unfortunately, if it fails the rename, it
> never resets the alias of the device stored in the mpvec to current
> alias of the actual dm device. So multipath will have devices in the
> mpvec where the alias and the wwid don't match the actual dm devices
> that exist.  This can cause all sorts of problems.
> =

> This patch does two things to deal with this.  First, it makes sure that
> if the rename fails, the device will reset its alias to the one that it
> currently has.
> =

> Second, it adds a new option to help avoid the problem in the first
> place.  There actually already is a solution to this issue. If
> multipathd is started with -B, it makes the bindings file read-only. If
> multipathd is started this way in the initramfs, it will never make new
> bindings for a device. If the device doesn't already have a binding, it
> will simply be named with its wwid. The problem with this method is that
> AFAICT it causes a maintenance problem with dracut.  At least on RedHat,
> dracut is simply copying the regular multipathd.service file into the
> initramfs. I don't see a way in multipathd.service to only start
> multipathd with the -B option in the initramfs (If there is a way, I'd
> be happy to use that). So, the only alternative that lets us use -B is
> to have a separate multipathd.service file that dracut uses for the
> initramfs.  This seems like more work than it's worth.
> =

> Instead, this patch pulls some code from systemd to detect if multipathd
> is running in the initramfs.  If it is, and if new_bindings_in_boot is
> not set, multipathd will set the bindings file to read-only, just like
> the -B option does.
> =

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Please split off this patch. The first issue is a real fix, it should
really be a separate patch.

For the second one it actually quite simple to inject a different
service file for dracut (I did that actually in our dracut package).
So I'd rather see this happening instead of second-guessing by looking
at magic files. Which will fail for anyone _not_ using dracut.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
