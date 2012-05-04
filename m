From: Spelic <spelic@shiftmail.org>
Subject: Re: dm-thin f.req. : SEEK_DATA / SEEK_HOLE / SEEK_DISCARD
Date: Fri, 04 May 2012 19:16:52 +0200
Message-ID: <4FA40F04.8040006@shiftmail.org>
References: <4F9FDCC2.2080905@shiftmail.org> <20120501141023.GA20313@ubuntu>
	<4FA006CD.3050204@shiftmail.org> <20120503091428.GB5351@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-reply-to: <20120503091428.GB5351@ubuntu>
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

On 05/03/12 11:14, Joe Thornber wrote:
> On Tue, May 01, 2012 at 05:52:45PM +0200, Spelic wrote:
>> I'm looking at it right now
>> Well, I was thinking at a parent snapshot and child snapshot (or
>> anyway an older and a more recent snapshot of the same device) so
>> I'm not sure that's the feature I needed... probably I'm missing
>> something and need to study more
> I'm not really following you here.  You can have arbitrary depth of
> snapshots (snaps of snaps) if that helps.

I'm not following you either (you pointed me to the external snapshot 
feature but this would not be an "external origin" methinks...?), but 
this is probably irrelevant after having seen the rest of the replies 
because I now finally understand what metadata is available inside 
dm-thin. Thanks for such clear replies.

With your implementation there's the problem of fragmentation and RAID 
alignment vs discards implementation. With concurrent access to many 
thin provisioned devices, if blocksize is small, fragmentation is likely 
to come out bad, HDDs streaming reads can suffer a lot on fragmented 
areas (up to a factor 1000), and on parity raid, write performance would 
also suffer; while if blocksize is set to be large (such as one RAID 
stripe), block unmapping on discards is not likely to work because one 
discard per file would be received but most files would be smaller than 
a thinpool block (smaller than a RAID stripe: in fact it is recommended 
that the raid chunk is made equal to the prospected average file size so 
average file size and average discard size would be 1/N of the thinpool 
block size) so nothing would be unprovisioned.

There would be another way to do it (pls excuse my obvious arrogance and 
I know I should write code instead of write emails) two layers: 
blocksize for provisioning is e.g. 64M (this one should be customizable 
like you have now), while blocksize for tracking writes and discards is 
e.g. 4K. You make the btree only for the 64M blocks, and inside that you 
keep 2 bitmaps for tracking its 16384  4K-blocks. One bit is "4K block 
has been written", and if this is zero, reads go against the parent 
snapshot (this avoids CoW costs when provisioning a new 64M block). The 
other bit is "4K block has been discarded" and if this is set, reads 
return zero, and if all 16384 bits are set, the 64M block gets 
un-provisioned. This would play well with RAID alignment, with HDD 
fragmentation, with CoW (normally no cow performed if writes are 4K or 
bigger... "read optimizations" could do that afterwards if needed), with 
multiple small discards, with tracking differences between parent 
snapshot and current snapshot for remote replication, and with 
compressed backups which would see zeroes on all discarded areas.
It should be possible to add this into your implementation because added 
metadata is just 2 bitmaps more for each block than what you have now.
I would really like to try to write code for this but unfortunately I 
foresee I won't have time to write code for a good while.
With this I don't want that to appear like I don't appreciate your 
current implementation which is great work, was very much needed, and in 
fact I will definitely use it for our production systems after 3.4 is 
stable (I was waiting for discards)


> Y, I'll provide tools to let you do this.  If you wish to help with
> writing a replicator please email me.  It's a project I'm keen to get
> going.

Thanks for the opportunity but for now it seems I can only be a leech, 
at most I have time for writing a few emails :-(

Thank you
S.
