From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Fri, 3 Aug 2018 21:18:35 +0200
Message-ID: <bc71118d-3003-6260-6ab3-ddcc4277aeed@redhat.com>
References: <226835ba-2197-b850-6e5b-8ba14f7fd016@torlan.ru>
	<CAOi1vP_tYG77e71CdDiOcszSSEWrp9Vfi+KB7yFAXVQChkjP5A@mail.gmail.com>
	<93bff248-6897-4867-841b-2dace11597de@torlan.ru>
	<CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
	<CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
	<CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
	<d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru>
	<1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
	<CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
	<b2bbd8ec-ac5b-fa8a-d3f7-8615d87f73c3@redhat.com>
	<CA+55aFwWZX=CXmWDTkDGb36kf12XmTehmQjbiMPCqCRG2hi9kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+55aFwWZX=CXmWDTkDGb36kf12XmTehmQjbiMPCqCRG2hi9kw@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>, wgh@torlan.ru
List-Id: dm-devel.ids

Dne 3.8.2018 v 18:37 Linus Torvalds napsal(a):
> [ Dammit. I haven't had to shout and curse at people for a while, but
> this is ABSOLUTELY THE MOST IMPORTANT THING IN THE UNIVERSE WHEN IT
> COMES TO SOFTWARE DEVELOPMENT ]
> 
> On Fri, Aug 3, 2018 at 6:31 AM Zdenek Kabelac <zkabelac@redhat.com> wrote:
>>
>> IMHO (as the author of fixing lvm2 patch) user should not be upgrading kernels
>> and keep running older lvm2 user-land tool (and there are very good reasons
>> for this).
> 
> Yeah, HELL NO!
> 
> Guess what? You're wrong. YOU ARE MISSING THE #1 KERNEL RULE.
> 
> We do not regress, and we do not regress exactly because your are 100% wrong.
> 

Hi Linus

Sorry to hear you so crazy about this :) -  but my comment was mainly targeted 
to 'distribution maintainers'  trying to push the latest kernel and preserving 
old tools  (not providing upgraded packages).   If it's worth to upgrade 
kernel - it should be worth to upgrade surrounding packages, especially if 
they are very tightly bind to work with kernel.

I just think you are overreacting here and you could trust me I personally do 
A LOT to keep everything as much usable & compatible in lvm2 as we can across 
all kernels, all distributions and many architectures.

Lvm2 is always tracking individual bugs in kernel and reports them to user or 
tries to bypass...

>> Kernel had a bug which has been fixed
> 
> That is *ENTIRELY* immaterial.
> 
> Guys, whether something was buggy or not DOES NOT MATTER.
> 
> Why?
> 
> Bugs happen. That's a fact of life. Arguing that "we had to break
> something because we were fixing a bug" is completely insane. We fix
> tens of bugs every single day, thinking that "fixing a bug" means that
> we can break something is simply NOT TRUE.

 From my userland POV - leaving kernel write to devices that are supposed to 
be read-only  'just because' it's kernel is wrong - the fact it has NOT been 
discover for so long means - there are not many users and not many testers of 
this combination.

But if kernel people do want to make a big stress case about this - I'm the 
last one to object - I'm just unsure what kind of bugs are supposed to be 
preserved and how it's going to be recognized which bugs are usable and which 
are fixable....

On a funny note - security exploits had also many users - so why fixing them....


> So no. Your rule is COMPLETELY wrong. If you cannot upgrade a kernel
> without upgrading some other random binary, then we have a problem.

It's was not meant as a rule, just recommendation - and I think we can end up 
this fight over nothing here - there is probably very low number of users of 
this combination....


Regards


Zdenek
