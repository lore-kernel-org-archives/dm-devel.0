From: Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v7 9/9] block: Avoid deadlocks with bio
	allocation by stacking drivers
Date: Wed, 29 Aug 2012 18:23:36 +0100
Message-ID: <20120829172336.GB5576@agk-dp.fab.redhat.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com> <1346175456-1572-10-git-send-email-koverstreet@google.com> <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com> <20120829165006.GB20312@google.com> <20120829170711.GC12504@redhat.com> <20120829171345.GC20312@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120829171345.GC20312-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: dm-devel.ids

On Wed, Aug 29, 2012 at 10:13:45AM -0700, Kent Overstreet wrote:
> Only on allocation failure.
 
Which as you already said assumes wrapping together the other mempools in the
submission path first...

Alasdair
