From: "Michael Phoenix" <michaelandrewphoenix@gmail.com>
Subject: device mapper error when attempting to install 2nd
	kernel on CentOS
Date: Tue, 14 Mar 2006 01:29:27 -0800
Message-ID: <7903deec0603140129t5e97d6dw13de371d4650f0ce@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I am having trouble trying to install version 2.6.15 of the linux
kernel onto a machine that is currently running 2.6.9 version of the
kernel. I am using the 2.6.9 configuration file and running make
install successfully. When I try to boot the new kernel, I get the
following:
No entry for device mapper found Is device mapper driver missing from ker=
nel?
Failure to communicate with kernel
mount: error 19 mounting ext3
mount: error 2 mounting none

Apparently the device mapper is being used on the current kernel and
does exist in the direcotory /sys/misc. What do I need to do to get my
new kernel to run? According to what I've read, every kernel since
2.6.9 should have it in the source.
I checked the .config file and couldn't find anything called device
mapper. There was an entry for an IOMAPPER associated with a certain
scsi device that was commented out, but I have no idea what to put
after =3D. I couldn't find a comparable entry using make menuconfig. Any
help would be greatly appreciated.
I don't really have any need for it so if I can get my kernel to run
without it that is an acceptable solution.

Mike
