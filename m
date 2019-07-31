From: Pankaj Gupta <pagupta@redhat.com>
Subject: Re: dm: fix dax_dev NULL dereference
Date: Tue, 30 Jul 2019 23:50:36 -0400 (EDT)
Message-ID: <1887039269.5822356.1564545036201.JavaMail.zimbra@redhat.com>
References: <20190730113708.14660-1-pagupta@redhat.com> <2030283543.5419072.1564486701158.JavaMail.zimbra@redhat.com> <20190730190737.GA14873@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190730190737.GA14873@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dan j williams <dan.j.williams@intel.com>, dm-devel@redhat.com, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com, jencce kernel <jencce.kernel@gmail.com>
List-Id: dm-devel.ids


> 
> I staged the fix (which I tweaked) here:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.3&id=95b9ebb78c4c733f8912a195fbd0bc19960e726e
> 
> Also, please note this additional related commit that just serves to
> improve a related function name and clean up some whitespace:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.3&id=f965f935a89bb174fd3f6d6b51bba91c1ed258c5
> 
> I'll likely send these to Linus for 5.2-rc3 later this week.

o.k

Thank you,
Pankaj

> 
> Thanks,
> Mike
> 
