From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: hch's native NVMe multipathing [was: Re: [PATCH 1/2]
 Don't blacklist nvme]
Date: Wed, 15 Feb 2017 21:00:07 -0800
Message-ID: <d1f39bbd-d5fe-06d7-34a7-484b723886c9@sandisk.com>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
	<20170215145617.GA4241@infradead.org>
	<20170216025357.GA9241@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170216025357.GA9241@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

On 02/15/17 18:53, Mike Snitzer wrote:
> Nobody has interest in Linux multipathing becoming fragmented.
>
> If every transport implemented their own multipathing the end-user would
> be amazingly screwed trying to keep track of all the
> quirks/configuration/management of each.
>
> Not saying multipath-tools is great, nor that DM multipath is god's
> gift.  But substantiating _why_ you need this "native NVMe
> multipathing" would go a really long way to justifying your effort.
>
> For starters, how about you show just how much better than DM multipath
> this native NVMe multipathing performs?  NOTE: it'd imply you put effort
> to making DM multipath work with NVMe.. if you've sat on that code too
> that'd be amazingly unfortunate/frustrating.

Another question is what your attitude is towards dm-mpath changes? Last 
time I posted a series of patches that significantly clean up and
improve readability of the dm-mpath code you refused to take these upstream.

Bart.
