From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 0 of 10] LVM: Mirrored log support
Date: Fri, 09 Oct 2009 18:07:17 +0200
Message-ID: <1255104437.20671.1.camel@o>
References: <1255036474.12319.16.camel@hydrogen.msp.redhat.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1255036474.12319.16.camel@hydrogen.msp.redhat.com>
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

Hi Jon,

shouldn't these rather go to lvm-devel ?

Heinz

On Thu, 2009-10-08 at 16:14 -0500, Jonathan Brassow wrote:
> I spent the last few days looking over the mirror allocation code.  I
> wanted to understand why 'log_count' was being treated generically in
> most places... as if the idea of mirrored logs were already thought of.
> I mostly discovered that it was possible to push what looked like
> incomplete code towards completion.  The following patches represent
> where I would like the mirrored log support to start from.
> 
> These patches are a replacement to the proposed patches - a fresh start.
> They address a couple problems that I saw with the old patches: 1)
> Allocation policies are respected and behave the same as today for other
> log types.
> 2) The on-disk layout of the previous version - when given only two
> disks to allocate from - would put the log on the front of one device
> and the back of another.  This virtually ensures a performance hit.
> These patches put the logs in the same place WRT the images.
> 3) The new patches reduce parameter bloat.  I think the previous patches
> required the extra parameters because they were using functions deep in
> the code that were from higher levels... adding parameters and
> "spaghettifying" the code.
> 
> These patches should be considered a starting point.  While 'lvcreate'
> works, 'lvconvert' does not handle all transitions.  In fact,
> 'lvconvert' will only handle 'core' -> 'disk/redundant' and
> 'disk/redundant' -> 'core'.  It will not handle 'disk' <-> 'redundant'.
> 
>  brassow
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
