From: "Thomas S. Iversen" <zensonic@zensonic.dk>
Subject: Re: Help tracking down problem --- endless loop in
	__find_get_block_slow
Date: Thu, 24 Feb 2005 09:54:57 +0100
Message-ID: <421D9661.1080208@zensonic.dk>
References: <4219BC1A.1060007@zensonic.dk>	<20050222011821.2a917859.akpm@osdl.org>	<20050223120013.GA28169@zensonic.dk>	<20050223041036.5f5df2ff.akpm@osdl.org>	<20050223130251.GA31851@zensonic.dk>	<20050223120928.133778a4.akpm@osdl.org>	<421D029E.8010600@zensonic.dk>
	<20050223151756.22c8c48d.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050223151756.22c8c48d.akpm@osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

> I don't know.   Can you describe how your driver implements the remapping?

I have tested with ext2. I get double faults when trying to sync.
What are those? (By the look of the error message, I can see they are 
not something I want to have :-)

I'm at loss how all of this can happend. All I do is to allocate BIOs 
and kernel memory, process the BIOs and deal with deallocation afterwards.

Thomas
