From: Edward Goggin <egoggin@emc.com>
Subject: dm-multipath alua assigned path priorities
Date: Wed, 4 Oct 2006 14:24:07 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D140E@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
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

Are the relationships between various dm-multipath ALUA assigned path
priorities (active/optimal=3D50;active/sub-optimal=3D10;standby=3D1;other=
=3D0)
based on the performance characteristics of a particular array or were
they arbitrarily chosen?  Also, is it reasonable to make these ALUA
assigned path priorities configurable (particularly the ratio of
active/optimal to active/sub-optimal priorities) on a per storage system
basis?
