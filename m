From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] md/dm-ioctl.c: optimize memory allocation
	in copy_params
Date: Tue, 22 Jul 2014 02:23:52 +0100
Message-ID: <20140722012352.GD6822@agk-dp.fab.redhat.com>
References: <53B68068.2060102@intel.com> <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com> <53BCA278.5050205@linux.intel.com> <alpine.LRH.2.02.1407091032400.4545@file01.intranet.prod.int.rdu2.redhat.com> <53CDB81B.90509@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53CDB81B.90509@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, "xinhui.pan" <xinhuix.pan@intel.com>, linux-kernel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, "Liu, ShuoX" <shuox.liu@intel.com>
List-Id: dm-devel.ids

>>> On 2014/7/9 6:39, Mikulas Patocka wrote:
>> Which ioctl with more than 16kB
>> arguments do you use? 

Unanswered.  Let's ask the same question in a different way:

Please supply the output of these three commands on the real-world system on
which you believe that that particular allocation is causing you a problem:
  dmsetup info -c
  dmsetup table
  dmsetup status

Alasdair
