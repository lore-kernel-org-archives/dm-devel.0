From: Eduard Nicodei <omega2youall@gmail.com>
Subject: Re: logical volumes not being detected
Date: Wed, 30 Jul 2008 14:02:58 +0300
Message-ID: <200807301402.58647.omega2youall@gmail.com>
References: <200807281212.32092.omega2youall@gmail.com>
	<1D80D4F6D179BD4D869FE807A5BF8336026171DA@EXCNYSM0A1AN.nysemail.nyenet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1D80D4F6D179BD4D869FE807A5BF8336026171DA@EXCNYSM0A1AN.nysemail.nyenet>
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

On Monday 28 July 2008 18:57:22 Romanowski, John (OFT) wrote:
> Hi,
> I'm not familiar with ubuntu. In SLES one has to enable the boot.lvm script
> which runs vgscan and vgchange to detect and enable the PV's, VG's and
> their LV's.
>
> Try manually running vgscan and then vgchange -a y
> and see if that helps.
> good luck.
>
>
> --------------------------------------------------------
> This e-mail, including any attachments, may be confidential, privileged or
> otherwise legally protected. It is intended only for the addressee. If you
> received this e-mail in error or from someone who was not authorized to
> send it to you, do not disseminate, copy or otherwise use this e-mail or
> its attachments.  Please notify the sender immediately by reply e-mail and
> delete the e-mail from your system.
>
>
> -----Original Message-----
>
> From: dm-devel-bounces@redhat.com on behalf of Eduard Nicodei
> Sent: Mon 7/28/2008 5:12 AM
> To: dm-devel@redhat.com
> Subject: [dm-devel] logical volumes not being detected
>
> Hello, this is my first posting here and I'm sorry if this has already been
> discused. All I want to know is what other modules/libraries other than the
> device-mapper kernel module, lvm2 and the devmapper library do I need in
> order to have my logical volumes detected.
> here's my setup: one 160GB sata2 hdd; one 320GB sata2 hdd; a minimal
> version of ubuntu (installed from debootstrap) and a custom compiled kernel
> version 2.6.26 (I should mention that the kernel doesn't contain all of the
> modules - I wanted it to provide only the features I need). I have created
> a physical volume, volume group and logical volume from another ubuntu
> installation. It is detected while using the live cd, and also if I boot
> the minimal ubuntu with another kernel that has a full set of features.
>
> regards, Eduard
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

sorry, neither vgscan nor vgchange -a -y didn't work. However, after twinking 
my kernel I found the problem: I had to select the "Create deprecated sysfs 
files" and the "Kernel->user space relay support (formerly relayfs)" kernel 
configuration options, (both from "General setup");
now I'm not a dm-developer so this is just a suggestion: does device-mapper 
use deprecated sysfs files? If so, it should be upgraded, or at least a 
warning be posted somewhere that dm needs those files.
