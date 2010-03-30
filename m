From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH] multipath: don't let init script
 stop	multipathd for root devices
Date: Tue, 30 Mar 2010 09:11:13 +0900
Message-ID: <4BB141A1.3070402@ct.jp.nec.com>
References: <20100325175205.GG23952@ether.msp.redhat.com>
	<4BAC1626.3080605@ct.jp.nec.com>
	<20100326162340.GI23952@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100326162340.GI23952@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Ben,

On 03/27/2010 01:23 AM +0900, Benjamin Marzinski wrote:
> On Fri, Mar 26, 2010 at 11:04:22AM +0900, Kiyoshi Ueda wrote:
>> Hi Ben,
>>
>> On 03/26/2010 02:52 AM +0900, Benjamin Marzinski wrote:
>>> This patch modifies the redhat init script, so that it doesn't allow
>>> multipathd to be stopped when the root device is on it.
>> Why do you need to prevent stopping daemon by script-level forcibly?
>> I think that users/developers may want to restart the daemon at their
>> own risk when it starts to behave something wrong or they change
>> a configuration (since "reconfigure" may not be stable feature).
>>
>> # Maybe others have different opinion but I often use "restart".
>>
>> If you need this patch anyway, please add other options to stop/restart
>> the daemon forcibly.  (e.g. adding force-stop/force-restart)
> 
> I can certainly add a force-stop/force-restart.  This can currently be
> accomplished by simply killing the daemon, but admittedly doing it
> through the init script is cleaner and more obvious to users, and it's
> necessary to allow package upgrades to immediately start using
> multipathd on systems with multipathed root disks.
> 
> However, what is there that you need to restart the daemon for that
> 
> # service multipathd reload
> 
> won't fix, besides upgrading the package.  If there is something, then
> we should fix it.  I only stop the daemon when I'm testing shutting
> down, and upgrading source. Otherwise, I've been using reconfigure
> without problems.

I may be confusing you.
I know/understand that current reconfigure works well and if it doesn't
work we should fix it.

My point is that "why do you need to prevent stopping daemon
by script-level forcibly?".
As you mentioned above, killing the daemon through the init script
is cleaner and more obvious.  So I think leaving something to stop
the daemon in the init script is more friendly for admins.

Thanks,
Kiyoshi Ueda
