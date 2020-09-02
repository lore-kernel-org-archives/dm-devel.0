From: Coly Li <colyli@suse.de>
Subject: Re: flood of "dm-X: error: dax access failed" due to 5.9
 commit 231609785cbfb
Date: Thu, 3 Sep 2020 00:53:03 +0800
Message-ID: <04dc00a0-086b-fff7-9d01-bd663d3a676a@suse.de>
References: <20200902160432.GA5513@redhat.com>
	<df0203fa-7f75-53ac-8bf1-79a1c861918e@suse.de>
	<20200902164456.GA5928@redhat.com>
	<4968af50-663d-74cf-1be2-aaed48a380d5@suse.de>
	<20200902165101.GB5928@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200902165101.GB5928@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-US
To: Mike Snitzer <snitzer@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, dm-devel@redhat.com, Jan Kara <jack@suse.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: dm-devel.ids

On 2020/9/3 00:51, Mike Snitzer wrote:
> On Wed, Sep 02 2020 at 12:46pm -0400,
> Coly Li <colyli@suse.de> wrote:
> 
>> On 2020/9/3 00:44, Mike Snitzer wrote:
>>> On Wed, Sep 02 2020 at 12:40pm -0400,
>>> Coly Li <colyli@suse.de> wrote:
>>>
>>>> On 2020/9/3 00:04, Mike Snitzer wrote:
>>>>> 5.9 commit 231609785cbfb ("dax: print error message by pr_info() in
>>>>> __generic_fsdax_supported()") switched from pr_debug() to pr_info().
>>>>>
>>>>> The justification in the commit header is really inadequate.  If there
>>>>> is a problem that you need to drill in on, repeat the testing after
>>>>> enabling the dynamic debugging.
>>>>>
>>>>> Otherwise, now all DM devices that aren't layered on DAX capable devices
>>>>> spew really confusing noise to users when they simply activate their
>>>>> non-DAX DM devices:
>>>>>
>>>>> [66567.129798] dm-6: error: dax access failed (-5)
>>>>> [66567.134400] dm-6: error: dax access failed (-5)
>>>>> [66567.139152] dm-6: error: dax access failed (-5)
>>>>> [66567.314546] dm-2: error: dax access failed (-95)
>>>>> [66567.319380] dm-2: error: dax access failed (-95)
>>>>> [66567.324254] dm-2: error: dax access failed (-95)
>>>>> [66567.479025] dm-2: error: dax access failed (-95)
>>>>> [66567.483713] dm-2: error: dax access failed (-95)
>>>>> [66567.488722] dm-2: error: dax access failed (-95)
>>>>> [66567.494061] dm-2: error: dax access failed (-95)
>>>>> [66567.498823] dm-2: error: dax access failed (-95)
>>>>> [66567.503693] dm-2: error: dax access failed (-95)
>>>>>
>>>>> commit 231609785cbfb must be reverted.
>>>>>
>>>>> Please advise, thanks.
>>>>
>>>> Adrian Huang from Lenovo posted a patch, which titled: dax: do not print
>>>> error message for non-persistent memory block device
>>>>
>>>> It fixes the issue, but no response for now. Maybe we should take this fix.
>>>
>>> OK, yes sounds like it.  It was merged and is commit c2affe920b0e066
>>> ("dax: do not print error message for non-persistent memory block
>>> device")
>>
>> Thanks for informing me this patch is merged, I am going to update my
>> local one :-)
> 
> So the thing is I'm running v5.9-rc3 (which includes this commit) but
> I'm still seeing all these warnings when I run the lvm2 testsuite.  The
> reason _seems_ to be because the lvm2 testsuite uses brd devices for
> test devices.  So there is something about the brd device that shows
> commit c2affe920b0e066 isn't enough :(

Let me take a look. Thanks for reminding me.

Coly Li
