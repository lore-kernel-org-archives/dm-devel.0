From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: about the new snapshots
Date: Tue, 24 Mar 2009 10:46:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0903240954310.29968@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0903240354020.3850@hs20-bc2-1.build.redhat.com>
	<20090324122133.GA10158@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090324122133.GA10158@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 24 Mar 2009, Christoph Hellwig wrote:

> On Tue, Mar 24, 2009 at 04:40:11AM -0400, Mikulas Patocka wrote:
> > Things, you should know if you want to port this implementation into your 
> > code:
> 
> What is Jonathan's code?  I thought your patch series was supposed to get
> in after some more work?

Jonathan's code joins Fujita+Daniel's zumastore snasphots with the old 
snapshots.

See this:
http://patchwork.kernel.org/bundle/jbrassow/Exception%20Store%20API%20group1/

This group of patches can be found at:
http://patchwork.kernel.org/bundle/jbrassow/Exception%20Store%20API%20group2/

(yesterday when I checked them, the patches had many rejects, but it's 
good enough to read the source code and see its architecture)


My code is independent, written from scratch, it joins my snapshot store 
with Fujita+Daniel's store.

Alasdair wants to put Jon's patches to the kernel, but I don't know if 
they'll be able to port my implementation on the top of it. So maybe we 
end up with my code+Jon's code as separate projects, only with the same 
interface to userspace. I don't know how it will end.

Mikulas
