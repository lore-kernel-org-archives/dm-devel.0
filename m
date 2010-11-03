From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: kernel update and dmraid causing grub errors
Date: Wed, 03 Nov 2010 17:19:07 -0500
Message-ID: <4CD1DFDB.50907@suddenlinkmail.com>
References: <4CCF3EC4.1020708@suddenlinkmail.com> <1288785893.25565.42.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1288785893.25565.42.camel@o>
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

On 11/03/2010 07:04 AM, Heinz Mauelshagen wrote:
> Hi David,
> 
> because you're able to access your config fine with some arch LTS
> kernels, it doesn't make sense to analyze your metadata upfront and the
> following reasons may cause the failures:
> 
> - initramfs issue not activating ATARAID mappings properly via dmraid
> 
> - drivers missing to access the mappings
> 
> - host protected area changes going together with the kernel changes
>   (eg. the "Error 24: Attempt to access block outside partition");
>   try the libata.ignore_hpa kernel paramaters described
>   in the kernel source Documentation/kernel-parameters.txt
>   to test for this one
> 
> FYI: in general dmraid doesn't rely on a particular controller, just
> metadata signatures it discovers. You could attach the disks to some
> other SATA controller and still access your RAID sets.
> 
> Regards,
> Heinz

Heinz,

	Thank you for your reply. The LTS kernel is just there (long term support)
kernel (2.6.32.25-2). I can boot the SuSE kernels fine, and the immediately
prior Arch kernel just fine as well (2.6.35.7-1).

	I will try the libata.ignore_hpa setting and let you know and I'll pass this
info to the Arch devs to see if they can help as well.

	This has really been a strange issue. It seems like every other kernel (1 out
of every 2 new releases) just won't boot and stops at the very beginning with
either grub Error 24: or Error 5: (Nothing has changed otherwise and simply
booting another kernel works fine). I'll keep plugging away at trying to find an
answer.

	If you can think of any other tests or helpful diagnostics, please let me know.
Since this occurs at the very beginning of boot, there is no logging which makes
this tough to figure out. (not to mention dmraid is just voodoo to me. ;-)

-- 
David C. Rankin, J.D.,P.E.
Rankin Law Firm, PLLC
510 Ochiltree Street
Nacogdoches, Texas 75961
Telephone: (936) 715-9333
Facsimile: (936) 715-9339
www.rankinlawfirm.com
