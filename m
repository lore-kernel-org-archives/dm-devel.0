From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] Re: Oops using 2.6.28.n after a lazy umount
 of a crypted loop-device
Date: Fri, 06 Mar 2009 09:24:54 +0100
Message-ID: <49B0DDD6.2080608@redhat.com>
References: <49AFA565.6030902@ahsoftware.de> <49AFBE4A.1010605@redhat.com>
	<49B0BFBD.7060208@ahsoftware.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49B0BFBD.7060208@ahsoftware.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alexander Holler <holler@ahsoftware.de>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Alexander Holler wrote:
> Milan Broz schrieb:
>> Please Can you try attached patch if helps here?
>> (Patch is not perfect, but should help, at least identify that
>> it is the same problem I am fixing:-)
> 
> The patch works (I had to add an #include <linux/delay.h> /* msleep */).

ok, thanks.


> I've tested it using 2.6.28.7 and the script below. With your patch the 
> script was running over night looping about 400 times without any error. 
> A crosscheck without the patch needed only 10 iterations to get an oops. 
> So I assume you have fixed the problem I had. ;)
> 
> There stills seems to be another problem left, I've got 3 times the 
> kernel-message
> 
> device-mapper: ioctl: unable to remove open device 
> temporary-cryptsetup-21571

This is bug in cryptsetup related to udev (udev should not touch temporary
cryptsetup device) which is fixed upstream, but there is no
new release yet (Fedora has this patched, not sure about other distros)

see http://code.google.com/p/cryptsetup/source/detail?r=32 and other patches.

Milan
--
mbroz@redhat.com
