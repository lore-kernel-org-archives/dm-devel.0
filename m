From: Milan Broz <gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Hang problem with dm-crypt
Date: Tue, 27 Sep 2016 08:44:49 +0200
Message-ID: <2e3e43a9-706c-cb88-de2d-7577324f30c8@gmail.com>
References: <858B57D94E9DE244922C3CF355D7FFD64EB5FFA0@SHSMSX104.ccr.corp.intel.com>
 <d8ffe9ed-d6e7-53af-ce87-9512e94b8cfe@gmail.com>
 <858B57D94E9DE244922C3CF355D7FFD64EB600BA@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
In-Reply-To: <858B57D94E9DE244922C3CF355D7FFD64EB600BA-0J0gbvR4kTg/UvCtAeCM4rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <http://www.saout.de/mailman/options/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.saout.de/pipermail/dm-crypt/>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=help>
List-Subscribe: <http://www.saout.de/mailman/listinfo/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=subscribe>
Errors-To: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
Sender: "dm-crypt" <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
To: "Yu, Wenqian" <wenqian.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dm-crypt-4q3lyFh4P1g@public.gmane.org" <dm-crypt-4q3lyFh4P1g@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On 09/26/2016 03:08 PM, Yu, Wenqian wrote:
> Hi, Milan,
> 
> Thanks for the detail information. I noticed the comments and the underlying design logic.
> 
> In dm-crypt existing design, there is an assumption that the acceleration driver can queue the requests which are not sent to hardware.  
> 
> I think there are at least two scenarios we should consider to make it more robust.
> 1.  The queue is full even if the driver has the ability to queue a number of the requests.
> 2.  The acceleration hardware/driver doesn't have the ability to queue the requests.
> 
> Should we add other error code to handle this?

I would prefer to ask on crypto API mailing list how the interface is expected to behave
(if the queue/REQ_MAY_BACKLOG is mandatory etc) before complicating any logic in dmcrypt.

Also please send any possible patches to dm-devel mailing list (I added cc there now).

Thanks,
Milan

>  
> Thanks,
> - Wenqian
> 
> -----Original Message-----
> From: Milan Broz [mailto:gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] 
> Sent: Monday, September 26, 2016 6:28 PM
> To: Yu, Wenqian; dm-crypt-4q3lyFh4P1g@public.gmane.org
> Subject: Re: [dm-crypt] Hang problem with dm-crypt
> 
> On 09/26/2016 08:50 AM, Yu, Wenqian wrote:
>> I tried to use dm-crypt for disk encryption with accelerators and 
>> found that it will hang when accelerator returned EBUSY, which means 
>> the driver request queue is full.
> 
> That is normal state, when request is processed asynchronously later.
> 
> Please read explicit comments in code we added to understand this logic.
> added in this commit:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/md/dm-crypt.c?id=54cea3f6681ad9360814e2926d1f723bbd0f74ed
>  
>> Per the logic in crypt_convert(), the request will be skipped if the 
>> request is not sent to crypto driver when the driver request queue is 
>> full.  Is this expected behavior?
> 
> It is not skipped, it is queued (or it waits if queue is full and then processes as asynchronous branch (EINPROGRESS))
> 
>> In crypt_convert_block(), the sector is advanced (bio_advance_iter()) 
>> no matter whether crypto_skcipher_encrypt()/crypto_skcipher_decrypt()
>> send the request to accelerator driver or not.   When the driver
>> request queue is full, EBUSY will be returned from 
>> crypto_skcipher_encrypt()/crypto_skcipher_decrypt().  And in 
>> crypt_convert(), the existing implementation is waiting for a 
>> completion from a request, which is not queued in the driver when 
>> EBUSY is encountered from crypt_convert_block ().  In this case, the 
>> sector should not be advanced or should be rolled back as the request 
>> is not sent to accelerator driver.
> 
> I think it should be queued (IOW the one that returns BUSY should be queued).
> If it is not done, I would say it is bug in acceleration driver.
> Note this flag:
> /*
>  * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
>  * requests if driver request queue is full.
>  */
> 
> Anyway, this is more question for crypto API mailing list...
> I think that dmcrypt processing is correct here.
> 
> Milan
> _______________________________________________
> dm-crypt mailing list
> dm-crypt-4q3lyFh4P1g@public.gmane.org
> http://www.saout.de/mailman/listinfo/dm-crypt
> 
_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
