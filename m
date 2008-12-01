From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Mon, 1 Dec 2008 11:10:01 -0500
Message-ID: <49340C59.4070504@cfl.rr.com>
References: <492C91DF.7040507@redhat.com>	<492D9BDB.5010001@cfl.rr.com>	<492E514F.2080007@redhat.com>	<49304F41.2060205@cfl.rr.com>
	<49338BA6.3010809@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49338BA6.3010809@redhat.com>
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
> log disks are updated in parallel and we do not know which disk has the
> latest and correct data if the system crashes during write operations
> on log devices. But there is no problem about it.

Once the IO request has been completed, the data needs to be stable on
the disk.  This means that either you have to wait until the data has
been written to all underlying mirror devices before completing the
request ( slow ) or you have to have some way of knowing which disk(s)
got written to, and which ones need updated after a crash.  Are you
saying you take the former path?

> There are two cases we need to think about.
> 
> 1) Some log devices contain "clean", but mirror devices are not synchronized
> 
> This case is problematic, but never happens, because data is written on
> mirror devices after marking log devices "dirty", and make it "clean"
> after write I/Os on mirror devices completed and mirrors get synchronized.

Does the entire log-data-log update cycle complete before dm completes
the higher level IO request?  That would maintain data integrity, but at
significant cost to performance.

For performance sake, don't you want to allow write requests to be
completed before the log is necessarily marked as clean again?  That way
multiple writes to the same data zone do not require multiple log
dirty/clean updates.  Also for performance reasons, don't you want to
allow the data to be written to only one mirror before completing the
request?  Then go back and do lazy synchronization?
