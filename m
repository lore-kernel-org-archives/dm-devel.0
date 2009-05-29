From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 01/20] io-controller: Documentation
Date: Fri, 29 May 2009 23:42:52 +0800
Message-ID: <20090529154252.GD5587@balbir.in.ibm.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com>
	<1243377729-2176-2-git-send-email-vgoyal@redhat.com>
Reply-To: balbir@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1243377729-2176-2-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, jbaron@redhat.com
List-Id: dm-devel.ids

* Vivek Goyal <vgoyal@redhat.com> [2009-05-26 18:41:50]:

> +	mount -t cgroup -o io,blkio none /cgroup
> +
> +- Create two cgroups
> +	mkdir -p /cgroup/test1/ /cgroup/test2
> +
> +- Set weights of group test1 and test2
> +	echo 1000 > /cgroup/test1/io.ioprio
> +	echo 500 > /cgroup/test2/io.ioprio
> +

I am not sure if anyone has asked this before, but are the numbers
arbitrary like shares or are they time units?

-- 
	Balbir
