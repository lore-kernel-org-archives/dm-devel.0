From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH] dm: Check for device sector overflow if
 CONFIG_LBDAF is not set
Date: Mon, 5 Nov 2018 19:59:25 +0100
Message-ID: <178d2361-8d31-ae07-a1ca-59889193e3ce@gmail.com>
References: <20181104134234.13597-1-gmazyland@gmail.com>
	<alpine.LRH.2.02.1811051333580.28808@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1811051333580.28808@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On 05/11/2018 19:35, Mikulas Patocka wrote:
> But the condition "sizeof(cc->start) < sizeof(tmpll)" could be dropped, 
> the compiler will optimize out "cc->start != tmpll" if the types have the 
> same width.

Yes, the intention here is that in 64bit env. the whole if condition
is not compiled in. If it happens without "sizeof(cc->start) < sizeof(tmpll)",
then we can drop it.

So, does it make sense to add this to all dm targets? Or any better idea?

Milan
