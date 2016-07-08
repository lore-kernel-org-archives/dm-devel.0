From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [Question] udev ID_UID attribute ???
Date: Fri, 8 Jul 2016 22:45:11 +0200
Message-ID: <c6ca404f-4e0e-d7c9-de1f-60e0697df789@gmail.com>
References: <22f39ecd-bfe7-d3b0-87af-e0b28d368bc8@gmail.com>
	<5c9472d8-ef1a-bfd7-a916-d4120d881fc1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5c9472d8-ef1a-bfd7-a916-d4120d881fc1@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <mchristi@redhat.com>, device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

On 07/08/2016 05:52 PM, Mike Christie wrote:

> On 07/07/2016 04:21 PM, Xose Vazquez Perez wrote:
>> Is "ID_UID" really valid?
>>
>> libmultipath/hwtable.c:         .uid_attribute = "ID_UID",
>>
> 
> I was wondering the same thing. For ceph rbd, we do not have the normal
> scsi serial/wwn values, so I am modifying our udev rule to export ID_UID.
> 
> I made the ID_UID, the values we use for the udev (/dev/rbd) name which
> is the pool name (basically just a grouping of storage) plus the image
> name (basically name of a disk created in a pool).

ID_UID isn't "standard". It wasn't found in kernel, multipath-tools or systemd(udev)
sources.

It's variable returned by dasdinfo from 390-tools package, it contains the "DASD uid"
of a dasd device. And it's used by udev rules to make symlinks for dasd devices under
/dev/disk/by-id/

This is hercules, but in a LPAR shows a similar output:
sles11-s390x:~ # dasdinfo -e -a -d /dev/dasda
ID_BUS=ccw
ID_TYPE=disk
ID_UID=HRC.ZZ000000000001.0120.22
ID_XUID=HRC.ZZ000000000001.0120.22
ID_SERIAL=0X0122

sles11-s390x:~ # grep ID_UID  /etc/udev/rules.d/59-dasd.rules
KERNEL=="dasd*[!0-9]", ENV{ID_UID}=="?*", SYMLINK+="disk/by-id/$env{ID_BUS}-$env{ID_UID}"
KERNEL=="dasd*[0-9]", ENV{ID_UID}=="?*", SYMLINK+="disk/by-id/$env{ID_BUS}-$env{ID_UID}-part%n"


It was used for dasd devices in multipath-tools because they haven't a WWN.

So, invent another undocumented variable name :-) , "ID_CEPH" or "ID_CEPH-RBD" ...
