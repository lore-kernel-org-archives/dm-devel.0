From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: dm-writeboost: Progress Report
Date: Sun, 19 Jan 2014 10:16:56 +0900
Message-ID: <52DB2788.40802@gmail.com>
References: <52D0F25D.6030904@gmail.com>
	<20140113100903.GA4984@debian>	<52D3D21B.8030408@gmail.com>
	<061401cf10a2$e059ed90$a10dc8b0$@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <061401cf10a2$e059ed90$a10dc8b0$@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: henson@acm.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi, Paul,

> Would I be incorrect in assuming that this increased write performance comes
> with the trade-off of a greater risk of losing data in the case of power
> failure or crash?
Incorrect. Performance and Robustness are irrelevant if it's designed correctly.
Writeboost's log contains both data blocks (4KB * N) and corresponding metablock (16B for each).
After crash, it can replay the log on the cache device and it guarantees no data lost.
Like the usual block device, those data acked to write barrier (REQ_FUA or REQ_FLUSH) are
guaranteed not to be lost.

FYI,
The worst thing in using writeboost or even other cache softwares is that the cache device
gone out of order (which means it can neither read nor write anymore).
The filesystem doesn't go inconsistent (need not fsck) in that worst situation is writeboost's another characteristic.
Writeboost writes back the dirty data on the cache device in the same order they were written.
Therefore, if the cache device is gone we can at least obtain the filesystem of the moment the last
write-back was done.
Read this article for SSD failure (http://lkcl.net/reports/ssd_analysis.html)
SSDs are very likely to go insane. Use trustworthy SSD is my advice.

Considering these characteristics,
Maybe, we can call dm-writeboost "log-structured write buffer" rather than "log-structured caching".

Thanks for your interest,
Akira
