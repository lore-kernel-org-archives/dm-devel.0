From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCHES] convert dm-thin to use dm-bufio
Date: Thu, 18 Aug 2011 18:31:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108181830050.7668@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1108141602440.28009@hs20-bc2-1.build.redhat.com>
	<20110815090416.GE3159@ubuntu>
	<Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
	<20110816091600.GA4284@ubuntu>
	<Pine.LNX.4.64.1108161755510.15859@hs20-bc2-1.build.redhat.com>
	<20110817082656.GA3267@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110817082656.GA3267@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

> This all sounds good; get the locking interface in and I'll switch to
> bufio straight away.
> 
> - Joe

I uploaded bufio-based block manager at 
http://people.redhat.com/mpatocka/patches/kernel/dm-thinp-bufio/. It 
supports locks, but it defines new functions down_write_non_owner and 
up_write_non_owner.

Mikulas
