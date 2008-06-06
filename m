From: Milan Broz <mbroz@redhat.com>
Subject: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Date: Fri, 06 Jun 2008 08:46:20 +0200
Message-ID: <4848DD3C.9000001@redhat.com>
References: <20080602030738.GA7761@yantp.cn.ibm.com>
	<48439890.6030904@redhat.com>
	<20080602123145.GA8258@yantp.cn.ibm.com>
	<4843ECB8.4010002@redhat.com>
	<20080605224410.GA7584@yantp.cn.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080605224410.GA7584@yantp.cn.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Ritesh Raj Sarraf <rrs@researchut.com>, Christophe Saout <christophe@saout.de>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, dm-devel@redhat.com, rjmaomao@gmail.com, Herbert Xu <herbert@gondor.apana.org.au>, Andrew Morton <akpm@linux-foundation.org>, Yan Li <elliot.li.tech@gmail.com>
List-Id: dm-devel.ids

Yan Li wrote:
> On Mon, Jun 02, 2008 at 02:51:04PM +0200, Milan Broz wrote:
>> Patch for 2.6.24 kernel
>> Add cond_resched() to prevent stuck in big bio processing.
> 
> This patch actual has lead to performance _gain_.
hmmm, nice:)

> With patched kernel, soft lockup _no longer_ occurred.

Alasdair, please could you move this patch back to actual tree
and sent it upstream?

We have at least two separate reports confirming that it fixes
the problem.

Milan
--
mbroz@redhat.com
