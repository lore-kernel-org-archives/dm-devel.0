From: Andrew Morton <akpm@osdl.org>
Subject: Re: Help tracking down problem --- endless loop in
 __find_get_block_slow
Date: Wed, 23 Feb 2005 15:17:56 -0800
Message-ID: <20050223151756.22c8c48d.akpm@osdl.org>
References: <4219BC1A.1060007@zensonic.dk>
	<20050222011821.2a917859.akpm@osdl.org>
	<20050223120013.GA28169@zensonic.dk>
	<20050223041036.5f5df2ff.akpm@osdl.org>
	<20050223130251.GA31851@zensonic.dk>
	<20050223120928.133778a4.akpm@osdl.org>
	<421D029E.8010600@zensonic.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <421D029E.8010600@zensonic.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Thomas S. Iversen" <zensonic@zensonic.dk>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

"Thomas S. Iversen" <zensonic@zensonic.dk> wrote:
>
> > I'd be suspecting that the sector remapping is the cause of the problem. 
> > How is it implemented?
> 
> Quite simple actually. You're most welcome to see the code, but I have 
> just done a test like the one below. Never mind the performance figures, 
>   correctness comes as a very first priority. It does not block, cause 
> endless loops or anything funny if I take the filsystem out of the 
> question and access the raw devicemapped block device.
> 
> This should assert that it is not a fault in my code, right?

I don't know.   Can you describe how your driver implements the remapping?
