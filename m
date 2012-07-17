From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/2] block: split discard into aligned requests
Date: Tue, 17 Jul 2012 03:20:04 -0400
Message-ID: <20120717072004.GE15473@infradead.org>
References: <1341504104-1674-1-git-send-email-pbonzini@redhat.com>
 <1341504104-1674-3-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1341504104-1674-3-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, snitzer@redhat.com, martin.petersen@oracle.com, xfs@oss.sgi.com, dm-devel@redhat.com, hch@lst.de, vgoyal@redhat.com
List-Id: dm-devel.ids

Looks good.

Any chance we can get this into the 3.6 queue (and possibly -stable)?
