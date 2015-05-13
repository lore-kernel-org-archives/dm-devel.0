From: "Lidong Zhong" <lzhong@suse.com>
Subject: Re: [PATCH 0/3] [RESEND]dm-raid1: several fixes about
 writing on out of sync mirror device
Date: Wed, 13 May 2015 00:01:34 -0600
Message-ID: <5553593E020000E100024356@relay2.provo.novell.com>
References: <1429155804-5022-1-git-send-email-lzhong@suse.com>
	<20150511185512.GA3393@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150511185512.GA3393@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

>> On 5/12/2015 at 02:55 AM, in message <20150511185512.GA3393@redhat.com>, Mike
Snitzer <snitzer@redhat.com> wrote: 
> On Wed, Apr 15 2015 at 11:43pm -0400, 
> Lidong Zhong <lzhong@suse.com> wrote: 
>  
> > Hi List/Heinz, 
> >  
> > These three patches are done based on last patch series that replied on  
> April 8. 
>  
> Unless the current upstream code can crash (and there is an isolated fix 
> for that crash that should cc stable): I'd prefer to see all related 
> patches folded into a single patch and the patch header updated to 
> clearly document what is being fixed with these changes.  Also is there 
> a userspace dependency that is required for this kernel patch to work? 
> If so please say as much. 
>  
> So my current understanding is you should be able to fold all 5 of these 
> patches together and resubmit a single patch: 
>  
> https://patchwork.kernel.org/patch/6179141/ 
> https://patchwork.kernel.org/patch/6179151/ 
> https://patchwork.kernel.org/patch/6223631/ 
> https://patchwork.kernel.org/patch/6223651/ 
> https://patchwork.kernel.org/patch/6223641/ 
>  
> I'd be OK taking numerous patches but we aren't talking a lot of code 
> here... not seeing a need to make things more complex than needed. 
>  

Understood.
I will send the patch later. Thanks.

Regards,
Lidong
> Mike 
>  
> -- 
> dm-devel mailing list 
> dm-devel@redhat.com 
> https://www.redhat.com/mailman/listinfo/dm-devel 
>  
>  
