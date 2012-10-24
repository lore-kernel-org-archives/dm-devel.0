From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 1/2] block: Fix a buffer overrun in bio_integrity_split()
Date: Wed, 24 Oct 2012 12:34:14 -0400
Message-ID: <yq1mwzbbzi1.fsf@sermon.lab.mkp.net>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
	<1350331769-14856-28-git-send-email-koverstreet@google.com>
	<20121019203015.GS13370@google.com> <20121022153907.GC3401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121022153907.GC3401@redhat.com> (Vivek Goyal's message of
	"Mon, 22 Oct 2012 11:39:07 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, martin.petersen@oracle.com
List-Id: dm-devel.ids

>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:

Vivek> Initially he had reordered the bio_pair fields but there were
Vivek> couple of issues. We could not assume that there is no padding
Vivek> between fields and secondly some of the initializtion of looked
Vivek> plain ugly.

Vivek> IMHO, introduction of bip_vec to fix this issue is small and
Vivek> cleaner then reordering fields.

I agree.

-- 
Martin K. Petersen	Oracle Linux Engineering
