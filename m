From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [PATCH 1/1] improve the performance of
	dm-log-userspace
Date: Thu, 21 Nov 2013 19:26:31 +0900
Message-ID: <528DDFD7.6040005@gmail.com>
References: <d1a7ba26f5e515d635eb3f1d65315c4050bda7ae.1385021669.git.dmzhang@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d1a7ba26f5e515d635eb3f1d65315c4050bda7ae.1385021669.git.dmzhang@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi, Dongmao

I think you are using workqueue the wrong way in two places.

1)
WQ_NON_REENTRANT is deprecated. You should remove it.
> +	if (lc->integrated_flush) {
> +		lc->dmlog_wq = alloc_workqueue("dmlogd", WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);

2)
destory_workqueue first calls drain_workqueue which
then calls flush_workqueue. You should remove the first line of these.
> +		flush_workqueue(lc->dmlog_wq);
> +		destroy_workqueue(lc->dmlog_wq);

Akira
