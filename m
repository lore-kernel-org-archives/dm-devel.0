From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: dm-bufio
Date: Wed, 28 Sep 2011 11:51:07 +0200
Message-ID: <1317203467.16422.21.camel@o>
References: <Pine.LNX.4.64.1109271316500.1333@hs20-bc2-1.build.redhat.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1109271316500.1333@hs20-bc2-1.build.redhat.com>
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
Cc: Edward Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

On Tue, 2011-09-27 at 13:20 -0400, Mikulas Patocka wrote:
> Hi
> 
> I placed updated dm-bufio here: 
> http://people.redhat.com/mpatocka/patches/kernel/dm-thinp-bufio/
> 
> It uses kmem_cache with proper alignment instead of kmalloc (which may 
> return unaligned memory), so it should fix problems that Heinz observed on 
> Sparc.

Thanks Mikulas,

I'll test once Joe has merged it.

Heinz

> 
> Mikulas
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
