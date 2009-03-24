From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: configure MD3000 episode 2
Date: Tue, 24 Mar 2009 10:06:54 -0400
Message-ID: <20090324140654.GA1606@mars.virtualiron.com>
References: <d1392840903201754g119199d1u5b3863ba3a96abad@mail.gmail.com>
	<20090323143127.GA12731@mars.virtualiron.com>
	<d1392840903230844pe310cceya9160bcbe274b735@mail.gmail.com>
	<d1392840903231405p7b99846g65882690df77e96b@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d1392840903231405p7b99846g65882690df77e96b@mail.gmail.com>
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


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 23, 2009 at 05:05:37PM -0400, Thomas Witzel wrote:
> I'm now looking at the udev monitor and also set the loglevel to debug
> and I can see that udev is processing the multipath events, hence
> creating the /dev/mapper entries (but not the partition entries). But

The mechanism that does this is a bit more complex. Let me explain
to you and hopefully that will help you out.

When an HBA inits, it ends up calling a bunch of internal sd.c routines
which end up creating uevents (and of course setup the SysFS structures).
There are usually four sets of them:

1) device_add creates this:

[add@/devices/pci0000:00/0000:00:07.0/0000:04:00.3/0000:0a:01.0/0000:0b:07.0/host9/rport-9:0-17/target9:0:0/9:0:0:15]
[ACTION=add]
[DEVPATH=/devices/pci0000:00/0000:00:07.0/0000:04:00.3/0000:0a:01.0/0000:0b:07.0/host9/rport-9:0-17/target9:0:0/9:0:0:15]
[SUBSYSTEM=scsi]
[SEQNUM=8969]
[PHYSDEVBUS=scsi]
[PHYSDEVDRIVER=sd]

2) sd_probe creates this guy:

[add@/class/scsi_disk/9:0:0:15]
[ACTION=add]
[DEVPATH=/class/scsi_disk/9:0:0:15]
[SUBSYSTEM=scsi_disk]
[SEQNUM=9088]
[PHYSDEVPATH=/devices/pci0000:00/0000:00:07.0/0000:04:00.3/0000:0a:01.0/0000:0b:07.0/host9/rport-9:0-17/target9:0:0/9:0:0:15]
[PHYSDEVBUS=scsi]
[PHYSDEVDRIVER=sd]

3) add_disk creates this one:

add@/block/sdo]
[ACTION=add]
[DEVPATH=/block/sdo]
[SUBSYSTEM=block]
[SEQNUM=9332]
[MINOR=224]
[MAJOR=8]
[PHYSDEVPATH=/devices/pci0000:00/0000:00:07.0/0000:04:00.3/0000:0a:01.0/0000:0b:07.0/host9/rport-9:0-17/target9:0:0/9:0:0:15]
[PHYSDEVBUS=scsi]
[PHYSDEVDRIVER=sd]

4) and sg_add this one:

[add@/class/scsi_generic/sg15]
[ACTION=add]
[DEVPATH=/class/scsi_generic/sg15]
[SUBSYSTEM=scsi_generic]
[SEQNUM=9110]
[PHYSDEVPATH=/devices/pci0000:00/0000:00:07.0/0000:04:00.3/0000:0a:01.0/0000:0b:07.0/host9/rport-9:0-17/target9:0:0/9:0:0:15]
[PHYSDEVBUS=scsi]
[PHYSDEVDRIVER=sd]
[MAJOR=21]
[MINOR=15]

the kernel injects them in a netlink (NETLINK_KOBJECT_UEVENT) - I've attached a small C code
that grabs them. At that point the block disk is now usuable and userspace code can
access it by the major:minor numbers.

udev listens to this netlink and based on the udev rules execute them. But there are rules
in there that will short-circuit these uevents. If you see 'RUN=" that means it is done and won't
pass it on to the next one. If you see 'RUN+=' that means process it and pass it on to next rules
that might match the criteria.  Udev is the one that actually creates the /dev/sdo.

There might a udev rule in there that eats up the uevent before it is passed to the multipathd
netlink socket (/org/kernel/dm/multipath_event). You can make it less of chance if you
change the name of the rule to a low number, like 01-mpdc.rules.

Multipathd acts on the #3 uevent - it interrogates the block disk and then calls the
device mapper ioctl (/dev/mapper/control). The device mapper (kernel piece) sends its own
uevent, which looks as so:

[add@/block/dm-19]
[ACTION=add]
[DEVPATH=/block/dm-19]
[SUBSYSTEM=block]
[SEQNUM=9412]
[MINOR=19]
[MAJOR=253]

And udev then creates /dev/dm-19. It then would pass this on to multipathd socket. And
multipathd then does it stuff (which is to check the paths, make sure everthing
is right and kick of a checker path if it hasn't already been done).

> there is never anything called that would create the /dev/dm-* devices
> and the 95-kpartx rule is also never called it seems.

> I have now rigged it to run a script on boot that calls mkdnod and
> kpartx, but of course I'd still like udev support. I have not been

During bootup the udev isn't run. I think what gets called is the
HOTPLUG program, which is defined by default is "/sbin/hotplug".
Look in that program on the initrd image. It might not do any udev stuff at all
and just simple block disk creations.

> able to get any answer from ubuntu guys, so is it a fact that
> multipath is basically not supported under ubuntu ? What would be the
> next best distribution thats free of annual license fees ?

Huh? Ubuntu charges license fees on GPL code? I think you are confusing
what you are paying - it isn't license fee but support fee.

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="listen.c"

#include <sys/socket.h>
#include <linux/netlink.h>
#include <stdio.h>
#include <string.h>
#define MAX_PAYLOAD 1024        /* maximum payload size */
struct sockaddr_nl src_addr;
int sock_fd;
static char buff[MAX_PAYLOAD];
ssize_t buflen;

int
main ()
{
  sock_fd = socket (PF_NETLINK, SOCK_DGRAM, NETLINK_KOBJECT_UEVENT);

  memset (&src_addr, 0, sizeof (src_addr));
  src_addr.nl_family = AF_NETLINK;
  src_addr.nl_pid = getpid ();  /* self pid */
  src_addr.nl_groups = 0xffffffff;

  printf ("Listen..\n");
  bind (sock_fd, (struct sockaddr *) &src_addr, sizeof (src_addr));
  printf ("Receiving..\n");
  while (1)
    {
      buflen = recv (sock_fd, &buff, sizeof (buff), 0);
      printf ("Got data: %d\n", buflen);
      int i, bufpos;
      char *key;
      for (i = 0, bufpos = 0; (bufpos < buflen) && i < MAX_PAYLOAD; i++)
        {
          key = &buff[bufpos];
          printf ("[%s]\n", key);
          bufpos += strlen (key) + 1;
        }
      memset (&buff, 0, MAX_PAYLOAD);
    }
  /* Close Netlink Socket */
  close (sock_fd);
  return 0;
}

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--HcAYCG3uE/tztfnV--
