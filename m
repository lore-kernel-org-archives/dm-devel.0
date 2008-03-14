From: Hannes Reinecke <hare@suse.de>
Subject: Re: Linux utility to determine WWN from a LUN number
Date: Fri, 14 Mar 2008 15:03:13 +0100
Message-ID: <47DA85A1.2040503@suse.de>
References: <B6FF36386FC9AC4BB098A4528811409F022309BE@CORPUSMX40A.corp.emc.com>	<20080313214352.GA18433@us.ibm.com>	<B6FF36386FC9AC4BB098A4528811409F02230CC4@CORPUSMX40A.corp.emc.com>
	<alpine.LRH.1.00.0803140951210.23740@bogart.boston.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.1.00.0803140951210.23740@bogart.boston.redhat.com>
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
Cc: Doug Gilbert <dougg@torque.net>
List-Id: dm-devel.ids

Hi Chip,

Chip Coldwell wrote:
> On Thu, 13 Mar 2008, lemons_terry@emc.com wrote:
>> Sorry, but doesn't scsi_id only return what it finds in SCSI VPD pages
>> 80 or 83?  Not all devices provide a WWN in VPD page 83.
>=20
> It's quite a bit more complicated than that.  If a WWN exists on VPD
> pages 80 or 83, scsi_id will return that; otherwise it will synthesize
> a serial number.
>=20
> Doug Gilbert and I have exchange some correspondence on the subject of
> unifying his lsscsi (and possibly sg3_utils), my scsitool and the udev
> scsi_id utility.  At the moment, all of these are drawn from different
> code bases.  Doug chose to design lsscsi to use only sysfs information
> because he wanted it to be runnable as a non-privileged process.
> That's both good and bad: sysfs is shifting sand to build a foundation
> on, and so far there is no standard place in sysfs to retrieve a WWN.
> Both scsi_id and sg3_utils use SG_IO to do a VPD 0x80/0x83 INQUIRY.
>=20
I'd be more than happy to move the scsi_id program out of the udev
codebase and merge it with sg3_utils. Or, possibly better, would
be to have scsi_id use the libraries provided by sg3_utils.
scsi_id is just part of udev as it accidentally ended up there ...

IIRC we even hijacked that out of multipath-tools at one point.
And what's more, it's effectively orphaned as Patrick Mansfield
doesn't seem to work on SCSI things anymore. So moving scsi_id
to a better maintained base would indeed be a good idea.

BTW: what is the main reason for scsitool? Does it have features
which scsi_id and sg3_utils are missing?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
