From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: rename max_io_len to io_boundary
Date: Thu, 21 Mar 2019 20:52:19 -0400
Message-ID: <20190322005218.GA18625@redhat.com>
References: <alpine.LRH.2.02.1903211646170.994@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMeeMh8Sed3ZN5wew6epsNJghzXgQ9Krsku-TSsLEGrHLACTnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAMeeMh8Sed3ZN5wew6epsNJghzXgQ9Krsku-TSsLEGrHLACTnQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Dorminy <jdorminy@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Thu, Mar 21 2019 at  6:57pm -0400,
John Dorminy <jdorminy@redhat.com> wrote:

> Perhaps this wording might be clearer?
> 
> /* If non-zero, I/O submitted to a target will be split so as to not
> straddle any multiple of this length (in bytes) */

.max_io_len is a pretty well-worn DM target attribute.

I'd prefer to just take a patch with the above updated comment and leave
max_io_len as is.  Not too interested in a flag day to rename it,
especially since it just becomes churn for every target, etc.
