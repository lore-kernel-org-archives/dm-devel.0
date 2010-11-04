From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: kernel update and dmraid causing grub errors
Date: Thu, 04 Nov 2010 11:17:31 -0500
Message-ID: <4CD2DC9B.8010302@suddenlinkmail.com>
References: <4CCF3EC4.1020708@suddenlinkmail.com>	<1288785893.25565.42.camel@o>
	<4CD1E8BC.4060806@suddenlinkmail.com> <1288873952.26244.39.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1288873952.26244.39.camel@o>
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

On 11/04/2010 07:32 AM, Heinz Mauelshagen wrote:
> I overlooked you said it's a grub error, which occurs before any kernel
> argument is being processed. Hmm, this could be a grub flaw then
> identifying the disk size wrong or getting an offset wrong to load data
> from. Did grub change with the kernel installed?
> 

Hi Heinz,

	No, grub is (grub-0.97-17) and it hasn't changed since April 25, 2010. So
whatever is happening, isn't due to a grub change. Some of the Arch devs think
it might be a kernel issue. Last night, I posted the issue to the kernel list at
kernel.org and we will see what response we get back. The post to kernel.org was
pretty much the complete history of the issue, so I'll include the additional
information posted to the kernel list below for completeness:

Hardware:

  lspci -vv info

    http://www.3111skyline.com/dl/bugs/dmraid/lspci-vv.txt

  dmidecode info

    http://www.3111skyline.com/dl/bugs/Archlinux/aa-dmidecode.txt

  dmraid metadata and fdisk info

    http://www.3111skyline.com/dl/bugs/dmraid/dmraid.nvidia/

    http://www.3111skyline.com/dl/bugs/dmraid/fdisk-l-info-20100817.txt

Thoughts from the Arch Devs:

  post 1:

    These error are semi-random, they probably depend on where the kernel and
initramfs files are physically located in the file system.

    Grub (and all other bootloaders for that matter) use BIOS calls to access
files on the hard drive - they rely on the BIOS (and in your case, the jmicron
dmraid BIOS) for file access. This access seems to fail for certain areas on
your file system.

  post 2:

    Aah, it just hit me: the problem may in fact be fairly random in that it may
depend on where the initramfs is stored.  So, if the BIOS is broken, you may be
lucky to be able to boot under one kernel, and the next upgrade places things in
a place on disk where the BIOS bug kicks in, and you're screwed.  So it has
nothing to do with the kernel version, grub or dmraid in this case.  Do I
understand this correctly?

  post 3:

    I guess there has been something changed in the kernel26 2.6.35.8 and above
which doesn't work with your BIOS or your RAID. Either this is a bug in kernel26
2.6.35.8 and newer or it is not a bug but a new feature or a change which
doesn't work with your probably outdated BIOS.

    I'd suggest asking kernel upstream by either filing a bug report at
kernel.org or asking on their mailing list.

    It definitely must have something to do with the kernel. Otherwise it
wouldn't work again after a kernel downgrade.

Further tests I've done:

    Per the suggestions of the dm-devel list, I have tested with both
libata.ignore_hpa=0 (default) and libata.ignore_hpa=1 (ignore limits, using full
disk), but there is no change. I still get grub Error 24: (this is with the
2.6.36-3 kernel)

    I did another test starting with 2.6.35-7 (working), upgrade to 2.6.35-8
(expect failure -- it did), then upgrade directly to 2.6.36-3 and (expect
success if it was an initramfs location issue -- it failed too). Just to be
sure, I re-made the initramfs a couple of times and tried booting with them -
they all failed as well.

    Then downgraded to 2.6.35-7 -> it works like a champ -- no matter what order
it gets installed in.

Just FYI, the BIOS is current for the board and information on both can be found at:


http://www.msi.com/index.php?func=downloaddetail&type=bios&maincat_no=1&prod_no=1443

direct download:

  http://www.msi.com/index.php?func=downloadfile&dno=12299&type=bios

    So, I'm stumped again. With your help, the help of the Arch developers, and
the help of the guys at kernel.org, we should be able to isolate the issue and
figure out where the problem is. If you have any other ideas, please let me know
and I'll pass that information back to Arch and the kernel list. With all the
smart people involved, I'll bet we get this thing sorted out. Thanks.



-- 
David C. Rankin, J.D.,P.E.
Rankin Law Firm, PLLC
510 Ochiltree Street
Nacogdoches, Texas 75961
Telephone: (936) 715-9333
Facsimile: (936) 715-9339
www.rankinlawfirm.com
