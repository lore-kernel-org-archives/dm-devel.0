From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] coda: rename REQ_* to CODA_REQ_*
Date: Tue, 3 Aug 2010 19:31:51 +0200
Message-ID: <4C585287.80806@fusionio.com>
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net>	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>	<4C5073F3.1060406@vlnb.net>	<4C52A98A.7060507@kernel.org> <20100802104227.79340b49@notabene> <4C56D397.8010305@kernel.org> <4C5724E8.9010204@kernel.dk> <4C57E722.5060809@kernel.org> <4C57FA57.2000601@kernel.dk> <4C57FBAD.1080809@fusionio.com> <4C583B3B.3060301@kernel.org> <4C583DAD.4080507@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C583DAD.4080507@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, "coda@cs.cmu.edu" <coda@cs.cmu.edu>, "stable@kernel.org" <stable@kernel.org>, Vladislav Bolkhovitin <vst@vlnb.net>, Bryan Mesich <bryan.mesich@ndsu.edu>, "scst-devel@lists.sourceforge.net" <scst-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Neil Brown <neilb@suse.de>
List-Id: dm-devel.ids

On 2010-08-03 18:02, Tejun Heo wrote:
> REQ_* constants are used for block layer requests causing inconsistent
> duplicate definitions of REQ_WRITE.  Rename REQ_* used by coda to
> CODA_REQ_*.

Should have been clear, I committed the fixup already:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=ceb1fde0d5c7611fdb9004176ac34140d27e745a

Looks byte-for-byte identical :-)

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
