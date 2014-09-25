From: Christoph Hellwig <hch@infradead.org>
Subject: Re: dm-mpath: Work with blk multi-queue drivers
Date: Thu, 25 Sep 2014 09:08:23 -0700
Message-ID: <20140925160823.GA3452@infradead.org>
References: <1411491802-7356-1-git-send-email-keith.busch@intel.com>
	<20140924145215.GA26398@infradead.org>
	<alpine.LRH.2.03.1409241020540.4696@AMR>
	<20140924183453.GA23052@redhat.com>
	<20140924184834.GB23052@redhat.com>
	<20140925001341.GA25145@redhat.com>
	<alpine.LRH.2.03.1409250923390.4696@AMR>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.03.1409250923390.4696@AMR>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 25, 2014 at 09:57:41AM -0600, Keith Busch wrote:
> Thank you for all the background information. This definitely gives me
> a lot more to think about.
> 
> For my part, the goal was to change as little as possible to get basic
> blk-mq support working safely without regressing, and performance is
> not even on my radar yet. I purposefully did not try to understand the
> existing design well enough to propose re-arching. If we can address the
> 'request' life cycle management duality issue, would this be acceptable
> as a stopgap for blk-mq support?

I fully agree with going for the stop gap for now.  I tried going the
long way when I gave it a try and got stuck.

If people believe the get_request in the map path is harmful for the old
code we might have to make your change conditional just for blk-mq.  For
blk-mq request allocation never dips into the general purpose memory
pool, so it should be fine for that case.
