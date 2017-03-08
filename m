From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: [RFC] dm-thin: Heuristic early chunk copy before COW
Date: Wed, 8 Mar 2017 10:17:51 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1703081005001.19383@mail.ewheeler.net>
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
List-Id: dm-devel.ids

Hello all,

For dm-thin volumes that are snapshotted often, there is a performance 
penalty for writes because of COW overhead since the modified chunk needs 
to be copied into a freshly allocated chunk.

What if we were to implement some sort of LRU for COW operations on 
chunks? We could then queue chunks that are commonly COWed within the 
inter-snapshot interval to be background copied immediately after the next 
snapshot. This would hide the latency and increase effective throughput 
when the thin device is written by its user since only the meta data would 
need an update because the chunk has already been copied.

I can imagine a simple algorithm where the COW increments the chunk LRU by 
2, and decrements the LRU by 1 for all stored LRUs when the volume is 
snapshotted. After the snapshot, any LRU>0 would be queued for early copy.

The LRU would be in memory only, probably stored in a red/black tree. 
Pre-copied chunks would not update on-disk meta data unless a write occurs 
to that chunk. The allocator would need to be updated to ignore chunks 
that are in the LRU list which have been pre-copied (perhaps except in the 
case of pool free space exhaustion).

Does this sound viable?

--
Eric Wheeler
