From: Hannes Reinecke <hare@suse.de>
Subject: Re: Linux utility to determine WWN from a LUN number
Date: Fri, 14 Mar 2008 15:54:56 +0100
Message-ID: <47DA91C0.4010106@suse.de>
References: <B6FF36386FC9AC4BB098A4528811409F022309BE@CORPUSMX40A.corp.emc.com>	<20080313214352.GA18433@us.ibm.com>	<B6FF36386FC9AC4BB098A4528811409F02230CC4@CORPUSMX40A.corp.emc.com>	<alpine.LRH.1.00.0803140951210.23740@bogart.boston.redhat.com>	<47DA85A1.2040503@suse.de>
	<alpine.LRH.1.00.0803141025260.23740@bogart.boston.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.1.00.0803141025260.23740@bogart.boston.redhat.com>
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

Chip Coldwell wrote:
> On Fri, 14 Mar 2008, Hannes Reinecke wrote:
>> BTW: what is the main reason for scsitool?
>=20
> The main idea with scsitool is to be able to select, sort and output
> properties of SCSI disks.  The properties it supports are
>=20
> --devname (sda, sdb, etc.)
> --hbtl (host:bus:target:lun nexus)
> --wwid
> --target-wwnn
> --target-wwpn
> --host-wwnn
> --host-wwpn
> --vendor
> --model
> --driver (e.g. lpfc, qla2xxx)
>=20
[ .. ]
>=20
Ah, I see. So basically combining lsscsi and scsi_id.

>> Does it have features which scsi_id and sg3_utils are missing?
>=20
> I think the answer, in a mathematical sense, is "no".  However, I
> found it so cumbersome to combine the existing tools in scripts that
> it was worthwhile for me to write a new one from scratch.  In
> addition, in deployments with thousands of LUNs, I think combining the
> existing tools in scripts can turn out to be rather slow.
>=20
So the logical choice would be to include scsitool in sg3_utils,
I believe. And scsi_id, too, for good measure. Just so that we're
on one page with generating unique identifiers for udev :-)

As already mentioned, I'm not especially partial as to _where_
scsi_id is kept. I'd happily move it over to sg3_utils.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
