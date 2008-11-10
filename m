From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Queue upcall locking (was: [RFC][PATCH] fix
	dm_any_congested() to properly sync up with suspend code path)
Date: Mon, 10 Nov 2008 09:55:55 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0811100952150.19937@hs20-bc2-1.build.redhat.com>
References: <1225944008.14830.1101.camel@chandra-ubuntu>
	<Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com>
	<20081110135401.GA11606@infradead.org>
	<Pine.LNX.4.64.0811100914500.14825@hs20-bc2-1.build.redhat.com>
	<1226327210.7685.173.camel@twins>
	<Pine.LNX.4.64.0811100929380.16965@hs20-bc2-1.build.redhat.com>
	<1226328417.7685.198.camel@twins>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1226328417.7685.198.camel@twins>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, 10 Nov 2008, Peter Zijlstra wrote:

> > If you have a physical disk that has many LVM volumes on it, you end up in 
> > a situation when disk congestion state change is reported to all the 
> > volumes. So it will create O(n) problem at the other side.
> 
> *sigh* I can almost understand why people want to use lvm to combine
> multiple disks, but why make the partition thing even worse...

To protect the services from each other --- so that mail storm won't blow 
user's directories, users blowing their space can't corrupt the system 
updates, logs are kept safely even if other partition overflows etc.

I just know some admins who prefer to have separate filesystems instead of 
quotas for this purpose.

Mikulas
