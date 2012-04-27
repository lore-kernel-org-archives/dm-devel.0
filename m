From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/1] dm-multipath: delay retry of bypassed pg
Date: Fri, 27 Apr 2012 15:39:23 -0400
Message-ID: <20120427193923.GA30535@redhat.com>
References: <1334641618-24512-1-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1334641618-24512-1-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: dm-devel.ids

On Tue, Apr 17 2012 at  1:46am -0400,
michaelc@cs.wisc.edu <michaelc@cs.wisc.edu> wrote:

> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> If there are only bypassed PGs available then we do not want
> to retry right away. If for example the controller was getting
> reset or there was a fw upgrade going on and that was the reason
> for the bypass, then retrying right away is going to cause a flood of
> log messages and retries for what could be a longish time (more than
> a couple seconds and possible up to several minutes).
> 
> For the case where the only PGs are ones that are bypassed this
> patch will have dm-multipath delay the pg init by setting the
> pg_init_delay_retry flag.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Acked-by: Mike Snitzer <snitzer@redhat.com>
