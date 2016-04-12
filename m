From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] MAINTAINERS: correct entry for LVM
Date: Tue, 12 Apr 2016 11:01:26 +0530
Message-ID: <570C882E.1060109@gmail.com>
References: <1460388039-20282-1-git-send-email-sudipm.mukherjee@gmail.com> <20160411155147.GB9288@agk-dp.fab.redhat.com> <570BCD85.6090807@gmail.com> <20160411162306.GC9288@agk-dp.fab.redhat.com> <570BD354.2000100@gmail.com> <570BF1DB.1040700@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <570BF1DB.1040700@youngman.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Joe Perches <joe@perches.com>
List-Id: dm-devel.ids

On Tuesday 12 April 2016 12:20 AM, Wols Lists wrote:
> On 11/04/16 17:39, Sudip Mukherjee wrote:
>> On Monday 11 April 2016 09:53 PM, Alasdair G Kergon wrote:
>>> On Mon, Apr 11, 2016 at 09:45:01PM +0530, Sudip Mukherjee wrote:
>>>> L stands for "Mailing list that is relevant to this area", and this is a
>>>> mailing list. :)
>>>
>>> Your proposed patch isn't changing the L entry, so this is of no
>>> relevance.
>>
>> Sorry, I am not understanding.
>>
>> The current entry in MAINTAINERS is:
>> DEVICE-MAPPER  (LVM)
>> M:      Alasdair Kergon <agk@redhat.com>
>> M:      Mike Snitzer <snitzer@redhat.com>
>> M:      dm-devel@redhat.com
>> L:      dm-devel@redhat.com
>> ...
>>
>> So my patch just removed the line : "M:      dm-devel@redhat.com"
>>
>> So now the entry becomes :
>> DEVICE-MAPPER  (LVM)
>> M:      Alasdair Kergon <agk@redhat.com>
>> M:      Mike Snitzer <snitzer@redhat.com>
>> L:      dm-devel@redhat.com
>> ...
>>
>> So, now it correctly shows dm-devel@redhat.com as a mailing list which
>> should have cc to all the patches related to LVM.
>>
>> Or am I understanding this wrong?
>
> Yes. Because (I guess M stands for maintainer) this list has maintainer
> status. As all patches should be sent to the maintainers therefore all
> patches should be sent to this list.
>
> The same person can appear twice in a phone book, once under their name
> and once under their job title. This is exactly the same situation -
> this list should appear once as a list to tell people that it's a list,
> AND ALSO as a maintainer to tell people that patches must be sent to the
> list.
>
> I guess English is not your first language, but the important point is
> that M and L are not mutually exclusive.

Don't worry, English is my first language. Have you tried with 
getmaintainer.pl and seen the result? It only shows dm-devel@redhat.com 
as a Maintainer and not as a list. (I noticed because I was sending a 
patch, and hence this patch again). But I believe a mailing list can not 
be a Maintainer ( have you seen any patch with a Signed-off-by: from a 
mailing list? ).
Anyway, I think this thread has become too long for an unimportant patch.

regards
sudip
