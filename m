From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Re: dm targets with spaces in the name
Date: Mon, 15 Dec 2008 11:18:28 -0500
Message-ID: <49468354.1040504@cfl.rr.com>
References: <4936BBC6.7000800@cfl.rr.com>
	<1228405956.23557.74.camel@o>	<49383A77.80903@cfl.rr.com>	<20081205015938.GQ26097@agk.fab.redhat.com>	<49395DB6.6050802@cfl.rr.com>	<20081205170849.GC26097@agk.fab.redhat.com>	<493D8430.3010904@cfl.rr.com>
	<1229350163.31942.6.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1229350163.31942.6.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Heinz Mauelshagen wrote:
> We don't support them in dmraid and I find them principally bogus.
> Why not use '_' instead to avoid parsing hassles ?

Well I suppose you could convert spaces to underscores and the 
likelihood of a conflict with a name that originally had an underscore 
would be rather small.  Do you think that should be done in the format 
handler, or elsewhere?
