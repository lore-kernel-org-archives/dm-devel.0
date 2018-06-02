From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bisect BUG] dm-crypt percpu counter warnings and invalid kernel
 paging request at virtual address
Date: Fri, 1 Jun 2018 21:59:22 -0400
Message-ID: <20180602015922.GA28891@kmo-pixel>
References: <CAJKOXPfSbsu0RGTUFfb+t_uOvQQxa0uDn-nsG+1uuKAq56nVXA@mail.gmail.com>
 <20180601223557.GA25942@kmo-pixel>
 <220a69e1-f1ed-a878-3ab7-de4cea1239fa@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <220a69e1-f1ed-a878-3ab7-de4cea1239fa@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@fb.com>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, "linux-samsung-soc@vger.kernel.org" <linux-samsung-soc@vger.kernel.org>
List-Id: dm-devel.ids

On Fri, Jun 01, 2018 at 06:50:13PM -0600, Jens Axboe wrote:
> Nevermind that for now, do you have a fix for the issue reported?

Yeah, but let me look over it again tomorrow when I'm sober before I send it out
