From: Ed Cashin <ecashin@coraid.com>
Subject: Re: [PATCH v3 07/26] block: Use bio_sectors() more consistently
Date: Mon, 24 Sep 2012 19:54:04 -0500
Message-ID: <084DC7FE-0C5B-45B4-8D8C-E4AFB7C555D1@coraid.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-8-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348526106-17074-8-git-send-email-koverstreet@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "tj@kernel.org" <tj@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "neilb@suse.de" <neilb@suse.de>, "vgoyal@redhat.com" <vgoyal@redhat.com>, Nick Piggin <npiggin@kernel.dk>, Jiri Kosina <jkosina@suse.cz>, Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>, Alasdair Kergon <agk@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
List-Id: dm-devel.ids

On Sep 24, 2012, at 6:34 PM, Kent Overstreet wrote:

> Bunch of places in the code weren't using it where they could be -
> this'll reduce the size of the patch that puts bi_sector/bi_size/bi_idx
> into a struct bvec_iter.

The aoe changes look fine to me, thanks.

-- 
  Ed Cashin
  ecashin@coraid.com	ecashin@noserose.net
  http://www.coraid.com	http://noserose.net/e/
