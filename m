From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Configuring multipath for root device
Date: Tue, 15 Jan 2008 18:25:54 -0800
Message-ID: <110b17190801151825ofd63e20yd9d4f01be7b67407@mail.gmail.com>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
	<1198099093.26366.32.camel@linuxchandra>
	<110b17190801071219k11749b81n45a7d1d5d35b9413@mail.gmail.com>
	<4783239C.7020206@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4783239C.7020206@suse.de>
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

Thanks for all your comments, it worked for installaions on partitions.

Now the question is:
Is it supposed to work the same way if the SLES is installed on LVM?
On SLES, under fstab, I do not see any device, except for the boot
device; other entries does not have /dev/deisk mention. In such
scenario, how am I supposed to make the /root device multipath-aware?

I tried the same with RHEL, but with RHEL installed (with linux mpath)
on LVM, it seems to be working fine. Is there anything I am missing on
SLES?

Thanks and Regards,
Pradipmaya.



On Jan 7, 2008 11:17 PM, Hannes Reinecke <hare@suse.de> wrote:
> Pradipmaya Maharana wrote:
> > RHEL Steps worked perfectly for me but i have a question for SLES ins=
tallation.
> >
> > Question. While installing SLES on multipath devices, the second step=
 says:
> >
> > " 2. Complete the installation. Let the system boot up in multiuser m=
ode.
> > Make sure the root device, swap device are all referenced by their by=
-id
> > device node entries instead of /dev/sd* type names. If they are not, =
fix
> > them first."
> >
> > How do you check that root device and swap device are referenced by t=
heir by-id?
> > And if it is not referenced by the by-id, how do I fix it? Re-install=
?
> >
> Check /etc/fstab. Those devices should be listed as /dev/disk/by-id/XXX=
.
> If not (ie if their names are /dev/sdXX) look for the appropriate symli=
nk
> in /dev/disk/by-id and edit /etc/fstab.
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
> --
>
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
