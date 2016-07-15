From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: write directly to device mapper snapshot origin
	device ?
Date: Fri, 15 Jul 2016 09:50:25 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1607150949290.5034@file01.intranet.prod.int.rdu2.redhat.com>
References: <CAA=4086wdhAxNsWjAYgZG3bWORV2vF3YpMQk9OTjAg22MJi07Q@mail.gmail.com>
	<CAA=4086b_9xz32cU+DnuUMGU=rZhWZ=+UVfjwq0AKnX3C7k3qA@mail.gmail.com>
	<alpine.LRH.2.02.1607150738100.5034@file01.intranet.prod.int.rdu2.redhat.com>
	<CAA=4086fe1a02vm8VWHyCpUD15pO_2vBsiVhcik1kx8Xt+5EYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAA=4086fe1a02vm8VWHyCpUD15pO_2vBsiVhcik1kx8Xt+5EYA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Navin P.S" <navinp1912@gmail.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

> Are origin devices readonly ?
> 
> When i do dd if=/dev/zero of=/dev/mapper/ff count=10, it kills all the
> process says OOM.
> 
> How do you go about debugging this ? I'm running 4.7.0-rc7+ .

Find some older kernel where this worked.

Use the git bisect tool on the kernel tree to find out which patch broke 
it.

Mikulas

> root@vm-xenial-foo:~# dmsetup info
> Name:              cryptie4-ff
> State:             ACTIVE
> Read Ahead:        256
> Tables present:    LIVE
> Open count:        0
> Event number:      0
> Major, minor:      251, 0
> Number of targets: 2
> 
> Name:              ff
> State:             ACTIVE
> Read Ahead:        256
> Tables present:    LIVE
> Open count:        0
> Event number:      0
> Major, minor:      251, 1
> Number of targets: 1
> 
> root@vm-xenial-foo:~# dmsetup status
> cryptie4-ff: 0 102400 linear
> cryptie4-ff: 102400 122880 linear
> ff: 0 102400 snapshot-origin
> root@vm-xenial-foo:~#
> 
> 
> 
> 
> free -m
>               total        used        free      shared  buff/cache   available
> Mem:           7762        2178        3720         358        1864        4920
> Swap:         19145           0       19145
> 
> 
> -- 
> -- Navin
> 
