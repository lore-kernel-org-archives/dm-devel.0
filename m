From: "Chakravarti, Avishek (STSD)" <avishek.chakravarti@hp.com>
Subject: Dm-mirror creation failure
Date: Mon, 27 Feb 2006 12:33:18 +0530
Message-ID: <71ED110921D72047BFD1C9B300133745052BE7DE@BGEEXC02.asiapacific.cpqcorp.net>
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


Hi,

I came across the following scenario while testing a dm-mirror created
using dmsetup.

One of the mirror halves was failed and the node was rebooted
immediately afterwards so that when the node came up the failed disk was
not only accessible but was also not configured. Now when I tried
creating the mirror again using using the same target as before, it
failed.=20

In such a scenario, how do I create the dm mirror with just one half of
the mirror available ?=20

Is there a way to create a device-mapper device survive reboots, e.g.
create a mirror once and then start and stop it, after node reboots.

Is there a way to start the dm-mirror by using the " -u uuid " option
instead of device names with dmsetup?=20

What is the status of lvm mirroring, using "lvcreate -m" , how stable is
it?=20

Thanks,
Avishek
