From: "Lidong Zhong" <lzhong@suse.com>
Subject: Re: dm-raid1: keep writing after leg failure
Date: Sun, 17 May 2015 21:49:26 -0600
Message-ID: <5559D1C6020000E100024B78@relay2.provo.novell.com>
References: <1431497050-10098-1-git-send-email-lzhong@suse.com>
	<20150515161108.GA28234@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150515161108.GA28234@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Liuhua Wang <LWang@suse.com>, heinzm@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

>>> On 5/16/2015 at 12:11 AM, in message <20150515161108.GA28234@redhat.com>, Mike
Snitzer <snitzer@redhat.com> wrote: 
> On Wed, May 13 2015 at  2:04am -0400, 
> Lidong Zhong <lzhong@suse.com> wrote: 
>  
> > Currently if there is a leg failure, the bio will be put into the hold 
> > list until userspace replace/remove the leg. Here we are trying to make 
> > dm-raid1 ignore the failure and keep the following bios going on. 
> > This is because there maybe a temporary path failure in clvmd 
> > which leads to cluster raid1 remove/replace the fake device failure. And 
> > it takes a long time to do the full sync if we readd the device back. 
> >  
> > This patch merges the former five small patches to implement this 
> > feature. The userspace should pass "keep_log" into kernel to make this  
> feature to 
> > take effect when creating dm-raid1, same as "handle_errors". 
> >  
> > Signed-off-by: Lidong Zhong <lzhong@suse.com> 
> > Tested-by: Liuhua Wang <lwang@suse.com> 
>  
> I've staged a revised patch for 4.2 here: 
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit 
> /?h=for-next&id=164a064dd85801986f3190e6edd119b6fc9a05c5 
>  
> The big things I clarified/cleaned are: 
> 1) keep_log depends on handle_errors feature 
> 2) feature reporting via 'dmsetup table' needed to be decoupled 
>    otherwise any future feature would've forced this same cleanup. 
> 3) Cleaned up header and in-code comments. 
> 4) bumped the target version 
>  
> Please let me know if you see nay issues with this version. 
>  

Hi Mike,

All look good to me. Thanks.

Regards,
Lidong
> Thanks, 
> Mike 
>  
>  
