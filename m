From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RESEND 1/2 block#for-linus] bio, fs: update READA and
 SWRITE to match the corresponding BIO_RW_* bits
Date: Fri, 06 Aug 2010 08:29:39 +0200
Message-ID: <4C5BABD3.6010303@kernel.org>
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net>	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>	<4C5073F3.1060406@vlnb.net> <4C52A98A.7060507@kernel.org>	<20100802104227.79340b49@notabene> <4C56D30A.3000403@kernel.org> <x49y6ckc302.fsf@segfault.boston.devel.redhat.com> <4C5B89DB.5050106@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C5B89DB.5050106@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tao Ma <tao.ma@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <jens.axboe@kernel.dk>, stable@kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>, Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Neil Brown <neilb@suse.de>
List-Id: dm-devel.ids

Hello,

On 08/06/2010 06:04 AM, Tao Ma wrote:
> If only this patch goes into stable, do we need to change RWA_MASK in this patch also(I have seen you change it the 2/2)?
> 
> -#define RWA_MASK        2
> +#define RWA_MASK        16

Yeah, Neil already pointed it out and updated patch has been posted
and merged.

Thanks.

-- 
tejun
