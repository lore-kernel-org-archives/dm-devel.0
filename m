From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Re: Help needed with RDAC in production environment!!
Date: Thu, 15 Nov 2007 08:51:08 +0100
Message-ID: <1195113068.5944.2.camel@sanderbal>
References: <1195072704.5881.16.camel@sanderbal> <473BF64E.1030008@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <473BF64E.1030008@linpro.no>
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

Thanks for the explanation. I had some troubles before, so I was afraid
that there was a problem with multipath/RDAC. Fortunately it turned out
to be something else...

And indeed, when sending some I/O only one of the paths became active :)

Sander


On Thu, 2007-11-15 at 08:33 +0100, Tore Anderson wrote:
> * S. J. van Harmelen
> 
> > See the xen and vmware disks. They both display enable / enable instead
> > of active / enable. Is this correct? Or is a disaster waiting to happen?
> 
> If I understand correctly, "enabled" means something like "ready to use,
> but not in active use".  The preferred PG will become active ("in active
> use") once you send some I/O there.  Try "dd if=/dev/mapper/wmware
> of=/dev/null count=10" or something like that, see if they go active then.
> 
> The semantics had me confused for a while too.  :-)
> 
> Regards
