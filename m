From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/22] Immutable biovecs, block layer changes
Date: Thu, 8 Aug 2013 08:09:54 -0700
Message-ID: <20130808150954.GA30092@infradead.org>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, neilb@suse.de, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Aug 07, 2013 at 02:54:09PM -0700, Kent Overstreet wrote:
> _However_, I have more patches (that depend on this patch series) to get
> that back - segment merging improvements that get rid of
> bi_seg_front_size, bi_seg_back_size, and bi_phys_segments. Once all that
> is in it should be a net reduction to the size of struct bio.

What is preventing you from sending those out as well?  While it's not
absolutely nessecary it would certainly be good if we'd avoid a struct
bio size regression.

