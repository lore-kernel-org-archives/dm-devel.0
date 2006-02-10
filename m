From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: [PATCH] Support HDIO_GETGEO on device-mapper volumes
Date: Fri, 10 Feb 2006 15:15:57 +0100
Message-ID: <62b0912f0602100615n77583a68ib3882d2c90fd20a6@mail.gmail.com>
References: <43EBEDD0.60608@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43EBEDD0.60608@us.ibm.com>
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
To: djwong@us.ibm.com
Cc: dm-devel@redhat.com, lcm@us.ibm.com
List-Id: dm-devel.ids

Darrick J. Wong wrote:
> I'm trying to install grub on a device-mapper RAID1 array that I set up
> via dmraid (in other words, a bootable software fakeraid).  Since dm
> doesn't implement the HDIO_GETGEO ioctl, grub assumes that the CHS
> geometry is 620/128/63, which makes it impossible to configure it to
> boot a filesystem that lives beyond the 2GB mark, even if the system
> BIOS supports that.
>
> The attached patch implements a simple ioctl handler that supplies a
> compatible geometry when HDIO_GETGEO is called against a device-mapper
> device.

FYI, I made a patch a year ago or so that achieves the same, only in GRUB=
 land.
I like your approach just as well (and my patch was ugly and needed
TLC badly), so cool.

You might want to cc: your patch to Peter Jones or someone from Fedora Co=
re,
just in case they picked up that ugly Grub thing I did, so they can
remove that and use yours instead :-)...
