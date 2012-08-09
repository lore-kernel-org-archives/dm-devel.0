From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/2] dm: verity support data device
	offset (Linux 3.4.7)
Date: Thu, 9 Aug 2012 03:04:19 +0100
Message-ID: <20120809020419.GD23758@agk-dp.fab.redhat.com>
References: <8893CF66-2E2C-4D8F-9239-E38BE55716AE@netflix.com> <Pine.LNX.4.64.1208081437550.16469@file.rdu.redhat.com> <5022CC99.30103@redhat.com> <0066B4B7-B0FA-4C7F-99C4-0AABB577382C@netflix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0066B4B7-B0FA-4C7F-99C4-0AABB577382C@netflix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wesley Miaw <wmiaw@netflix.com>
Cc: Milan Broz <mbroz@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, "msb@google.com" <msb@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Will =?utf-8?B?RHJld3J54oSi?= <w@google.com>
List-Id: dm-devel.ids

On Thu, Aug 09, 2012 at 12:40:22AM +0000, Wesley Miaw wrote:
> Apologies if the version increment is incorrect; I was not sure if the minor
> or patch number should be incremented. I assume the different version number is
> what would be used to detect if the data offset option is supported. Thanks.

Minor number is the correct thing to increment as you're retaining
compatibility.  (Your original version would have needed to increment the major
number to indicate incompatibility with existing userspace code.)
 
However, first you need to address the second part of Mikulas's email,
namely to make the case for these changes rather than making no kernel
changes and instead stacking the verity target over a linear target.

To put this another way, your patch offers an alternative way to do
something we think the existing kernel can already do, so you need to
advance some reasons why you believe the new alternative method is worth
adding to the kernel and explain this in the patch header.

Alasdair
