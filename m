From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH] libmultipath: multipath active paths count
 optimization
Date: Thu, 5 Sep 2019 07:36:52 +0000
Message-ID: <e33a9aefa073e1d9c107dce12c32608afc50090e.camel@suse.com>
References: <413f046d0cfc4d5dbd39ebed92068c8b@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <413f046d0cfc4d5dbd39ebed92068c8b@h3c.com>
Content-Language: en-US
Content-ID: <99742E329A7D324DA053E4F0448D2E2F@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "wu.chongyun@h3c.com" <wu.chongyun@h3c.com>
Cc: "liu.cong@h3c.com" <liu.cong@h3c.com>, "zhang.chengA@h3c.com" <zhang.chengA@h3c.com>, "guozhonghua@h3c.com" <guozhonghua@h3c.com>, "zhang.duan@h3c.com" <zhang.duan@h3c.com>, "li.liangA@h3c.com" <li.liangA@h3c.com>, "changlimin@h3c.com" <changlimin@h3c.com>, "ren.qinwei@h3c.com" <ren.qinwei@h3c.com>, "wang.xibo@h3c.com" <wang.xibo@h3c.com>, "li.kai4@h3c.com" <li.kai4@h3c.com>, "zhang.guanghui@h3c.com" <zhang.guanghui@h3c.com>, "wang.yongD@h3c.com" <wang.yongD@h3c.com>, "huang.yongA@h3c.com" <huang.yongA@h3c.com>
List-Id: dm-devel.ids

Hi Chongyun,

On Thu, 2019-09-05 at 02:58 +0000, Chongyun Wu wrote:
> Hi Martin, Ben and other viewers
> 
> Cloud you help to view below patch which try to deal with a multipath
> active paths
> count not right issue, thanks a lot.
> 
> From deee7196ece43b01b8ee635e60ce465080905b5e Mon Sep 17 00:00:00
> 2001
> From: Chongyun Wu <wu.chongyun@h3c.com>
> Date: Tue, 27 Aug 2019 13:58:33 +0800
> Subject: [PATCH] libmultipath:  multipath active paths count
> optimization
> 
> Really count multipath active paths not use mpp->nr_active++
> or mpp->nr_active--, because there are other places might call
> pathinfo to change path state not only in check_path, if other
> places detect and changed path state but not do mpp->nr_active++
> or mpp->nr_active--, the active paths might not right any more.
> 
> We meet an issue which actually have three paths but after all
> paths down syslog report have three paths remaining so multipathd
> not send disable queueing to dm and this dm device been blocked.
> This patch might fix this issue.
> 
> Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
> ---
>  libmultipath/structs_vec.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)


Thanks a lot for your patch. We've discussed this previously, and in
general, there's little reason not to do it - pathcount() is fast, and
could be made even faster. But if we do, we should ditch the nr_active
field altogether - no need to carry it around if we re-calculate it
anyway when we need it.

However, it worries me a bit that nr_active may go wrong. Both Ben and
I have reviewed the code and we thought the nr_active tracking was
correct. Something seems to happen in our code that we don't
understand.

 - can you please confirm that you are using the latest code,
containing e224d57 "libmutipath: continue to use old state on
PATH_PENDING", 9b715bf "multipathd: Fix miscounting active paths" and
(in case you're using the marginal_paths options) also 7d4b40f and
058df77 ?

 - If you have a reliable reproducer, would you mind adding log
messages to the code you just submitted, so that we can observe how
nr_active evolves in time, and perhaps understand why it's going wrong?

Regards
Martin
