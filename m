From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-bufio
Date: Wed, 28 Sep 2011 10:41:19 +0100
Message-ID: <20110928094119.GA3899@ubuntu>
References: <Pine.LNX.4.64.1109271316500.1333@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Sep 27, 2011 at 01:20:49PM -0400, Mikulas Patocka wrote:
> Hi
> 
> I placed updated dm-bufio here: 
> http://people.redhat.com/mpatocka/patches/kernel/dm-thinp-bufio/
> 
> It uses kmem_cache with proper alignment instead of kmalloc (which may 
> return unaligned memory), so it should fix problems that Heinz observed on 
> Sparc.

Thanks Mikulas,  I'll merge straight away.

- Joe
