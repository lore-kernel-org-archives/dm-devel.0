From: "Dan Bar Dov" <danb@voltaire.com>
Subject: Usage question: how to access partitions?
Date: Sun, 8 Oct 2006 19:01:00 +0200
Message-ID: <D4F8F0B3820E754C887699BEF26A8940016E3489@taurus.voltaire.com>
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


After configuring multipath access to a LU, I partitioned it with fdisk.
fdisk complained about failing to re-read the partition table,=20
blockdev --rereadpt failed as well.

No new devices were created for the new partitions. I guess
there are udev rules to do that, are there?

How do I get the partition to become available, what should be the=20
partitions device names in /dev?

I'm using SLES9sp3

Thanks for pointers/advice
Dan
