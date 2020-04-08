From: Andreas Kinzler <hfp@posteo.de>
Subject: alignment enforcement in dm-crypt causes severe problems
Date: Wed, 8 Apr 2020 12:21:19 +0200
Message-ID: <754a4098-9da2-3395-8a9e-f5b7737ed242@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello devs,

please see issue: 
https://github.com/virtio-win/kvm-guest-drivers-windows/issues/446

Short summary: When using encrypted disks with qemu (using dm-crypt) and 
pass that through LIO/vhost to qemu (via virtio-scsi) the following code 
is hit:

https://elixir.bootlin.com/linux/v5.3.18/source/drivers/md/dm-crypt.c#L1251

I am not familiar with the specification/contract of "bio". So I am not 
sure if the enforced alignment is legitimate.

Under Windows you cannot even initialize a disk because it wants to 
write sector 0 (count = 1) at offset 432.

Could some expert please comment?

Regards Andreas
