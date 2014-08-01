From: Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: [PATCH] dm cache: fix race affecting dirty block
	count
Date: Sat, 02 Aug 2014 00:02:48 +0300
Message-ID: <53DC0078.50308@iki.fi>
References: <53D32999.6080206@iki.fi>
	<1406831487-18750-1-git-send-email-anssi.hannula@iki.fi>
	<20140801151729.GA27644@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140801151729.GA27644@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com, stable@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

01.08.2014, 18:17, Joe Thornber kirjoitti:
> On Thu, Jul 31, 2014 at 09:31:27PM +0300, Anssi Hannula wrote:
>> I did notice that after a reboot (after having incorrect nr_dirty) the
>> entire cache was considered to be dirty and a full writeback occurred,
>> but I don't know if that was related at all.
> 
> Did you take the cache down cleanly?  Normally this happens when you
> shutdown without destroying the cache device first.

Apparently not. Looking at the logs systemd-cryptsetup failed to
deactivate the dm-crypt volume on top of the LV, as it was still mounted
as it seems systemd (v208) tried to unmount them way too early, while
they were still in use. Or maybe it should have retried later but didn't
for some reason... will have to debug further.

In any case, not a dm-cache issue it seems.

> Patch looks good.
> 
> - Joe
> 


-- 
Anssi Hannula
