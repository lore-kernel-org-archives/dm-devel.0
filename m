From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: patches for 2.6.33
Date: Tue, 16 Feb 2010 11:01:31 +0900
Message-ID: <4B79FC7B.7090608@ct.jp.nec.com>
References: <Pine.LNX.4.64.1002101202400.30138@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1002101202400.30138@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Alasdair, Mikulas,

Sorry for the late reply.

On 02/11/2010 02:25 AM +0900, Mikulas Patocka wrote:
> I went through the patches in Alasdair's patchset and tried to sort them 
> for seriousness. These should be sent immediatelly (before 2.6.33):
<snip>
> multipath patches
> - let Kiyoshi Ueda decide, I am not familiar with mpath well enough

http://patchwork.kernel.org/patch/76618/
  - Fixes a serious bug (system stall) of request-based dm.
    No bug report yet, but I can reproduce it on my box.
    It has been existing since 2.6.31-rc1.
  - Should be sent for 2.6.33
  - Should be sent to -stable, too

dm-mpath-wait-for-pg_init-completion-when-suspending.patch # 76027
  - Fixes a possible serious bug (panic).
    But no bug report, I don't have any producer, and
    some cosmetic dependencies on other patches.
  - No need to send for 2.6.33 nor -stable for now.

Some other patches fix some minor bugs which display unnecessary
I/O errors, but such I/O errors have no serious effect.
So no need to send for 2.6.33 nor -stable.

Thanks,
Kiyoshi Ueda
