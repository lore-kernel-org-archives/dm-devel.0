From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: Re: dm targets with spaces in the name
Date: Mon, 15 Dec 2008 15:09:23 +0100
Message-ID: <1229350163.31942.6.camel@o>
References: <4936BBC6.7000800@cfl.rr.com> <1228405956.23557.74.camel@o>
	<49383A77.80903@cfl.rr.com>	<20081205015938.GQ26097@agk.fab.redhat.com>
	<49395DB6.6050802@cfl.rr.com>
	<20081205170849.GC26097@agk.fab.redhat.com>
	<493D8430.3010904@cfl.rr.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <493D8430.3010904@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Am Montag, den 08.12.2008, 15:31 -0500 schrieb Phillip Susi:
> Alasdair G Kergon wrote:
> > which is a bug as per what I stated above, if true.
> > 
> > dmsetup knows nothing about the format of the table line - it's a simple
> > string - and should not be interfering with it: a backslash+space (after any
> > shell escaping) should get handled consistently, passed through to the target
> > and should work.
> 
> Nevermind, I must have made a typeo before because now the kernel 
> accepts targets with spaces in the name just fine, as long as they are 
> properly backslash escaped.
> 
> Heinz, you mentioned that dmraid should just not be using names with 
> spaces in them.  My first thought was to fix dmraid to backslash escape 
> the spaces, but you seem to have another idea in mind?

We don't support them in dmraid and I find them principally bogus.
Why not use '_' instead to avoid parsing hassles ?

Heinz

> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
