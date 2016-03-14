From: Thanos Makatos <thanos.makatos@onapp.com>
Subject: dm-cache: blocks don't get cached on
	3.18.21-17.el6.x86_64
Date: Mon, 14 Mar 2016 09:54:06 +0000
Message-ID: <CAM2wQBvqXoKz7kyHqsqg6VbXz_8M-QbhiS-RNYDk8eu+1dAKtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

(I've already reported this issue to centos and centos-devel. and
waited long enough but didn't get any reply.)

I'm evaluating dm-cache on CentOS 6 kernels  3.18.21-17.el6.x86_64 (Xen 4) and
2.6.32-573.7.1.el6.x86_64 (KVM). The test I do is a simple sequential
read using dd(1). read_promote_adjustment and sequential_threshold
have been set to 1 and 0, respectively. For the 2.6.32 kernel, all
seems to be working fine, "#usedcacheblocks" correctly reflects the
number of cached blocks based on what I'm reading with dd(1),
performance is pretty much native SSD performance. However, the same
test on the 3.18.21-17.el6.x86_64 kernel results in "#usedcacheblocks"
being stuck to "2" and no performance improvement is observed.

Any ideas what could be wrong? How can I further debug this?

-- 
Thanos Makatos
