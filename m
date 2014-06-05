From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/7] dm-mpath: Do not clone requests
Date: Thu, 5 Jun 2014 07:40:40 -0700
Message-ID: <20140605144040.GC4590@infradead.org>
References: <1401973867-121561-1-git-send-email-hare@suse.de>
	<20140605133626.GA7149@infradead.org>
	<20140605140150.GB21684@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140605140150.GB21684@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 05, 2014 at 10:01:50AM -0400, Mike Snitzer wrote:
> Interested to know how you'll ensure we'll never block on
> blk_get_request() waiting for memory?  (something beyond gfp flags, more
> context below).

For requests it's pretty easy - we just do the non-blocking request
allocation on the low level driver, and that's either get us one or
fail.  The bios are the interesting part, that's why I'd love to
get rid of the cloning.
