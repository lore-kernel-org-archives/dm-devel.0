From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 8/9] dm crypt: offload writes to thread
Date: Tue, 1 Apr 2014 14:15:54 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1404011411100.12362@file01.intranet.prod.int.rdu2.redhat.com>
References: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
	<1396037476-26595-9-git-send-email-snitzer@redhat.com>
	<533AE8DC.5080004@redhat.com> <20140401163247.GF13050@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140401163247.GF13050@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On Tue, 1 Apr 2014, Mike Snitzer wrote:

> On Tue, Apr 01 2014 at 12:27pm -0400,
> Ondrej Kozina <okozina@redhat.com> wrote:
> 
> > On 03/28/2014 09:11 PM, Mike Snitzer wrote:
> > >From: Mikulas Patocka <mpatocka@redhat.com>
> > >
> > >Submitting write bios directly in the encryption thread caused serious
> > >performance degradation.  On a multiprocessor machine, encryption requests
> > >finish in a different order than they were submitted.  Consequently, write
> > >requests would be submitted in a different order and it could cause severe
> > >performance degradation.
> > > (...)
> > 
> > Hi,
> > 
> > originally I planed to post result of performance testing but
> > unfortunately I crashed the test machine several times with
> > <in_subject> patch applied and onward:
> > 
> > The test set up looks following:
> > 
> > the base is kernel-3.14-rc8 with applied "[PATCH 2/9] block: use
> > kmalloc alignment for bio slab"
> > 
> > On top of base I compiled various dm-crypt modules:
> > 
> > <no_patch>		= raw 3.14-rc8 dm-crypt module
> > <no_percpu>		= "[PATCH 1/9]"
> > <per_bio_data>		= <no_percpu> + "[PATCH 3/9]"
> > <unbound>		= <per_bio_data> + "[PATCH 4/9]"
> > <dont_allocate_wfix>	= <unbound> + "[PATCH 5/9]" + "[PATCH 6/9]"
> > <remove_io_pool>	= <dont_allocate_wfix> + "[PATCH 7/9]"
> > <offload>		= <remove_io_pool> + "[PATCH 8/9]"
> > <sort>			= <offload> + "[PATCH 9/9]"
> 
> Wonder if it worthwhile to rebase to final v3.14... could this
> bio_add_page/mm crash be a function of something since fixed late in the
> rc cycle?

... or try it without XFS. XFS corrupts memory on I/O error 
(https://bugzilla.redhat.com/show_bug.cgi?id=924301), so it may be that.

Can the bug be reproduced if you modify the test to use ext2, ext3 or ext4 
instead of xfs?

Mikulas
