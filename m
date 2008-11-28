From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Fri, 28 Nov 2008 15:06:25 -0500
Message-ID: <49304F41.2060205@cfl.rr.com>
References: <492C91DF.7040507@redhat.com> <492D9BDB.5010001@cfl.rr.com>
	<492E514F.2080007@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <492E514F.2080007@redhat.com>
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
List-Id: dm-devel.ids

Takahiro Yasui wrote:
> bitmap data on a log disk indicates if each region are "clean" or "dirty"
> among mirror disks. If a bit related to a region is "1", it means that
> the region is "clean" and data in the region is synchronized in all mirror
> disks and they store the same data in the region. On the other hand,
> if a bit related to a region is "0", the region is "dirty" and the region
> is out of synchronization. It means that each mirror disk might contain
> different data in the region.
> 
> Therefore, a log disk contains a state of each region, but does not
> correspond to a specific mirror device.
> 
> This patch set introduces redundant log disk on dm-mirror.

Right... and when recording a log on every disk in the mirror, each copy
of the log may not contain exactly the same information at any given
time.  If you write to one disk in the mirror first, then you need to
mark the region as dirty on that disk first, so that if the system
crashes before you can copy the data to the other mirror, you can see
that the first disk is more up to date than the second disk.

In other words, knowing that a region is or is not synchronized across
each disk is not enough; if they are out of sync you need to figure out
which disk has the most current information so it can be replicated to
the others, don't you?

Or do you just always write to the first disk first, and assume it has
the most recent data if the region was marked as dirty in ANY of the logs?
