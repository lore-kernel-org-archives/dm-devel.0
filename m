From: "Ed Lin - PTU" <ed.lin@promise.com>
Subject: Bug#604049: linux-image-2.6.32-5-amd64: data corruption with promise stex driver and use of device-mapper layers (lvm/dm-crypt/..)
Date: Mon, 22 Nov 2010 10:33:27 -0800
Message-ID: <85ABFDC4641C4847BA6088F2982EFD8F049D500A@nonamew.ptu.promise.com>
References: <1290231222.3818.167.camel@localhost>
Reply-To: "Ed Lin - PTU" <ed.lin@promise.com>, 604049@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.604049.B604049.12904515318737@bugs.debian.org>
Content-class: urn:content-classes:message
In-Reply-To: <1290231222.3818.167.camel@localhost>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Ben Hutchings <ben@decadent.org.uk>, Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com
Cc: Markus Schulz <msc@antzsystem.de>, 604049@bugs.debian.org
List-Id: dm-devel.ids



>-----Original Message-----
>From: Ben Hutchings [mailto:ben@decadent.org.uk] 
>Sent: 2010年11月19日 21:34
>To: Ed Lin - PTU; Jens Axboe; dm-devel@redhat.com
>Cc: Markus Schulz; 604049@bugs.debian.org
>Subject: Re: Bug#604049: linux-image-2.6.32-5-amd64: data 
>corruption with promise stex driver and use of device-mapper 
>layers (lvm/dm-crypt/..)
>
>
>On Fri, 2010-11-19 at 20:26 +0100, Markus Schulz wrote:
>> Package: linux-2.6
>> Version: 2.6.32-27
>> Severity: critical
>> Tags: d-i upstream
>> Justification: causes serious data loss
>> 
>> any use of the stex.ko promise hw-raid controller driver with a
>> device-mapper layer produces data corruption (or filesystem 
>corruption
>> like you can see in my dmesg).
>[...]
>> i've asked Ed Lin (Maintainer of stex.c from promise) on 
>lkml and got the following answer:
>> 
>> > We found similar problem during test.
>> 
>> > The stex driver sets sg_tablesize as 32 (for st_yel it's 
>38) in the probe
>> > entry. It seems that this value was overridden by the 
>system if using
>> > dm/lvm, for unknown reason. The driver received requests with more
>> > sg items than registered. Sg item number could be as high 
>as 64. This
>> > is completely unexpected. The firmware could not handle such
>> > requests, and error occurred.
>[..]
>
>I have little idea how this stuff is supposed to work, but it 
>looks like
>dm_dispatch_request() calls blk_insert_cloned_request() which calls
>blk_rq_check_limits() which checks the request against the maximum
>number of segments initialised from sg_tablesize.
>
>We can perhaps mitigate the data loss by checking the number 
>of segments
>again in scsi_dispatch_cmd(), but it won't really solve the problem.
>

I believe the cause of the problem has been found. An explanation
and a possible solution was posted at the linux-scsi mail list
and dm-devel@redhat.com.

The link is http://marc.info/?l=linux-scsi&m=129021716922966&w=2
So far no one responded. Any comment is welcome.

Thanks,
Ed Lin
