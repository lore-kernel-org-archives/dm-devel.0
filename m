From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: To add, or not to add, a bio REQ_ROTATIONAL flag
Date: Thu, 28 Jul 2016 21:16:16 -0400
Message-ID: <yq1y44l2qhr.fsf@sermon.lab.mkp.net>
References: <alpine.LRH.2.11.1607281603530.10662@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1607281603530.10662@mail.ewheeler.net> (Eric
	Wheeler's message of "Thu, 28 Jul 2016 17:50:14 -0700 (PDT)")
Sender: linux-block-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: dm-devel.ids

>>>>> "Eric" == Eric Wheeler <bcache@lists.ewheeler.net> writes:

Eric,

Eric> However, just because FADV_SEQUENTIAL is flagged doesn't mean the
Eric> cache should bypass.  Filesystems can fragment, and while the file
Eric> being read may be read sequentially, the blocks on which it
Eric> resides may not be.  Same thing for higher-level block devices
Eric> such as dm-thinp where one might sequentially read a thin volume
Eric> but its _tdata might not be in linear order.  This may imply that
Eric> we need a new way to flag cache bypass from userspace that is
Eric> neither io-priority nor fadvise driven.

Why conflate the two? Something being a background task is orthogonal to
whether it is being read sequentially or not.

Eric> So what are our options?  What might be the best way to do this?

For the SCSI I/O hints I use the idle I/O priority to classify
backups. Works fine.

Eric> Are FADV_NOREUSE/FADV_DONTNEED reasonable candidates?

FADV_DONTNEED was intended for this. There have been patches posted in
the past that tied the loop between the fadvise flags and the bio. I
would like to see those revived.

Eric> Perhaps ionice could be used used, but the concept of "priority"
Eric> doesn't exactly encompass the concept of cache-bypass---so is
Eric> something else needed?

The idle class explicitly does not have a priority.

-- 
Martin K. Petersen	Oracle Linux Engineering
