From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC PATCH] bio integrity: do not assume bio_integrity_pool exists if bioset exists
Date: Tue, 07 Jul 2015 20:19:33 -0400
Message-ID: <yq1zj37wley.fsf@sermon.lab.mkp.net>
References: <20150701165740.GA1573@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150701165740.GA1573@redhat.com> (Mike Snitzer's message of
	"Wed, 1 Jul 2015 12:57:40 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org, mpatocka@redhat.com
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Sorry I'm a bit late to the game here. Just got back from vacation.

But I agree with the patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
