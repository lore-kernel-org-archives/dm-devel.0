From: "Mitura, Radoslaw" <radoslaw.mitura@intel.com>
Subject: Activation with missing device
Date: Tue, 12 Feb 2008 18:44:36 -0000
Message-ID: <170B86B6CD3A4E4683CCAAF936E402E502DA47CA@swsmsx412.ger.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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

When I add devices to mirror in device mapper and activate I have:
# dmsetup table
isw_dgdccjfdbi_test: 0 20971779 mirror core 2 16384 nosync 2 8:16 0 8:32
0 1 handle_errors
# dmsetup status
isw_dgdccjfdbi_test: 0 20971779 mirror 2 8:16 8:32 1281/1281 1 AA 1 core

After removing one of disks I can still work on the volume and device
mapper take care of writes to disk that is left and change its status.
# dmsetup table
isw_dgdccjfdbi_test: 0 20971779 mirror core 2 16384 nosync 2 8:16 0 8:32
0 1 handle_errors
# dmsetup status
isw_dgdccjfdbi_test: 0 20971779 mirror 2 8:16 8:32 1281/1281 1 DA 1 core

However after rebooting that system I cannot create device mapper table
with missing device.
# dmsetup create isw_dgdccjfdbi_test
0 20971779 mirror core 2 16384 nosync 2 8:16 0 8:32 0 1 handle_errors
device-mapper: reload ioctl failed: No such device or address

Is it possible to create table with missing device and tell device
mapper to set missing device status to "D"?

Regards,
Radek

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku,=20
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego,=20
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
