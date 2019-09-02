From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Kernel error at a LVM snapshot creation
Date: Mon, 2 Sep 2019 10:32:28 +0200
Message-ID: <1cd9447e-9d84-e7f3-3b5f-c3064537e6e3@redhat.com>
References: <20190829081514.29660-1-yuyufen@huawei.com>
	<877e6vf45p.fsf@notabene.neil.brown.name>
	<07ffeca5-6b69-0602-0981-2221cfb682af@huawei.com>
	<8a1c4146-fdc5-138d-af2d-a77b606b59e2@gusev.co>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8a1c4146-fdc5-138d-af2d-a77b606b59e2@gusev.co>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dmitrij Gusev <dmitrij@gusev.co>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dne 02. 09. 19 v 3:04 Dmitrij Gusev napsal(a):
> Hello.
> 
> I get a kernel error every time I create LVM snapshot - at the creation and at 
> boot time, though the snapshot itself is working properly.
> 
> Linux nexus 4.19.69 #2 SMP Thu Aug 29 16:33:35 CDT 2019 x86_64 Intel(R) 
> Xeon(R) E-2174G CPU @ 3.80GHz GenuineIntel GNU/Linux

Hi


This is likely not a kernel error.

In which way are you creating your snapshot ?
Seems like it's made read-only ?

What version of lvm2 are you using ?
(there used to be bug when creating COW as read-only device)

Regard

Zdenek
