From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Re: NIC and HBA based multipathing
Date: Thu, 15 Nov 2007 14:26:44 -0600
Message-ID: <342d47870711151226r77e754e9n78a6491bdc30fd56@mail.gmail.com>
References: <342d47870711061746s64daeaa0wcb6adf060506686c@mail.gmail.com>
	<20071107050925.GA25156@linux.vnet.ibm.com>
	<342d47870711070707s7ac0fca2w1fdda12fb73fc548@mail.gmail.com>
	<342d47870711120954p56f41b30ob2c0956d11740244@mail.gmail.com>
	<20071112201835.GB23668@linux.vnet.ibm.com>
	<342d47870711121234o3aa82f95vc248308ef30097a3@mail.gmail.com>
	<342d47870711130852x4352d55axd2a0759cba9aa79@mail.gmail.com>
	<342d47870711151000o8bc5e6aw31394e039370c42c@mail.gmail.com>
	<473C939E.10609@cs.wisc.edu>
	<20071115191638.GB29968@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071115191638.GB29968@linux.vnet.ibm.com>
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

On Nov 15, 2007 1:16 PM, Mike Anderson <andmike@linux.vnet.ibm.com> wrote:
>
> > >> I can use 'mknod sdc b 8 32' to generate a new /dev/sdc, which I can
> > >> fdisk and the data looks good, but once I reboot the /dev/sdc device
> > >> is once again removed (or not re-created, whichever the case may be).
>
> I would agree that we should look to see what udev is doing when it
> receives the events.
>
> Since I believe this is failing on a RHEL4 sytem we cannot use
> udevmonitor. If you unload the iSCSI module, edit /etc/udev/udev.conf to
> set udev_log="yes", and then load the module again you should get some info
> in /var/log/message on what udev is doing.
>

Hey Mike,

Here's the guts of what happened...

# cat /var/log/messages | grep udev
Nov 13 15:39:01 ems1 udevsend[1185]: starting udevd daemon
Nov 13 15:39:02 ems1 start_udev: Starting udev:  succeeded
Nov 13 15:39:06 ems1 udevsend[1691]: starting udevd daemon
Nov 15 20:13:58 ems1 udev[30499]: creating device node '/dev/iscsictl'
Nov 15 20:13:58 ems1 udev[30509]: creating device node '/dev/iscsictl'
Nov 15 20:14:03 ems1 udev[30551]: configured rule in
'/etc/udev/rules.d/20-local.rules' at line 2 applied, 'sdc' is ignored
Nov 15 20:14:03 ems1 udev[30552]: configured rule in
'/etc/udev/rules.d/51-by-id.rules' at line 4 applied, added symlink
'disk/by-id/scsi-%c-part%n'
Nov 15 20:14:03 ems1 udev[30552]: creating device node '/dev/sdc1'

# cat /etc/udev/rules.d/20-local.rules
BUS="scsi", SYSFS{vendor}="EQLOGIC", SYSFS{model}="100E-00",
PROGRAM="/sbin/scsi_id -g -u -s /block/%k",
RESULT="30690a018f015191a6472441d1500f057", NAME=""

Maybe I shot myself in the foot.  While I don't necessarily recall
very putting that entry in there, I'm not going to exclude myself as
the cause of the problem (seeing how many steps I jumped through when
playing with all of this HBA, NIC and MPIO stuff).

Should I comment out that line, reboot (or restart iscsi) and see what happens?

Thanks!
Scott
