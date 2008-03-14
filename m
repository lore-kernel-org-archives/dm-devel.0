From: Hannes Reinecke <hare@suse.de>
Subject: Re: Linux utility to determine WWN from a LUN number
Date: Fri, 14 Mar 2008 08:12:59 +0100
Message-ID: <47DA257B.70904@suse.de>
References: <B6FF36386FC9AC4BB098A4528811409F022309BE@CORPUSMX40A.corp.emc.com>	<20080313214352.GA18433@us.ibm.com>
	<B6FF36386FC9AC4BB098A4528811409F02230CC4@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <B6FF36386FC9AC4BB098A4528811409F02230CC4@CORPUSMX40A.corp.emc.com>
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

lemons_terry@emc.com wrote:
>> lemons_terry@emc.com [lemons_terry@emc.com] wrote:
>>> Hi
>>>
>>> I want to have multipath manage only the CLARiiON LUN that I boot
> from (LUN 0).  So I know that I can specify the following in
> /etc/multipath.conf:
>>> blacklist {
>>> 	wwid *
>>> 	}
>>> blacklist_exceptions {
>>> 	wwid nnnnnnnnnn
>>> 	}
>>>
>>> The wwid value is different for every CLARiiON LUN.  So, if I want to
> automate the process of adding the 'wwid' value to the blacklist, what
> utility can I use to specify a LUN number, and find the WWN of the LUN?
>>> Thanks!
>>> tl
>> lsscsi, lists all your SCSI devices. It should have LUN number and
>> device name. You can use scsi_id to get WWN. lsscsi uses "sysfs" file
>> system (/sys/class/scsi_device/ etc), so you should be able to write
>> your own to suite your exact needs.
>=20
> Sorry, but doesn't scsi_id only return what it finds in SCSI VPD pages
> 80 or 83?  Not all devices provide a WWN in VPD page 83.
>=20
The WWN is either in VPD page 0x83 or 0x80 (in that order of preference).
You should be using the utility 'scsi_id' to generate the WWN for a given
path (eg call it like 'scsi_id -g -u -s /block/sdX'), as this is the same
program multipath is using.

So the scsi_id program will give a you a mapping sdX -> WWN. And to get
the mapping 'LUN -> sdX' you can simply do a

( cd -P /sys/block/sdX/device; echo ${PWD##*/} )

which will display the SCSI ID of the device; the last number of which is
the LUN presented to the OS.

The remainder is left as an exercise to the reader :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
