From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2 1/2] block: Fix a NULL pointer dereference in
 generic_make_request()
Date: Tue, 21 May 2019 05:51:28 -0700
Message-ID: <20190521125128.GA16799@infradead.org>
References: <20190520220911.25192-1-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190520220911.25192-1-gpiccoli@canonical.com>
Sender: stable-owner@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, gavin.guo@canonical.com, jay.vosburgh@canonical.com, kernel@gpiccoli.net, stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@redhat.com>, Eric Ren <renzhengeek@gmail.com>
List-Id: dm-devel.ids

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
