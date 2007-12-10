From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: device-mapper multipath retry IO errors
Date: Mon, 10 Dec 2007 09:18:07 -0600
Message-ID: <1197299887.5169.21.camel@localhost.localdomain>
References: <1197299207.6188.10.camel@eddie-laptop.sc.steeleye.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1197299207.6188.10.camel@eddie-laptop.sc.steeleye.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eddie Williams <Eddie.Williams@SteelEye.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Mon, 2007-12-10 at 10:06 -0500, Eddie Williams wrote:
> It looks to me like device mapper multipath will retry IO errors, no
> matter what the error, indefinitely if no_path_retry is set to anything
> other than 0 and the path checker does not detect the failure.
> 
> Say you run into a medium error, the particular IO will fail.  The path
> will be marked failed and retried on another path.  This will exhaust
> the list of paths since the medium error will happen on each path.  If
> no_path_retry is set to 1 or more then the IO will be queued.  The path
> checker will come along and the TUR or the IO to block 0 will pass so it
> will mark the path as good, clearing the error.  The IO will then get
> reissued, marking the paths failed, etc.
> 
> Am I missing something in the code that will catch this?

I've been advocating for some time that we need to split our errors into
transport related (and therefore potentially retryable over a different
path) and device related (and therefore path independent and needing to
be reported to the user).

> I don't have a means to force a medium error but I was able to create
> something similar by creating a reservation conflict.

Actually, just for the record, there is a way to force devices to report
medium error using the READ LONG/WRITE LONG commands (these allow you to
pull the "real" data off the drive including the crc information.  If
you save the old data and fill it with random bits before writing it,
the crc will inevitably mismatch and the device will signal a medium
error for that sector (on a read, anyway).

James
