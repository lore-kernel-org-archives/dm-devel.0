From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH RFC 00/10] dm-dedup: device-mapper
	deduplication target
Date: Thu, 17 Jul 2014 22:43:36 -0400
Message-ID: <20140718024336.GA1291@redhat.com>
References: <535ed0d2.0729e00a.4489.0c48@mx.google.com>
	<20140505182450.GA16456@redhat.com>
	<20140506134357.GA27331@vass-desktop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140506134357.GA27331@vass-desktop>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vasily Tarasov <tarasov@vasily.name>
Cc: ejt@redhat.com, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Tue, May 06 2014 at  9:43am -0400,
Vasily Tarasov <tarasov@vasily.name> wrote:

> Interestingly, I can see 4, 5, and 7 in dm-devel's archive:
> 
> https://www.redhat.com/archives/dm-devel/2014-April/author.html
> 
> In any case, you can pull the patches from:
> 
> git://git.fsl.cs.sunysb.edu/linux-dmdedup.git
> 
> Branch: rfc-v1.1
> 
> Thanks for looking into this.

Hi,

I haven't been able to get to _really_ reviewing dm-dedup.  It isn't
anything against you guys.. I've just been quite busy with other tasks.

I did start in on dm-dedup a month or so ago by staging a baseline of
your work in a branch here:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=dm-dedup

I found a few things that didn't look right, but they are more
DM-specific mechanics and not anything to do with your approach for
accomplishing dedup, see the FIXMEs I added to the documentation file in
this commit:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=dm-dedup&id=fed855928fba624c7a494db7519c37dcc7c9492d

The reconstruct= param isn't needed.  In both dm-thinp and dm-cache we
use __superblock_all_zeroes to checks if the metadata device's
superblock is all zeros.  Ideally dm-dedup would do something
comparable.

I'm going to be on paternity leave until Sept. 8.  It'd be great if Joe
and/or Mikulas took some time to review dm-dedup but I'm not sure if
they'll be able to.  I do hope to be around to respond to emails
periodically but my availability is TBD at this point.

When I get back from leave I'll definitely make dm-dedup a priority if
others don't beat me to it.
