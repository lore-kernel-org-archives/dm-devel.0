From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for-4.2 v2 01/14] block: remove management of
 bi_remaining when restoring original bi_end_io
Date: Mon, 18 May 2015 23:28:56 -0700
Message-ID: <20150519062856.GA22674@infradead.org>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
 <1431637512-64245-2-git-send-email-snitzer@redhat.com>
 <20150518072237.GE26351@quack.suse.cz>
 <20150518131358.GA13998@redhat.com>
 <20150518153644.GA10187@quack.suse.cz>
 <20150518155948.GE13998@redhat.com>
 <20150518204017.GA17202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150518204017.GA17202@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, hch@infradead.org, Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
