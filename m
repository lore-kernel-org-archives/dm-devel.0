From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] MAINTAINERS: correct entry for LVM
Date: Mon, 11 Apr 2016 22:09:48 +0530
Message-ID: <570BD354.2000100@gmail.com>
References: <1460388039-20282-1-git-send-email-sudipm.mukherjee@gmail.com> <20160411155147.GB9288@agk-dp.fab.redhat.com> <570BCD85.6090807@gmail.com> <20160411162306.GC9288@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160411162306.GC9288@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Joe Perches <joe@perches.com>
List-Id: dm-devel.ids

On Monday 11 April 2016 09:53 PM, Alasdair G Kergon wrote:
> On Mon, Apr 11, 2016 at 09:45:01PM +0530, Sudip Mukherjee wrote:
>> L stands for "Mailing list that is relevant to this area", and this is a
>> mailing list. :)
>
> Your proposed patch isn't changing the L entry, so this is of no relevance.

Sorry, I am not understanding.

The current entry in MAINTAINERS is:
DEVICE-MAPPER  (LVM)
M:      Alasdair Kergon <agk@redhat.com>
M:      Mike Snitzer <snitzer@redhat.com>
M:      dm-devel@redhat.com
L:      dm-devel@redhat.com
...

So my patch just removed the line : "M:      dm-devel@redhat.com"

So now the entry becomes :
DEVICE-MAPPER  (LVM)
M:      Alasdair Kergon <agk@redhat.com>
M:      Mike Snitzer <snitzer@redhat.com>
L:      dm-devel@redhat.com
...

So, now it correctly shows dm-devel@redhat.com as a mailing list which 
should have cc to all the patches related to LVM.

Or am I understanding this wrong?

regards
sudip
