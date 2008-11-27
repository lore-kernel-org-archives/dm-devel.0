From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Announce: unlimited number of shared snapshots
Date: Thu, 27 Nov 2008 00:41:36 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0811270022370.30288@hs20-bc2-1.build.redhat.com>
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

I made first release of my snapshot storage that can hold unlimited number 
of snapshots and share data between them:

http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/

How-to-use is at the beginning of dm-multisnapshot.patch

If you see some errors, report them.

This storage uses btree with the key (chunk number, snapshot range). It 
uses log-structured storage, so that it is safe w.r.t. crash.

TODO:
- reclaim allocated space, allow deleting snapshots
- writable snapshots

Mikulas
