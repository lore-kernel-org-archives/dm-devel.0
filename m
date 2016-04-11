From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: dm: ioctl: use kvfree
Date: Mon, 11 Apr 2016 21:39:53 +0530
Message-ID: <570BCC51.50004@gmail.com>
References: <1460387677-19948-1-git-send-email-sudipm.mukherjee@gmail.com> <20160411151714.GB25938@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160411151714.GB25938@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Monday 11 April 2016 08:47 PM, Mike Snitzer wrote:
> On Mon, Apr 11 2016 at 11:14am -0400,
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
>
>> We can use kvfree() instead of calling kfree() and vfree() based on
>> if-else and param_flags. kvfree() will check the type of address and
>> will call the respective function to free it.
>> Additionally we can also remove the use of DM_PARAMS_KMALLOC and
>> DM_PARAMS_VMALLOC.
>>
>> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
>
> Have you actually tested htis?  Last time I looked to do this it exposed
> crashes.  I don't have time to dig into this again right now but this is
> _not_ as simple as this patch implies.
>

No, it was just build tested. Is it possible to test it in qemu or kvm?

regards
sudip

