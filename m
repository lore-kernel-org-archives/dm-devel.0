From: Mikulas Patocka <mpatocka@redhat.com>
Subject: dm-raid1 barriers
Date: Mon, 16 Nov 2009 11:50:56 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911161136500.5769@hs20-bc2-1.build.redhat.com>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

As you talked about setting the whole device dirty. The problem is this:

When there are no writes pending for a given region, we set the bit in 
memory, indicating that the region is clean.

Some times later (usually while setting another dirty bit in the log), we 
write the log to disk.

Before writing the log, we must flush cache on both mirror legs. 
(otherwise, we might write some bit as clean while the data is still 
pending in the disk cache)

If this flush fails, the bits in memory are already clean and we don't 
know which regions may hold unwritten data in the disk cache and which 
not. So, we must set all regions as dirty.

---

If you don't like setting all regions as dirty, we would have to introduce 
new region state ("no pending writes but possibly unflushed") and 
introduce new bitmap for regions in this state.

I wouldn't like to do it because it is considerable coding overhead, it 
makes a lot of opportunities for bugs (which are hard to find because 
failures happen rarely) and the whole effect for the user could be 
negative --- instead of resyncing the whole array it could introduce a bug 
that corrupts user's data.

BTW, when running with dmeventd, the whole issue is poitless because 
dmeventd removes failed mirror legs, so it always resyncs when recreating 
the mirror. Without dmeventd, the mirror is already unsafe and has 
problems leading to data corruption when failed devices reappear, so 
resyncing or not-resyncing the whole mirror is probably the least serious 
thing to worry about.

Mikulas
