From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dm-thinp: report correct optimal I/O size
Date: Thu, 28 Apr 2011 04:49:07 -0400
Message-ID: <20110428084907.GA10252@infradead.org>
References: <20110427134150.GA15413@infradead.org>
	<1303925125.7049.9.camel@ubuntu>
	<20110428084223.GB32658@infradead.org>
	<1303980453.2483.2.camel@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1303980453.2483.2.camel@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, ejt@redhat.com
List-Id: dm-devel.ids

On Thu, Apr 28, 2011 at 09:47:33AM +0100, Joe Thornber wrote:
> I'm tempted to just say min(16M, tc->block_size << SECTOR_SHIFT).  Does
> this sound reasonable to you?

If you have a good reason for the limit go for it.  But please add a
comment explaining why the limit is there, so people running into it
later on won't be completely puzzled.
