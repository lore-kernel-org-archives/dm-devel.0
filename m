From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/7] dm-mpath: Do not clone requests
Date: Thu, 5 Jun 2014 07:44:32 -0700
Message-ID: <20140605144432.GD4590@infradead.org>
References: <1401973867-121561-1-git-send-email-hare@suse.de>
	<20140605133626.GA7149@infradead.org> <539076D1.9000704@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <539076D1.9000704@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 05, 2014 at 03:55:29PM +0200, Hannes Reinecke wrote:
> The primary reason for cloning the bios would from my POV would be
> so that we can handle partial completion properly. When eliminating
> it we would be always return an error here.

I don't see how partial completions matter - we never finish a partial
request in the low level driver and let DM retry.  All partial
completion handling stays in the low level driver.

If we'd didn't clone bios the workflow would look something like this:

 - allocate new clone request in dm-mpath
 - point clone->bio and clone->biotail to the original bio, zero
   them out in the original request
 - the low level driver does one or more calls to blk_update_request
   until clone->bio is NULL, and then calls blk_finish_request (or
   __blk_mq_end_io) once the request has been completed,
 - This hands control back to dm-mpath, which can now call
   __blk_mq_end_io without blk_update_request as the low level driver
   took care of the bio completions.
