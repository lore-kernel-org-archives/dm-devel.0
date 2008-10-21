From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.8.0:
 Introduction
Date: Tue, 21 Oct 2008 11:00:48 +0900
Message-ID: <20081021110048.949704bd.kamezawa.hiroyu@jp.fujitsu.com>
References: <2891419e0810200140s3cf9c0a3q228620519ae5f4af@mail.gmail.com>
	<20081020.180129.193689104.ryov@valinux.co.jp>
	<2891419e0810200313j5cac8541qff80614e3d784b1b@mail.gmail.com>
	<20081020.214858.193685328.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754598AbYJUCB0@vger.kernel.org>
In-Reply-To: <20081020.214858.193685328.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: baramsori72@gmail.com, xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, corsetproject@googlegroups.com, fernando@oss.ntt.co.jp, agk@redhat.com
List-Id: dm-devel.ids

On Mon, 20 Oct 2008 21:48:58 +0900 (JST)
Ryo Tsuruta <ryov@valinux.co.jp> wrote:

> Hi Dong-Jae,
> 
> > Well, do you have any plan to upgrade bio-cgroup patches for stable
> > latest kernel?
> > but, I think it will be not easy job ^^
> 
> I think the memory cgroup will have a major change sometime soon.
> So the new patch will be released after that.
> 

the newest mmotm has the newest *big* change. enjoy it ;)
I think no major change around page_cgroup will not occur for a while
but I myself have plan/patches to modify memcg itself's charge/uncharge
callpath.

Thanks,
-Kame
