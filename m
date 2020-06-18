From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: New mode DM-Verity error handling
Date: Thu, 18 Jun 2020 11:44:45 -0400
Message-ID: <20200618154444.GB18007@redhat.com>
References: <CGME20200618070250epcas1p409eb2ddd19ecc5d55c219ac3dc884f25@epcas1p4.samsung.com>
 <98eac3fc-c399-625d-5730-29853b3a0771@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <98eac3fc-c399-625d-5730-29853b3a0771@samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: JeongHyeon Lee <jhs2.lee@samsung.com>
Cc: agk@redhat.com, dm-devel@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jun 18 2020 at  2:56am -0400,
JeongHyeon Lee <jhs2.lee@samsung.com> wrote:

> Hello, Dear devcice-mapper maintainers.
> 
> I'm JeongHyeon Lee, work in Samsung. I'm chage of DM-Verity feature with 
> Mr. sunwook eom.
> I have a patch or suggestion about DM-Verity error handling.
> 
> Our device (smart phone) need DM-Verity feature. So I hope there is new 
> mode DM-Verity error handling.
> This new mode concept is When detect corrupted block, will be go to panic.
> 
> Because our team policy is found device DM-Verity error, device will go 
> panic.
> And then analyze what kind of device fault (crash UFS, IO error, DRAM 
> bit flip etc)
> 
> In addition to the smart phone, I would like to have an option that 
> users or administrators can use accordingly.
> There are patch contents in the attachment. I would really appreciate it 
> if you could check it.
> 
> I will look forward to hearing from yours.
> Thank you :)
> 

I do not accept that panicing the system because of verity failure is
reasonable.

In fact, even rebooting (via DM_VERITY_MODE_RESTART) looks very wrong.

The device should be put in a failed state and left for admin recovery.

Mike
