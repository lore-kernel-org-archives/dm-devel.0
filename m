From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Re: Ext3 sequential read performance drop 2.6.29 ->
	2.6.30,2.6.31,...
Date: Tue, 3 Nov 2009 05:06:45 -0500
Message-ID: <20091103100645.GA13118@infradead.org>
References: <20091013120955.6bd5844b@smartjog.com>
	<20091102135554.b10ece3e.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091102135554.b10ece3e.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, Laurent CORBES <laurent.corbes@smartjog.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Nov 02, 2009 at 01:55:54PM -0800, Andrew Morton wrote:
> On Tue, 13 Oct 2009 12:09:55 +0200
> Laurent CORBES <laurent.corbes@smartjog.com> wrote:
> 
> > Hi all,
> > 
> > While benchmarking some systems I discover a big sequential read performance
> > drop using ext3 on ~ big files. The drop seems to be introduced in 2.6.30. I'm
> > testing with 2.6.28.6 -> 2.6.29.6 -> 2.6.30.4 -> 2.6.31.3.
> 
> Seems that large performance regressions aren't of interest to this
> list :(

No sure which list you mean, but dm-devel is for dm, not md.  We're also
seeing similarly massive performance drops with md and ext3/xfs as
already reported on the list.  Someone tracked it down to writeback
changes as usual, but there it got stuck.
