From: McPacino <mcpacino@gmail.com>
Subject: Re: introduce dm-snap-mv
Date: Fri, 8 Oct 2010 17:28:09 +0800
Message-ID: <AANLkTikK1wiKiCN2N+YdUHtT5XiZx999yePrOO01pHTn@mail.gmail.com>
References: <20101006083150.GA15758@zhongling>
	<201010071431.14937.phillips@phunq.net>
	<20101008082231.GA2054@lst.de>
	<AANLkTim9KFuP1_mrUUsMOEspxkfA=SZW2dmTX4WJbfep@mail.gmail.com>
	<20101008092427.GA5426@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101008092427.GA5426@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>
List-Id: dm-devel.ids

Thank you very very much...


On Fri, Oct 8, 2010 at 5:24 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Oct 08, 2010 at 05:14:27PM +0800, McPacino wrote:
>> Hi Christoph,
>>
>> I have to take care the cache problem If using the bio directly.
>> BHs can be released by kernel when necessary.
>>
>> Is there any existing code using bio to read/write metadata
>> blocks? How do they handle the timing freeing bios? I really
>> wish to learn something form it.
>
> If you actually need caching just use the pagecache, e.g.
> read_mapping_page to read in your data. =A0That completely abstracts
> away the underlying block size.
>
>
