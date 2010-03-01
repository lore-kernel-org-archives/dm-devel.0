From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH 4 of 10] LVM: add logic to allow mirrored log
Date: Mon, 1 Mar 2010 10:17:12 -0600
Message-ID: <A99981CD-BBD1-4C84-BA21-7368D3BAD2B7@redhat.com>
References: <201002262336.o1QNaJwv024277@hydrogen.msp.redhat.com>
	<4B88C986.7040508@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B88C986.7040508@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I've added your changes into my patches.

On Feb 27, 2010, at 1:28 AM, Takahiro Yasui wrote:

> Hello Jon,
>
> I haven't got your comments for the following emails.
>
> https://www.redhat.com/archives/lvm-devel/2010-February/msg00207.html

I changed this one slightly.  I'm checking if the log_lv is mirrored  
before calling _failed_mirrors_count - that way, we aren't relying on  
an error to tell us if the log was mirrored or not.

> https://www.redhat.com/archives/lvm-devel/2010-February/msg00213.html

Pulled in as suggested.

>
> Could please you check them?
>
> I tested your new patch set, but the above two issues haven't been  
> fixed.
>
> Please tell me if I have misunderstandings.

The allocation changes that were made are causing issues with the '-- 
alloc anywhere' condition in my tests.  I'm working to address this now.

  brassow
