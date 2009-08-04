From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/4] Fix corruption of snapshot store on
	invalidation
Date: Mon, 3 Aug 2009 21:38:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0908032135580.6002@hs20-bc2-1.build.redhat.com>
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

These four patches fix snapshot store corruption on snapshot invalidation.
(bug https://bugzilla.redhat.com/show_bug.cgi?id=461506)

The first two patches fix a race causing corruption of snapshot store 
header.

The second two patches fix a crash when the snapshot is activated with 
corrupted store. With the patches applied, error is reported instead of a 
crash and the volume is not activated.

Mikulas
