From: Milan Broz <gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: trouble with dm-crypt and NFS: server hangs
Date: Thu, 20 Mar 2014 20:16:30 +0100
Message-ID: <532B3E8E.5080406@gmail.com>
References: <CAMFqqRr+hDepUv8LGWbm_RSv=K4ApDbvbsaSAb44Qp1ZaJnNTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
In-Reply-To: <CAMFqqRr+hDepUv8LGWbm_RSv=K4ApDbvbsaSAb44Qp1ZaJnNTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <http://www.saout.de/mailman/options/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.saout.de/pipermail/dm-crypt/>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=help>
List-Subscribe: <http://www.saout.de/mailman/listinfo/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=subscribe>
Errors-To: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
Sender: "dm-crypt" <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
To: Stephen Cousins <steve.cousins-e7X0jjDqjFGHXe+LvDLADg@public.gmane.org>, dm-crypt-4q3lyFh4P1g@public.gmane.org
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On 03/20/2014 03:48 PM, Stephen Cousins wrote:
> I am testing dm-crypt with a system that serves data over NFS. I'm
> finding that when serving the data over NFS4 it will go for a little
> while and then it will just stop copying and networking on the NFS
> server will stall out so that other connections to other parts of the
> storage (a non-dm-crypt volume) will become very laggy. Soon after
> canceling the copy the other connections resume back to normal.
> 
> I have tried this on two different servers, one with a single disk
> with ZFS and another with a ZFS raidz2 pool and they both do the same
> thing. CPU doesn't seem to be an issue. Doing local copies is not a
> problem. That is, copying to/from these volumes made up of dm-crypted
> disks from other disks on the server have no problems.
> 
> One system (the one with the RAID pool) is CentOS 6.4 and the other
> one is CentOS 6.5.
> 
> I'm curious if anyone else has run into this before and if so, what
> can be done to make it work? I'm going to test to see if taking ZFS
> out of the equation helps. I haven't run into this with ZFS with
> disks without dm-crypt.

Hi,

unfortunately the dmcrypt code in Centos 6.x is not what is upstream
kernel (mainly because of per cpu processing changes upstream).
(It would be interesting if it is reproducible with upstream kernel,
but I guess it is not easy to test...)

I am adding cc to dm-devel list, maybe someone there could have some idea
how to help here.

Milan

> 
> Thanks,
> 
> Steve
> 
> 
> 
> -- ________________________________________________________________ 
> Steve Cousins             Supercomputer Engineer/Administrator 
> Advanced Computing Group            University of Maine System 244
> Neville Hall (UMS Data Center)              (207) 561-3574
> <tel:%28207%29%20561-3574> Orono ME 04469
> steve.cousins at maine.edu <http://maine.edu>
_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
