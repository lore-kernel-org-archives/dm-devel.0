From: Alan Kasindorf <akasindorf@mail.communityconnect.com>
Subject: Re: multipath-tools-0.4.4 on 3par unknown path failure
	issue
Date: Wed, 17 Aug 2005 16:25:15 -0400
Message-ID: <43039D2B.4060506@mail.communityconnect.com>
References: <42FA7674.4070201@mail.communityconnect.com>	<20050811195540.GA16665@thumper2>	<42FBB2CC.2040508@mail.communityconnect.com>	<4303923E.1000606@mail.communityconnect.com>
	<20050817200821.GA28881@www.ewilts.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050817200821.GA28881@www.ewilts.org>
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


> The current Red Hat qlogic driver doesn't support most of the adjustable
> parameters.  However, the one you can download from qlogic does.  Red
> Hat will include this driver in its next release (beta in about a week,
> production in mid-September).  In addition, Red Hat will support
> multipathing to at least same level as what SuSe supports today:
> http://portal.suse.com/sdb/en/2005/04/sles_multipathing.html

I haven't used a QLogic driver with those tunables, and the ones shown 
to me via `modinfo qla2xxx` have been sufficient for fixing most of our 
latency related problems. I don't believe any of these tunables will be 
able to fix this problem though. Both paths go down in the same second, 
so there is no way to support the device. On that note however, I assume 
the U2 release will have both the mpath driver and the QLogic driver 
updated?

> Red Hat is just a bit behind, but if you really need this in production,
> I'd suggest you contact your support and/or sales rep to ask them to
> support you with the beta release.  How much luck you'll have, I don't
> know.

All I really care about is getting a workaround, or getting a redhat 
kernel which is at least on par with a stable vanilla release of Linux. 
Having consistently subpar stable releases of redhat software, and 
absolutely no option to bring it up to the quality of a stable Linux 
release is possibly going to result us in switching our contracts at 
this point. I have contacted support, and am still waiting for some kind 
of response. Last time we talked with them about multipath support, they 
said to wait for U1 then it'd be good. Now we get to start over? :)

Thanks,
-Alan
