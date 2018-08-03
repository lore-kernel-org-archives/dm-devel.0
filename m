From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Fri, 3 Aug 2018 15:31:18 +0200
Message-ID: <b2bbd8ec-ac5b-fa8a-d3f7-8615d87f73c3@redhat.com>
References: <226835ba-2197-b850-6e5b-8ba14f7fd016@torlan.ru>
 <CAOi1vP_tYG77e71CdDiOcszSSEWrp9Vfi+KB7yFAXVQChkjP5A@mail.gmail.com>
 <93bff248-6897-4867-841b-2dace11597de@torlan.ru>
 <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
 <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
 <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
 <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru>
 <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
 <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, wgh@torlan.ru
Cc: Ilya Dryomov <idryomov@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 2.8.2018 v 23:52 Linus Torvalds napsal(a):
> On Thu, Aug 2, 2018 at 2:39 PM WGH <wgh@torlan.ru> wrote:
>>
>> I've just found one public report of this bug, though:
>> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=900442
> 
> Yeah, it does sound like we should fix this issue.
> 


Hi

IMHO (as the author of fixing lvm2 patch) user should not be upgrading kernels 
and keep running older lvm2 user-land tool (and there are very good reasons 
for this).

Kernel had a bug which has been fixed, lvm2 misused this kernel bug and was 
also fixed.  Keeping kernel bug present allowing certain device to write to 
read-only devices can be possibly seen as some security risk.

Also the number of users who ever create a read-only snapshot is probably very 
low.

Maybe there could be  some  'dm-snapshot'  loading modinfo option to allowing 
to create in case user really wants to have this bug being present in kernel 
(reinstantiate old buggy logic), but on default the user should get error when 
it tries to write to read-only volume and should upgrade lvm2.

Regards

Zdenek
