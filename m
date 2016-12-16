From: Christoph Hellwig <hch@infradead.org>
Subject: Re: trouble with generic/081
Date: Fri, 16 Dec 2016 00:15:23 -0800
Message-ID: <20161216081523.GA13847@infradead.org>
References: <20161214164314.GA25105@infradead.org>
 <20161215063650.GJ4326@dastard>
 <20161215084224.GA14395@infradead.org>
 <c05b64b6-80d3-655d-db9b-6f49038e53ee@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c05b64b6-80d3-655d-db9b-6f49038e53ee@redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, eguan@redhat.com, fstests@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Dec 15, 2016 at 10:16:23AM +0100, Zdenek Kabelac wrote:
> So let me explain the logic behind this 'amazingly stupid' idea.

And that logic doesn't make any sense at all.  invibly unmounting
a file system behind the users back is actively harmful, as it is
contradicting the principle of least surprise, and the xfstests mess
is one simple example for it.  Add a callback in-kernel to tell the
fs to shut down but NOT unmount and expose the namespace below it,
which the administrator has probably intentionally hid.

Even worse unmount may trigger further writes and with fses not
handling them the fs might now be stuck after being detached from
the namespace without a way for the admin to detect or recover this.

What XFS did on IRIX was to let the volume manager call into the fs
and shut it down.  At this point no further writes are possible,
but we do not expose the namespace under the mount point, and the
admin can fix the situation with all the normal tools.
