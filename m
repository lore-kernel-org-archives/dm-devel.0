From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] block: trace completion of all bios.
Date: Mon, 27 Mar 2017 02:03:08 -0700
Message-ID: <20170327090308.GA11757@infradead.org>
References: <877f3iave6.fsf@notabene.neil.brown.name>
 <20170322125149.GA29606@infradead.org>
 <87shm4a4lt.fsf@notabene.neil.brown.name>
 <20170323104331.GA16903@ming.t460p>
 <87fui3a65o.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87fui3a65o.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

I don't really like the flag at all.  I'd much prefer a __bio_endio
with a 'bool trace' flag.  Also please remove the manual tracing in
dm.ċ.  Once that is done I suspect we can also remove the
block_bio_complete export.
