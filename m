From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Making failover work quickly with QLogic HBAs
Date: Thu, 21 Apr 2005 14:23:28 +0200
Message-ID: <20050421122328.GJ17315@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

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
