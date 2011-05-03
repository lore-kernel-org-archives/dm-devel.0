From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: [Multipath] Round-robin performance limit
Date: Mon, 2 May 2011 22:04:06 -0700
Message-ID: <20110503050406.GA11442@us.ibm.com>
References: <BANLkTikyCtPX8L=7h94hTm4TjOYDyb7nxQ@mail.gmail.com>
	<20110502072528.GW32595@reaktio.net>
	<BANLkTi=h0AwEy0S4Miv-SYTEu3jF0DXXJQ@mail.gmail.com>
	<1304375238.3134.23.camel@denise.theartistscloset.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1304375238.3134.23.camel@denise.theartistscloset.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

John A. Sullivan III [jsullivan@opensourcedevel.com] wrote:
> I'm also very curious about your findings on rr_min_io.  I cannot find
> my benchmarks but we tested various settings heavily.  I do not recall
> if we saw more even scaling with 10 or 100.  I remember being surprised
> that performance with it set to 1 was poor.  I would have thought that,
> in a bonded environment, changing paths per iSCSI command would give
> optimal performance.  Can anyone explain why it does not?

rr_min_io of 1 will give poor performance if your multipath kernel
module doesn't support request based multipath. In those BIO based
multipath, multipath receives 4KB requests. Such requests can't be
coalesced if they are sent on different paths.

Thanks, Malahal.
