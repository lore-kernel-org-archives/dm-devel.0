From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 06/12] Make multipath add wwids from kernel
 cmdline mpath.wwids with -A
Date: Wed, 2 Jul 2014 14:48:16 -0500
Message-ID: <20140702194816.GF10438@dhcp80-209.msp.redhat.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
	<1404105243-5071-7-git-send-email-bmarzins@redhat.com>
	<CABr-GnedX62W_U988FjXs4eV+GisRjt_AhPe4J6XhBPzF+_uCw@mail.gmail.com>
	<53B3A0BA.9040502@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <53B3A0BA.9040502@suse.de>
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

On Wed, Jul 02, 2014 at 08:03:38AM +0200, Hannes Reinecke wrote:
> On 07/01/2014 09:22 PM, Christophe Varoqui wrote:
> >Hannes,
> >
> >would you Ack this one, or do you have some other idea for this in
> >your tree ?
> >
> Sigh. The whole multipath / systemd / dracut integration
> is _a mess_.
> The main problem is that RH and SUSE treat multipath handling differently.
> (From what I can see. I've still a hard time to understand how
>  multipath booting works with RH. So there might be errors.)
> =

> RH is taking a restrictive approach, ie it'll allow only configured
> multipath devices during boot. IE it'll accept only devices present
> in '/etc/multipath/wwids' for booting. So when coming across a new
> wwid multipath won't be setup there, so of course they'll need an
> additional parameter for that.

That's not strictly true.  multipathd will happily create a multipath
device on top of any valid scsi devices it finds, but unless those
devices are in /etc/multipath/wwids, other components, like lvm won't
know to leave them alone.  This actually isn't an issue during the
initramfs boot stages because lvm doesn't do autoactivation there.

So, if the device appears in the initramfs portion of boot, we're great.

The specific issue that prompted this goes like this:

- The iscsi initiator is not setup to run in the initramfs on install
- Storage is added to the system that makes up a working LV
- Once the machine boots up, and is past the initramfs, the iscsi
initiator starts up and discovers the devices.
- Multipath races with lvmetad and loses
- Now you have a LV built on top of a single path device, instead of
  being multipathed (The LV is on top of a partition of the path
  device, so reassign_maps doesn't work on it)

If you tell the redhat installer that you want to use multipath, this
causes problems, since it can't disassemble the an arbitrary stack of
virtual devices.  Eventually, we'll fix that issue, and this won't
matter anymore, because it will just be able to disassemble the virtual
device stack, and rerun multipath, to make everything autoassemble in
the correct order.
 =

> SUSE, OTOH, is taking the permissive approach. When multipath is included=
 in
> dracut it'll try to generate multipath devices for _all_ existing devices;
> the wwid file is not really required here.
> And, consequently, the '-A' parameter isn't required, too.
> =

> While this is nice and proper, both approaches have issues:
> - From what I've seen RH is building a 'generic' initrd, and
>   configures them via the kernel or dracut commandline.
>   Which makes it a bit hard for multipathing as the wwid
>   most certainly cannot be part of /etc/multipath/wwids.
>   But I guess this is what should be fixed by this patch.
> - SUSE is building a 'per-host' initrd, ie it'll generate
>   an initrd for that specific installation.
>   So there isn't actually a _need_ for the permissive approach,
>   as chances are it'll never come across anything else
>   _but_ the configured device.
>   Plus I haven't really evaluated whether the permissive
>   approach actually works properly, ie that multipath will
>   try to create device-mapper devices for unknown wwids.
> =

> But back to the patch.
> I must say I'm not really in favour of this.
> Implementing kernel commandline parsing in the _daemon_ is just downright
> evil.
> It would be _far_ more sensible to have it implemented in dracut
> as a commandline hook, which just adds the wwid from the kernel commandli=
ne
> to /etc/multipath/wwids.
> That's a simple shell script with no magic involved.
> Then the wwids would be in place when multipathd is started and everything
> will work.

Like I metioned above, we don't have a problem in the initramfs, so
adding functionality to dracut wouldn't help. If the path devices get
discovered there, everything just works. It's what happens when
multipath is racing against lvm autoactivation in late boot that's the
problem.  This problem should go away when we can automatically
deactivate an arbitrary stack of virtual devices, so I won't be
horribly sad if I have to maintain this patch outside of upstream until
then.  I just thought that people might find it a valuable feature.

Also, I'd like to point out that the daemon doesn't parse the cmdline.
You can call multipath to do it.  I agree that having this happen
everytime the daemon starts up by including it in multipathd.service
is kind of excessive, seeing as it's only really helpful when run
right after root pivots in the boot process. But I don't see what's
"just downright evil" about letting a command parse /proc/cmdline. =


-Ben

> Cheers,
> =

> Hannes
> P.S.: And yes, I do have some patches queued, too ...
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
