From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [Multipath] Round-robin performance limit
Date: Mon, 2 May 2011 10:25:28 +0300
Message-ID: <20110502072528.GW32595@reaktio.net>
References: <BANLkTikyCtPX8L=7h94hTm4TjOYDyb7nxQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <BANLkTikyCtPX8L=7h94hTm4TjOYDyb7nxQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Thu, Apr 28, 2011 at 11:55:55AM -0400, Adam Chasen wrote:
> 
> [root@zed ~]# multipath -ll
> 3600c0ff000111346d473554d01000000 dm-3 DotHill,DH3000
> size=1.1T features='0' hwhandler='0' wp=rw
> `-+- policy='round-robin 0' prio=1 status=active
>   |- 88:0:0:0 sdd 8:48  active ready  running
>   |- 86:0:0:0 sdc 8:32  active ready  running
>   |- 89:0:0:0 sdg 8:96  active ready  running
>   `- 87:0:0:0 sdf 8:80  active ready  running
> 3600c0ff00011148af973554d01000000 dm-2 DotHill,DH3000
> size=1.1T features='0' hwhandler='0' wp=rw
> `-+- policy='round-robin 0' prio=1 status=active
>   |- 89:0:0:1 sdk 8:160 active ready  running
>   |- 88:0:0:1 sdi 8:128 active ready  running
>   |- 86:0:0:1 sdh 8:112 active ready  running
>   `- 87:0:0:1 sdl 8:176 active ready  running
> 
> /etc/multipath.conf
> defaults {
>         path_grouping_policy    multibus
>         rr_min_io 100
> }

Did you try a lower value for rr_min_io ?

-- Pasi

> 
> multipath-tools v0.4.9 (05/33, 2016)
> 2.6.35.11-2-fl.smp.gcc4.4.x86_64
> 
> Thanks,
> Adam
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
