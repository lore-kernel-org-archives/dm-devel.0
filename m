From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 06/12] Make multipath add wwids from kernel
 cmdline mpath.wwids with -A
Date: Thu, 3 Jul 2014 14:25:55 -0500
Message-ID: <20140703192555.GG10438@dhcp80-209.msp.redhat.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
	<1404105243-5071-7-git-send-email-bmarzins@redhat.com>
	<CABr-GnedX62W_U988FjXs4eV+GisRjt_AhPe4J6XhBPzF+_uCw@mail.gmail.com>
	<53B3A0BA.9040502@suse.de>
	<20140702194816.GF10438@dhcp80-209.msp.redhat.com>
	<53B53901.3050606@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <53B53901.3050606@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 03, 2014 at 01:05:37PM +0200, Hannes Reinecke wrote:
> On 07/02/2014 09:48 PM, Benjamin Marzinski wrote:
> >On Wed, Jul 02, 2014 at 08:03:38AM +0200, Hannes Reinecke wrote:
> >>On 07/01/2014 09:22 PM, Christophe Varoqui wrote:
> >>>Hannes,
> >>>
> >>>would you Ack this one, or do you have some other idea for this in
> >>>your tree ?
> >>>
> >>Sigh. The whole multipath / systemd / dracut integration
> >>is _a mess_.
> >>The main problem is that RH and SUSE treat multipath handling different=
ly.
> >>(From what I can see. I've still a hard time to understand how
> >>  multipath booting works with RH. So there might be errors.)
> >>
> >>RH is taking a restrictive approach, ie it'll allow only configured
> >>multipath devices during boot. IE it'll accept only devices present
> >>in '/etc/multipath/wwids' for booting. So when coming across a new
> >>wwid multipath won't be setup there, so of course they'll need an
> >>additional parameter for that.
> >
> >That's not strictly true.  multipathd will happily create a multipath
> >device on top of any valid scsi devices it finds, but unless those
> >devices are in /etc/multipath/wwids, other components, like lvm won't
> >know to leave them alone.  This actually isn't an issue during the
> >initramfs boot stages because lvm doesn't do autoactivation there.
> >
> >So, if the device appears in the initramfs portion of boot, we're great.
> >
> >The specific issue that prompted this goes like this:
> >
> >- The iscsi initiator is not setup to run in the initramfs on install
> >- Storage is added to the system that makes up a working LV
> >- Once the machine boots up, and is past the initramfs, the iscsi
> >initiator starts up and discovers the devices.
> >- Multipath races with lvmetad and loses
> >- Now you have a LV built on top of a single path device, instead of
> >   being multipathed (The LV is on top of a partition of the path
> >   device, so reassign_maps doesn't work on it)
> >
> >If you tell the redhat installer that you want to use multipath, this
> >causes problems, since it can't disassemble the an arbitrary stack of
> >virtual devices.  Eventually, we'll fix that issue, and this won't
> >matter anymore, because it will just be able to disassemble the virtual
> >device stack, and rerun multipath, to make everything autoassemble in
> >the correct order.
> >
> Hmm. Similar to what I've seen here when booting with multipath enabled a=
nd
> an empty '/etc/multipath/wwids' file.
> =

> We're having an udev rule calling 'multipath -u' to check if the device is
> eligible for multipathing. If so it'll set the various udev properties to
> keep LVM and others from working with that device.
> =

> But as 'multipath -u' is be checking /etc/multipath/wwids it will always
> report 'not a multipath device'.
> So I would be perfectly happy with 'multipath -u' _not_ checking
> /etc/multipath/wwids (or have a switch for doing so).

'multipath -u'? Do you mean 'multipath -c'?  I do worry that not
checking the wwids file could break things were some device appears
multipathable, but will never successfully get created for reasons
outside of multipath's knowledge.  The wwids file makes sure that this
device is multipathable, because it HAS been multipathed before.

That being said, I have no objections to a switch to avoid the wwid file
check.
 =

> Anyway. There is actually a slight inconsistency with the above approach:
> Multipath is _not_ setup for autoconfiguration; from my understanding this
> was exactly why /etc/multipath/wwids was introduced in the first place.
> LVM, on the other hand, is trying to do autoconfiguration.
> =

> Why? I would set either both to autoconfiguration or none.
> If I want something different I need to configure the system.

Well, multipath is only not set up to do autoconfiguration because you
keep objecting to my find_multipaths patch, which makes multipath only
run on devices that have more than one path. With that, you can usually
leave the blacklists alone, and you will only get the devices that you
want.


> Can you clarify what the intended usage for /etc/multipath/wwids is?
> I was under the impression that it's been introduced to keep
> multipath from accepting unconfigured devices ...

Like I mentioned above, it was added to avoid the situations where
multipath isn't blacklisted on a device, but is unable to set up on it.
We use this to so that 'multipath -c' doesn't claim a device and keep
lvm or md from using it when it shouldn't.

-Ben

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
