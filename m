From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
Date: 10 May 2007 15:41:38 +0200
Message-ID: <p73fy64g5il.fsf@bingen.suse.de>
References: <20070508194845.GC24114@agk.fab.redhat.com>
	<20070508174159.7d78a275.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761374AbXEJMog@vger.kernel.org>
In-Reply-To: <20070508174159.7d78a275.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org, Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids

Andrew Morton <akpm@linux-foundation.org> writes:
> 
> I have this vague memory from a long time ago that one particular CPU type
> wants to go oops when prefetching from an invalid address.

AMD K7/K8, but we got a generic workaround for a long time.

-Andi
