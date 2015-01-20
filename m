From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND] md:Remove no longer needed fix me
	comment in dm-region-hash.c for removing the structure pointer, *rh
	from the definiton of dm_region
Date: Tue, 20 Jan 2015 11:40:33 +0000
Message-ID: <20150120114032.GC17599@agk-dp.fab.redhat.com>
References: <1421723781-21984-1-git-send-email-xerofoify@gmail.com> <20150120111951.GB17599@agk-dp.fab.redhat.com> <54BE3DAA.5080900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54BE3DAA.5080900@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: nick <xerofoify@gmail.com>
Cc: agk@redhat.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

On Tue, Jan 20, 2015 at 06:36:10AM -0500, nick wrote:
> Unless we use a union or something similar there seems to be no easy 
> way without rewriting a lot of an already function driver file.

The comment does not restrict itself to 'easy ways'.

Alasdair
