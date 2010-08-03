From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RESEND 1/2 block#for-linus] bio, fs: update READA and
 SWRITE to match the corresponding BIO_RW_* bits
Date: Tue, 03 Aug 2010 11:27:42 +0200
Message-ID: <4C57E10E.7000401@kernel.org>
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net>	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>	<4C5073F3.1060406@vlnb.net>	<4C52A98A.7060507@kernel.org>	<20100802104227.79340b49@notabene>	<4C56D30A.3000403@kernel.org> <20100803075210.22c7bd30@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100803075210.22c7bd30@notabene>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, stable@kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>, Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 08/02/2010 11:52 PM, Neil Brown wrote:
> Close, but not quite there - RWA_MASK must be 16 too !!

Indeed.  Updated.

Thanks.

-- 
tejun
