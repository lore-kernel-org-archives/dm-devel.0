From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: IO scheduler based IO Controller V2
Date: Mon, 11 May 2009 10:59:31 +0800
Message-ID: <4A079493.4030100@cn.fujitsu.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <4A014619.1040000@cn.fujitsu.com> <20090506161012.GC8180@redhat.com> <4A027348.6000808@cn.fujitsu.com> <20090508133740.GD7293@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754866AbZEKDAh@vger.kernel.org>
In-Reply-To: <20090508133740.GD7293@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, nauman@google.com, dpshah@google.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
>>
> 
> Thanks Li and Gui for pointing out the problem. With you script, I could
> also produce lock validator warning as well as system freeze. I could
> identify at least two trouble spots. With following patch things seems
> to be fine on my system. Can you please give it a try.

  Hi Vivek,

  I'v tried this patch, and seems the problem is addressed. Thanks.

-- 
Regards
Gui Jianfeng
