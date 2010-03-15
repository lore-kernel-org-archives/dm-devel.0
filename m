From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/4] fix snapshot flaws with 4k sectors
Date: Mon, 15 Mar 2010 01:59:55 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1003150145220.12526@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

This is series of 4 patches that fix flaws with 4k sectors and snapshots.
The first flaw is bad iterate devices (it can hurt even with 512-byte 
sectors, if the snapshot and origin are at devices with different 
limits).

The next two patches just prepare things for the 4th patch. The 4th patch 
extends the chunk size test for both the snapshot and the origin --- i.e. 
chunk size must be greater than or equal to both snapshot and origin 
sector size. Previously, the test was only for the snapshot, thus if you 
had origin with large sector and snapshot with small sector, it would fail 
copying the small chunk from the origin to the snapshot.

BTW. if anyone wants to test his code with non-512-byte sector devices, 
you can use old Seagate U160 SCSI disks (Cheetah XL and before), they can 
be reformatted to 512-4096 byte sectors with sg_format command. They are 
no longer being manufactured, you can find them at internet auctions. The 
current U320 SCSI disks (Cheetah 10K.X or 15K.X) don't support large 
sectors, they only support 512-528 byte sector-size.

Mikulas
