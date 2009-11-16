From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-raid1 barriers
Date: Mon, 16 Nov 2009 18:48:02 +0000
Message-ID: <20091116184802.GD11886@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.0911161136500.5769@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911161136500.5769@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Nov 16, 2009 at 11:50:56AM -0500, Mikulas Patocka wrote:
> When there are no writes pending for a given region, we set the bit in 
> memory, indicating that the region is clean.
> Some times later (usually while setting another dirty bit in the log), we 
> write the log to disk.
> Before writing the log, we must flush cache on both mirror legs. 
> (otherwise, we might write some bit as clean while the data is still 
> pending in the disk cache)
> 
> If this flush fails, the bits in memory are already clean and we don't 
> know which regions may hold unwritten data in the disk cache and which 

Actually we do: the on-disk version of the log tells us.

> not. So, we must set all regions as dirty.
 
Anyway, let's not try to handle these situations at the moment.
what I need for now, is a way to know whether or not this situation has
actually occurred when we get reports from users, so probably a kernel
log message, a dm event raised plus a failure indicator against the device in
the status line.

Alasdair
