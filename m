From: Akira Hayakawa <hayakawa@valinux.co.jp>
Subject: Re: [PATCH 9/9] dm crypt: sort writes
Date: Wed, 2 Apr 2014 13:18:50 +0900
Message-ID: <20140402131850.1f7effb54d09b3b5b5079665@valinux.co.jp>
References: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
	<1396037476-26595-10-git-send-email-snitzer@redhat.com>
	<53368043.5000808@gmail.com> <20140331123940.GB25683@redhat.com>
	<20140401083755.55afa738d5a98b6bc07aca71@valinux.co.jp>
	<20140401010129.GB9214@redhat.com>
	<20140402082113.0665494c70af795d0746ddec@valinux.co.jp>
	<20140402121936.a0a61e405771c83935b9e352@valinux.co.jp>
	<20140402033813.GA16982@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140402033813.GA16982@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

> list_sort() uses merge sort, which has O(nlog(n)) complexity;
> list_sort() also suffers from "list passed to list_sort() too long for
> efficiency".  But in practice I'm not sure how long a list needs to be
> to hit that case.
> 
> Whereas an rb-tree has O(log(n)) complexity and is efficient for
> traversal, it also doesn't have the length limits.

I see. OK, I will remain on rb-tree.

Btw, if I want to disable sorting
1. Always attach new node to the left
2. Eliminate rb_insert_color()
is enough?

-- 
Akira
