From: "Marti Raudsepp" <marti@juffo.org>
Subject: Re: [PATCH] disable barriers in dm-crypt [was Re: BUG: Files corrupt after moving LVM volume to USB disk]
Date: Mon, 26 Mar 2007 03:05:19 +0300
Message-ID: <2a12af650703251705x30a05194je1cfece44b2cf45d@mail.gmail.com>
References: <20070322000348.92631512.akpm@linux-foundation.org>
	 <20070322153301.GN27600@agk.surrey.redhat.com>
	 <2a12af650703221742p6691f4b5i21667a5c98217fb6@mail.gmail.com>
	 <4603E806.3030205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933156AbXCZAFX@vger.kernel.org>
In-Reply-To: <4603E806.3030205@redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, device-mapper development <dm-devel@redhat.com>, Kernel hackers <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

On 3/23/07, Milan Broz <mbroz@redhat.com> wrote:
> Disable barriers in dm-crypt because of current workqueue processing
> can reorder requests.
>
> --- linux-2.6.20.1.orig/drivers/md/dm-crypt.c   2007-03-23 15:07:11.000000000 +0100
> +++ linux-2.6.20.1/drivers/md/dm-crypt.c        2007-03-23 15:09:59.000000000 +0100
> +       if (bio_barrier(bio))
> +               return -EOPNOTSUPP;
> +

Sorry, this doesn't help either. ext3 is still slow, reiserfs still fails.

(And sorry for the double e-mail, I forgot to reply to all)

Marti Raudsepp
