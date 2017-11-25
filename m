From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/4] dm: convert dm_dev_internal.count from
 atomic_t to refcount_t
Date: Sat, 25 Nov 2017 00:56:32 -0500
Message-ID: <CAMM=eLfrnQqBH06pPnNKfmeF=AjScAxjR1WD7Ur9NAEY=4Sxog@mail.gmail.com>
References: <1508485059-21881-1-git-send-email-elena.reshetova@intel.com>
 <1508485059-21881-4-git-send-email-elena.reshetova@intel.com>
 <20171123154941.GA15790@agk-dp.fab.redhat.com> <2236FBA76BA1254E88B949DDB74E612B802C1F07@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B802C1F07@IRSMSX102.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Alasdair G Kergon <agk@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "keescook@chromium.org" <keescook@chromium.org>, "peterz@infradead.org" <peterz@infradead.org>, "shli@kernel.org" <shli@kernel.org>, "koverstreet@google.com" <koverstreet@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "ejt@redhat.comg" <ejt@redhat.comg>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Nov 24, 2017 at 2:36 AM, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
>> On Fri, Oct 20, 2017 at 10:37:38AM +0300, Elena Reshetova wrote:
>> >     } else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
>> >             r = upgrade_mode(dd, mode, t->md);
>> >             if (r)
>> >                     return r;
>> > +           refcount_inc(&dd->count);
>> >     }
>>
>> Missing here:
>>
>>         else
>>               refcount_inc(&dd->count);
>>
>> ?
>
> Oh, yes, thanks for catching this! I think this got unnoticed so far and patch was merged, so I am going to send a followup patch now.

I pushed this fix and will send to Linus next week:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.15&id=d908af82d06cc420f9581c97c6db941cb87e4434
