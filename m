From: "Duane Grigsby" <duane.grigsby@qlogic.com>
Subject: RE: Making failover work quickly with QLogic HBAs
Date: Thu, 21 Apr 2005 17:56:16 -0700
Message-ID: <41EBA11203419D4CA8EB4C6140D8B4010295B6C6@AVEXCH01.qlogic.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
content-class: urn:content-classes:message
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

Lars,
Sorry for the late response. I would remove the "ql2xloginretrycount" par=
ameter because it specifies how many times to re-login to the port once i=
t returns.  Usually, OEMs set the correct value they need for their stora=
ge in the NVRAM and we get it from there. The qlport_down_retry is the ma=
in timer that affects how long we will keep the command before returning =
with DID_NO_CONNECT.  All the other parameters are ok as long as multipat=
h can handle the fact that there are some targets can have no-paths avail=
able for a short period of time.=20

Regards,
Duane

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On=
 Behalf Of Lars Marowsky-Bree
Sent: Thursday, April 21, 2005 5:23 AM
To: dm-devel@redhat.com
Subject: [dm-devel] Making failover work quickly with QLogic HBAs

This will greatly speed up failover times; with the defaults, the
timeout values are just way too long for multipathing:

options qla2xxx ql2xfailover=3D0 ql2xioctltimeout=3D10 ql2xprocessnotread=
y=3D0 ql2xloginretrycount=3D3 ql2xsuspendcount=3D3 ql2xretrycount=3D5 qlp=
ort_down_retry=3D3


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
