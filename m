From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-mirror: do not degrade the mirror on
 discard error
Date: Tue, 17 Feb 2015 14:59:37 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502171455140.13128@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1502121007010.24282@file01.intranet.prod.int.rdu2.redhat.com>
	<1423967994.19864.9.camel@HansenPartnership.com>
	<alpine.LRH.2.02.1502160742030.14038@file01.intranet.prod.int.rdu2.redhat.com>
	<1424096844.2089.2.camel@HansenPartnership.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1424096844.2089.2.camel@HansenPartnership.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Mon, 16 Feb 2015, James Bottomley wrote:

> I already said this in the first sentence of the last paragraph of my
> email.  The point isn't what it does today it's what might happen
> tomorrow and the principle of least surprise.  One day, someone might
> propagate the error.  When that happens, they'll be surprised to find
> every discard failure reported as -ENOTSUPP and it will cost someone
> time and effort to investigate and fix.  If you just propagate the error
> today, you save all that work in the future.
> 
> James

The question is if this case is so important that it justifies dm-io 
change.

The SSD may ignore discards and report them as sucesfully completed, so no 
one should depend on the return code anyway. The error code may be used as 
a hint that it is futile to send more discards in the future, but relying 
on the return code is already not correct.

Mikulas
