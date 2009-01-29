From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCHES] new barriers - 2
Date: Thu, 29 Jan 2009 09:43:14 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0901290935290.27047@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi

Here I announce 2nd version my new barrier support patches:
http://people.redhat.com/mpatocka/patches/kernel/barriers/

They are against 2.6.29-rc3.

The most important enhancement is that with these patches, device mapper 
is able to send barrier requests to lower devices.

So it should be safe to enable write cache with hdparm -W 1 command on 
disks used in lvm and get enhanced performance because of write caching.

(prior to this patch, if you enabled write cache, you'd get misordered 
writes if you used journaling filesystems, because the barriers wouldn't 
get through to the real devices).

The barriers should work on linear volumes, mirrors, snapshots and 
multipath volumes. On mirrors and multipath, cache flush errors are 
ignored (this may be further improved).

Mikulas
