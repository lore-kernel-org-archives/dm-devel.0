From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/2] Don't blacklist nvme
Date: Mon, 20 Feb 2017 12:17:02 -0600
Message-ID: <20170220181702.GB22981@octiron.msp.redhat.com>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
	<20170215145617.GA4241@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170215145617.GA4241@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Feb 15, 2017 at 06:56:17AM -0800, Christoph Hellwig wrote:
> On Tue, Feb 14, 2017 at 04:19:13PM -0500, Keith Busch wrote:
> > These devices are mulitpath capable, and have been able to stack with
> > dm-mpath since kernel 4.2.
> 
> Can we make this conditional on something?  I have native NVMe
> multipathing almost ready for the next merge window which is a lot easier
> to use and faster than dm.  So I don't want us to be locked into this
> mode just before that.

It seems to me that it already is conditional. Keith just made
multipath-tools default to using NVMe devices. If you don't want it to,
you can add them back to the blacklist.

blacklist {
	devnode "^nvme[0-9]"
}

Just like you could turn it on before by overriding the blacklist
(except that it wouldn't work without the device handler fix and the
rest of Keith's code to setup NVMe devices correctly, which I trust is
unobjectionable).

-Ben

> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
