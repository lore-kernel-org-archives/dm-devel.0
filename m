From: Tore Anderson <tore@linpro.no>
Subject: Re: multibus / failover and EMC CX600
Date: Wed, 17 Oct 2007 12:40:36 +0200
Message-ID: <4715E6A4.7060308@linpro.no>
References: <061401c810a7$cac685d0$0a00a8c0@ALDI2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <061401c810a7$cac685d0$0a00a8c0@ALDI2>
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

* Gerald Nowitzky

> What I'd like to have is multibus via HBA-A -> SW-A -> SP-A  and
> HBA-B -> SW-B -> SP-A to the active SP and, in case both paths to the
> active SP fail, a trespas of my LUN to SP-B, multibus to the other
> SP-B and vice versa.

Try the following:

  prio_callout "/sbin/mpath_prio_emc /dev/%n"
  path_grouping_policy group_by_prio

The -EEXIST message is a kernel bug, see the thread starting at
<http://lkml.org/lkml/2007/8/14/106> for more information.  It might be
possible to work around it by disabling async SCSI scanning, if not
there's a patch from Matthew Wilcox that removed most of those -EEXIST
errors (but not all the corner cases).

It kinda sucks that the kernel removes the SCSI devices pointing to
blocked rports.  Wonder if it's possible to disable that somehow...

Regards
-- 
Tore Anderson
