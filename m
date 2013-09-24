From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work [was:
 dm mpath: disable WRITE SAME if it fails]
Date: Tue, 24 Sep 2013 11:37:20 +0200
Message-ID: <52415D50.508@redhat.com>
References: <20130919161043.GA27081@redhat.com> <20130920212142.GA17898@redhat.com> <yq1eh8jf8wq.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <yq1eh8jf8wq.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

Il 21/09/2013 00:03, Martin K. Petersen ha scritto:
> 
> The major headache here of course is that WRITE SAME is inherently
> destructive. We can't just fire off one during discovery and see if it
> works. For WRITE you can issue a command with a transfer length of 0 to
> see if things work. But unfortunately for WRITE SAME a transfer length
> of zero means "wipe the entire device". Yikes!

What about WRITE SAME with an out-of-range lba?  Or lba equal to the
size of the disk and #blocks equal to zero.

Paolo
