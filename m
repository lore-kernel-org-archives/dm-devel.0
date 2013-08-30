From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [dm-devel] [RFC] dm-lc: plan to go to staging
Date: Fri, 30 Aug 2013 23:41:16 +0900
Message-ID: <5220AF0C.4020106@gmail.com>
References: <521EA567.1070801@gmail.com> <20130829020555.GA26206@kroah.com> <20130829033023.GH4872@agk-dp.fab.redhat.com> <alpine.LRH.2.02.1308291043410.20142@file01.intranet.prod.int.rdu2.redhat.com> <52209119.3070907@gmail.com> <20130830125014.GD12181@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130830125014.GD12181@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: gregkh@linuxfoundation.org, mpatocka@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com, kernelnewbies@kernelnewbies.org
List-Id: dm-devel.ids

> (Within the codebase, the filename and module name would still need the
> prefix: we use this for auto-module loading, function name/error message
> scoping etc.)

>> 3) writeboost or wboost
>> Concentrating on the characteristic b)
>> but doesn't mention cache.
> 
> I quite like that option.

OK,
I would like to rename from dm-lc to dm-writeboost.
Do you agree?

Akira

On 8/30/13 9:50 PM, Alasdair G Kergon wrote:
> On Fri, Aug 30, 2013 at 09:33:29PM +0900, Akira Hayakawa wrote:
>> I have three candidates on my mind.
>> I am thinking of removing the dm- prefix as bcache and enhanceio do.
>  
> Yes, that's fine for the general way of referring to this.
> (Within the codebase, the filename and module name would still need the
> prefix: we use this for auto-module loading, function name/error message
> scoping etc.)
> 
>>    a) It writes in-coming writes in log-structured manner.
>>    b) It is extremely fast in write.
>>    c) It is caching software.
> 
> Another candidate: 'lcache' - contrast with 'bcache
>  
>> 3) writeboost or wboost
>> Concentrating on the characteristic b)
>> but doesn't mention cache.
> 
> I quite like that option.
> 
> Alasdair
> 
