From: gistolero@gmx.de
Subject: Re: EMC Cx300 multipath seems to work
Date: Tue, 13 Sep 2005 14:14:23 +0200
Message-ID: <4326C29F.3060202@gmx.de>
References: <4326878A.3090303@theorematica.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4326878A.3090303@theorematica.it>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Nicola,

Nicola Murino wrote:
> Hi,
> 
> multipath seems to work on gentoo, I have to load the modules in proper
> order, this is my configuration:
> 
> cat /etc/conf.d/local.start
> # /etc/conf.d/local.start
> 
> # This is a good place to load any misc programs
> # on startup ( use 1>&2 to hide output)
> /sbin/modprobe dm-emc
> /sbin/modprobe qla2300
> /bin/sleep 5
> /sbin/udevstart
> /etc/init.d/multipathd start
> 
> is critical the command udevstart without only one path is seen,


After rebooting my system, I see only one path always:

testhalde2 ~ # multipath -l
150gb ()
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:1 sda 8:0  [active]


I have to run multipath again:

testhalde2 ~ # multipath /dev/sda
reload: 150gb (3600508b40010079d0001900000460000)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0
  \_ 0:0:0:1 sda 8:0  [active][ready]
  \_ 1:0:0:1 sdb 8:16 [ready]


> I experienced a kernel oops with kernel-2.6.12 (both vanilla-sources and
> gentoo-sources) when I load qla2300 module, here are the logs:

I'm using a HP DL-380 G3 Proliant + Qlogic QLA 2340 (qla2300) with 2.6.12.5 
(vanilla). No kernel oops here.


> P.S. for gistolero, I haven't your problem with multipathd (or so seems)
> however my hardware is different, I think also that the need to run
> udevstart is a gentoo bug, today gentoo has releases udev-0.68-r1 with
> start-stop script, if you read start script there is udevstart, however
> I haven't yet tested this script because they require unstable
> baselayout-1.12

The same behavior with udev-068-r1. I don't think that this is a gentoo bug, 
because distributions differ in udev _startup_ scripts only. I know that I 
have to run udevstart after creating a new udev.rules in /etc/udev/rules/. But 
  after this, udev should parse this rule after every change:



After reboot...

testhalde2 ~ # ls -lF /dev/mapper/
brw-------  1 root root 254,  0 Sep 13  2005 150gb
brw-------  1 root root 254,  1 Sep 13  2005 150gb1
brw-------  1 root root 254,  2 Sep 13  2005 150gb2
crw-rw----  1 root root  10, 63 Sep 13  2005 control

testhalde2 ~ # ls -lF /dev/1*
lrwxrwxrwx  1 root root 4 Sep 13  2005 /dev/150gb2 -> dm-2

testhalde2 ~ # udevstart

testhalde2 ~ # ls -lF /dev/1*
lrwxrwxrwx  1 root root 4 Sep 13 13:00 /dev/150gb -> dm-0
lrwxrwxrwx  1 root root 4 Sep 13 13:00 /dev/150gb1 -> dm-1
lrwxrwxrwx  1 root root 4 Sep 13 13:00 /dev/150gb2 -> dm-2

Ok, udev knows the multipath udev-rule and creates this links.



Deleting the multipath-table...

testhalde2 ~ # dmsetup table
150gb1: 0 64197 linear 254:0 63
150gb: 0 314572800 multipath 0 0 1 1 round-robin 0 2 1 8:0 1000 8:16 1000
150gb2: 0 314504505 linear 254:0 64260

testhalde2 ~ # dmsetup remove 150gb1
testhalde2 ~ # dmsetup remove 150gb2
testhalde2 ~ # dmsetup remove 150gb
testhalde2 ~ # dmsetup table
No devices found

testhalde2 ~ # ls -lF /dev/mapper/
total 0
crw-rw----  1 root root 10, 63 Sep 13  2005 control

testhalde2 ~ # ls -lF /dev/1*
ls: /dev/1*: No such file or directory



Creating the multipath-table...

testhalde2 ~ # multipath /dev/sda
create: 150gb (3600508b40010079d0001900000460000)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0
  \_ 0:0:0:1 sda 8:0  [ready]
  \_ 1:0:0:1 sdb 8:16 [ready]

testhalde2 ~ # ls -lF /dev/mapper/
total 0
brw-------  1 root root 254,  0 Sep 13 13:04 150gb
brw-------  1 root root 254,  1 Sep 13 13:04 150gb1
brw-------  1 root root 254,  2 Sep 13 13:04 150gb2
crw-rw----  1 root root  10, 63 Sep 13  2005 control

testhalde2 ~ # ls -lF /dev/1*
ls: /dev/1*: No such file or directory


No links in /dev/... I don't understand this, because
udev should read the multipath udev-rule again.
Perhaps I'm mistaken?

Simon
