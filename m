From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 4/4] dm: convert table_device.count from atomic_t to
        refcount_t
Date: Fri, 24 Nov 2017 14:44:40 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B802C2094@IRSMSX102.ger.corp.intel.com>
References: <1508485059-21881-1-git-send-email-elena.reshetova@intel.com>
 <1508485059-21881-5-git-send-email-elena.reshetova@intel.com>
 <92f8c04f-ef1a-c41b-e82f-8d68a3ec84b5@redhat.com>
 <2236FBA76BA1254E88B949DDB74E612B802C1F4D@IRSMSX102.ger.corp.intel.com>
 <20171124140413.GG5952@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20171124140413.GG5952@agk-dp.fab.redhat.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, "koverstreet@google.com" <koverstreet@google.com>, "ejt@redhat.com" <ejt@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "shli@kernel.org" <shli@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "keescook@chromium.org" <keescook@chromium.org>
List-Id: dm-devel.ids

> On Fri, Nov 24, 2017 at 08:29:42AM +0000, Reshetova, Elena wrote:
> > By looking at the code, I don't see where the change in the reference counting
> > could have caused this.
> 
> The cause was the bug I identified in patch 3, not this patch.

Oh, ok, because I could not figure an issue with this patch. 
I will send the fixing patch shortly. 

Best Regards,
Elena.

> 
> The regression is easily hit - tables that reference the same underlying device
> more than once are very common.
> 
> Alasdair
