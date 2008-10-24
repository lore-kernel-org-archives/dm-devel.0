From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [Question] power management related with cgroup based resource
 management
Date: Fri, 24 Oct 2008 17:17:14 +0530
Message-ID: <4901B5C2.9070108@linux.vnet.ibm.com>
References: <2891419e0810201954q57087fc8ufcaa0e42f3ca99e2@mail.gmail.com>
Reply-To: balbir@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756263AbYJXLre@vger.kernel.org>
In-Reply-To: <2891419e0810201954q57087fc8ufcaa0e42f3ca99e2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dong-Jae Kang <baramsori72@gmail.com>
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, corsetproject@googlegroups.com, Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
List-Id: dm-devel.ids

Dong-Jae Kang wrote:
> Hi, all
> 
> These days, I am interested in green IT area for low power OS
> So, I have a question about it.
> Is there any good idea or comments about power management related with
> cgroup based resource management?
> I have no idea about that, but it seems to be possible to find a good concept.
> And I hope so
> Is it some strange question? ^^

lesswatts.org, linux-pm (mailing list) are good sources on Power Management. I
would recommend asking at those mailing lists (there are several new features
like range timers, no idle hertz, sched_mc consolidation and much more). Could
you be specific about what you are looking for? Are you looking at
Server/Desktop power management?

-- 
	Balbir
