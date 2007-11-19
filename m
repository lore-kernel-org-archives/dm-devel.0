From: Tore Anderson <tore@linpro.no>
Subject: Re: CLARiiON failover modes and DM.
Date: Mon, 19 Nov 2007 19:51:28 +0100
Message-ID: <4741DB30.8020009@linpro.no>
References: <940B4FF1F5958E4F96FC83C055A2F2611B8C5F@exch-2003.incipient.waltham>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <940B4FF1F5958E4F96FC83C055A2F2611B8C5F@exch-2003.incipient.waltham>
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

> Is there a specific failover mode that the CX must be set for DM
> interoperability?

You have (at least) two options.  CLARiiON Open mode 1 is the 
traditional way where all paths to the passive controller is present but 
will refuse almost all I/O operations.  You'll need to be using the 
"emc" hardware handler for that to work, since a proprietary command 
needs to be sent to a path to the passive controller in order to 
trespass the volume there.

The other option (which is only available in FLARE 26) is ALUA mode 
(CLARiiON Open mode 4), where I/O is accepted on both controllers even 
though only one is the one handling all the I/O.  You can use this 
without a hardware handler (there's one in developement, though), but 
you'll still want to be prioritising the paths to the preferred 
controller for optimal performance.  This is the mode I would prefer, at 
least.  I wrote a bit more about the ALUA mode a few days ago:

http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/4366/focus=4435

Regards
-- 
Tore Anderson
