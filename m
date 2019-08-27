From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH] multipathd: "san_path_err" failure
 optimization
Date: Tue, 27 Aug 2019 19:57:38 +0000
Message-ID: <933edbd8794512cd35a48c596b36634b1bcd820c.camel@suse.com>
References: <CEB9978CF3252343BE3C67AC9F0086A378D9A799@H3CMLB12-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CEB9978CF3252343BE3C67AC9F0086A378D9A799@H3CMLB12-EX.srv.huawei-3com.com>
Content-Language: en-US
Content-ID: <3E594772962A514FA6C5D74DCDE7BC88@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "wu.chongyun@h3c.com" <wu.chongyun@h3c.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "guozhonghua@h3c.com" <guozhonghua@h3c.com>, "changlimin@h3c.com" <changlimin@h3c.com>, "wang.yongD@h3c.com" <wang.yongD@h3c.com>, "zhang.guanghui@h3c.com" <zhang.guanghui@h3c.com>
List-Id: dm-devel.ids

On Tue, 2019-08-27 at 12:28 +0000, Chongyun Wu wrote:
> Hi Martin and Ben,
> 
> Cloud you help to view below patch, thanks.
> 
> From a7126e33e7eff8a985600b41b1723ee66b183586 Mon Sep 17 00:00:00
> 2001
> From: Chongyun Wu <wu.chongyun@h3c.com>
> Date: Tue, 27 Aug 2019 10:23:50 +0800
> Subject: [PATCH] multipathd: "san_path_err" failure optimization
> 
> Let san_path_err_recovery_time path unstable can be
> detected and not reinstate it until this path keep up in
> san_path_err_recovery_time. It will fix heavy IO delay
> caused by parts of paths state shaky in multipath device.
> 
> Test and result:
> Run up eth1 30s and down eth1 30s with 100 loops script to
> make some paths shaky in each multipath devices.
> Using below multipath.conf configure in defaults section:
>     san_path_err_recovery_time 30
>     san_path_err_threshold 2
>     san_path_err_forget_rate 6
> After test, not found any IO delay logs except several logs in the
> very
> beginning which before san_path_err filter shaky path works .
> If without above config and this patch there will be lots of IO delay
> in syslog and some paths state change from up to down again and
> again.
> 
> Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
> ---
>  multipathd/main.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 

Hello Chongyun,

Your patch makes sense to me. Ben has worked much more than myself on
marginal paths recently, so I'd want to see his opinion, too.

Regards,
Martin
