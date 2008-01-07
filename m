From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Configuring multipath for root device
Date: Mon, 7 Jan 2008 10:11:48 -0800
Message-ID: <110b17190801071011saf2cdbcq3c3d400f3d846f04@mail.gmail.com>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
	<1198099093.26366.32.camel@linuxchandra> <4781D6D9.5030204@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4781D6D9.5030204@suse.de>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi All,

Yes, I tried the steps and it worked for me.
Thanks for your help.

Regards,
Pradipmaya.


On Jan 6, 2008 11:38 PM, Hannes Reinecke <hare@suse.de> wrote:
> Chandra Seetharaman wrote:
> > I am working on a multipath usage document. Attached is the installat=
ion
> > section of that document.
> >
> > Note that it is written for RHEL5 U1 and SLES10 SP1.
> >
> > Good Luck,
> >
> > chandra
> >
> > On Wed, 2007-12-19 at 13:02 -0800, Pradipmaya Maharana wrote:
> >> Hi All,
> >>
> >> Is there a process/document that talks about how to configure
> >> root/boot device for multipath?
> >>
> >> Thanks and Regards,
> >> Pradipmaya.
> >>
> >> --
> >> dm-devel mailing list
> >> dm-devel@redhat.com
> >> https://www.redhat.com/mailman/listinfo/dm-devel
> >>
> >> --------------------------------------------------------------------=
----
> >>
> >> 4.1. Installation instructions for SLES10
> >>
> >> Note: This is tested on SLES10 SP1. If you have any other version, y=
our
> >> mileage may vary.
> >>
> >>    1. Install the OS in a device that has multiple paths. Make sure =
the
> >> root device's "Mount by" option is set to "Device by-id" (this optio=
n is
> >> available under "expert partitioner" as "fstab options").
> >>    2. Complete the installation. Let the system boot up in multiuser=
 mode.
> >> Make sure the root device, swap device are all referenced by their b=
y-id
> >> device node entries instead of /dev/sd* type names. If they are not,=
 fix
> >> them first.
> >>    3. Once booted, update /etc/multipath.conf If you have to make ch=
anges
> >> to /etc/multipath.conf, make the changes.
> >>       Note: the option "user_friendly_names" is not supported by ini=
trd.
> >> So, if you have user_friendly_names in your /etc/multipath.conf file=
,
> >> comment it for now, you can uncomment it later.
> >>    4. Enable multipathing by running the following commands
> >>           * chkconfig boot.multipath on
> >>
> >>           * chkconfig multipathd on
> >>    5. Add multipath module to initrd
> >>
> >>       Edit the file /etc/sysconfig/kernel and add "dm-multipath" to
> >> INITRD_MODULES". Note: If your storage devices needs a hardware hand=
ler,
> >> add the corresponding module to INITRD_MODULES, in addition to
> >> "dm-multipath". For example add "dm-rdac" and "dm-multipath" to supp=
ort
> >> IBM's DS4K storage devices
> >>    6.  Run mkinitrd
> >>       Note: You can uncomment the user friendly name if you have com=
mented it above.
> >>    7. Reboot
> >>
> >> The system will come up with the root disk on a multipathed device.
> >>
> >> Note: You can switch off multipathing to the root device by adding
> >> multipath=3Doff to the kernel command line.
> >>
> ACK. This is the correct way.
>
> Thanks for writing this up.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
