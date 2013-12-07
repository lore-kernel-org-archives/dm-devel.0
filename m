From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: dm-cache refusing to come up again after a crash
Date: Sat, 7 Dec 2013 01:16:20 +0100
Message-ID: <20131207001620.GG9700@samfundet.no>
References: <20131206154914.GE25206@samfundet.no>
	<20131206175712.GD23496@debian>
	<20131206191605.GA9700@samfundet.no>
	<20131206193541.GC9700@samfundet.no>
	<20131206195310.GD9700@samfundet.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131206195310.GD9700@samfundet.no>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Dec 06, 2013 at 08:53:10PM +0100, Steinar H. Gunderson wrote:
> <superblock uuid="" block_size="512" nr_cache_blocks="865560" policy="cleaner" hint_width="4">
>   <mappings>
>     <mapping cache_block="0" origin_block="6118373" dirty="false"/>
>     <mapping cache_block="1" origin_block="6118275" dirty="false"/>
>     <mapping cache_block="2" origin_block="5934780" dirty="false"/>
> [... lots of blocks, none of them dirty ...]
>     <mapping cache_block="505877" origin_block="889613" dirty="false"/>
>     <mapping cache_block="505878" origin_block="690575" dirty="false"/>
>     <mapping cache_block="505879" origin_block="875752" dirty="false"/>
>   </mappings>

OK, so since all blocks were marked as non-dirty, I wiped the metadata
volume, which made the system boot just fine, but was seemingly a big
mistake; a lot of filesystems had more or less fatal errors.

I'm restoring from backup right now. (Yes, I have them.)

/* Steinar */
-- 
Homepage: http://www.sesse.net/
