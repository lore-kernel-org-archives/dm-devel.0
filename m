From: Tore Anderson <tore@linpro.no>
Subject: Re: CLARiiON failover modes and DM.
Date: Wed, 21 Nov 2007 08:20:50 +0100
Message-ID: <4743DC52.8050809@linpro.no>
References: <940B4FF1F5958E4F96FC83C055A2F2611B8C84@exch-2003.incipient.waltham>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <940B4FF1F5958E4F96FC83C055A2F2611B8C84@exch-2003.incipient.waltham>
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

* Paul Cote

> Thanks for all the info ... Setting the CX FO mode to 1 appears to
> have clear up the mess. One thing I've noticed after doing a dynamic 
> discovery of newly provisioned CX LUNs in that path state is
> generally wrong. It will come up as [active][faulty]and to correct
> that requires a reboot of the server. Don't know if that's a bug or
> not ... But I'm not opposed to a reboot.

That's odd, never had that problem myself.  I rescan like this:

(where hostN is a FC adapter, repeat for all of them but give it some
time between iterations as you'll see paths failing for a short while):

echo 1 > /sys/class/fc_host/hostN/issue_lip
echo - - - > /sys/class/scsi_host/hostN/scan

Usually only these steps are required to discover new volumes properly,
but you can also force a rediscovery of the multipath topology and maybe
also do a restart of multipathd:

multipath -v2
pkill multipathd && multipathd

Regards
-- 
Tore Anderson
