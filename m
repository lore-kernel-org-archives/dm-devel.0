From: Andrew Morton <akpm@osdl.org>
Subject: Re: Help tracking down problem --- endless loop in
 __find_get_block_slow
Date: Wed, 23 Feb 2005 12:09:28 -0800
Message-ID: <20050223120928.133778a4.akpm@osdl.org>
References: <4219BC1A.1060007@zensonic.dk>
	<20050222011821.2a917859.akpm@osdl.org>
	<20050223120013.GA28169@zensonic.dk>
	<20050223041036.5f5df2ff.akpm@osdl.org>
	<20050223130251.GA31851@zensonic.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050223130251.GA31851@zensonic.dk>
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

zensonic@zensonic.dk (Thomas S. Iversen) wrote:
>
> > OK, so we're looking for the buffer_head for block 101 and the first
> > buffer_head which is attached to the page represents block 100.  So the
> > next buffer_head _should_ represent block 101.  Please print it out:
> 
> Not quite the same, but simelar:
> 
> Feb 23 14:50:24 localhost kernel: __find_get_block_slow() failed. block=102,
> b_blocknr=128, next=129
> Feb 23 14:50:24 localhost kernel: b_state=0x00000013, b_size=2048
> Feb 23 14:50:24 localhost kernel: device blocksize: 2048
> Feb 23 14:50:24 localhost kernel: ------------[ cut here ]------------

Something has caused the page at offset 51 (block 102) to have buffer_heads
for blocks 128 and 129 attached to it.

> > Could be UFS.  But what does "transparent block encryption and sector
> > shuffling" mean?  How is the sector shuffling implemented?
> 
> GDBE is a block level encrypter. It encrypts the actual sectors
> transparently via the GEOM API (corresponds to the devicemapper api in linux).
> 
> GBDE assigns a key for each block, thereby introducing keysectors.
> Furthermore the sectors are remapped so that one can not guess where e.g.
> metadata is located on the physical disk. It is a rather simple remap:

I'd be suspecting that the sector remapping is the cause of the problem. 
How is it implemented?
