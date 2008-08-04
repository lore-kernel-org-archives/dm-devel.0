From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: Too many I/O controller patches
Date: Tue, 05 Aug 2008 00:04:59 +0530
Message-ID: <48974BD3.6050503@linux.vnet.ibm.com>
References: <20080804.175126.193692178.ryov@valinux.co.jp> <1217870433.20260.101.camel@nimitz>
Reply-To: balbir@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759674AbYHDSfm@vger.kernel.org>
In-Reply-To: <1217870433.20260.101.camel@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, Andrea Righi <righi.andrea@gmail.com>
List-Id: dm-devel.ids

Dave Hansen wrote:
> On Mon, 2008-08-04 at 17:51 +0900, Ryo Tsuruta wrote:
>> This series of patches of dm-ioband now includes "The bio tracking mechanism,"
>> which has been posted individually to this mailing list.
>> This makes it easy for anybody to control the I/O bandwidth even when
>> the I/O is one of delayed-write requests.
> 
> During the Containers mini-summit at OLS, it was mentioned that there
> are at least *FOUR* of these I/O controllers floating around.  Have you
> talked to the other authors?  (I've cc'd at least one of them).
> 
> We obviously can't come to any kind of real consensus with people just
> tossing the same patches back and forth.

Ryo and Andrea - Naveen and Satoshi met up at OLS and discussed their approach.
It would be really nice to see an RFC, I know Andrea did work on this and
compared the approaches.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
