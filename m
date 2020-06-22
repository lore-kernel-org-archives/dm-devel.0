From: Milan Broz <gmazyland@gmail.com>
Subject: Re: New mode DM-Verity error handling
Date: Mon, 22 Jun 2020 09:58:37 +0200
Message-ID: <b7eaf4a7-6692-ffdf-2bbc-b622f93ef601@gmail.com>
References: <CGME20200618070250epcas1p409eb2ddd19ecc5d55c219ac3dc884f25@epcas1p4.samsung.com>
 <98eac3fc-c399-625d-5730-29853b3a0771@samsung.com>
 <20200618154444.GB18007@redhat.com> <20200618165006.GA103290@google.com>
 <20200618170952.GA18057@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20200618170952.GA18057@redhat.com>
Content-Language: en-US
Sender: linux-doc-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Sami Tolvanen <samitolvanen@google.com>
Cc: JeongHyeon Lee <jhs2.lee@samsung.com>, dm-devel@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com, corbet@lwn.net
List-Id: dm-devel.ids

On 18/06/2020 19:09, Mike Snitzer wrote:
> On Thu, Jun 18 2020 at 12:50pm -0400,
> Sami Tolvanen <samitolvanen@google.com> wrote:
> 
>> On Thu, Jun 18, 2020 at 11:44:45AM -0400, Mike Snitzer wrote:
>>> I do not accept that panicing the system because of verity failure is
>>> reasonable.
>>>
>>> In fact, even rebooting (via DM_VERITY_MODE_RESTART) looks very wrong.
>>>
>>> The device should be put in a failed state and left for admin recovery.
>>
>> That's exactly how the restart mode works on some Android devices. The
>> bootloader sees the verification error and puts the device in recovery
>> mode. Using the restart mode on systems without firmware support won't
>> make sense, obviously.
> 
> OK, so I need further justification from Samsung why they are asking for
> this panic mode.

I think when we have reboot already, panic is not much better :-)

Just please note that dm-verity is used not only in Android world (with own tooling)
but in normal Linux distributions, and I need to modify userspace (veritysetup) to support
and recognize this flag.

Please *always* increase minor dm-verity target version when adding a new feature
- we can then provide some better hint if it is not supported.

Thanks,
Milan
