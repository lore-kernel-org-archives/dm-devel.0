From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-cache: Add handle to contlr if
	cache_create failed.
Date: Fri, 8 Mar 2013 02:10:27 +0000
Message-ID: <20130308021027.GV8913@agk.fab.redhat.com>
References: <5139441C.7000309@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5139441C.7000309@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: majianpeng <majianpeng@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 08, 2013 at 09:51:24AM +0800, majianpeng wrote:
> It  ignored to judge the result of cache_create.
> If cache_create failed, but the copy_ctr_args successed.

Thanks for reporting this, but I already added this patch to linux-next today:
  https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=f1ccbd181202c660b237b9bef0af277b980d5073

and will push the batch of 7 patches upstream either Friday or early
next week.  (I'm waiting to hear about two more patches first: a fix for
a theoretical problem that's been discovered and a possible adjustment
to the hints metadata.)

Alasdair
