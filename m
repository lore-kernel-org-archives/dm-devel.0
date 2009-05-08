From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 17/18] io-controller: IO group refcounting support
Date: Fri, 8 May 2009 08:44:05 -0400
Message-ID: <20090508124405.GB7293@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-18-git-send-email-vgoyal@redhat.com> <4A03A013.9000405@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762959AbZEHMuf@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A03A013.9000405@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

On Fri, May 08, 2009 at 10:59:31AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> >  
> > -		BUG_ON(!RB_EMPTY_ROOT(&st->active));
> > -		BUG_ON(!RB_EMPTY_ROOT(&st->idle));
> >  	}
> >  
> > -	BUG_ON(iog->sched_data.next_active != NULL);
> > -	BUG_ON(iog->sched_data.active_entity != NULL);
> > -	BUG_ON(entity->tree != NULL);
> > +	/* Drop iocg reference on io group */
> 
>   We'd better to reset iog->iocg_id here since the cgroup is going to destroy.
> 

Hm.., that does not harm. Will do in next version.

Thanks
Vivek
