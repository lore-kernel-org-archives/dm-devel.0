From: "Mike Moerk" <Mike_Moerk@us.xyratex.com>
Subject: Maps not created for read-only devices
Date: Thu, 24 Jan 2008 08:25:19 -0800
Message-ID: <9F94CC89AA0F524CBA8A619D43C4AED85C00BB@XYUS-EX22.xyus.xyratex.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Using SuSE10 with multipath-tools-0.4.6-25.8 and device-mapper-1.02.03-8.=
2, I am having the following problem. =A0When I set a LUN to read-only on=
 the storage controller, the LUN does not show up under "multipath -l".

The following debug messages show up from multipathd for the read-only de=
vice:

Jan 23 11:56:35 | mpath6: set ACT_CREATE (map does not exist)
Jan 23 11:56:35 | mpath6: domap (0) failure for create/reload map

Meanwhile I see the following entries in /var/log/messages:

Jan 24 08:58:36 suse10 kernel: device-mapper: dm-multipath: error getting=
 device
Jan 24 08:58:36 suse10 kernel: device-mapper: error adding target to tabl=
e

If the LUN is set to read/write access I have no problems.

Does anyone have any ideas why this might be happening?

Thanks,
Mike


______________________________________________________________________
This email may contain privileged or confidential information, which shou=
ld only be used for the purpose for which it was sent by Xyratex. No furt=
her rights or licenses are granted to use such information. If you are no=
t the intended recipient of this message, please notify the sender by ret=
urn and delete it. You may not use, copy, disclose or rely on the informa=
tion contained in it.

Internet email is susceptible to data corruption, interception and unauth=
orised amendment for which Xyratex does not accept liability. While we ha=
ve taken reasonable precautions to ensure that this email is free of viru=
ses, Xyratex does not accept liability for the presence of any computer v=
iruses in this email, nor for any losses caused as a result of viruses.

Xyratex Technology Limited (03134912), Registered in England & Wales, Reg=
istered Office, Langstone Road, Havant, Hampshire, PO9 1SA.

The Xyratex group of companies also includes, Xyratex Ltd, registered in =
Bermuda, Xyratex International Inc, registered in California, Xyratex (Ma=
laysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd =
registered in The People's Republic of China and Xyratex Japan Limited re=
gistered in Japan.
______________________________________________________________________
