From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [dm-devel] Re: dm-ioband: Test results.
Date: Tue, 21 Apr 2009 21:18:27 +0900 (JST)
Message-ID: <20090421.211827.39163016.ryov@valinux.co.jp>
References: <e98e18940904161324p9833457vdf699d66bb323591@mail.gmail.com>
	<20090420.172959.193682665.ryov@valinux.co.jp>
	<20090420213738.GB9080@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752211AbZDUMSl@vger.kernel.org>
In-Reply-To: <20090420213738.GB9080@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: nauman@google.com, fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com
List-Id: dm-devel.ids

Hi Vivek,

> > I could see the priority inversion by running Vivek's script and I
> > understand how RT requests has to be handled. I'll create a patch
> > which makes dm-ioband cooperates with CFQ scheduler. However, do you
> > think we need some kind of limitation on processes which belong to the
> > RT class to prevent the processes from depleting bandwidth?
>
> I think to begin with, we can keep the same behavior as CFQ. An RT task
> can starve other tasks.
> 
> But we should provide two configurations and user can choose any one.
> If RT task is in root group, it will starve other sibling tasks/groups. If
> it is with-in a cgroup, then it will starve its sibling only with-in that
> cgroup and will not impact other cgroups.
> 
> What I mean is following.
> 
> 			root
> 			/  \
> 		      RT   group1
> 
> In above configuration RT task will starve everybody else.
> 
> 			root
> 		        /   \
> 		   group1   group2
> 		   /  \
> 	         RT   BE
> 
> In above configuration  RT task will starve only sibling in group1 but
> will not starve the tasks in group2 or in root.

Thanks for the suggestion. I'll try this way when dm-ioband supports
hierarchical grouping.

Thanks,
Ryo Tsuruta
