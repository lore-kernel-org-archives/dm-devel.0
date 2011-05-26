From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm: pass up rotational flag
Date: Thu, 26 May 2011 14:48:23 -0400
Message-ID: <yq1vcwx47t4.fsf@sermon.lab.mkp.net>
References: <1306356648-30730-1-git-send-email-msb@chromium.org>
	<20110526182321.GA26219@redhat.com>
	<yq1zkm948oa.fsf@sermon.lab.mkp.net>
	<20110526184321.GC26219@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110526184321.GC26219@redhat.com> (Mike Snitzer's message of
	"Thu, 26 May 2011 14:43:21 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org, jrbarnette@chromium.org, Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Similarly, couldn't the discard flag be made part of topology?

Actually, now that I think about it I'm fairly sure my patch nuked the
discard queue flag because I was tired of keeping the flag and the
topology in sync. I don't think I mucked with the rotational flag.

Let me grep my patch queue and see. It must be in there somewhere...

-- 
Martin K. Petersen	Oracle Linux Engineering
