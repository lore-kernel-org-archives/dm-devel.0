From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/2] Use low pointer bits for dm io region
Date: Wed, 11 Nov 2009 15:29:06 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911111527010.32278@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0911102104350.23116@hs20-bc2-1.build.redhat.com>
	<4AFA6717.2060305@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AFA6717.2060305@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Wed, 11 Nov 2009, Kiyoshi Ueda wrote:

> Hi Mikulas,
> 
> On 11/11/2009 11:05 AM +0900, Mikulas Patocka wrote:
> > Use low pointer bits for dm io region
> > 
> > We need to store two things per bio: the pointer to the main io structure and
> > a region number, an index of disk where this bio belongs to (if there is
> > simultaneous write to multiple disks). There can be at most BITS_PER_LONG
> > regions. BITS_PER_LONG is 32 on 32-bit machines and 64 on 64-bit machines.
> > 
> > A region number was stored in the last hidden bio vector and the pointer to
> > struct io was stored in bi_private.
> > 
> > This patch changes it so that "struct io" is always aligned on BITS_PER_LONG
> > bytes and region number is stored in the low BITS_PER_LONG bits of bi_private.
> 
> The code is not easily readable for me.
> Why don't you introduce a new structure in which those two things
> can be stored, and allocate/attach it per bio?
> If it's possible, the code should be easy to read and maintain, I think.

Yes, but this allocation would degrade performance for all users of dm-io. 
The whole purpose of the patch is to not have to allocate any extra 
memory.

I tried to put the bit tricks into two functions, bio_set_io_region and 
bio_get_io_region so that the lest of the code is free from them.

Mikulas
