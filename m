From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: RE: dm-devel Digest, Vol 11, Issue 18
Date: Sat, 29 Jan 2005 01:22:11 +0100
Message-ID: <20050129002211.GA9195@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321A72B@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A72B@SRMANNING.eng.emc.com>
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

> 
> Noticed already.  I am advocating that detecting path-to-LU inconsistency
> be adopted generically by the multipath configuration software using one
> of the two methods described in previous email and not be implemented
> piecemeal or just for CLARiion, Symmetrix, or EMC storage.
> 
> This could mean that the storage system getuid callouts become functions
> like the checker callouts and that by default, a storage system's getuid
> callout be used also as that storage system's path checker.
> 
Some assumptions are not that clear to me, so let me confront them to
your knowledge :

1) A Logical Unit can change its H/B/T/L mapping.
1.1) H/B/T through LUN masking reconfiguration
1.2) L through a logical unit reconfiguration
2) These topology changes can happen between two checks of the affected path
3) No path failure is seen by the device mapper during the topology
reconfiguration
4) Not failing or isolating the changed path from its previous multipath
map will lead to unrecoverable data corruption at the first submitted
write IO routed through this path
5) HBA drivers see the LU remapping events

If all these assertions are legitimate, it might not be enough to check
uid changes at pathcheck interval.

It would seem safer to let the HBA driver error the first IO submitted to a 
changed LU *and* send an event (maybe through a transport class kobj) for
userspace to reconfigure the maps.

Please comment abundantly.

regards,
cvaroqui

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
