From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: high iowait problem(Bug 12309 on bugzilla.kernel.org)
Date: Wed, 14 Apr 2010 10:25:08 -0400
Message-ID: <yq1sk6yjem3.fsf@sermon.lab.mkp.net>
References: <20100331124834.192500@gmx.com>
	<20100413135416.b537eee8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100413135416.b537eee8.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 13 Apr 2010 13:54:16 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frank Ren <frankrq2009@gmx.com>, mingo <mingo@elte.hu>, "a.p.zijlstra" <a.p.zijlstra@chello.nl>, "jens.axboe" <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, stable@kernel.org, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

>>>>> "Andrew" == Andrew Morton <akpm@linux-foundation.org> writes:

Andrew> I'm seeing just one device-mapper change whcih went in over that
Andrew> timeframe:

Andrew> : commit e0f5cfa7c18b411634e73923841eccd3a4c0ce7f
Andrew> : Author: Martin K. Petersen <martin.petersen@oracle.com>
Andrew> : Date:   Mon Jan 11 03:21:50 2010 -0500
Andrew> : 
Andrew> :     DM: Fix device mapper topology stacking

The topology changes do not modify anything in our runtime I/O path.
They only come into play during filesystem or logical volume creation on
top of devices that support reporting alignment/physical block size.
And you need recent dm and filesystem utilities for that to work.

-- 
Martin K. Petersen	Oracle Linux Engineering
