From: Andrew Morton <akpm@osdl.org>
Subject: Re: Help tracking down problem --- endless loop in
 __find_get_block_slow
Date: Tue, 22 Feb 2005 01:18:21 -0800
Message-ID: <20050222011821.2a917859.akpm@osdl.org>
References: <4219BC1A.1060007@zensonic.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <4219BC1A.1060007@zensonic.dk>
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
> But if I do
> 
>  dd if=/dev/zero of=/mnt/testfile count=N, N>6
> 
>  I get into an endless loop in __find_get_block_slow. 

The only way in which __find_get_block_slow() can loop is if something
wrecked the buffer_head ring at page->private: something caused an internal
loop via bh->b_this_page.

Are you sure that's where things are hanging?  That it's not stuck on a
spinlock?

A sysrq-P trace might help.
