From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 5/8 v2] dm: replace memset by memzero_explicit
Date: Mon, 1 Dec 2014 18:00:38 -0500
Message-ID: <20141201230037.GA9761@redhat.com>
References: <1417367029-32762-1-git-send-email-Julia.Lawall@lip6.fr>
 <1417367029-32762-6-git-send-email-Julia.Lawall@lip6.fr>
 <547CD7B9.5030000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <547CD7B9.5030000@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Dec 01 2014 at  4:03pm -0500,
Milan Broz <gmazyland@gmail.com> wrote:

> On 11/30/2014 06:03 PM, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > 
> > Memset on a local variable may be removed when it is called just before the
> > variable goes out of scope.  Using memzero_explicit defeats this
> > optimization.  A simplified version of the semantic patch that makes this
> > change is as follows: (http://coccinelle.lip6.fr/)
> 
> Ack, but I submitted the same patch a week ago....
> 
> https://www.redhat.com/archives/dm-devel/2014-November/msg00084.html
> 
> Mike, please could you add this to linux-next tree or you want this
> to go through Herbert's tree?
> (I do not think it is good idea for DM patches.)

I staged it in linux-next for 3.19 inclusion, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.19&id=a722201f9075b28be140bc13f8ec07bf6a42edd4
