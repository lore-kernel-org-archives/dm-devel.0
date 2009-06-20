From: Thomas Graf <tgraf@infradead.org>
Subject: Re: [dm-devel] Updated cluster log patch (take 5)
Date: Sat, 20 Jun 2009 08:01:29 -0400
Message-ID: <20090620120128.GB22786@bombadil.infradead.org>
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

On Sat, Jun 13, 2009 at 07:07:33AM -0400, Christoph Hellwig wrote:
> On Fri, Jun 12, 2009 at 05:21:57PM -0500, Jonathan Brassow wrote:
> > The structure used for communication between kernel and userspace are
> > located in include/linux/dm-log-cluster.h.  Due to the frequency,
> > diversity, and 2-way communication nature of the exchanges between
> > kernel and userspace, 'connector' is used as the interface for
> > communication.
> 
> Maye I misremember it, but isn't the connector code strongly deprecated
> in favour of genetlink?

Use of connector is deprecated, it does not have any advantages over
genetlink while genetlink provides an optional attributes based
protocol interface which allows for messaging protocols to be developed
which can be extended without breaking binary compatibility. It also
features a userspace library which makes development trivial.


I guess nobody will force you but use of genetlink is encouraged.
