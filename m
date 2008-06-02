From: Yan Li <elliot.li.tech@gmail.com>
Subject: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Date: Mon, 2 Jun 2008 20:31:45 +0800
Message-ID: <20080602123145.GA8258@yantp.cn.ibm.com>
References: <20080602030738.GA7761@yantp.cn.ibm.com> <48439890.6030904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759922AbYFBMcW@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48439890.6030904@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Yan Li <elliot.li.tech@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Ritesh Raj Sarraf <rrs@researchut.com>, Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>, rjmaomao@gmail.com, Alasdair G Kergon <agk@redhat.com>, dm-crypt@saout.de
List-Id: dm-devel.ids

Hi Milan,

On Mon, Jun 02, 2008 at 08:52:00AM +0200, Milan Broz wrote:
> Please could you try if  patch here helps and doesn't cause performance degradation?
> http://www2.kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.25/dm-crypt-add-cond_resched.patch

Will the result of testing a Debian 2.6.24-etchnhalf.1-amd64 kernel
(very near a vanilla kernel) be of same value?  Since the data on some
other drives on this server is important so I dare not try 2.6.25-rc
on it.

Following is my test plan, comments are welcomed:

Test command:
# dd if=/dev/zero of=/dev/mapper/open_device bs=500M count=10
(this server has 2G memory)

The command will be run	for 3 times, and average speed of last two
runs will be taken as result score.

Dm-crypt LUKS Encryption scenarios:
aes-cbc-essiv:sha256, keysize 128
aes-xts-plain, keysize 256
aes-xts-plain, keysize 512

I will compare the speed of all above 3 encryption scenarios, with and
without the patch.

--
Li, Yan
