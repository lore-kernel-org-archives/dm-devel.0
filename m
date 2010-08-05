From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH RESEND 1/2 block#for-linus] bio, fs: update READA and SWRITE to match the corresponding BIO_RW_* bits
Date: Thu, 05 Aug 2010 15:30:20 -0400
Message-ID: <x49lj8kc0xf.fsf@segfault.boston.devel.redhat.com>
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>
	<4C28EFD6.2070203@vlnb.net>
	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>
	<4C3EF3AD.5070509@vlnb.net>
	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>
	<4C4D7DF5.9060909@vlnb.net>
	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>
	<4C5073F3.1060406@vlnb.net> <4C52A98A.7060507@kernel.org>
	<20100802104227.79340b49@notabene> <4C56D30A.3000403@kernel.org>
	<x49y6ckc302.fsf@segfault.boston.devel.redhat.com>
	<4C5B0994.1070203@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C5B0994.1070203@vlnb.net> (Vladislav Bolkhovitin's message of
	"Thu, 05 Aug 2010 22:57:24 +0400")
Sender: linux-raid-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <jens.axboe@kernel.dk>, stable@kernel.org, Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Neil Brown <neilb@suse.de>
List-Id: dm-devel.ids

Vladislav Bolkhovitin <vst@vlnb.net> writes:

> Jeff Moyer, on 08/05/2010 10:45 PM wrote:
>> Tejun Heo<tj@kernel.org>  writes:
>>
>>> Commit a82afdf (block: use the same failfast bits for bio and request)
>>> moved BIO_RW_* bits around such that they match up with REQ_* bits.
>>> Unfortunately, fs.h hard coded READ, WRITE, READA and SWRITE as 0, 1,
>>> 2 and 3, and expected them to match with BIO_RW_* bits.  READ/WRITE
>>> didn't change but BIO_RW_AHEAD was moved to bit 4 instead of bit 1,
>>> breaking READA and SWRITE.
>>>
>>> This patch updates READA and SWRITE such that they match the BIO_RW_*
>>> bits again.  A follow up patch will update the definitions to directly
>>> use BIO_RW_* bits so that this kind of breakage won't happen again.
>>>
>>> Stable: The offending commit a82afdf was released with v2.6.32, so
>>> this patch should be applied to all kernels since then but it must
>>> _NOT_ be applied to kernels earlier than that.
>>
>> Would someone be so kind as to remind me how this problem manifests
>> itself?  I know I read this recently, but my memory and googling skills
>> are both failing me.  :(
>
> See http://lkml.org/lkml/2010/7/28/315 and link inside.

Thanks a ton!

-Jeff
