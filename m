From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm: pass up rotational flag
Date: Thu, 26 May 2011 14:29:41 -0400
Message-ID: <yq1zkm948oa.fsf@sermon.lab.mkp.net>
References: <1306356648-30730-1-git-send-email-msb@chromium.org>
	<20110526182321.GA26219@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110526182321.GA26219@redhat.com> (Mike Snitzer's message of
	"Thu, 26 May 2011 14:23:21 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org, jrbarnette@chromium.org, Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

>> Allow the NONROT flag to be passed through to linear mappings if all
>> underlying device are non-rotational. Tools like ureadahead will
>> schedule IOs differently based on the rotational flag.

Mike> Thanks for doing this, looks good in general.

I'd rather we made the rotational property part of the topology instead
of having to special-case it in DM. I seem to recall posting a patch
that did that at some point but I can't seem to find it...

-- 
Martin K. Petersen	Oracle Linux Engineering
