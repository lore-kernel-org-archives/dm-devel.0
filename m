From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: Re: dm targets with spaces in the name
Date: Tue, 16 Dec 2008 09:55:21 +0100
Message-ID: <1229417721.25364.4.camel@o>
References: <4936BBC6.7000800@cfl.rr.com> <1228405956.23557.74.camel@o>
	<49383A77.80903@cfl.rr.com>	<20081205015938.GQ26097@agk.fab.redhat.com>
	<49395DB6.6050802@cfl.rr.com>	<20081205170849.GC26097@agk.fab.redhat.com>
	<493D8430.3010904@cfl.rr.com> <1229350163.31942.6.camel@o>
	<49468354.1040504@cfl.rr.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49468354.1040504@cfl.rr.com>
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

Am Montag, den 15.12.2008, 11:18 -0500 schrieb Phillip Susi:
> Heinz Mauelshagen wrote:
> > We don't support them in dmraid and I find them principally bogus.
> > Why not use '_' instead to avoid parsing hassles ?
> 
> Well I suppose you could convert spaces to underscores and the 
> likelihood of a conflict with a name that originally had an underscore 
> would be rather small.  Do you think that should be done in the format 
> handler, or elsewhere?

I was thinking along the same lines.
It should be done generically in the dmraid_read() code path.

Heinz

> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
