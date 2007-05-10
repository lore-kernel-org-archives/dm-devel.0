From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
Date: Thu, 10 May 2007 16:17:15 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705101616361.32349@yvahk01.tjqt.qr>
References: <20070508194845.GC24114@agk.fab.redhat.com>
 <20070508174159.7d78a275.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762477AbXEJOUd@vger.kernel.org>
In-Reply-To: <20070508174159.7d78a275.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids


On May 8 2007 17:41, Andrew Morton wrote:
>On Tue, 8 May 2007 20:48:45 +0100
>Alasdair G Kergon <agk@redhat.com> wrote:
>
>> +#define BIO_LIST_INIT { .head = NULL, .tail = NULL }
>> +
>> +#define BIO_LIST(bl) \
>> +	struct bio_list bl = BIO_LIST_INIT
>
>BIO_LIST is a strange name for something which initialises storage.

So try DEFINE_BIO_LIST, it goes in line with DEFINE_SPINLOCK for example.


	Jan
-- 
