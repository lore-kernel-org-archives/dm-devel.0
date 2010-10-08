From: McPacino <mcpacino@gmail.com>
Subject: Re: introduce dm-snap-mv
Date: Fri, 8 Oct 2010 17:14:27 +0800
Message-ID: <AANLkTim9KFuP1_mrUUsMOEspxkfA=SZW2dmTX4WJbfep@mail.gmail.com>
References: <20101006083150.GA15758@zhongling>
	<201010071431.14937.phillips@phunq.net>
	<20101008082231.GA2054@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101008082231.GA2054@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>
List-Id: dm-devel.ids

Hi Christoph,

I have to take care the cache problem If using the bio directly.
BHs can be released by kernel when necessary.

Is there any existing code using bio to read/write metadata
blocks? How do they handle the timing freeing bios? I really
wish to learn something form it.

Regards.

Cong Meng.



On Fri, Oct 8, 2010 at 4:22 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Oct 07, 2010 at 02:31:14PM -0700, Daniel Phillips wrote:
>> Hi Meng,
>>
>> The patch looks sensible, however the question is: why do you want t=
o
>> do this? =A0Would it not be better to generalize your metadata forma=
t to
>> accomodate the device's native blocksize?
>
> Even if it uses fixed 4k sectors it should just read them in smaller
> chunks OR even better stop using buffer heads and just read them
> manually using submit_bio. =A0BHs really shouldn't be used outside of
> filesystems, and even there they slowly are on their way out.
>
>
