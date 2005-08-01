From: =?iso-8859-1?Q?Ga=E1l_Norbert?= <norbert.gaal@comparex.hu>
Subject: RE: EMC Clariion ghost devices
Date: Mon, 1 Aug 2005 10:33:31 +0200
Message-ID: <180AB5814976694EB9B978153E1CD17DD36A5E@SRHUBUD01.comparex.bud>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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


Hi!

>> Is that a LUN 0 backed by actual storage or a LUN_Z?

>	I don't quite know what you mean by LUN_Z.  My EMC guy says it
>is a "ghost" projected because the second SP owns no disks, but SCSI
>requires a LUN 0 to be scannable.
>
>Joel

If no LUN 0 is present (or no LUN is in the Storage Group), and arraycomm=
path is enabled the Clariion 'emulates' a LUN this is a LUNZ.

From a EMC primus article:

A SCSI-3 (SCC-2) term defined as "the logical unit number that an applica=
tion client uses to communicate with, configure and determine information=
 about an SCSI storage array and the logical units attached to it. The LU=
N_Z value shall be zero." In the CLARiiON context, LUNz refers to a fake =
logical unit zero presented to the host to provide a path for host softwa=
re to send configuration commands to the array when no physical logical u=
nit zero is available to the host. When Access Logix is used on a CLARiiO=
N array, an agent runs on the host and communicates with the storage syst=
em through either LUNz or a storage device. On a CLARiiON array, the LUNZ=
 device is replaced when a valid LUN is assigned to the HLU LUN0 by the S=
torage Group. The agent then communicates through the storage device. The=
 user will continue, however, to see DGC LUNz in the Device Manager.=20
LUNz has been implemented on CLARiiON arrays to make arrays visible to th=
e host OS and PowerPath when no LUNs are bound on that array.  When using=
 a direct connect configuration, and there is no Navisphere Management st=
ation to talk directly to the array over IP, the LUNZ can be used as a pa=
thway for Navisphere CLI to send Bind commands to the array.=20

LUNz also makes arrays visible to the host OS and PowerPath when the host=
=B7s initiators have not yet =B7logged in to the Storage Group created fo=
r the host.  Without LUNz, there would be no device on the host for Navis=
phere Agent to push the initiator record through to the array. This is ma=
ndatory for the host to log in to the Storage Group. Once this initiator =
push is done, the host will be displayed as an available host to add to t=
he Storage Group in Navisphere Manager (Navisphere Express).

LUNz should disappear once a LUN zero is bound, or when Storage Group acc=
ess has been attained.

To turn on the LUNz behavior on CLARiiON arrays, you must configure the "=
arraycommpath."=20

Regards:
 Norbert Gaal
