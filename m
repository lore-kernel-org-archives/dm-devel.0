From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: Re: [dm-devel] [PATCH v4 0/2] Historical Service Time Path Selector
Date: Wed, 20 May 2020 20:15:09 -0400
Message-ID: <85tv0am9de.fsf@collabora.com>
References: <20200511163910.3778467-1-krisman@collabora.com>
        <ee987451-6d17-b978-809e-e0fe56dc13ce@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ee987451-6d17-b978-809e-e0fe56dc13ce@gmail.com> (Xose Vazquez
        Perez's message of "Thu, 21 May 2020 01:26:27 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: agk@redhat.com, snitzer@redhat.com, breeves@redhat.com, linux-kernel@vger.kernel.org, khazhy@google.com, song@kernel.org, dm-devel@redhat.com, mpatocka@redhat.com, kernel@collabora.com
List-Id: dm-devel.ids

Xose Vazquez Perez <xose.vazquez@gmail.com> writes:

> On 5/11/20 6:39 PM, Gabriel Krisman Bertazi wrote:
>
>> This fourth version of HST applies the suggestion from Mikulas Patocka
>> to do the ktime_get_ns inside the mpath map_bio instead of generic
>> device-mapper code. This means that struct dm_mpath_io gained another
>> 64bit field.  For the request-based case, we continue to use the block
>> layer start time information.
>
> You should add some info to the multipath.conf.5 man page (
> https://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=multipath/multipath.conf.5;h=05a5e8ffeb110d969f3b2381eb3b88d7f28380f6;hb=HEAD#l189
> ),
> or none one is going to use it.

Sure, will do.

-- 
Gabriel Krisman Bertazi
