From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] [PATCH v3 01/26] block: Fix a buffer overrun in bio_integrity_split()
Date: Tue, 02 Oct 2012 18:30:28 -0400
Message-ID: <yq1wqz833sr.fsf@sermon.lab.mkp.net>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
	<1348526106-17074-2-git-send-email-koverstreet@google.com>
	<20121001212336.GA17165@redhat.com>
	<20121001214241.GE26488@google.com> <20121002140847.GD758@redhat.com>
	<20121002202643.GQ26488@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121002202643.GQ26488@google.com> (Kent Overstreet's message of
	"Tue, 2 Oct 2012 13:26:43 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, "Martin K. Petersen" <martin.petersen@oracle.com>, tj@kernel.org
List-Id: dm-devel.ids

>>>>> "Kent" == Kent Overstreet <koverstreet@google.com> writes:

>> > + *bp->bip1.bip_vec = bip->bip_vec[0];
>> > + *bp->bip2.bip_vec = bip->bip_vec[0];
>> 
>> I think this is horrible.

Yep.


>> Why not introduce bvec pointer in bip (like bio), to cover the case
>> when bvec are not inline.

Kent> That's... exactly what the next patch in the series does.

I'm perfectly ok with a patch that introduces the pointer and fixes the
bio_pair case. As long as that's all it does.

-- 
Martin K. Petersen	Oracle Linux Engineering
