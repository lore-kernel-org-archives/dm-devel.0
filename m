From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: lvm2 hangs when creating snapshot of live root and
 IO to the root filesystem is happening
Date: Thu, 10 Jan 2013 10:28:02 +0100
Message-ID: <50EE89A2.2010907@redhat.com>
References: <50EDD0F3.5030807@passchier.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <50EDD0F3.5030807@passchier.net>
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
Cc: 1096520@bugs.launchpad.net, Peter & Kelly Passchier <peterkelly@passchier.net>
List-Id: dm-devel.ids

Dne 9.1.2013 21:20, Peter & Kelly Passchier napsal(a):
> 1. One-line summary
> lvm2 hangs when creating snapshot of live root and IO to the root filesystem
> is happening
>
>
> 2. Full description
> Root filesystem ext4 on lvm2 extent in luks-encrypted
> partition with mainline kernel 3.8-rc2.
> This is causing a hang:
> lvcreate -s -n oscopy -v -l 100%FREE /dev/secret/root 2>/root/savefile
>
> See: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1096520


Attach full -vvvv trace.

Hmm bugreport talks about  2.6.35 kernel.

My first suspect would be the 'Debian way' of handling udev rules - handling 
differes from the upstream solution and must be tracked and fixed on Debian.

>
> 6. Script to replicate the problem
> lvcreate -s -n oscopy -v -l 100%FREE /dev/secret/root 2>/root/savefile

'-vvvv'


Attach also 'changes' to udev rules from the upstream solution.

Probably  udevadm  monitoring output would be also useful.

Any cookies left unfinished  'dmsetup udevcookies' ?


Zdenek
