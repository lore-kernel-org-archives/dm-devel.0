From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] Don't blacklist nvme
Date: Wed, 15 Feb 2017 06:56:17 -0800
Message-ID: <20170215145617.GA4241@infradead.org>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 14, 2017 at 04:19:13PM -0500, Keith Busch wrote:
> These devices are mulitpath capable, and have been able to stack with
> dm-mpath since kernel 4.2.

Can we make this conditional on something?  I have native NVMe
multipathing almost ready for the next merge window which is a lot easier
to use and faster than dm.  So I don't want us to be locked into this
mode just before that.
