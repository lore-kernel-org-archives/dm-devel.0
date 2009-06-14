From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [dm-devel] Updated cluster log patch (take 5)
Date: Sun, 14 Jun 2009 20:24:06 +0400
Message-ID: <20090614162406.GA6013@ioremap.net>
References: <1244845317.19994.3.camel@hydrogen.msp.redhat.com> <20090613110733.GA7895@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090613110733.GA7895@infradead.org>
Sender: netdev-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: device-mapper development <dm-devel@redhat.com>, netdev@vger.kernel.org
List-Id: dm-devel.ids

On Sat, Jun 13, 2009 at 07:07:33AM -0400, Christoph Hellwig (hch@infradead.org) wrote:
> On Fri, Jun 12, 2009 at 05:21:57PM -0500, Jonathan Brassow wrote:
> > The structure used for communication between kernel and userspace are
> > located in include/linux/dm-log-cluster.h.  Due to the frequency,
> > diversity, and 2-way communication nature of the exchanges between
> > kernel and userspace, 'connector' is used as the interface for
> > communication.
> 
> Maye I misremember it, but isn't the connector code strongly deprecated
> in favour of genetlink?

Looks like you misremember this. Connector and genetlink are quite
different projects - the former has very simple to use interface
specially designed for the subsystem which are not deeply network aware,
while genetlink has classical netlink networking interface (attributes,
macroses and so on).

-- 
	Evgeniy Polyakov
