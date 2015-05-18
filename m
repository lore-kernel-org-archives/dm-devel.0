From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH for-4.2 01/14] block: remove management of
 bi_remaining when restoring original bi_end_io
Date: Mon, 18 May 2015 01:24:39 -0700
Message-ID: <20150518082439.GA5439@infradead.org>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
 <1431637512-64245-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431637512-64245-2-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

In general this looks good.  But as Jan mentioned you need to
clear BIO_CHAIN when bi_remaining reaches zero, and I'd really
prefer if bio_inc_remaining wuld not be left exported and folded
into bio_chain so that we prevent new abuses from showing up
and keep the code centralized.
