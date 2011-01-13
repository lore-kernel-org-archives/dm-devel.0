From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
Date: Thu, 13 Jan 2011 15:49:50 +0100
Message-ID: <4D2F110E.3010401@redhat.com>
References: <16069.1294853673@localhost>	<4D2E4611.90002@redhat.com>	<4D2E6129.8000700@ce.jp.nec.com>	<20110113110640.GC30719@htj.dyndns.org>	<4D2EE156.1050006@redhat.com>	<20110113122701.GG16523@nb.net.home>	<20110113131216.GF30719@htj.dyndns.org>	<20110113132637.GH16523@nb.net.home>	<20110113133722.GG30719@htj.dyndns.org>	<4D2F04FF.1070309@redhat.com>	<20110113141107.GI30719@htj.dyndns.org>	<4D2F0B6A.6010201@redhat.com> <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Karel Zak <kzak@redhat.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

On 01/13/2011 03:30 PM, Tejun Heo wrote:

Hi,

>> Anyway, it is /sys/block - so it represents block devices.
>>
>> If btrfs internally creates some virtual _block_ device for its pool, it should
>> present it here too with slaves/holders. If not, why it should create any links there?
> 
> Yeah, that's the most bothering part for me.  The biggest customers of
> bd_claim are filesystems and all these custom symlinkeries don't do
> nothing for them.  It just doesn't make a whole lot of sense to me.

Well, then it is not optimal for fs and should it be separated?
There is also /sys/fs now...

I think represent dependences of block devices in some generic (and exactly defined)
way is useful. So if there is something missing, lets define it properly.

The whole idea behind lsblk was practical: we responded many questions why
"device is busy" and what keeps it open in stacked subsystem.
Just try fdisk, mdadm, dmsetup table, losetup -a, kpartx, cryptsetup, etc ...

So listing block device tree using ONE interface (sysfs) to check and display
device tree for ALL subsystems seems to be good idea for me.
In this exactly defined case.

I am not saying that symlinks are perfect, just that generic interface here
is not superfluous.

Thanks,
Milan
