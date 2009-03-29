From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [ANNOUNCE] new release of multisnapshot
Date: Sun, 29 Mar 2009 15:45:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0903291536250.12730@hs20-bc2-1.build.redhat.com>
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
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

Here I make new release of multisnapshots. This allows to have unlimited 
number of snapshots with shared storage.

http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/

From feature point of view, it should be complete.

Enhancements from my first release: writeable snapshots, unlimited chunk 
size, reclaiming of free space and deleting snapshots.

Mikulas
