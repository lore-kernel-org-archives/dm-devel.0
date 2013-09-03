From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-crypt parallelization patches
Date: Tue, 03 Sep 2013 22:49:08 +0200
Message-ID: <52264B44.6050409@gmail.com>
References: <alpine.LRH.2.02.1309031457480.28146@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1309031457480.28146@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Andi Kleen <ak@linux.intel.com>, Milan Broz <gmazyland@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On 09/03/2013 09:06 PM, Mikulas Patocka wrote:
> Hi Andi
> 
> You wrote the original dm-crypt paralllelization patch (commit 
> c029772125594e31eb1a5ad9e0913724ed9891f2). This patch improves 
> parallelization, it makes data being encrypted on the same CPU that 
> submitted the request.

Hi Mikulas,

Do you have some recent reported performance problems with
the current dmcrypt code?

Please post numbers from tests. Also include systems using AES-NI.

You know I tested your patchset cca year ago and result was not clear
improvement... So if this changed, it is good news.

Milan
