From: Hannes Reinecke <hare@suse.de>
Subject: Re: Linux utility to determine WWN from a LUN number
Date: Fri, 14 Mar 2008 16:37:46 +0100
Message-ID: <47DA9BCA.2080007@suse.de>
References: <B6FF36386FC9AC4BB098A4528811409F022309BE@CORPUSMX40A.corp.emc.com>	<20080313214352.GA18433@us.ibm.com>	<B6FF36386FC9AC4BB098A4528811409F02230CC4@CORPUSMX40A.corp.emc.com>	<alpine.LRH.1.00.0803140951210.23740@bogart.boston.redhat.com>	<47DA85A1.2040503@suse.de>	<alpine.LRH.1.00.0803141025260.23740@bogart.boston.redhat.com>	<47DA91C0.4010106@suse.de>
	<alpine.LRH.1.00.0803141133310.23740@bogart.boston.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.1.00.0803141133310.23740@bogart.boston.redhat.com>
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
>=20
>> Ah, I see. So basically combining lsscsi and scsi_id.
>=20
> Yes, although the output format is more configurable than lsscsi.
>=20
>> As already mentioned, I'm not especially partial as to _where_
>> scsi_id is kept. I'd happily move it over to sg3_utils.
>=20
> Ideally, we would also factor out all the common code among the three
> into a common library.
>=20
sg3-utils already has such a library. Would be fairly easy to use that ..=
.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
