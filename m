From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: path priority group and path state
Date: Sat, 12 Feb 2005 11:23:50 +0100
Message-ID: <420DD936.8090105@free.fr>
References: <C2EEB4E538D3DC48BF57F391F422779321A783@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A783@SRMANNING.eng.emc.com>
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

goggin, edward wrote:

>The multipath utility is relying on having at least one block
>read/write I/O be serviced through a multipath mapped
>device in order to show one of the path priority groups in
>an active state.  While I can see the semantic correctness
>in this claim since the priority group is not yet initialized,
>is this what is intended? 
>
In fact, the multipath tool shares the same checker with the daemon.

It is intended the tool doesn't rely on the path status the daemon could 
provide, because, the check interval being what it is, we can't assume 
the daemon path status are an accurate representation of the current 
reality. The tool being in charge to load new maps, I fear it could load 
erroneous ones if relying on outdated info.

Maybe I'm paranoid, but I'm still convinced it's a safe bet to do so.

> Why show both the single priority
>group of an active-active storage system using a multibus
>path grouping policy and the non-active priority group of an
>active-passive storage system using a priority path grouping
>policy both as "enabled" when the actual readiness of each
>differs quite significantly?
>  
>
We don't have so many choices there. The device mapper declares 3 PG 
states : active, enabled, disabled.
How would you map these states upon the 2 scenarii you mention ?

>Also, multipath will not set a path to a failed state until the
>first block read/write I/O to that path fails.  This approach
>can be misleading while monitoring path health via
>"multipath -l".  Why not have multipath(8) fail paths known to
>fail path testing?  Waiting instead for block I/O requests to
>fail lessens the responsiveness of the product to path failures.
>Also, the failed paths of enabled, but non-active path priority
>groups will not have their path state updated for possibly a
>very long time -- and this seems very misleading.
>
>  
>
Maybe I'm overseeing something, but to my knowledge "multipath -l" gets 
the paths status from devinfo.c, which in turn switches to pp->checkfn() 
... ie the same checker the daemon uses.

>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
>  
>


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
