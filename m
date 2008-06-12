From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: "Snapshots and mirrors may not yet be mixed."
Date: Wed, 11 Jun 2008 22:21:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0806112217580.23166@engineering.redhat.com>
References: <m3bq28lrte.fsf@luke.xen.prgmr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3bq28lrte.fsf@luke.xen.prgmr.com>
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
Cc: chris@prgmr.com
List-Id: dm-devel.ids

On Tue, 10 Jun 2008, Luke S Crawford wrote:

> So, I have been using the lvm mirror target on CentOS 5.1
> (2.6.18-53.1.21.el5xen) for some time now;  it works great for most things,
> and gives me much more flexibility than putting my PVs on md devices.
>
> The other day I tried to create a snapshot:
>
> lvcreate -s -L 100M -d hydra_domU/test -n test_snap
>
> it returned:
>
> Snapshots and mirrors may not yet be mixed.
>
> is the mirror target still under active development?  or is it a problem
> with my setup?
>
>
> thanks.

There is a bug that "lvconvert -s" can create snapshot of a mirror ... and 
to my surprise, once it was created this way, it worked.

So maybe we could remove this restriction at all. There was some concern 
that dmeventd may misbehave in this situation. lvm commands seem to handle 
snapshots of a mirror fine.

Mikulas
